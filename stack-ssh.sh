#!/bin/bash

touch ~/.ssh/config

if [[ "$OSTYPE" == linux* ]]; then
	export tgt=$(readlink -f ~/.ssh/config)
else
	export tgt=$(stat -f "%N" ~/.ssh/config)
fi

if [ -e "$tgt" ]; then

    export backup="${tgt}_backup_`date +%s`"
    echo "backing up $tgt to $backup"
    cp $tgt $backup
fi


echo "Populating $tgt with AWS EC2 instances"
aws-ssh-config --tags "aws:autoscaling:groupName,Name" | tee "$tgt"
echo "Done."

echo "Appending fixed hosts to config"
cat ~/.ssh/fixed >>~/.ssh/config


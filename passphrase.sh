#!/bin/bash
#program to crack the passphrase used to encrypt a file
#the passphrase is of the form ("String""number") where the string is taken from the dict file and the number is between 1 and 10,000
#it will test out combinations of each until the program returns the String WARNING
#	This means the passphrase worked. 

while read line		#read a line from the dict file for the first part of the passphrase
do
	for j in "$line"
	do
		START=1
		END=9999
		while [[ $START -le $END ]]	#tries every number between START and END, 4 digits takes long enough
		do
			echo "$j$START"
			gpg --no-use-agent --yes --logger-file log --passphrase $j$START chest.gpg
			#chest.gpg is the name of the encrypted file, change accordingly
	
			if grep -Fq "WARNING" log #check if the log file has the string WARNING
			then 
				echo Here it is
				break 3		#stop the code as its job is done
			else
				echo NOPE
			fi

			((START = START + 1))
		done
	done
done < dict

rm log #clean up the mess it made

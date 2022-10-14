#!/bin/sh -l

set -e

if [ -z "$VAULT_TOKEN" ]; then
	echo "VAULT_TOKEN is not set. Quitting."
	exit 1
fi

if [ -z "$VAULT_ROLE" ]; then
	echo "VAULT_ROLE is not set. Quitting."
	exit 1
fi

if [ -z "$VAULT_ADDR" ]; then
	VAULT_ADDR=https://vault.24g.dev
fi

vault read -address=$VAULT_ADDR aws/sts/$VAULT_ROLE ttl=30m --format=json >creds.json
AWS_ACCESS_KEY_ID=$(jq -r '.data.access_key' creds.json)
AWS_SECRET_ACCESS_KEY=$(jq -r '.data.secret_key' creds.json)
AWS_SESSION_TOKEN=$(jq -r '.data.security_token' creds.json)

echo "access_key=$AWS_ACCESS_KEY_ID" >> $GITHUB_OUTPUT
echo "secret_key=$AWS_SECRET_ACCESS_KEY" >> $GITHUB_OUTPUT
echo "session_token=$AWS_SESSION_TOKEN" >> $GITHUB_OUTPUT

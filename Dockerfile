ARG NODE_VERSION=17
FROM docker/dev-environments-go:latest
LABEL maintainer "Oceaneering Cloud <cloud-infr-oii@oceaneering.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /

# Install required system packages and dependencies
RUN install_packages ca-certificates curl wget gzip \
    tar unzip nano vim python3-pip sudo

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# AZ CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# GCloud CLI
RUN install_packages apt-transport-https ca-certificates gnupg
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    tee /usr/share/keyrings/cloud.google.gpg && install_packages google-cloud-sdk 

# Terraform
RUN install_packages gnupg software-properties-common curl && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    install_packages terraform

# apt updates and apt cleanup
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

WORKDIR /home/vscode
USER vscode
# ENTRYPOINT [ "/bin/bash" ]

# USER root

# TODO: install node 17
FROM ubuntu:xenial
MAINTAINER Pavel Vondruska <dextor@centrum.cz>, Tacid <tacid@tacid.kiev.ua>

ENV VERSION 5.0.2
ENV DEB_VERSION 5.0.2-2

ENV ONE_URL http://downloads.opennebula.org/packages/opennebula-$VERSION/ubuntu-1604/opennebula-$DEB_VERSION.tar.gz

RUN buildDeps=' \
		ca-certificates \
		curl \
		netcat-openbsd \
		bridge-utils \
	' \
	set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL "$ONE_URL" -o one.tar.gz \
	&& mkdir -p debs \
	&& tar -xvf one.tar.gz -C debs --strip-components=1 \
	&& rm one.tar.gz \
	&& cd debs \
	&& dpkg -i *.deb \
	; apt-get install -fy --no-install-recommends \
	&& gem install treetop parse-cron \
	&& apt-get install -y --no-install-recommends openssh-server \
	&& rm -fv /etc/ssh/ssh_host* \
	&& apt-get remove -y systemd systemd-sysv \
	&& apt-get clean \
	&& rm -r /var/lib/apt/lists/* \
	&& cd ../../ \
	&& rm -r debs \
	&& sed -i -e "s/#auth_unix_rw/auth_unix_rw/" -e "s/#auth_unix_ro/auth_unix_ro/" /etc/libvirt/libvirtd.conf \
	&& mkdir -p /var/lib/libvirt \
	&& chown -R oneadmin. /var/lib/libvirt

COPY start.sh /

CMD ["/start.sh"]



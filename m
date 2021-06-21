Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA853AEDE5
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFUQX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhFUQWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE666135D;
        Mon, 21 Jun 2021 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292396;
        bh=yhv+e6KBJc6Z2/Fs4/gIG6bn5UCZ7ennW4Pyxv5sGKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPhzhqC1thfDbV5Bh79REEAngLeXVWF/+lHDMfFCbiZZuxTLkaDoHqBzMO5l9gweN
         8H55qPzBRRIeAez5gHLC6WFHRnWkCJnpUbw2OcuXwJdVZ9Jg7LTiL8pMOLyd1KNYyB
         +e+CvFnwSNzrq39CSYnnkG5TzdtRKM5YsLeG2obY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juliusz Chroboczek <jch@irif.fr>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/90] icmp: dont send out ICMP messages with a source address of 0.0.0.0
Date:   Mon, 21 Jun 2021 18:15:16 +0200
Message-Id: <20210621154905.509386140@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 321827477360934dc040e9d3c626bf1de6c3ab3c ]

When constructing ICMP response messages, the kernel will try to pick a
suitable source address for the outgoing packet. However, if no IPv4
addresses are configured on the system at all, this will fail and we end up
producing an ICMP message with a source address of 0.0.0.0. This can happen
on a box routing IPv4 traffic via v6 nexthops, for instance.

Since 0.0.0.0 is not generally routable on the internet, there's a good
chance that such ICMP messages will never make it back to the sender of the
original packet that the ICMP message was sent in response to. This, in
turn, can create connectivity and PMTUd problems for senders. Fortunately,
RFC7600 reserves a dummy address to be used as a source for ICMP
messages (192.0.0.8/32), so let's teach the kernel to substitute that
address as a last resort if the regular source address selection procedure
fails.

Below is a quick example reproducing this issue with network namespaces:

ip netns add ns0
ip l add type veth peer netns ns0
ip l set dev veth0 up
ip a add 10.0.0.1/24 dev veth0
ip a add fc00:dead:cafe:42::1/64 dev veth0
ip r add 10.1.0.0/24 via inet6 fc00:dead:cafe:42::2
ip -n ns0 l set dev veth0 up
ip -n ns0 a add fc00:dead:cafe:42::2/64 dev veth0
ip -n ns0 r add 10.0.0.0/24 via inet6 fc00:dead:cafe:42::1
ip netns exec ns0 sysctl -w net.ipv4.icmp_ratelimit=0
ip netns exec ns0 sysctl -w net.ipv4.ip_forward=1
tcpdump -tpni veth0 -c 2 icmp &
ping -w 1 10.1.0.1 > /dev/null
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on veth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 29, seq 1, length 64
IP 0.0.0.0 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92
2 packets captured
2 packets received by filter
0 packets dropped by kernel

With this patch the above capture changes to:
IP 10.0.0.1 > 10.1.0.1: ICMP echo request, id 31127, seq 1, length 64
IP 192.0.0.8 > 10.0.0.1: ICMP net 10.1.0.1 unreachable, length 92

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Juliusz Chroboczek <jch@irif.fr>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/in.h | 3 +++
 net/ipv4/icmp.c         | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index e7ad9d350a28..60e1241d4b77 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -284,6 +284,9 @@ struct sockaddr_in {
 /* Address indicating an error return. */
 #define	INADDR_NONE		((unsigned long int) 0xffffffff)
 
+/* Dummy address for src of ICMP replies if no real address is set (RFC7600). */
+#define	INADDR_DUMMY		((unsigned long int) 0xc0000008)
+
 /* Network number for local host loopback. */
 #define	IN_LOOPBACKNET		127
 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index dd8fae89be72..c88612242c89 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -739,6 +739,13 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		icmp_param.data_len = room;
 	icmp_param.head_len = sizeof(struct icmphdr);
 
+	/* if we don't have a source address at this point, fall back to the
+	 * dummy address instead of sending out a packet with a source address
+	 * of 0.0.0.0
+	 */
+	if (!fl4.saddr)
+		fl4.saddr = htonl(INADDR_DUMMY);
+
 	icmp_push_reply(&icmp_param, &fl4, &ipc, &rt);
 ende:
 	ip_rt_put(rt);
-- 
2.30.2




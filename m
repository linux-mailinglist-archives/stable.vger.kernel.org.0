Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E9273F18
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388379AbfGXTck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387727AbfGXTcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:32:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DEE120659;
        Wed, 24 Jul 2019 19:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996759;
        bh=QaNt2Bqoz293TI+9GC4n2RO3J6yhqrLe95Wmi1UZT4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oy4l3/n4t+trSyAEMchG0bqGL/UrCh+gnH0Hm+kAZmtQ2pZErK/hd3RguWT5KwZIh
         2yUD+Z5P1iSqVxdO2XFS+BRFJ4eI77+JhAFeCgiAwoeHs1tx2gzg8fBzSM0hTwLrAw
         BDoo6v9eKahedWmXzo1cHDhX8s5QYbH3SWDaubkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhao <yi.zhao@windriver.com>,
        He Zhe <zhe.he@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 204/413] netfilter: Fix remainder of pseudo-header protocol 0
Date:   Wed, 24 Jul 2019 21:18:15 +0200
Message-Id: <20190724191749.116655234@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5d1549847c76b1ffcf8e388ef4d0f229bdd1d7e8 ]

Since v5.1-rc1, some types of packets do not get unreachable reply with the
following iptables setting. Fox example,

$ iptables -A INPUT -p icmp --icmp-type 8 -j REJECT
$ ping 127.0.0.1 -c 1
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
— 127.0.0.1 ping statistics —
1 packets transmitted, 0 received, 100% packet loss, time 0ms

We should have got the following reply from command line, but we did not.
>From 127.0.0.1 icmp_seq=1 Destination Port Unreachable

Yi Zhao reported it and narrowed it down to:
7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it"),

This is because nf_ip_checksum still expects pseudo-header protocol type 0 for
packets that are of neither TCP or UDP, and thus ICMP packets are mistakenly
treated as TCP/UDP.

This patch corrects the conditions in nf_ip_checksum and all other places that
still call it with protocol 0.

Fixes: 7fc38225363d ("netfilter: reject: skip csum verification for protocols that don't support it")
Reported-by: Yi Zhao <yi.zhao@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_icmp.c | 2 +-
 net/netfilter/nf_nat_proto.c            | 2 +-
 net/netfilter/utils.c                   | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index a824367ed518..dd53e2b20f6b 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -218,7 +218,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 	/* See ip_conntrack_proto_tcp.c */
 	if (state->net->ct.sysctl_checksum &&
 	    state->hook == NF_INET_PRE_ROUTING &&
-	    nf_ip_checksum(skb, state->hook, dataoff, 0)) {
+	    nf_ip_checksum(skb, state->hook, dataoff, IPPROTO_ICMP)) {
 		icmp_error_log(skb, state, "bad hw icmp checksum");
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 07da07788f6b..83a24cc5753b 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -564,7 +564,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
-	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
+	if (nf_ip_checksum(skb, hooknum, hdrlen, IPPROTO_ICMP))
 		return 0;
 
 	inside = (void *)skb->data + hdrlen;
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 06dc55590441..51b454d8fa9c 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -17,7 +17,8 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
 			break;
-		if ((protocol == 0 && !csum_fold(skb->csum)) ||
+		if ((protocol != IPPROTO_TCP && protocol != IPPROTO_UDP &&
+		    !csum_fold(skb->csum)) ||
 		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
 				       skb->len - dataoff, protocol,
 				       skb->csum)) {
@@ -26,7 +27,7 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		}
 		/* fall through */
 	case CHECKSUM_NONE:
-		if (protocol == 0)
+		if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP)
 			skb->csum = 0;
 		else
 			skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9A229B4EA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793573AbgJ0PHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790063AbgJ0PDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D82D2071A;
        Tue, 27 Oct 2020 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811022;
        bh=R4NJutnY0Z2v5U+SHfPYXSQdEBBKJ15gjFvu+24Qi+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZyt2TEh3oZC8ux9fXdUutKbZ1OPuQcZ0S1+ir2MLoiAy05FTZPwiTQBvHJYBGuJ8
         56UfslrvWStXxZZKH0gz2KmVyuMvsCK3qzpzkOpHkraLEgRG3BewK+ow1k87Lii3gI
         tjsoVTnn5+h9/P22/JnTbQl188tSZwYwFrUKTG9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 315/633] netfilter: nf_log: missing vlan offload tag and proto
Date:   Tue, 27 Oct 2020 14:50:58 +0100
Message-Id: <20201027135537.453523796@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0d9826bc18ce356e8909919ad681ad65d0a6061e ]

Dump vlan tag and proto for the usual vlan offload case if the
NF_LOG_MACDECODE flag is set on. Without this information the logging is
misleading as there is no reference to the VLAN header.

[12716.993704] test: IN=veth0 OUT= MACSRC=86:6c:92:ea:d6:73 MACDST=0e:3b:eb:86:73:76 VPROTO=8100 VID=10 MACPROTO=0800 SRC=192.168.10.2 DST=172.217.168.163 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=2548 DF PROTO=TCP SPT=55848 DPT=80 WINDOW=501 RES=0x00 ACK FIN URGP=0
[12721.157643] test: IN=veth0 OUT= MACSRC=86:6c:92:ea:d6:73 MACDST=0e:3b:eb:86:73:76 VPROTO=8100 VID=10 MACPROTO=0806 ARP HTYPE=1 PTYPE=0x0800 OPCODE=2 MACSRC=86:6c:92:ea:d6:73 IPSRC=192.168.10.2 MACDST=0e:3b:eb:86:73:76 IPDST=192.168.10.1

Fixes: 83e96d443b37 ("netfilter: log: split family specific code to nf_log_{ip,ip6,common}.c files")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_log.h   |  1 +
 net/ipv4/netfilter/nf_log_arp.c  | 19 +++++++++++++++++--
 net/ipv4/netfilter/nf_log_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_log_ipv6.c |  8 +++++---
 net/netfilter/nf_log_common.c    | 12 ++++++++++++
 5 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 0d3920896d502..716db4a0fed89 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -108,6 +108,7 @@ int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
 			   unsigned int logflags);
 void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
 			    struct sock *sk);
+void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb);
 void nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
 			       unsigned int hooknum, const struct sk_buff *skb,
 			       const struct net_device *in,
diff --git a/net/ipv4/netfilter/nf_log_arp.c b/net/ipv4/netfilter/nf_log_arp.c
index 7a83f881efa9e..136030ad2e546 100644
--- a/net/ipv4/netfilter/nf_log_arp.c
+++ b/net/ipv4/netfilter/nf_log_arp.c
@@ -43,16 +43,31 @@ static void dump_arp_packet(struct nf_log_buf *m,
 			    const struct nf_loginfo *info,
 			    const struct sk_buff *skb, unsigned int nhoff)
 {
-	const struct arphdr *ah;
-	struct arphdr _arph;
 	const struct arppayload *ap;
 	struct arppayload _arpp;
+	const struct arphdr *ah;
+	unsigned int logflags;
+	struct arphdr _arph;
 
 	ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
 	if (ah == NULL) {
 		nf_log_buf_add(m, "TRUNCATED");
 		return;
 	}
+
+	if (info->type == NF_LOG_TYPE_LOG)
+		logflags = info->u.log.logflags;
+	else
+		logflags = NF_LOG_DEFAULT_MASK;
+
+	if (logflags & NF_LOG_MACDECODE) {
+		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
+			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
+		nf_log_dump_vlan(m, skb);
+		nf_log_buf_add(m, "MACPROTO=%04x ",
+			       ntohs(eth_hdr(skb)->h_proto));
+	}
+
 	nf_log_buf_add(m, "ARP HTYPE=%d PTYPE=0x%04x OPCODE=%d",
 		       ntohs(ah->ar_hrd), ntohs(ah->ar_pro), ntohs(ah->ar_op));
 
diff --git a/net/ipv4/netfilter/nf_log_ipv4.c b/net/ipv4/netfilter/nf_log_ipv4.c
index 0c72156130b68..d07583fac8f8c 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/ipv4/netfilter/nf_log_ipv4.c
@@ -284,8 +284,10 @@ static void dump_ipv4_mac_header(struct nf_log_buf *m,
 
 	switch (dev->type) {
 	case ARPHRD_ETHER:
-		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM MACPROTO=%04x ",
-			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
+		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
+			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
+		nf_log_dump_vlan(m, skb);
+		nf_log_buf_add(m, "MACPROTO=%04x ",
 			       ntohs(eth_hdr(skb)->h_proto));
 		return;
 	default:
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index da64550a57075..8210ff34ed9b7 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -297,9 +297,11 @@ static void dump_ipv6_mac_header(struct nf_log_buf *m,
 
 	switch (dev->type) {
 	case ARPHRD_ETHER:
-		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM MACPROTO=%04x ",
-		       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
-		       ntohs(eth_hdr(skb)->h_proto));
+		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
+			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
+		nf_log_dump_vlan(m, skb);
+		nf_log_buf_add(m, "MACPROTO=%04x ",
+			       ntohs(eth_hdr(skb)->h_proto));
 		return;
 	default:
 		break;
diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
index ae5628ddbe6d7..fd7c5f0f5c25b 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -171,6 +171,18 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
 }
 EXPORT_SYMBOL_GPL(nf_log_dump_packet_common);
 
+void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb)
+{
+	u16 vid;
+
+	if (!skb_vlan_tag_present(skb))
+		return;
+
+	vid = skb_vlan_tag_get(skb);
+	nf_log_buf_add(m, "VPROTO=%04x VID=%u ", ntohs(skb->vlan_proto), vid);
+}
+EXPORT_SYMBOL_GPL(nf_log_dump_vlan);
+
 /* bridge and netdev logging families share this code. */
 void nf_log_l2packet(struct net *net, u_int8_t pf,
 		     __be16 protocol,
-- 
2.25.1




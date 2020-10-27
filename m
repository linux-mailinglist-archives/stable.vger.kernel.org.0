Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC7729C45E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368603AbgJ0R4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758672AbgJ0OWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:22:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF272225E;
        Tue, 27 Oct 2020 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808527;
        bh=4lqWiup8sVhEJkswnNRUgp+peu/M7glWddMn8d+sW5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppLV4r7Vlx1409bb7hannVmr7ckCB7UqwHEinHh237ZIiQ+y5ZyHJuQOaMAwc1TC2
         Tsch7VvfcXjW9MikeVjhXNy1Rwai+LdBBomMTtnJaJp6o613X9xKSFVYt9tTK1H7o+
         M0dCTr1mLoBlr1RuoqMabIzQBtXuuZiQGe7VJOHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 126/264] netfilter: nf_log: missing vlan offload tag and proto
Date:   Tue, 27 Oct 2020 14:53:04 +0100
Message-Id: <20201027135436.605098963@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index df5c2a2061a4b..19fff2c589fac 100644
--- a/net/ipv4/netfilter/nf_log_arp.c
+++ b/net/ipv4/netfilter/nf_log_arp.c
@@ -46,16 +46,31 @@ static void dump_arp_packet(struct nf_log_buf *m,
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
index 1e6f28c97d3a2..cde1918607e9c 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/ipv4/netfilter/nf_log_ipv4.c
@@ -287,8 +287,10 @@ static void dump_ipv4_mac_header(struct nf_log_buf *m,
 
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
index c6bf580d0f331..c456e2f902b93 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -300,9 +300,11 @@ static void dump_ipv6_mac_header(struct nf_log_buf *m,
 
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
index a8c5c846aec10..b164a0e1e0536 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -176,6 +176,18 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
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




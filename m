Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ED3226A22
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731763AbgGTP4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbgGTP4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0743D22BEF;
        Mon, 20 Jul 2020 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260568;
        bh=ZnMwQPqSatnQaUqxmYcRPKEsAp1t63ZvCX61A7UlJlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeKQ3Z1kyH36h6C+g8EEBxr0S6JmKRTfQywRcgTqaDRPoR/QHQQXGUEzVXckOaT04
         Wzxn7nvMGpaYdU3Vvc/I6HH1fSf55020obJVasPmkP1HUhftdOyrSFNuDdOipbrWHI
         pfTuqPJRCMliAvaMY1kQcOXGqLHebhBCAGr+JXRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 016/215] sched: consistently handle layer3 header accesses in the presence of VLANs
Date:   Mon, 20 Jul 2020 17:34:58 +0200
Message-Id: <20200720152820.935053886@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Toke H�iland-J�rgensen" <toke@redhat.com>

[ Upstream commit d7bf2ebebc2bd61ab95e2a8e33541ef282f303d4 ]

There are a couple of places in net/sched/ that check skb->protocol and act
on the value there. However, in the presence of VLAN tags, the value stored
in skb->protocol can be inconsistent based on whether VLAN acceleration is
enabled. The commit quoted in the Fixes tag below fixed the users of
skb->protocol to use a helper that will always see the VLAN ethertype.

However, most of the callers don't actually handle the VLAN ethertype, but
expect to find the IP header type in the protocol field. This means that
things like changing the ECN field, or parsing diffserv values, stops
working if there's a VLAN tag, or if there are multiple nested VLAN
tags (QinQ).

To fix this, change the helper to take an argument that indicates whether
the caller wants to skip the VLAN tags or not. When skipping VLAN tags, we
make sure to skip all of them, so behaviour is consistent even in QinQ
mode.

To make the helper usable from the ECN code, move it to if_vlan.h instead
of pkt_sched.h.

v3:
- Remove empty lines
- Move vlan variable definitions inside loop in skb_protocol()
- Also use skb_protocol() helper in IP{,6}_ECN_decapsulate() and
  bpf_skb_ecn_set_ce()

v2:
- Use eth_type_vlan() helper in skb_protocol()
- Also fix code that reads skb->protocol directly
- Change a couple of 'if/else if' statements to switch constructs to avoid
  calling the helper twice

Reported-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/if_vlan.h  |   28 ++++++++++++++++++++++++++++
 include/net/inet_ecn.h   |   25 +++++++++++++++++--------
 include/net/pkt_sched.h  |   11 -----------
 net/core/filter.c        |   10 +++++++---
 net/sched/act_connmark.c |    9 ++++++---
 net/sched/act_csum.c     |    2 +-
 net/sched/act_ct.c       |    9 ++++-----
 net/sched/act_ctinfo.c   |    9 ++++++---
 net/sched/act_mpls.c     |    2 +-
 net/sched/act_skbedit.c  |    2 +-
 net/sched/cls_api.c      |    2 +-
 net/sched/cls_flow.c     |    8 ++++----
 net/sched/cls_flower.c   |    2 +-
 net/sched/em_ipset.c     |    2 +-
 net/sched/em_ipt.c       |    2 +-
 net/sched/em_meta.c      |    2 +-
 net/sched/sch_cake.c     |    4 ++--
 net/sched/sch_dsmark.c   |    6 +++---
 net/sched/sch_teql.c     |    2 +-
 19 files changed, 86 insertions(+), 51 deletions(-)

--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -308,6 +308,34 @@ static inline bool eth_type_vlan(__be16
 	}
 }
 
+/* A getter for the SKB protocol field which will handle VLAN tags consistently
+ * whether VLAN acceleration is enabled or not.
+ */
+static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
+{
+	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
+	__be16 proto = skb->protocol;
+
+	if (!skip_vlan)
+		/* VLAN acceleration strips the VLAN header from the skb and
+		 * moves it to skb->vlan_proto
+		 */
+		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
+
+	while (eth_type_vlan(proto)) {
+		struct vlan_hdr vhdr, *vh;
+
+		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
+		if (!vh)
+			break;
+
+		proto = vh->h_vlan_encapsulated_proto;
+		offset += sizeof(vhdr);
+	}
+
+	return proto;
+}
+
 static inline bool vlan_hw_offload_capable(netdev_features_t features,
 					   __be16 proto)
 {
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -4,6 +4,7 @@
 
 #include <linux/ip.h>
 #include <linux/skbuff.h>
+#include <linux/if_vlan.h>
 
 #include <net/inet_sock.h>
 #include <net/dsfield.h>
@@ -172,7 +173,7 @@ static inline void ipv6_copy_dscp(unsign
 
 static inline int INET_ECN_set_ce(struct sk_buff *skb)
 {
-	switch (skb->protocol) {
+	switch (skb_protocol(skb, true)) {
 	case cpu_to_be16(ETH_P_IP):
 		if (skb_network_header(skb) + sizeof(struct iphdr) <=
 		    skb_tail_pointer(skb))
@@ -191,7 +192,7 @@ static inline int INET_ECN_set_ce(struct
 
 static inline int INET_ECN_set_ect1(struct sk_buff *skb)
 {
-	switch (skb->protocol) {
+	switch (skb_protocol(skb, true)) {
 	case cpu_to_be16(ETH_P_IP):
 		if (skb_network_header(skb) + sizeof(struct iphdr) <=
 		    skb_tail_pointer(skb))
@@ -272,12 +273,16 @@ static inline int IP_ECN_decapsulate(con
 {
 	__u8 inner;
 
-	if (skb->protocol == htons(ETH_P_IP))
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		inner = ip_hdr(skb)->tos;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+		break;
+	case htons(ETH_P_IPV6):
 		inner = ipv6_get_dsfield(ipv6_hdr(skb));
-	else
+		break;
+	default:
 		return 0;
+	}
 
 	return INET_ECN_decapsulate(skb, oiph->tos, inner);
 }
@@ -287,12 +292,16 @@ static inline int IP6_ECN_decapsulate(co
 {
 	__u8 inner;
 
-	if (skb->protocol == htons(ETH_P_IP))
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		inner = ip_hdr(skb)->tos;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+		break;
+	case htons(ETH_P_IPV6):
 		inner = ipv6_get_dsfield(ipv6_hdr(skb));
-	else
+		break;
+	default:
 		return 0;
+	}
 
 	return INET_ECN_decapsulate(skb, ipv6_get_dsfield(oipv6h), inner);
 }
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -128,17 +128,6 @@ static inline void qdisc_run(struct Qdis
 	}
 }
 
-static inline __be16 tc_skb_protocol(const struct sk_buff *skb)
-{
-	/* We need to take extra care in case the skb came via
-	 * vlan accelerated path. In that case, use skb->vlan_proto
-	 * as the original vlan header was already stripped.
-	 */
-	if (skb_vlan_tag_present(skb))
-		return skb->vlan_proto;
-	return skb->protocol;
-}
-
 /* Calculate maximal size of packet seen by hard_start_xmit
    routine of this device.
  */
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5730,12 +5730,16 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk
 {
 	unsigned int iphdr_len;
 
-	if (skb->protocol == cpu_to_be16(ETH_P_IP))
+	switch (skb_protocol(skb, true)) {
+	case cpu_to_be16(ETH_P_IP):
 		iphdr_len = sizeof(struct iphdr);
-	else if (skb->protocol == cpu_to_be16(ETH_P_IPV6))
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
 		iphdr_len = sizeof(struct ipv6hdr);
-	else
+		break;
+	default:
 		return 0;
+	}
 
 	if (skb_headlen(skb) < iphdr_len)
 		return 0;
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -43,17 +43,20 @@ static int tcf_connmark_act(struct sk_bu
 	tcf_lastuse_update(&ca->tcf_tm);
 	bstats_update(&ca->tcf_bstats, skb);
 
-	if (skb->protocol == htons(ETH_P_IP)) {
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		if (skb->len < sizeof(struct iphdr))
 			goto out;
 
 		proto = NFPROTO_IPV4;
-	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		break;
+	case htons(ETH_P_IPV6):
 		if (skb->len < sizeof(struct ipv6hdr))
 			goto out;
 
 		proto = NFPROTO_IPV6;
-	} else {
+		break;
+	default:
 		goto out;
 	}
 
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -587,7 +587,7 @@ static int tcf_csum_act(struct sk_buff *
 		goto drop;
 
 	update_flags = params->update_flags;
-	protocol = tc_skb_protocol(skb);
+	protocol = skb_protocol(skb, false);
 again:
 	switch (protocol) {
 	case cpu_to_be16(ETH_P_IP):
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -100,7 +100,7 @@ static u8 tcf_ct_skb_nf_family(struct sk
 {
 	u8 family = NFPROTO_UNSPEC;
 
-	switch (skb->protocol) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		family = NFPROTO_IPV4;
 		break;
@@ -222,6 +222,7 @@ static int ct_nat_execute(struct sk_buff
 			  const struct nf_nat_range2 *range,
 			  enum nf_nat_manip_type maniptype)
 {
+	__be16 proto = skb_protocol(skb, true);
 	int hooknum, err = NF_ACCEPT;
 
 	/* See HOOK2MANIP(). */
@@ -233,14 +234,13 @@ static int ct_nat_execute(struct sk_buff
 	switch (ctinfo) {
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
-		if (skb->protocol == htons(ETH_P_IP) &&
+		if (proto == htons(ETH_P_IP) &&
 		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
 			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
 							   hooknum))
 				err = NF_DROP;
 			goto out;
-		} else if (IS_ENABLED(CONFIG_IPV6) &&
-			   skb->protocol == htons(ETH_P_IPV6)) {
+		} else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
 			__be16 frag_off;
 			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
 			int hdrlen = ipv6_skip_exthdr(skb,
@@ -993,4 +993,3 @@ MODULE_AUTHOR("Yossi Kuperman <yossiku@m
 MODULE_AUTHOR("Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>");
 MODULE_DESCRIPTION("Connection tracking action");
 MODULE_LICENSE("GPL v2");
-
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -96,19 +96,22 @@ static int tcf_ctinfo_act(struct sk_buff
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
-	if (tc_skb_protocol(skb) == htons(ETH_P_IP)) {
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
 		wlen += sizeof(struct iphdr);
 		if (!pskb_may_pull(skb, wlen))
 			goto out;
 
 		proto = NFPROTO_IPV4;
-	} else if (tc_skb_protocol(skb) == htons(ETH_P_IPV6)) {
+		break;
+	case htons(ETH_P_IPV6):
 		wlen += sizeof(struct ipv6hdr);
 		if (!pskb_may_pull(skb, wlen))
 			goto out;
 
 		proto = NFPROTO_IPV6;
-	} else {
+		break;
+	default:
 		goto out;
 	}
 
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -82,7 +82,7 @@ static int tcf_mpls_act(struct sk_buff *
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:
-		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
+		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb_protocol(skb, true)));
 		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len,
 				  skb->dev && skb->dev->type == ARPHRD_ETHER))
 			goto drop;
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -41,7 +41,7 @@ static int tcf_skbedit_act(struct sk_buf
 	if (params->flags & SKBEDIT_F_INHERITDSFIELD) {
 		int wlen = skb_network_offset(skb);
 
-		switch (tc_skb_protocol(skb)) {
+		switch (skb_protocol(skb, true)) {
 		case htons(ETH_P_IP):
 			wlen += sizeof(struct iphdr);
 			if (!pskb_may_pull(skb, wlen))
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1571,7 +1571,7 @@ int tcf_classify(struct sk_buff *skb, co
 reclassify:
 #endif
 	for (; tp; tp = rcu_dereference_bh(tp->next)) {
-		__be16 protocol = tc_skb_protocol(skb);
+		__be16 protocol = skb_protocol(skb, false);
 		int err;
 
 		if (tp->protocol != protocol &&
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -80,7 +80,7 @@ static u32 flow_get_dst(const struct sk_
 	if (dst)
 		return ntohl(dst);
 
-	return addr_fold(skb_dst(skb)) ^ (__force u16) tc_skb_protocol(skb);
+	return addr_fold(skb_dst(skb)) ^ (__force u16)skb_protocol(skb, true);
 }
 
 static u32 flow_get_proto(const struct sk_buff *skb,
@@ -104,7 +104,7 @@ static u32 flow_get_proto_dst(const stru
 	if (flow->ports.ports)
 		return ntohs(flow->ports.dst);
 
-	return addr_fold(skb_dst(skb)) ^ (__force u16) tc_skb_protocol(skb);
+	return addr_fold(skb_dst(skb)) ^ (__force u16)skb_protocol(skb, true);
 }
 
 static u32 flow_get_iif(const struct sk_buff *skb)
@@ -151,7 +151,7 @@ static u32 flow_get_nfct(const struct sk
 static u32 flow_get_nfct_src(const struct sk_buff *skb,
 			     const struct flow_keys *flow)
 {
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		return ntohl(CTTUPLE(skb, src.u3.ip));
 	case htons(ETH_P_IPV6):
@@ -164,7 +164,7 @@ fallback:
 static u32 flow_get_nfct_dst(const struct sk_buff *skb,
 			     const struct flow_keys *flow)
 {
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		return ntohl(CTTUPLE(skb, dst.u3.ip));
 	case htons(ETH_P_IPV6):
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -310,7 +310,7 @@ static int fl_classify(struct sk_buff *s
 		/* skb_flow_dissect() does not set n_proto in case an unknown
 		 * protocol, so do it rather here.
 		 */
-		skb_key.basic.n_proto = skb->protocol;
+		skb_key.basic.n_proto = skb_protocol(skb, false);
 		skb_flow_dissect_tunnel_info(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
--- a/net/sched/em_ipset.c
+++ b/net/sched/em_ipset.c
@@ -59,7 +59,7 @@ static int em_ipset_match(struct sk_buff
 	};
 	int ret, network_offset;
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		state.pf = NFPROTO_IPV4;
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -212,7 +212,7 @@ static int em_ipt_match(struct sk_buff *
 	struct nf_hook_state state;
 	int ret;
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return 0;
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -195,7 +195,7 @@ META_COLLECTOR(int_priority)
 META_COLLECTOR(int_protocol)
 {
 	/* Let userspace take care of the byte ordering */
-	dst->value = tc_skb_protocol(skb);
+	dst->value = skb_protocol(skb, false);
 }
 
 META_COLLECTOR(int_pkttype)
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -592,7 +592,7 @@ static void cake_update_flowkeys(struct
 	struct nf_conntrack_tuple tuple = {};
 	bool rev = !skb->_nfct;
 
-	if (tc_skb_protocol(skb) != htons(ETH_P_IP))
+	if (skb_protocol(skb, true) != htons(ETH_P_IP))
 		return;
 
 	if (!nf_ct_get_tuple_skb(&tuple, skb))
@@ -1521,7 +1521,7 @@ static u8 cake_handle_diffserv(struct sk
 	u16 *buf, buf_;
 	u8 dscp;
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		buf = skb_header_pointer(skb, offset, sizeof(buf_), &buf_);
 		if (unlikely(!buf))
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -210,7 +210,7 @@ static int dsmark_enqueue(struct sk_buff
 	if (p->set_tc_index) {
 		int wlen = skb_network_offset(skb);
 
-		switch (tc_skb_protocol(skb)) {
+		switch (skb_protocol(skb, true)) {
 		case htons(ETH_P_IP):
 			wlen += sizeof(struct iphdr);
 			if (!pskb_may_pull(skb, wlen) ||
@@ -303,7 +303,7 @@ static struct sk_buff *dsmark_dequeue(st
 	index = skb->tc_index & (p->indices - 1);
 	pr_debug("index %d->%d\n", skb->tc_index, index);
 
-	switch (tc_skb_protocol(skb)) {
+	switch (skb_protocol(skb, true)) {
 	case htons(ETH_P_IP):
 		ipv4_change_dsfield(ip_hdr(skb), p->mv[index].mask,
 				    p->mv[index].value);
@@ -320,7 +320,7 @@ static struct sk_buff *dsmark_dequeue(st
 		 */
 		if (p->mv[index].mask != 0xff || p->mv[index].value)
 			pr_warn("%s: unsupported protocol %d\n",
-				__func__, ntohs(tc_skb_protocol(skb)));
+				__func__, ntohs(skb_protocol(skb, true)));
 		break;
 	}
 
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -239,7 +239,7 @@ __teql_resolve(struct sk_buff *skb, stru
 		char haddr[MAX_ADDR_LEN];
 
 		neigh_ha_snapshot(haddr, n, dev);
-		err = dev_hard_header(skb, dev, ntohs(tc_skb_protocol(skb)),
+		err = dev_hard_header(skb, dev, ntohs(skb_protocol(skb, false)),
 				      haddr, NULL, skb->len);
 
 		if (err < 0)



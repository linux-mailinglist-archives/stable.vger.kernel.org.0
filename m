Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79532B6521
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgKQNvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731783AbgKQNbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98D1821534;
        Tue, 17 Nov 2020 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619870;
        bh=nqUSdrmq0K10KxmmM+IWyiZIL8t3oYNXiWkVH9lAuyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+x01wlsgmgH/aLnJCArB/z+DQiCpTO7vGjU262zbw/QEIraaT1gFss4GXOuLjGit
         s+MHutOJe36KSfoqji8nY4gGnawvh8m1XV0Vg23tzlJ+mnoznCmNe7VUCVgn5rlVMt
         Vmv2us/DtYQihTlzlb61k3BocZd3XM8dgnyfdaiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 024/255] netfilter: use actual socket sk rather than skb sk when routing harder
Date:   Tue, 17 Nov 2020 14:02:44 +0100
Message-Id: <20201117122140.120632060@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 46d6c5ae953cc0be38efd0e469284df7c4328cf8 ]

If netfilter changes the packet mark when mangling, the packet is
rerouted using the route_me_harder set of functions. Prior to this
commit, there's one big difference between route_me_harder and the
ordinary initial routing functions, described in the comment above
__ip_queue_xmit():

   /* Note: skb->sk can be different from sk, in case of tunnels */
   int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,

That function goes on to correctly make use of sk->sk_bound_dev_if,
rather than skb->sk->sk_bound_dev_if. And indeed the comment is true: a
tunnel will receive a packet in ndo_start_xmit with an initial skb->sk.
It will make some transformations to that packet, and then it will send
the encapsulated packet out of a *new* socket. That new socket will
basically always have a different sk_bound_dev_if (otherwise there'd be
a routing loop). So for the purposes of routing the encapsulated packet,
the routing information as it pertains to the socket should come from
that socket's sk, rather than the packet's original skb->sk. For that
reason __ip_queue_xmit() and related functions all do the right thing.

One might argue that all tunnels should just call skb_orphan(skb) before
transmitting the encapsulated packet into the new socket. But tunnels do
*not* do this -- and this is wisely avoided in skb_scrub_packet() too --
because features like TSQ rely on skb->destructor() being called when
that buffer space is truely available again. Calling skb_orphan(skb) too
early would result in buffers filling up unnecessarily and accounting
info being all wrong. Instead, additional routing must take into account
the new sk, just as __ip_queue_xmit() notes.

So, this commit addresses the problem by fishing the correct sk out of
state->sk -- it's already set properly in the call to nf_hook() in
__ip_local_out(), which receives the sk as part of its normal
functionality. So we make sure to plumb state->sk through the various
route_me_harder functions, and then make correct use of it following the
example of __ip_queue_xmit().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_ipv4.h       |  2 +-
 include/linux/netfilter_ipv6.h       | 10 +++++-----
 net/ipv4/netfilter.c                 |  8 +++++---
 net/ipv4/netfilter/iptable_mangle.c  |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c  |  2 +-
 net/ipv6/netfilter.c                 |  6 +++---
 net/ipv6/netfilter/ip6table_mangle.c |  2 +-
 net/netfilter/ipvs/ip_vs_core.c      |  4 ++--
 net/netfilter/nf_nat_proto.c         |  4 ++--
 net/netfilter/nf_synproxy_core.c     |  2 +-
 net/netfilter/nft_chain_route.c      |  4 ++--
 net/netfilter/utils.c                |  4 ++--
 12 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 082e2c41b7ff9..5b70ca868bb19 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -16,7 +16,7 @@ struct ip_rt_info {
 	u_int32_t mark;
 };
 
-int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned addr_type);
+int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, unsigned addr_type);
 
 struct nf_queue_entry;
 
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 9b67394471e1c..48314ade1506f 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -42,7 +42,7 @@ struct nf_ipv6_ops {
 #if IS_MODULE(CONFIG_IPV6)
 	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
 			const struct net_device *dev, int strict);
-	int (*route_me_harder)(struct net *net, struct sk_buff *skb);
+	int (*route_me_harder)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int (*dev_get_saddr)(struct net *net, const struct net_device *dev,
 		       const struct in6_addr *daddr, unsigned int srcprefs,
 		       struct in6_addr *saddr);
@@ -143,9 +143,9 @@ static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
 #endif
 }
 
-int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
+int ip6_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb);
 
-static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
+static inline int nf_ip6_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 #if IS_MODULE(CONFIG_IPV6)
 	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
@@ -153,9 +153,9 @@ static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 	if (!v6_ops)
 		return -EHOSTUNREACH;
 
-	return v6_ops->route_me_harder(net, skb);
+	return v6_ops->route_me_harder(net, sk, skb);
 #elif IS_BUILTIN(CONFIG_IPV6)
-	return ip6_route_me_harder(net, skb);
+	return ip6_route_me_harder(net, sk, skb);
 #else
 	return -EHOSTUNREACH;
 #endif
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index a058213b77a78..7c841037c5334 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -17,17 +17,19 @@
 #include <net/netfilter/nf_queue.h>
 
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
-int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned int addr_type)
+int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, unsigned int addr_type)
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	struct rtable *rt;
 	struct flowi4 fl4 = {};
 	__be32 saddr = iph->saddr;
-	const struct sock *sk = skb_to_full_sk(skb);
-	__u8 flags = sk ? inet_sk_flowi_flags(sk) : 0;
+	__u8 flags;
 	struct net_device *dev = skb_dst(skb)->dev;
 	unsigned int hh_len;
 
+	sk = sk_to_full_sk(sk);
+	flags = sk ? inet_sk_flowi_flags(sk) : 0;
+
 	if (addr_type == RTN_UNSPEC)
 		addr_type = inet_addr_type_dev_table(net, dev, saddr);
 	if (addr_type == RTN_LOCAL || addr_type == RTN_UNICAST)
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index f703a717ab1d2..8330795892730 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -62,7 +62,7 @@ ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
 		    iph->daddr != daddr ||
 		    skb->mark != mark ||
 		    iph->tos != tos) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 9dcfa4e461b65..93b07739807b2 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -145,7 +145,7 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 				   ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 
-	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
+	if (ip_route_me_harder(net, nskb->sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
 	niph = ip_hdr(nskb);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 6d0e942d082d4..ab9a279dd6d47 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -20,10 +20,10 @@
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include "../bridge/br_private.h"
 
-int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
+int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff *skb)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct sock *sk = sk_to_full_sk(skb->sk);
+	struct sock *sk = sk_to_full_sk(sk_partial);
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	int strict = (ipv6_addr_type(&iph->daddr) &
@@ -84,7 +84,7 @@ static int nf_ip6_reroute(struct sk_buff *skb,
 		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
 		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
 		    skb->mark != rt_info->mark)
-			return ip6_route_me_harder(entry->state.net, skb);
+			return ip6_route_me_harder(entry->state.net, entry->state.sk, skb);
 	}
 	return 0;
 }
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 1a2748611e003..cee74803d7a1c 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -57,7 +57,7 @@ ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
 	     skb->mark != mark ||
 	     ipv6_hdr(skb)->hop_limit != hop_limit ||
 	     flowlabel != *((u_int32_t *)ipv6_hdr(skb)))) {
-		err = ip6_route_me_harder(state->net, skb);
+		err = ip6_route_me_harder(state->net, state->sk, skb);
 		if (err < 0)
 			ret = NF_DROP_ERR(err);
 	}
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index e3668a6e54e47..570d8ef6fb8b6 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -742,12 +742,12 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
 		struct dst_entry *dst = skb_dst(skb);
 
 		if (dst->dev && !(dst->dev->flags & IFF_LOOPBACK) &&
-		    ip6_route_me_harder(ipvs->net, skb) != 0)
+		    ip6_route_me_harder(ipvs->net, skb->sk, skb) != 0)
 			return 1;
 	} else
 #endif
 		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL) &&
-		    ip_route_me_harder(ipvs->net, skb, RTN_LOCAL) != 0)
+		    ip_route_me_harder(ipvs->net, skb->sk, skb, RTN_LOCAL) != 0)
 			return 1;
 
 	return 0;
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 59151dc07fdc1..e87b6bd6b3cdb 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -715,7 +715,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 
 		if (ct->tuplehash[dir].tuple.dst.u3.ip !=
 		    ct->tuplehash[!dir].tuple.src.u3.ip) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
@@ -953,7 +953,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 
 		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3,
 				      &ct->tuplehash[!dir].tuple.src.u3)) {
-			err = nf_ip6_route_me_harder(state->net, skb);
+			err = nf_ip6_route_me_harder(state->net, state->sk, skb);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 9cca35d229273..d7d34a62d3bf5 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -446,7 +446,7 @@ synproxy_send_tcp(struct net *net,
 
 	skb_dst_set_noref(nskb, skb_dst(skb));
 	nskb->protocol = htons(ETH_P_IP);
-	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
+	if (ip_route_me_harder(net, nskb->sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
 	if (nfct) {
diff --git a/net/netfilter/nft_chain_route.c b/net/netfilter/nft_chain_route.c
index 8826bbe71136c..edd02cda57fca 100644
--- a/net/netfilter/nft_chain_route.c
+++ b/net/netfilter/nft_chain_route.c
@@ -42,7 +42,7 @@ static unsigned int nf_route_table_hook4(void *priv,
 		    iph->daddr != daddr ||
 		    skb->mark != mark ||
 		    iph->tos != tos) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
@@ -92,7 +92,7 @@ static unsigned int nf_route_table_hook6(void *priv,
 	     skb->mark != mark ||
 	     ipv6_hdr(skb)->hop_limit != hop_limit ||
 	     flowlabel != *((u32 *)ipv6_hdr(skb)))) {
-		err = nf_ip6_route_me_harder(state->net, skb);
+		err = nf_ip6_route_me_harder(state->net, state->sk, skb);
 		if (err < 0)
 			ret = NF_DROP_ERR(err);
 	}
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index cedf47ab3c6f9..2182d361e273f 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -191,8 +191,8 @@ static int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry
 		      skb->mark == rt_info->mark &&
 		      iph->daddr == rt_info->daddr &&
 		      iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(entry->state.net, skb,
-						  RTN_UNSPEC);
+			return ip_route_me_harder(entry->state.net, entry->state.sk,
+						  skb, RTN_UNSPEC);
 	}
 #endif
 	return 0;
-- 
2.27.0




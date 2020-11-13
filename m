Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71AF2B28C7
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 23:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgKMWtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 17:49:50 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:55327 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKMWtt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 17:49:49 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f16a8d82;
        Fri, 13 Nov 2020 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=7l5s7QBG4DD6GUlronyKgzbmp
        JU=; b=1oiPc+WuBEjOFNKlDQmmg7hjs7Sp/q8WT7nGM8p4g/da5iIbAovymJQXc
        Vuj9Rj76bMlB7V7ChjX1DUpFu42hYgz4IdjmjwK7sK3XmSpGIvap766ehDESGlls
        Xs68+m/5J3ejxtWlbgVcpBWSfORqHiII7TrjILbMqLUQW7QuCFMoiCdmsX4o/n1R
        W239kPiuShz58JhWx6Ew8FtiR8PDeTooduvmwe+DdwESzDZF3u/kNr3dGMOp7ofd
        bLKh+raI6mpDdJr3ZMESdpGwYAeg9ZvnX57wNd+7jKhrpwAFljssSZVPRRQfrerx
        tfmqVeb3siiCPImhDFl/R1+E8KvUw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0e03f5c2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 13 Nov 2020 22:46:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg KH <greg@kroah.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19] netfilter: use actual socket sk rather than skb sk when routing harder
Date:   Fri, 13 Nov 2020 23:49:36 +0100
Message-Id: <20201113224936.2969548-1-Jason@zx2c4.com>
In-Reply-To: <X6rMJe+bF+/ZyyTz@kroah.com>
References: <X6rMJe+bF+/ZyyTz@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[Jason: backported to 4.19 from Sasha's 5.4 backport]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/netfilter_ipv4.h            |  2 +-
 include/linux/netfilter_ipv6.h            |  2 +-
 net/ipv4/netfilter.c                      | 12 +++++++-----
 net/ipv4/netfilter/ipt_SYNPROXY.c         |  2 +-
 net/ipv4/netfilter/iptable_mangle.c       |  2 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c  |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c       |  2 +-
 net/ipv4/netfilter/nft_chain_route_ipv4.c |  2 +-
 net/ipv6/netfilter.c                      |  6 +++---
 net/ipv6/netfilter/ip6table_mangle.c      |  2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c  |  2 +-
 net/ipv6/netfilter/nft_chain_route_ipv6.c |  2 +-
 net/netfilter/ipvs/ip_vs_core.c           |  4 ++--
 13 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 95ab5cc64422..45ff1330b339 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -16,7 +16,7 @@ struct ip_rt_info {
 	u_int32_t mark;
 };
 
-int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned addr_type);
+int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, unsigned addr_type);
 
 struct nf_queue_entry;
 
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index c0dc4dd78887..47a2de582f57 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -36,7 +36,7 @@ struct nf_ipv6_ops {
 };
 
 #ifdef CONFIG_NETFILTER
-int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
+int ip6_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb);
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 8d2e5dc9a827..3d670d5aea34 100644
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
@@ -91,8 +93,8 @@ int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry)
 		      skb->mark == rt_info->mark &&
 		      iph->daddr == rt_info->daddr &&
 		      iph->saddr == rt_info->saddr))
-			return ip_route_me_harder(entry->state.net, skb,
-						  RTN_UNSPEC);
+			return ip_route_me_harder(entry->state.net, entry->state.sk,
+						  skb, RTN_UNSPEC);
 	}
 	return 0;
 }
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 690b17ef6a44..d64b1ef43c10 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -54,7 +54,7 @@ synproxy_send_tcp(struct net *net,
 
 	skb_dst_set_noref(nskb, skb_dst(skb));
 	nskb->protocol = htons(ETH_P_IP);
-	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
+	if (ip_route_me_harder(net, nskb->sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
 	if (nfct) {
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index dea138ca8925..0829f46ddfdd 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -65,7 +65,7 @@ ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
 		    iph->daddr != daddr ||
 		    skb->mark != mark ||
 		    iph->tos != tos) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 6115bf1ff6f0..6a27766b7d0f 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -329,7 +329,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 
 		if (ct->tuplehash[dir].tuple.dst.u3.ip !=
 		    ct->tuplehash[!dir].tuple.src.u3.ip) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 5cd06ba3535d..4996db1f64a1 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -129,7 +129,7 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 				   ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 
-	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
+	if (ip_route_me_harder(net, nskb->sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
 	niph = ip_hdr(nskb);
diff --git a/net/ipv4/netfilter/nft_chain_route_ipv4.c b/net/ipv4/netfilter/nft_chain_route_ipv4.c
index 7d82934c46f4..61003768e52b 100644
--- a/net/ipv4/netfilter/nft_chain_route_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_route_ipv4.c
@@ -50,7 +50,7 @@ static unsigned int nf_route_table_hook(void *priv,
 		    iph->daddr != daddr ||
 		    skb->mark != mark ||
 		    iph->tos != tos) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 6d0b1f3e927b..5679fa3f696a 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -17,10 +17,10 @@
 #include <net/xfrm.h>
 #include <net/netfilter/nf_queue.h>
 
-int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
+int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff *skb)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct sock *sk = sk_to_full_sk(skb->sk);
+	struct sock *sk = sk_to_full_sk(sk_partial);
 	unsigned int hh_len;
 	struct dst_entry *dst;
 	int strict = (ipv6_addr_type(&iph->daddr) &
@@ -81,7 +81,7 @@ static int nf_ip6_reroute(struct sk_buff *skb,
 		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
 		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
 		    skb->mark != rt_info->mark)
-			return ip6_route_me_harder(entry->state.net, skb);
+			return ip6_route_me_harder(entry->state.net, entry->state.sk, skb);
 	}
 	return 0;
 }
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index b0524b18c4fb..acba3757ff60 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -60,7 +60,7 @@ ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state)
 	     skb->mark != mark ||
 	     ipv6_hdr(skb)->hop_limit != hop_limit ||
 	     flowlabel != *((u_int32_t *)ipv6_hdr(skb)))) {
-		err = ip6_route_me_harder(state->net, skb);
+		err = ip6_route_me_harder(state->net, state->sk, skb);
 		if (err < 0)
 			ret = NF_DROP_ERR(err);
 	}
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index ca6d38698b1a..2b6a3b27f670 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -352,7 +352,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 
 		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3,
 				      &ct->tuplehash[!dir].tuple.src.u3)) {
-			err = ip6_route_me_harder(state->net, skb);
+			err = ip6_route_me_harder(state->net, state->sk, skb);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
index da3f1f8cb325..afe79cb46e63 100644
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_route_ipv6.c
@@ -52,7 +52,7 @@ static unsigned int nf_route_table_hook(void *priv,
 	     skb->mark != mark ||
 	     ipv6_hdr(skb)->hop_limit != hop_limit ||
 	     flowlabel != *((u_int32_t *)ipv6_hdr(skb)))) {
-		err = ip6_route_me_harder(state->net, skb);
+		err = ip6_route_me_harder(state->net, state->sk, skb);
 		if (err < 0)
 			ret = NF_DROP_ERR(err);
 	}
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d5e4329579e2..acaeeaf81441 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -725,12 +725,12 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
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
-- 
2.29.1


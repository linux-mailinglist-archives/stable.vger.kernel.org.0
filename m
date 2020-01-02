Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817E012EC58
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgABWRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbgABWRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1803922314;
        Thu,  2 Jan 2020 22:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003454;
        bh=qZ/PTkbMR/9spREKCWZx8OfV4qRNAcpSavqRtMo9V8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUZDsKMUi0qgJwr2ENZ5fjiBdJCn8PPOITJ9WhY3FM52+6riXelefFL8vaoi6rJTE
         8Lre/c1O44h0+S2Rvgnxrc0fSgjCJVO2ghIz3I5DGZZ+zqcvCqknfoko1qzx3wQqwN
         uAHf20KC7i/Z14OFQdf2wPXslU2cK1EJut8toXM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Miller <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 5.4 167/191] net: add bool confirm_neigh parameter for dst_ops.update_pmtu
Date:   Thu,  2 Jan 2020 23:07:29 +0100
Message-Id: <20200102215847.224283302@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit bd085ef678b2cc8c38c105673dfe8ff8f5ec0c57 ]

The MTU update code is supposed to be invoked in response to real
networking events that update the PMTU. In IPv6 PMTU update function
__ip6_rt_update_pmtu() we called dst_confirm_neigh() to update neighbor
confirmed time.

But for tunnel code, it will call pmtu before xmit, like:
  - tnl_update_pmtu()
    - skb_dst_update_pmtu()
      - ip6_rt_update_pmtu()
        - __ip6_rt_update_pmtu()
          - dst_confirm_neigh()

If the tunnel remote dst mac address changed and we still do the neigh
confirm, we will not be able to update neigh cache and ping6 remote
will failed.

So for this ip_tunnel_xmit() case, _EVEN_ if the MTU is changed, we
should not be invoking dst_confirm_neigh() as we have no evidence
of successful two-way communication at this point.

On the other hand it is also important to keep the neigh reachability fresh
for TCP flows, so we cannot remove this dst_confirm_neigh() call.

To fix the issue, we have to add a new bool parameter for dst_ops.update_pmtu
to choose whether we should do neigh update or not. I will add the parameter
in this patch and set all the callers to true to comply with the previous
way, and fix the tunnel code one by one on later patches.

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Suggested-by: David Miller <davem@davemloft.net>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c                |    2 +-
 include/net/dst.h                |    2 +-
 include/net/dst_ops.h            |    3 ++-
 net/bridge/br_nf_core.c          |    3 ++-
 net/decnet/dn_route.c            |    6 ++++--
 net/ipv4/inet_connection_sock.c  |    2 +-
 net/ipv4/route.c                 |    9 ++++++---
 net/ipv4/xfrm4_policy.c          |    5 +++--
 net/ipv6/inet6_connection_sock.c |    2 +-
 net/ipv6/ip6_gre.c               |    2 +-
 net/ipv6/route.c                 |   22 +++++++++++++++-------
 net/ipv6/xfrm6_policy.c          |    5 +++--
 net/netfilter/ipvs/ip_vs_xmit.c  |    2 +-
 net/sctp/transport.c             |    2 +-
 14 files changed, 42 insertions(+), 25 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -541,7 +541,7 @@ static int gtp_build_skb_ip4(struct sk_b
 		mtu = dst_mtu(&rt->dst);
 	}
 
-	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu);
+	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, true);
 
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -516,7 +516,7 @@ static inline void skb_dst_update_pmtu(s
 	struct dst_entry *dst = skb_dst(skb);
 
 	if (dst && dst->ops->update_pmtu)
-		dst->ops->update_pmtu(dst, NULL, skb, mtu);
+		dst->ops->update_pmtu(dst, NULL, skb, mtu, true);
 }
 
 static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -27,7 +27,8 @@ struct dst_ops {
 	struct dst_entry *	(*negative_advice)(struct dst_entry *);
 	void			(*link_failure)(struct sk_buff *);
 	void			(*update_pmtu)(struct dst_entry *dst, struct sock *sk,
-					       struct sk_buff *skb, u32 mtu);
+					       struct sk_buff *skb, u32 mtu,
+					       bool confirm_neigh);
 	void			(*redirect)(struct dst_entry *dst, struct sock *sk,
 					    struct sk_buff *skb);
 	int			(*local_out)(struct net *net, struct sock *sk, struct sk_buff *skb);
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -22,7 +22,8 @@
 #endif
 
 static void fake_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			     struct sk_buff *skb, u32 mtu)
+			     struct sk_buff *skb, u32 mtu,
+			     bool confirm_neigh)
 {
 }
 
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -110,7 +110,8 @@ static void dn_dst_ifdown(struct dst_ent
 static struct dst_entry *dn_dst_negative_advice(struct dst_entry *);
 static void dn_dst_link_failure(struct sk_buff *);
 static void dn_dst_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			       struct sk_buff *skb , u32 mtu);
+			       struct sk_buff *skb , u32 mtu,
+			       bool confirm_neigh);
 static void dn_dst_redirect(struct dst_entry *dst, struct sock *sk,
 			    struct sk_buff *skb);
 static struct neighbour *dn_dst_neigh_lookup(const struct dst_entry *dst,
@@ -251,7 +252,8 @@ static int dn_dst_gc(struct dst_ops *ops
  * advertise to the other end).
  */
 static void dn_dst_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			       struct sk_buff *skb, u32 mtu)
+			       struct sk_buff *skb, u32 mtu,
+			       bool confirm_neigh)
 {
 	struct dn_route *rt = (struct dn_route *) dst;
 	struct neighbour *n = rt->n;
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1086,7 +1086,7 @@ struct dst_entry *inet_csk_update_pmtu(s
 		if (!dst)
 			goto out;
 	}
-	dst->ops->update_pmtu(dst, sk, NULL, mtu);
+	dst->ops->update_pmtu(dst, sk, NULL, mtu, true);
 
 	dst = __sk_dst_check(sk, 0);
 	if (!dst)
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -139,7 +139,8 @@ static unsigned int	 ipv4_mtu(const stru
 static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst);
 static void		 ipv4_link_failure(struct sk_buff *skb);
 static void		 ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					   struct sk_buff *skb, u32 mtu);
+					   struct sk_buff *skb, u32 mtu,
+					   bool confirm_neigh);
 static void		 ip_do_redirect(struct dst_entry *dst, struct sock *sk,
 					struct sk_buff *skb);
 static void		ipv4_dst_destroy(struct dst_entry *dst);
@@ -1043,7 +1044,8 @@ static void __ip_rt_update_pmtu(struct r
 }
 
 static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			      struct sk_buff *skb, u32 mtu)
+			      struct sk_buff *skb, u32 mtu,
+			      bool confirm_neigh)
 {
 	struct rtable *rt = (struct rtable *) dst;
 	struct flowi4 fl4;
@@ -2648,7 +2650,8 @@ static unsigned int ipv4_blackhole_mtu(c
 }
 
 static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					  struct sk_buff *skb, u32 mtu)
+					  struct sk_buff *skb, u32 mtu,
+					  bool confirm_neigh)
 {
 }
 
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -100,12 +100,13 @@ static int xfrm4_fill_dst(struct xfrm_ds
 }
 
 static void xfrm4_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			      struct sk_buff *skb, u32 mtu)
+			      struct sk_buff *skb, u32 mtu,
+			      bool confirm_neigh)
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 	struct dst_entry *path = xdst->route;
 
-	path->ops->update_pmtu(path, sk, skb, mtu);
+	path->ops->update_pmtu(path, sk, skb, mtu, confirm_neigh);
 }
 
 static void xfrm4_redirect(struct dst_entry *dst, struct sock *sk,
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -146,7 +146,7 @@ struct dst_entry *inet6_csk_update_pmtu(
 
 	if (IS_ERR(dst))
 		return NULL;
-	dst->ops->update_pmtu(dst, sk, NULL, mtu);
+	dst->ops->update_pmtu(dst, sk, NULL, mtu, true);
 
 	dst = inet6_csk_route_socket(sk, &fl6);
 	return IS_ERR(dst) ? NULL : dst;
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1040,7 +1040,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu);
+		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, true);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   NEXTHDR_GRE);
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -95,7 +95,8 @@ static int		ip6_pkt_prohibit(struct sk_b
 static int		ip6_pkt_prohibit_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 static void		ip6_link_failure(struct sk_buff *skb);
 static void		ip6_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					   struct sk_buff *skb, u32 mtu);
+					   struct sk_buff *skb, u32 mtu,
+					   bool confirm_neigh);
 static void		rt6_do_redirect(struct dst_entry *dst, struct sock *sk,
 					struct sk_buff *skb);
 static int rt6_score_route(const struct fib6_nh *nh, u32 fib6_flags, int oif,
@@ -264,7 +265,8 @@ static unsigned int ip6_blackhole_mtu(co
 }
 
 static void ip6_rt_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
-					 struct sk_buff *skb, u32 mtu)
+					 struct sk_buff *skb, u32 mtu,
+					 bool confirm_neigh)
 {
 }
 
@@ -2695,7 +2697,8 @@ static bool rt6_cache_allowed_for_pmtu(c
 }
 
 static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
-				 const struct ipv6hdr *iph, u32 mtu)
+				 const struct ipv6hdr *iph, u32 mtu,
+				 bool confirm_neigh)
 {
 	const struct in6_addr *daddr, *saddr;
 	struct rt6_info *rt6 = (struct rt6_info *)dst;
@@ -2713,7 +2716,10 @@ static void __ip6_rt_update_pmtu(struct
 		daddr = NULL;
 		saddr = NULL;
 	}
-	dst_confirm_neigh(dst, daddr);
+
+	if (confirm_neigh)
+		dst_confirm_neigh(dst, daddr);
+
 	mtu = max_t(u32, mtu, IPV6_MIN_MTU);
 	if (mtu >= dst_mtu(dst))
 		return;
@@ -2767,9 +2773,11 @@ out_unlock:
 }
 
 static void ip6_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			       struct sk_buff *skb, u32 mtu)
+			       struct sk_buff *skb, u32 mtu,
+			       bool confirm_neigh)
 {
-	__ip6_rt_update_pmtu(dst, sk, skb ? ipv6_hdr(skb) : NULL, mtu);
+	__ip6_rt_update_pmtu(dst, sk, skb ? ipv6_hdr(skb) : NULL, mtu,
+			     confirm_neigh);
 }
 
 void ip6_update_pmtu(struct sk_buff *skb, struct net *net, __be32 mtu,
@@ -2788,7 +2796,7 @@ void ip6_update_pmtu(struct sk_buff *skb
 
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (!dst->error)
-		__ip6_rt_update_pmtu(dst, NULL, iph, ntohl(mtu));
+		__ip6_rt_update_pmtu(dst, NULL, iph, ntohl(mtu), true);
 	dst_release(dst);
 }
 EXPORT_SYMBOL_GPL(ip6_update_pmtu);
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -98,12 +98,13 @@ static int xfrm6_fill_dst(struct xfrm_ds
 }
 
 static void xfrm6_update_pmtu(struct dst_entry *dst, struct sock *sk,
-			      struct sk_buff *skb, u32 mtu)
+			      struct sk_buff *skb, u32 mtu,
+			      bool confirm_neigh)
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 	struct dst_entry *path = xdst->route;
 
-	path->ops->update_pmtu(path, sk, skb, mtu);
+	path->ops->update_pmtu(path, sk, skb, mtu, confirm_neigh);
 }
 
 static void xfrm6_redirect(struct dst_entry *dst, struct sock *sk,
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -208,7 +208,7 @@ static inline void maybe_update_pmtu(int
 	struct rtable *ort = skb_rtable(skb);
 
 	if (!skb->dev && sk && sk_fullsock(sk))
-		ort->dst.ops->update_pmtu(&ort->dst, sk, NULL, mtu);
+		ort->dst.ops->update_pmtu(&ort->dst, sk, NULL, mtu, true);
 }
 
 static inline bool ensure_mtu_is_adequate(struct netns_ipvs *ipvs, int skb_af,
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -263,7 +263,7 @@ bool sctp_transport_update_pmtu(struct s
 
 		pf->af->from_sk(&addr, sk);
 		pf->to_sk_daddr(&t->ipaddr, sk);
-		dst->ops->update_pmtu(dst, sk, NULL, pmtu);
+		dst->ops->update_pmtu(dst, sk, NULL, pmtu, true);
 		pf->to_sk_daddr(&addr, sk);
 
 		dst = sctp_transport_dst_check(t);



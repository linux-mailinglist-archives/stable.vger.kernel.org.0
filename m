Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F74CA639
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404588AbfJCQlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392502AbfJCQlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D356206BB;
        Thu,  3 Oct 2019 16:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120878;
        bh=00OTd1dz2jgplco0ubuPDUqryUSVd6/BFS1qtabzsTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8/Op+RjiwgVOAyOIqjn7KWydp3qOPAzg1cxb3pq97tctQOMDogoPgv0bxmldQjl5
         P+dxUIRSc+bVIq5qk/DApuigfU1EqkJLOJTVzR1Eqo4B6e48QCjKGBBk7ekPSOhKoc
         txF7AWtLhtsaX4t25PNM5/EmVg7c2x8t5I3UJ7r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.3 026/344] ipv4: Revert removal of rt_uses_gateway
Date:   Thu,  3 Oct 2019 17:49:51 +0200
Message-Id: <20191003154542.662890537@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 77d5bc7e6a6cf8bbeca31aab7f0c5449a5eee762 ]

Julian noted that rt_uses_gateway has a more subtle use than 'is gateway
set':
    https://lore.kernel.org/netdev/alpine.LFD.2.21.1909151104060.2546@ja.home.ssi.bg/

Revert that part of the commit referenced in the Fixes tag.

Currently, there are no u8 holes in 'struct rtable'. There is a 4-byte hole
in the second cacheline which contains the gateway declaration. So move
rt_gw_family down to the gateway declarations since they are always used
together, and then re-use that u8 for rt_uses_gateway. End result is that
rtable size is unchanged.

Fixes: 1550c171935d ("ipv4: Prepare rtable for IPv6 gateway")
Reported-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/addr.c  |    2 +-
 include/net/route.h             |    3 ++-
 net/ipv4/inet_connection_sock.c |    4 ++--
 net/ipv4/ip_forward.c           |    2 +-
 net/ipv4/ip_output.c            |    2 +-
 net/ipv4/route.c                |   36 +++++++++++++++++++++---------------
 net/ipv4/xfrm4_policy.c         |    1 +
 7 files changed, 29 insertions(+), 21 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -352,7 +352,7 @@ static bool has_gateway(const struct dst
 
 	if (family == AF_INET) {
 		rt = container_of(dst, struct rtable, dst);
-		return rt->rt_gw_family == AF_INET;
+		return rt->rt_uses_gateway;
 	}
 
 	rt6 = container_of(dst, struct rt6_info, dst);
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -53,10 +53,11 @@ struct rtable {
 	unsigned int		rt_flags;
 	__u16			rt_type;
 	__u8			rt_is_input;
-	u8			rt_gw_family;
+	__u8			rt_uses_gateway;
 
 	int			rt_iif;
 
+	u8			rt_gw_family;
 	/* Info on neighbour */
 	union {
 		__be32		rt_gw4;
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -560,7 +560,7 @@ struct dst_entry *inet_csk_route_req(con
 	rt = ip_route_output_flow(net, fl4, sk);
 	if (IS_ERR(rt))
 		goto no_route;
-	if (opt && opt->opt.is_strictroute && rt->rt_gw_family)
+	if (opt && opt->opt.is_strictroute && rt->rt_uses_gateway)
 		goto route_err;
 	rcu_read_unlock();
 	return &rt->dst;
@@ -598,7 +598,7 @@ struct dst_entry *inet_csk_route_child_s
 	rt = ip_route_output_flow(net, fl4, sk);
 	if (IS_ERR(rt))
 		goto no_route;
-	if (opt && opt->opt.is_strictroute && rt->rt_gw_family)
+	if (opt && opt->opt.is_strictroute && rt->rt_uses_gateway)
 		goto route_err;
 	return &rt->dst;
 
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -123,7 +123,7 @@ int ip_forward(struct sk_buff *skb)
 
 	rt = skb_rtable(skb);
 
-	if (opt->is_strictroute && rt->rt_gw_family)
+	if (opt->is_strictroute && rt->rt_uses_gateway)
 		goto sr_failed;
 
 	IPCB(skb)->flags |= IPSKB_FORWARDED;
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -499,7 +499,7 @@ int __ip_queue_xmit(struct sock *sk, str
 	skb_dst_set_noref(skb, &rt->dst);
 
 packet_routed:
-	if (inet_opt && inet_opt->opt.is_strictroute && rt->rt_gw_family)
+	if (inet_opt && inet_opt->opt.is_strictroute && rt->rt_uses_gateway)
 		goto no_route;
 
 	/* OK, we know where to send it, allocate and build IP header. */
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -635,6 +635,7 @@ static void fill_route_from_fnhe(struct
 
 	if (fnhe->fnhe_gw) {
 		rt->rt_flags |= RTCF_REDIRECTED;
+		rt->rt_uses_gateway = 1;
 		rt->rt_gw_family = AF_INET;
 		rt->rt_gw4 = fnhe->fnhe_gw;
 	}
@@ -1313,7 +1314,7 @@ static unsigned int ipv4_mtu(const struc
 	mtu = READ_ONCE(dst->dev->mtu);
 
 	if (unlikely(ip_mtu_locked(dst))) {
-		if (rt->rt_gw_family && mtu > 576)
+		if (rt->rt_uses_gateway && mtu > 576)
 			mtu = 576;
 	}
 
@@ -1569,6 +1570,7 @@ static void rt_set_nexthop(struct rtable
 		struct fib_nh_common *nhc = FIB_RES_NHC(*res);
 
 		if (nhc->nhc_gw_family && nhc->nhc_scope == RT_SCOPE_LINK) {
+			rt->rt_uses_gateway = 1;
 			rt->rt_gw_family = nhc->nhc_gw_family;
 			/* only INET and INET6 are supported */
 			if (likely(nhc->nhc_gw_family == AF_INET))
@@ -1634,6 +1636,7 @@ struct rtable *rt_dst_alloc(struct net_d
 		rt->rt_iif = 0;
 		rt->rt_pmtu = 0;
 		rt->rt_mtu_locked = 0;
+		rt->rt_uses_gateway = 0;
 		rt->rt_gw_family = 0;
 		rt->rt_gw4 = 0;
 		INIT_LIST_HEAD(&rt->rt_uncached);
@@ -2694,6 +2697,7 @@ struct dst_entry *ipv4_blackhole_route(s
 		rt->rt_genid = rt_genid_ipv4(net);
 		rt->rt_flags = ort->rt_flags;
 		rt->rt_type = ort->rt_type;
+		rt->rt_uses_gateway = ort->rt_uses_gateway;
 		rt->rt_gw_family = ort->rt_gw_family;
 		if (rt->rt_gw_family == AF_INET)
 			rt->rt_gw4 = ort->rt_gw4;
@@ -2778,21 +2782,23 @@ static int rt_fill_info(struct net *net,
 		if (nla_put_in_addr(skb, RTA_PREFSRC, fl4->saddr))
 			goto nla_put_failure;
 	}
-	if (rt->rt_gw_family == AF_INET &&
-	    nla_put_in_addr(skb, RTA_GATEWAY, rt->rt_gw4)) {
-		goto nla_put_failure;
-	} else if (rt->rt_gw_family == AF_INET6) {
-		int alen = sizeof(struct in6_addr);
-		struct nlattr *nla;
-		struct rtvia *via;
-
-		nla = nla_reserve(skb, RTA_VIA, alen + 2);
-		if (!nla)
+	if (rt->rt_uses_gateway) {
+		if (rt->rt_gw_family == AF_INET &&
+		    nla_put_in_addr(skb, RTA_GATEWAY, rt->rt_gw4)) {
 			goto nla_put_failure;
-
-		via = nla_data(nla);
-		via->rtvia_family = AF_INET6;
-		memcpy(via->rtvia_addr, &rt->rt_gw6, alen);
+		} else if (rt->rt_gw_family == AF_INET6) {
+			int alen = sizeof(struct in6_addr);
+			struct nlattr *nla;
+			struct rtvia *via;
+
+			nla = nla_reserve(skb, RTA_VIA, alen + 2);
+			if (!nla)
+				goto nla_put_failure;
+
+			via = nla_data(nla);
+			via->rtvia_family = AF_INET6;
+			memcpy(via->rtvia_addr, &rt->rt_gw6, alen);
+		}
 	}
 
 	expires = rt->dst.expires;
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -85,6 +85,7 @@ static int xfrm4_fill_dst(struct xfrm_ds
 	xdst->u.rt.rt_flags = rt->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST |
 					      RTCF_LOCAL);
 	xdst->u.rt.rt_type = rt->rt_type;
+	xdst->u.rt.rt_uses_gateway = rt->rt_uses_gateway;
 	xdst->u.rt.rt_gw_family = rt->rt_gw_family;
 	if (rt->rt_gw_family == AF_INET)
 		xdst->u.rt.rt_gw4 = rt->rt_gw4;



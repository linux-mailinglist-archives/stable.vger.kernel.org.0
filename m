Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD6C2886A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390854AbfEWTZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391228AbfEWTZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:25:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D4F6217D9;
        Thu, 23 May 2019 19:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639556;
        bh=2oQPVjb/XH6t5N0VlZPojdoMnrm+tfWh1CGpuHuzy8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Se5eqo7YphNDsf/vlKqGOvdtp3p/oyMHFtnr7O2NEU7qZsiiIv2fqcl6GkbJa4FeH
         V6j/hJe25e5ICGJwCxV4a33UZy2Wz1Mc5FQThW43Nii4p7PDanqhMRVAFcoj+fr7cW
         ifOmkO+fYTfewcRTY0YJxXPTcU9DBFuCbC8lKrHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Wei Wang <weiwan@google.com>, Martin Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 5.1 001/122] ipv6: fix src addr routing with the exception table
Date:   Thu, 23 May 2019 21:05:23 +0200
Message-Id: <20190523181705.324928617@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

[ Upstream commit 510e2ceda031eed97a7a0f9aad65d271a58b460d ]

When inserting route cache into the exception table, the key is
generated with both src_addr and dest_addr with src addr routing.
However, current logic always assumes the src_addr used to generate the
key is a /128 host address. This is not true in the following scenarios:
1. When the route is a gateway route or does not have next hop.
   (rt6_is_gw_or_nonexthop() == false)
2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
This means, when looking for a route cache in the exception table, we
have to do the lookup twice: first time with the passed in /128 host
address, second time with the src_addr stored in fib6_info.

This solves the pmtu discovery issue reported by Mikael Magnusson where
a route cache with a lower mtu info is created for a gateway route with
src addr. However, the lookup code is not able to find this route cache.

Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
Bisected-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Cc: Martin Lau <kafai@fb.com>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -110,8 +110,8 @@ static int rt6_fill_node(struct net *net
 			 int iif, int type, u32 portid, u32 seq,
 			 unsigned int flags);
 static struct rt6_info *rt6_find_cached_rt(struct fib6_info *rt,
-					   struct in6_addr *daddr,
-					   struct in6_addr *saddr);
+					   const struct in6_addr *daddr,
+					   const struct in6_addr *saddr);
 
 #ifdef CONFIG_IPV6_ROUTE_INFO
 static struct fib6_info *rt6_add_route_info(struct net *net,
@@ -1529,31 +1529,44 @@ out:
  * Caller has to hold rcu_read_lock()
  */
 static struct rt6_info *rt6_find_cached_rt(struct fib6_info *rt,
-					   struct in6_addr *daddr,
-					   struct in6_addr *saddr)
+					   const struct in6_addr *daddr,
+					   const struct in6_addr *saddr)
 {
+	const struct in6_addr *src_key = NULL;
 	struct rt6_exception_bucket *bucket;
-	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
 	struct rt6_info *res = NULL;
 
-	bucket = rcu_dereference(rt->rt6i_exception_bucket);
-
 #ifdef CONFIG_IPV6_SUBTREES
 	/* rt6i_src.plen != 0 indicates rt is in subtree
 	 * and exception table is indexed by a hash of
 	 * both rt6i_dst and rt6i_src.
-	 * Otherwise, the exception table is indexed by
-	 * a hash of only rt6i_dst.
+	 * However, the src addr used to create the hash
+	 * might not be exactly the passed in saddr which
+	 * is a /128 addr from the flow.
+	 * So we need to use f6i->fib6_src to redo lookup
+	 * if the passed in saddr does not find anything.
+	 * (See the logic in ip6_rt_cache_alloc() on how
+	 * rt->rt6i_src is updated.)
 	 */
 	if (rt->fib6_src.plen)
 		src_key = saddr;
+find_ex:
 #endif
+	bucket = rcu_dereference(rt->rt6i_exception_bucket);
 	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
 
 	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
 		res = rt6_ex->rt6i;
 
+#ifdef CONFIG_IPV6_SUBTREES
+	/* Use fib6_src as src_key and redo lookup */
+	if (!res && src_key && src_key != &rt->fib6_src.addr) {
+		src_key = &rt->fib6_src.addr;
+		goto find_ex;
+	}
+#endif
+
 	return res;
 }
 
@@ -2608,10 +2621,8 @@ out:
 u32 ip6_mtu_from_fib6(struct fib6_info *f6i, struct in6_addr *daddr,
 		      struct in6_addr *saddr)
 {
-	struct rt6_exception_bucket *bucket;
-	struct rt6_exception *rt6_ex;
-	struct in6_addr *src_key;
 	struct inet6_dev *idev;
+	struct rt6_info *rt;
 	u32 mtu = 0;
 
 	if (unlikely(fib6_metric_locked(f6i, RTAX_MTU))) {
@@ -2620,18 +2631,10 @@ u32 ip6_mtu_from_fib6(struct fib6_info *
 			goto out;
 	}
 
-	src_key = NULL;
-#ifdef CONFIG_IPV6_SUBTREES
-	if (f6i->fib6_src.plen)
-		src_key = saddr;
-#endif
-
-	bucket = rcu_dereference(f6i->rt6i_exception_bucket);
-	rt6_ex = __rt6_find_exception_rcu(&bucket, daddr, src_key);
-	if (rt6_ex && !rt6_check_expired(rt6_ex->rt6i))
-		mtu = dst_metric_raw(&rt6_ex->rt6i->dst, RTAX_MTU);
-
-	if (likely(!mtu)) {
+	rt = rt6_find_cached_rt(f6i, daddr, saddr);
+	if (unlikely(rt)) {
+		mtu = dst_metric_raw(&rt->dst, RTAX_MTU);
+	} else {
 		struct net_device *dev = fib6_info_nh_dev(f6i);
 
 		mtu = IPV6_MIN_MTU;



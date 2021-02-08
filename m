Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E469313697
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhBHPNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:13:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233059AbhBHPKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 586EA64ED0;
        Mon,  8 Feb 2021 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796838;
        bh=3TuOz8bHl4HIAeQs1ik+Ny4j3GynPyIccpbC9utCSZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifjptJKXlHXqWfbtfC0zQ1iboISgMqEs+ExahJGUqN9wfSwWmb6Gygyo+mHkNNdlz
         SQaG66kj8EyVWcuL4Weqp+87qhO8RNEyAYrvB7tuWVemSzXb6QeENWTuI+BjGze1p7
         KgcNtuqRuVnYT54ZX5pJ1MvvbO8V897togyXAbGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <weiwan@google.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Carsten Schmid <carsten_schmid@mentor.com>
Subject: [PATCH 4.14 09/30] ipv4: fix race condition between route lookup and invalidation
Date:   Mon,  8 Feb 2021 16:00:55 +0100
Message-Id: <20210208145805.625201180@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

[ upstream commit 5018c59607a511cdee743b629c76206d9c9e6d7b ]

Jesse and Ido reported the following race condition:
<CPU A, t0> - Received packet A is forwarded and cached dst entry is
taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()

<t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
from multiple ISPs"), route is added / deleted and rt_cache_flush() is
called

<CPU B, t2> - Received packet B tries to use the same cached dst entry
from t0, but rt_cache_valid() is no longer true and it is replaced in
rt_cache_route() by the newer one. This calls dst_dev_put() on the
original dst entry which assigns the blackhole netdev to 'dst->dev'

<CPU A, t3> - dst_input(skb) is called on packet A and it is dropped due
to 'dst->dev' being the blackhole netdev

There are 2 issues in the v4 routing code:
1. A per-netns counter is used to do the validation of the route. That
means whenever a route is changed in the netns, users of all routes in
the netns needs to redo lookup. v6 has an implementation of only
updating fn_sernum for routes that are affected.
2. When rt_cache_valid() returns false, rt_cache_route() is called to
throw away the current cache, and create a new one. This seems
unnecessary because as long as this route does not change, the route
cache does not need to be recreated.

To fully solve the above 2 issues, it probably needs quite some code
changes and requires careful testing, and does not suite for net branch.

So this patch only tries to add the deleted cached rt into the uncached
list, so user could still be able to use it to receive packets until
it's done.

Fixes: 95c47f9cf5e0 ("ipv4: call dst_dev_put() properly")
Signed-off-by: Wei Wang <weiwan@google.com>
Reported-by: Ido Schimmel <idosch@idosch.org>
Reported-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
Tested-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Carsten Schmid <carsten_schmid@mentor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1437,6 +1437,24 @@ static bool rt_bind_exception(struct rta
 	return ret;
 }
 
+struct uncached_list {
+	spinlock_t		lock;
+	struct list_head	head;
+};
+
+static DEFINE_PER_CPU_ALIGNED(struct uncached_list, rt_uncached_list);
+
+static void rt_add_uncached_list(struct rtable *rt)
+{
+	struct uncached_list *ul = raw_cpu_ptr(&rt_uncached_list);
+
+	rt->rt_uncached_list = ul;
+
+	spin_lock_bh(&ul->lock);
+	list_add_tail(&rt->rt_uncached, &ul->head);
+	spin_unlock_bh(&ul->lock);
+}
+
 static bool rt_cache_route(struct fib_nh *nh, struct rtable *rt)
 {
 	struct rtable *orig, *prev, **p;
@@ -1456,7 +1474,7 @@ static bool rt_cache_route(struct fib_nh
 	prev = cmpxchg(p, orig, rt);
 	if (prev == orig) {
 		if (orig) {
-			dst_dev_put(&orig->dst);
+			rt_add_uncached_list(orig);
 			dst_release(&orig->dst);
 		}
 	} else {
@@ -1467,24 +1485,6 @@ static bool rt_cache_route(struct fib_nh
 	return ret;
 }
 
-struct uncached_list {
-	spinlock_t		lock;
-	struct list_head	head;
-};
-
-static DEFINE_PER_CPU_ALIGNED(struct uncached_list, rt_uncached_list);
-
-static void rt_add_uncached_list(struct rtable *rt)
-{
-	struct uncached_list *ul = raw_cpu_ptr(&rt_uncached_list);
-
-	rt->rt_uncached_list = ul;
-
-	spin_lock_bh(&ul->lock);
-	list_add_tail(&rt->rt_uncached, &ul->head);
-	spin_unlock_bh(&ul->lock);
-}
-
 static void ipv4_dst_destroy(struct dst_entry *dst)
 {
 	struct dst_metrics *p = (struct dst_metrics *)DST_METRICS_PTR(dst);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25BF13921
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfEDK0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbfEDK0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E5572086A;
        Sat,  4 May 2019 10:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965564;
        bh=K5lYJwuJeJ7LsJFj37qYIH8A6/gaHBzzR1qmQ1eRQeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q47Lvp/aavc5ey8wYoQToBzD7ahqLvS1eeklJRpuLdzhzZHkGJulCR1Wr9jJvg6N5
         C/heOsB0rAFbID87qIq1EzgmyTstiDiznkgRvgoyv+mS5chkI9LdAif8RAHadOsOkR
         ZKjsjLoUCMLhzfxR0B3685cGG5BcZ1X1av35EJHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 02/32] ipv6: A few fixes on dereferencing rt->from
Date:   Sat,  4 May 2019 12:24:47 +0200
Message-Id: <20190504102452.606769366@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 886b7a50100a50f1cbd08a6f8ec5884dfbe082dc ]

It is a followup after the fix in
commit 9c69a1320515 ("route: Avoid crash from dereferencing NULL rt->from")

rt6_do_redirect():
1. NULL checking is needed on rt->from because a parallel
   fib6_info delete could happen that sets rt->from to NULL.
   (e.g. rt6_remove_exception() and fib6_drop_pcpu_from()).

2. fib6_info_hold() is not enough.  Same reason as (1).
   Meaning, holding dst->__refcnt cannot ensure
   rt->from is not NULL or rt->from->fib6_ref is not 0.

   Instead of using fib6_info_hold_safe() which ip6_rt_cache_alloc()
   is already doing, this patch chooses to extend the rcu section
   to keep "from" dereference-able after checking for NULL.

inet6_rtm_getroute():
1. NULL checking is also needed on rt->from for a similar reason.
   Note that inet6_rtm_getroute() is using RTNL_FLAG_DOIT_UNLOCKED.

Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Wei Wang <weiwan@google.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3403,11 +3403,8 @@ static void rt6_do_redirect(struct dst_e
 
 	rcu_read_lock();
 	from = rcu_dereference(rt->from);
-	/* This fib6_info_hold() is safe here because we hold reference to rt
-	 * and rt already holds reference to fib6_info.
-	 */
-	fib6_info_hold(from);
-	rcu_read_unlock();
+	if (!from)
+		goto out;
 
 	nrt = ip6_rt_cache_alloc(from, &msg->dest, NULL);
 	if (!nrt)
@@ -3419,10 +3416,7 @@ static void rt6_do_redirect(struct dst_e
 
 	nrt->rt6i_gateway = *(struct in6_addr *)neigh->primary_key;
 
-	/* No need to remove rt from the exception table if rt is
-	 * a cached route because rt6_insert_exception() will
-	 * takes care of it
-	 */
+	/* rt6_insert_exception() will take care of duplicated exceptions */
 	if (rt6_insert_exception(nrt, from)) {
 		dst_release_immediate(&nrt->dst);
 		goto out;
@@ -3435,7 +3429,7 @@ static void rt6_do_redirect(struct dst_e
 	call_netevent_notifiers(NETEVENT_REDIRECT, &netevent);
 
 out:
-	fib6_info_release(from);
+	rcu_read_unlock();
 	neigh_release(neigh);
 }
 
@@ -4957,16 +4951,20 @@ static int inet6_rtm_getroute(struct sk_
 
 	rcu_read_lock();
 	from = rcu_dereference(rt->from);
-
-	if (fibmatch)
-		err = rt6_fill_node(net, skb, from, NULL, NULL, NULL, iif,
-				    RTM_NEWROUTE, NETLINK_CB(in_skb).portid,
-				    nlh->nlmsg_seq, 0);
-	else
-		err = rt6_fill_node(net, skb, from, dst, &fl6.daddr,
-				    &fl6.saddr, iif, RTM_NEWROUTE,
-				    NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
-				    0);
+	if (from) {
+		if (fibmatch)
+			err = rt6_fill_node(net, skb, from, NULL, NULL, NULL,
+					    iif, RTM_NEWROUTE,
+					    NETLINK_CB(in_skb).portid,
+					    nlh->nlmsg_seq, 0);
+		else
+			err = rt6_fill_node(net, skb, from, dst, &fl6.daddr,
+					    &fl6.saddr, iif, RTM_NEWROUTE,
+					    NETLINK_CB(in_skb).portid,
+					    nlh->nlmsg_seq, 0);
+	} else {
+		err = -ENETUNREACH;
+	}
 	rcu_read_unlock();
 
 	if (err < 0) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1AD268A4
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfEVQvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 12:51:41 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52661 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729457AbfEVQvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 12:51:40 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 69C6820C69;
        Wed, 22 May 2019 12:51:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 22 May 2019 12:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/imONh
        1xImxMbmiTwm6px81Cy6Cai2Grk8U+ZpBNoS4=; b=zcaLn0U4/fHYZJSue3pi4n
        +1mrzSpwEh2mknUs6g8G2oBTxV/uWXzfY8jSndvkeLjxIlytyvxSQ/v9W4+K1WME
        fxBEfebF54oYzRF8bVSQQruwH++1EUwwuq113D1Av6P+FoPlZMCbY7CNk+Drz/GB
        j5zGDFSXNpS3JaHoARyKjgEBP/MHy7fBYzczZIX3fG5sgfiXhSZfMIhcKT4rPqrV
        o4TCD+V41IMLJen/CWIQ5T59VtPpWwSnHjh2Ao14JE7DBy/g/NUMkbinUsBBGrpY
        9XeacvI0sp91ntA9/QdKju1deqU+kdG0wSgL8azRHEsgPMAWB/hYcgtz/rhczmtQ
        ==
X-ME-Sender: <xms:Gn7lXB7mDSky55IKcvlcTplwFUabDHS3UwU34kzM85CXajbfCRzL2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudduvddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Gn7lXDK7efGDFMNpreoKlPHzEoHVjsCDu9oDiwg_SWRGBu8MyjI7-A>
    <xmx:Gn7lXFZYAyceclHM4lnDpOHNKM-yo5Jn-7rcFZWPobp37mQtEnPj4g>
    <xmx:Gn7lXI1hoYR10iojIT3tj20D96cOdyGX8AN38Om5rEDORWKZ8kNpYw>
    <xmx:G37lXBAJ043IxiKvA7oZUhIEBbKJImxewhKZSrqRdlX8IPTyvK9jmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 49B808005B;
        Wed, 22 May 2019 12:51:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ipv6: prevent possible fib6 leaks" failed to apply to 4.14-stable tree
To:     edumazet@google.com, davem@davemloft.net, dsahern@gmail.com,
        kafai@fb.com, syzkaller@googlegroups.com, weiwan@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 May 2019 18:51:36 +0200
Message-ID: <155854389617965@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 61fb0d01680771f72cc9d39783fb2c122aaad51e Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 May 2019 19:39:52 -0700
Subject: [PATCH] ipv6: prevent possible fib6 leaks

At ipv6 route dismantle, fib6_drop_pcpu_from() is responsible
for finding all percpu routes and set their ->from pointer
to NULL, so that fib6_ref can reach its expected value (1).

The problem right now is that other cpus can still catch the
route being deleted, since there is no rcu grace period
between the route deletion and call to fib6_drop_pcpu_from()

This can leak the fib6 and associated resources, since no
notifier will take care of removing the last reference(s).

I decided to add another boolean (fib6_destroying) instead
of reusing/renaming exception_bucket_flushed to ease stable backports,
and properly document the memory barriers used to implement this fix.

This patch has been co-developped with Wei Wang.

Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Wei Wang <weiwan@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin Lau <kafai@fb.com>
Acked-by: Wei Wang <weiwan@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 40105738e2f6..525f701653ca 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -167,7 +167,8 @@ struct fib6_info {
 					dst_nocount:1,
 					dst_nopolicy:1,
 					dst_host:1,
-					unused:3;
+					fib6_destroying:1,
+					unused:2;
 
 	struct fib6_nh			fib6_nh;
 	struct rcu_head			rcu;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 08e0390e001c..008421b550c6 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -904,6 +904,12 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 {
 	int cpu;
 
+	/* Make sure rt6_make_pcpu_route() wont add other percpu routes
+	 * while we are cleaning them here.
+	 */
+	f6i->fib6_destroying = 1;
+	mb(); /* paired with the cmpxchg() in rt6_make_pcpu_route() */
+
 	/* release the reference to this fib entry from
 	 * all of its cached pcpu routes
 	 */
@@ -927,6 +933,9 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 {
 	struct fib6_table *table = rt->fib6_table;
 
+	if (rt->rt6i_pcpu)
+		fib6_drop_pcpu_from(rt, table);
+
 	if (refcount_read(&rt->fib6_ref) != 1) {
 		/* This route is used as dummy address holder in some split
 		 * nodes. It is not leaked, but it still holds other resources,
@@ -948,9 +957,6 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 			fn = rcu_dereference_protected(fn->parent,
 				    lockdep_is_held(&table->tb6_lock));
 		}
-
-		if (rt->rt6i_pcpu)
-			fib6_drop_pcpu_from(rt, table);
 	}
 }
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 23a20d62daac..27c0cc5d9d30 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1295,6 +1295,13 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
 	prev = cmpxchg(p, NULL, pcpu_rt);
 	BUG_ON(prev);
 
+	if (res->f6i->fib6_destroying) {
+		struct fib6_info *from;
+
+		from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
+		fib6_info_release(from);
+	}
+
 	return pcpu_rt;
 }
 


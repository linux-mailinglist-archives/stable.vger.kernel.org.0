Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F47411D6A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbhITRUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346267AbhITRSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:18:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5F9D61A3B;
        Mon, 20 Sep 2021 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157172;
        bh=lpQGb2tZVtmJngg+97eEPxZo3xFcTgZfVOVnL7Gq/xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAW/dCgWAoMXruitWwl2zyCa1vy//Gvp0IH7ONv8e/i0qzEujv1eodrhaZ8KDvjb1
         +GkQthDMcTf2cmphdl8UTqDsGtfW6oWYVEPDLnm8Y1wy+vufX8Uz7STMlfMnXyCvN5
         PZ13f31Mt+T+H5jpsKhGYUFmsENxnmxmNWWXl7qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Keyu Man <kman001@ucr.edu>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/217] ipv4: make exception cache less predictible
Date:   Mon, 20 Sep 2021 18:41:48 +0200
Message-Id: <20210920163927.584824767@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 67d6d681e15b578c1725bad8ad079e05d1c48a8e ]

Even after commit 6457378fe796 ("ipv4: use siphash instead of Jenkins in
fnhe_hashfun()"), an attacker can still use brute force to learn
some secrets from a victim linux host.

One way to defeat these attacks is to make the max depth of the hash
table bucket a random value.

Before this patch, each bucket of the hash table used to store exceptions
could contain 6 items under attack.

After the patch, each bucket would contains a random number of items,
between 6 and 10. The attacker can no longer infer secrets.

This is slightly increasing memory size used by the hash table,
by 50% in average, we do not expect this to be a problem.

This patch is more complex than the prior one (IPv6 equivalent),
because IPv4 was reusing the oldest entry.
Since we need to be able to evict more than one entry per
update_or_create_fnhe() call, I had to replace
fnhe_oldest() with fnhe_remove_oldest().

Also note that we will queue extra kfree_rcu() calls under stress,
which hopefully wont be a too big issue.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Tested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 81901b052907..d67d424be919 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -619,18 +619,25 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
 	}
 }
 
-static struct fib_nh_exception *fnhe_oldest(struct fnhe_hash_bucket *hash)
+static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
 {
-	struct fib_nh_exception *fnhe, *oldest;
+	struct fib_nh_exception __rcu **fnhe_p, **oldest_p;
+	struct fib_nh_exception *fnhe, *oldest = NULL;
 
-	oldest = rcu_dereference(hash->chain);
-	for (fnhe = rcu_dereference(oldest->fnhe_next); fnhe;
-	     fnhe = rcu_dereference(fnhe->fnhe_next)) {
-		if (time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp))
+	for (fnhe_p = &hash->chain; ; fnhe_p = &fnhe->fnhe_next) {
+		fnhe = rcu_dereference_protected(*fnhe_p,
+						 lockdep_is_held(&fnhe_lock));
+		if (!fnhe)
+			break;
+		if (!oldest ||
+		    time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp)) {
 			oldest = fnhe;
+			oldest_p = fnhe_p;
+		}
 	}
 	fnhe_flush_routes(oldest);
-	return oldest;
+	*oldest_p = oldest->fnhe_next;
+	kfree_rcu(oldest, rcu);
 }
 
 static inline u32 fnhe_hashfun(__be32 daddr)
@@ -707,16 +714,21 @@ static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
 		if (rt)
 			fill_route_from_fnhe(rt, fnhe);
 	} else {
-		if (depth > FNHE_RECLAIM_DEPTH)
-			fnhe = fnhe_oldest(hash);
-		else {
-			fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
-			if (!fnhe)
-				goto out_unlock;
-
-			fnhe->fnhe_next = hash->chain;
-			rcu_assign_pointer(hash->chain, fnhe);
+		/* Randomize max depth to avoid some side channels attacks. */
+		int max_depth = FNHE_RECLAIM_DEPTH +
+				prandom_u32_max(FNHE_RECLAIM_DEPTH);
+
+		while (depth > max_depth) {
+			fnhe_remove_oldest(hash);
+			depth--;
 		}
+
+		fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
+		if (!fnhe)
+			goto out_unlock;
+
+		fnhe->fnhe_next = hash->chain;
+
 		fnhe->fnhe_genid = genid;
 		fnhe->fnhe_daddr = daddr;
 		fnhe->fnhe_gw = gw;
@@ -724,6 +736,8 @@ static void update_or_create_fnhe(struct fib_nh *nh, __be32 daddr, __be32 gw,
 		fnhe->fnhe_mtu_locked = lock;
 		fnhe->fnhe_expires = max(1UL, expires);
 
+		rcu_assign_pointer(hash->chain, fnhe);
+
 		/* Exception created; mark the cached routes for the nexthop
 		 * stale, so anyone caching it rechecks if this exception
 		 * applies to them.
-- 
2.30.2




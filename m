Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADBC18B5C
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfEIONp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46960 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726700AbfEIONL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:11 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-000127-Lg; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006MF-DT; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Thu, 09 May 2019 15:08:17 +0100
Message-ID: <lsq.1557410897.156917509@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 06/10] ipv4: fix a race in update_or_create_fnhe()
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.67-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit caa415270c732505240bb60171c44a7838c555e8 upstream.

nh_exceptions is effectively used under rcu, but lacks proper
barriers. Between kzalloc() and setting of nh->nh_exceptions(),
we need a proper memory barrier.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 4895c771c7f00 ("ipv4: Add FIB nexthop exceptions.")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/ip_fib.h     | 2 +-
 net/ipv4/fib_semantics.c | 8 +++++---
 net/ipv4/route.c         | 6 +++---
 3 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -89,7 +89,7 @@ struct fib_nh {
 	int			nh_saddr_genid;
 	struct rtable __rcu * __percpu *nh_pcpu_rth_output;
 	struct rtable __rcu	*nh_rth_input;
-	struct fnhe_hash_bucket	*nh_exceptions;
+	struct fnhe_hash_bucket	__rcu *nh_exceptions;
 };
 
 /*
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -157,9 +157,12 @@ static void rt_fibinfo_free(struct rtabl
 
 static void free_nh_exceptions(struct fib_nh *nh)
 {
-	struct fnhe_hash_bucket *hash = nh->nh_exceptions;
+	struct fnhe_hash_bucket *hash;
 	int i;
 
+	hash = rcu_dereference_protected(nh->nh_exceptions, 1);
+	if (!hash)
+		return;
 	for (i = 0; i < FNHE_HASH_SIZE; i++) {
 		struct fib_nh_exception *fnhe;
 
@@ -206,8 +209,7 @@ static void free_fib_info_rcu(struct rcu
 	change_nexthops(fi) {
 		if (nexthop_nh->nh_dev)
 			dev_put(nexthop_nh->nh_dev);
-		if (nexthop_nh->nh_exceptions)
-			free_nh_exceptions(nexthop_nh);
+		free_nh_exceptions(nexthop_nh);
 		rt_fibinfo_free_cpus(nexthop_nh->nh_pcpu_rth_output);
 		rt_fibinfo_free(&nexthop_nh->nh_rth_input);
 	} endfor_nexthops(fi);
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -635,12 +635,12 @@ static void update_or_create_fnhe(struct
 
 	spin_lock_bh(&fnhe_lock);
 
-	hash = nh->nh_exceptions;
+	hash = rcu_dereference(nh->nh_exceptions);
 	if (!hash) {
 		hash = kzalloc(FNHE_HASH_SIZE * sizeof(*hash), GFP_ATOMIC);
 		if (!hash)
 			goto out_unlock;
-		nh->nh_exceptions = hash;
+		rcu_assign_pointer(nh->nh_exceptions, hash);
 	}
 
 	hash += hval;
@@ -1293,7 +1293,7 @@ static void ip_del_fnhe(struct fib_nh *n
 
 static struct fib_nh_exception *find_exception(struct fib_nh *nh, __be32 daddr)
 {
-	struct fnhe_hash_bucket *hash = nh->nh_exceptions;
+	struct fnhe_hash_bucket *hash = rcu_dereference(nh->nh_exceptions);
 	struct fib_nh_exception *fnhe;
 	u32 hval;
 


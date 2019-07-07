Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA95F61688
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfGGTk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:40:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58054 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727673AbfGGTiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:17 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzG-0006jV-7a; Sun, 07 Jul 2019 20:38:14 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005gp-VC; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Amit Klein" <aksecurity@gmail.com>,
        "Pavel Emelyanov" <xemul@openvz.org>,
        "Benny Pinkas" <benny@pinkas.net>,
        "Eric Dumazet" <edumazet@google.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.845864780@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 129/129] netns: provide pure entropy for net_hash_mix()
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 355b98553789b646ed97ad801a619ff898471b92 upstream.

net_hash_mix() currently uses kernel address of a struct net,
and is used in many places that could be used to reveal this
address to a patient attacker, thus defeating KASLR, for
the typical case (initial net namespace, &init_net is
not dynamically allocated)

I believe the original implementation tried to avoid spending
too many cycles in this function, but security comes first.

Also provide entropy regardless of CONFIG_NET_NS.

Fixes: 0b4419162aa6 ("netns: introduce the net_hash_mix "salt" for hashes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Amit Klein <aksecurity@gmail.com>
Reported-by: Benny Pinkas <benny@pinkas.net>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -54,6 +54,8 @@ struct net {
 #endif
 	spinlock_t		rules_mod_lock;
 
+	u32			hash_mix;
+
 	struct list_head	list;		/* list of network namespaces */
 	struct list_head	cleanup_list;	/* namespaces on death row */
 	struct list_head	exit_list;	/* Use only net_mutex */
--- a/include/net/netns/hash.h
+++ b/include/net/netns/hash.h
@@ -1,21 +1,10 @@
 #ifndef __NET_NS_HASH_H__
 #define __NET_NS_HASH_H__
 
-#include <asm/cache.h>
+#include <net/net_namespace.h>
 
-struct net;
-
-static inline unsigned int net_hash_mix(struct net *net)
+static inline u32 net_hash_mix(const struct net *net)
 {
-#ifdef CONFIG_NET_NS
-	/*
-	 * shift this right to eliminate bits, that are
-	 * always zeroed
-	 */
-
-	return (unsigned)(((unsigned long)net) >> L1_CACHE_SHIFT);
-#else
-	return 0;
-#endif
+	return net->hash_mix;
 }
 #endif
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -156,6 +156,7 @@ static __net_init int setup_net(struct n
 
 	atomic_set(&net->count, 1);
 	atomic_set(&net->passive, 1);
+	get_random_bytes(&net->hash_mix, sizeof(u32));
 	net->dev_base_seq = 1;
 	net->user_ns = user_ns;
 


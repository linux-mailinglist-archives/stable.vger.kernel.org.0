Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE7437C1FC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhELPGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233204AbhELPEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:04:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B10A6193F;
        Wed, 12 May 2021 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831577;
        bh=3rAJkO0sl0sOSwQQA89z5pwiDZVyyE10tBkDzTIHnEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnSpqD4J/IJqkCT/tEHQUE6dY0Ln0/8LfOpiQV0d36O9CBXeC65zzfLsfj9n6Tf1y
         oIVv2T6uNoYebGS0XLQcvRJ73Y/euDvd7tEApTnA9a1PYAVEdsSs/8BW4VIHmTzDZL
         Bl9qj0+VejkMeHJ46rfIdZKuWh8tX/pwJqm7T66Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID generation
Date:   Wed, 12 May 2021 16:49:06 +0200
Message-Id: <20210512144748.600206118@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit aa6dd211e4b1dde9d5dc25d699d35f789ae7eeba ]

In commit 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
I used a very small hash table that could be abused
by patient attackers to reveal sensitive information.

Switch to a dynamic sizing, depending on RAM size.

Typical big hosts will now use 128x more storage (2 MB)
to get a similar increase in security and reduction
of hash collisions.

As a bonus, use of alloc_large_system_hash() spreads
allocated memory among all NUMA nodes.

Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
Reported-by: Amit Klein <aksecurity@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 53c5cf5723aa..3ff702380b62 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -66,6 +66,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/memblock.h>
 #include <linux/string.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
@@ -476,8 +477,10 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
 	__ipv4_confirm_neigh(dev, *(__force u32 *)pkey);
 }
 
-#define IP_IDENTS_SZ 2048u
-
+/* Hash tables of size 2048..262144 depending on RAM size.
+ * Each bucket uses 8 bytes.
+ */
+static u32 ip_idents_mask __read_mostly;
 static atomic_t *ip_idents __read_mostly;
 static u32 *ip_tstamps __read_mostly;
 
@@ -487,12 +490,16 @@ static u32 *ip_tstamps __read_mostly;
  */
 u32 ip_idents_reserve(u32 hash, int segs)
 {
-	u32 *p_tstamp = ip_tstamps + hash % IP_IDENTS_SZ;
-	atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
-	u32 old = READ_ONCE(*p_tstamp);
-	u32 now = (u32)jiffies;
+	u32 bucket, old, now = (u32)jiffies;
+	atomic_t *p_id;
+	u32 *p_tstamp;
 	u32 delta = 0;
 
+	bucket = hash & ip_idents_mask;
+	p_tstamp = ip_tstamps + bucket;
+	p_id = ip_idents + bucket;
+	old = READ_ONCE(*p_tstamp);
+
 	if (old != now && cmpxchg(p_tstamp, old, now) == old)
 		delta = prandom_u32_max(now - old);
 
@@ -3459,18 +3466,25 @@ struct ip_rt_acct __percpu *ip_rt_acct __read_mostly;
 
 int __init ip_rt_init(void)
 {
+	void *idents_hash;
 	int cpu;
 
-	ip_idents = kmalloc_array(IP_IDENTS_SZ, sizeof(*ip_idents),
-				  GFP_KERNEL);
-	if (!ip_idents)
-		panic("IP: failed to allocate ip_idents\n");
+	/* For modern hosts, this will use 2 MB of memory */
+	idents_hash = alloc_large_system_hash("IP idents",
+					      sizeof(*ip_idents) + sizeof(*ip_tstamps),
+					      0,
+					      16, /* one bucket per 64 KB */
+					      HASH_ZERO,
+					      NULL,
+					      &ip_idents_mask,
+					      2048,
+					      256*1024);
+
+	ip_idents = idents_hash;
 
-	prandom_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents));
+	prandom_bytes(ip_idents, (ip_idents_mask + 1) * sizeof(*ip_idents));
 
-	ip_tstamps = kcalloc(IP_IDENTS_SZ, sizeof(*ip_tstamps), GFP_KERNEL);
-	if (!ip_tstamps)
-		panic("IP: failed to allocate ip_tstamps\n");
+	ip_tstamps = idents_hash + (ip_idents_mask + 1) * sizeof(*ip_idents);
 
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);
-- 
2.30.2




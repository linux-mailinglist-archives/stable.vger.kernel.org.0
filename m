Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF083B62D1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhF1Otg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235745AbhF1Opg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79F0861CCF;
        Mon, 28 Jun 2021 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890857;
        bh=epEQKzjnltpyOPurIfJCvhaFWEb1wL+40dwVR2djE1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfDlKL12MdjoQe++5faHhQB9Y7MRNPNCskBpQxGf+rA3PLNgaXS54/TeWjadfa/mD
         2UF4+7ITlKY8giBaaX2AWqjV/SZD/hWx+W9KoCNDuvyq0QD+v++LoeJanv+GARwrg8
         N9SaN5NNtTxt/rnnHt0sOWe+G9zYWyyBklqY2JsXZpVModN1xupkyrKEB7B7ZaRyVW
         EZBibW8Td9vUb3hLvDO1Tbyhw4hjY/xiU5nLys47S3z/MobTlpbE0/BQmRWE/uTAeJ
         yaiCTYmVBUH3jyap8Yw2TZrtdcroO28LGkunrM/9gCgsYiLL8PEWjFBCI7Iujxc9L+
         TbPTPlio3fUmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Amit Klein <aksecurity@gmail.com>, Willy Tarreau <w@1wt.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 079/109] inet: use bigger hash table for IP ID generation
Date:   Mon, 28 Jun 2021 10:32:35 -0400
Message-Id: <20210628143305.32978-80-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit aa6dd211e4b1dde9d5dc25d699d35f789ae7eeba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2fe50f6f876d..484bd646df5f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -70,6 +70,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/bootmem.h>
 #include <linux/string.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
@@ -470,8 +471,10 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
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
 
@@ -481,12 +484,16 @@ static u32 *ip_tstamps __read_mostly;
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
 
@@ -3197,18 +3204,25 @@ struct ip_rt_acct __percpu *ip_rt_acct __read_mostly;
 
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


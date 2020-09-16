Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C46826CFAA
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 01:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIPXch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 19:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 19:32:36 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D2AD22207;
        Wed, 16 Sep 2020 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600299155;
        bh=YveDhBwvoeRGYCRew1QwRj1hZ0CuYNkymKUCujomPgc=;
        h=From:To:Cc:Subject:Date:From;
        b=JClFuT8e/pJa6a+NWybQFhtn0sLipLrdkUcQJ1S657m9J20YmW3LWgrV0V5DW079t
         VmQ1Csr/q2DDuddWfC2h5TnnQ1JbJLaYnP3dFMJE9JjvRoeHuDyobJ0fQtX8FyTARV
         LX6Ai5++v92JUuYFYN1gwpdjQvpNJtYxkdoeGfZA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] random: use correct memory barriers for crng_node_pool
Date:   Wed, 16 Sep 2020 16:30:42 -0700
Message-Id: <20200916233042.51634-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When a CPU selects which CRNG to use, it accesses crng_node_pool without
a memory barrier.  That's wrong, because crng_node_pool can be set by
another CPU concurrently.  Without a memory barrier, the crng_state that
is used might not appear to be fully initialized.

There's an explicit mb() on the write side, but it's redundant with
cmpxchg() (or cmpxchg_release()) and does nothing to fix the read side.

Implement this correctly by using a cmpxchg_release() +
smp_load_acquire() pair.

Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly userspace programs")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/char/random.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 09b1551d4092f..9f1e7a4a0fbbb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -843,8 +843,8 @@ static void do_numa_crng_init(struct work_struct *work)
 		crng_initialize_secondary(crng);
 		pool[i] = crng;
 	}
-	mb();
-	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+	/* pairs with smp_load_acquire() in select_crng() */
+	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
 		for_each_node(i)
 			kfree(pool[i]);
 		kfree(pool);
@@ -857,8 +857,26 @@ static void numa_crng_init(void)
 {
 	schedule_work(&numa_crng_init_work);
 }
+
+static inline struct crng_state *select_crng(void)
+{
+	struct crng_state **pool;
+	int nid = numa_node_id();
+
+	/* pairs with cmpxchg_release() in do_numa_crng_init() */
+	pool = smp_load_acquire(&crng_node_pool);
+	if (pool && pool[nid])
+		return pool[nid];
+
+	return &primary_crng;
+}
 #else
 static void numa_crng_init(void) {}
+
+static inline struct crng_state *select_crng(void)
+{
+	return &primary_crng;
+}
 #endif
 
 /*
@@ -1005,15 +1023,7 @@ static void _extract_crng(struct crng_state *crng,
 
 static void extract_crng(__u8 out[CHACHA_BLOCK_SIZE])
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_extract_crng(crng, out);
+	_extract_crng(select_crng(), out);
 }
 
 /*
@@ -1042,15 +1052,7 @@ static void _crng_backtrack_protect(struct crng_state *crng,
 
 static void crng_backtrack_protect(__u8 tmp[CHACHA_BLOCK_SIZE], int used)
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_crng_backtrack_protect(crng, tmp, used);
+	_crng_backtrack_protect(select_crng(), tmp, used);
 }
 
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
-- 
2.28.0


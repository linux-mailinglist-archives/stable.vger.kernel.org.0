Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8B8479EE4
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 03:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhLSCwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 21:52:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37208 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhLSCwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 21:52:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3353C60C36;
        Sun, 19 Dec 2021 02:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFE0C36AE1;
        Sun, 19 Dec 2021 02:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639882327;
        bh=LL/DQcC2N9azPevEEwI7fD5zh/Svk3aIPF7eb5otGdQ=;
        h=From:To:Cc:Subject:Date:From;
        b=JdrEgo3p0YIVADumT+fDaJGTfd8+FIry4DqKXny80l8ERdQk63CiOO9HChX9zznVv
         6U2pJfCqP+p27rSg8TKHAtFs1d1PWiPK/nK8EytJuH7k+tn4Dkr+bSdTkaANq6GvtE
         OToqqfKzx2zGqMOtQGAkxcTRLcYDPVFUJv1qFO2rTe4n/iZLkJ2co9efWg8l3ypOMC
         8Yl7R0I5VqBdVfKYF/kOFrj0JfYciUjysekvMoYf8tfRBGCHok/f89o7v/0F+MZjsV
         5JfqU3XTiR33Knx3j+7Lul/Fg/Gx3/Ensg0Lp6yc3HLGU3IBQPqtmVckqzO0L6Pmq8
         zAlPsbR2V279g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld " <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>, stable@vger.kernel.org
Subject: [PATCH RESEND] random: use correct memory barriers for crng_node_pool
Date:   Sat, 18 Dec 2021 20:51:39 -0600
Message-Id: <20211219025139.31085-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
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

Note: READ_ONCE() could be used instead of smp_load_acquire(), but it is
harder to verify that it is correct, so I'd prefer not to use it here.

Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly userspace programs")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I sent this fix about a year ago
(https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/T/#u),
and though it's a correct fix, it was derailed by a debate about whether
it's safe to use READ_ONCE() instead of smp_load_acquire() or not.
Therefore, the current code, which (AFAIK) everyone agrees is buggy, was
never actually fixed.  Since random.c has a new maintainer now, I think
it's worth sending this fix for reconsideration.

 drivers/char/random.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f96..349a6f235c61 100644
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
2.34.1


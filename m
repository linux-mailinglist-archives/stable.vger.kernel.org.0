Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080B447B600
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 23:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbhLTWxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 17:53:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46670 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhLTWxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 17:53:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB9EC6132D;
        Mon, 20 Dec 2021 22:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB820C36AEB;
        Mon, 20 Dec 2021 22:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640040823;
        bh=BByzkUZt+b/jwEL8ljnNHCuOiUVumRFLGfmTFy7aVaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLq3OOS1wV/T/2nW8aaw4cUgOZgH57hQ9ZXyXwQ1IRFuMhxBV9YTPc79Rk+kV5Lvz
         rKf6BBRNkjY6HhYU2hLZ5vHyKjXGm1pcYXxtmRN9/M8h6W1Og97fR0KIXX5/y6NH0V
         U7CN5/vkQKMf+roNWwxmCJMW8L1meUR7x5PIPMFNW5fOD9Acgbw1gRjoHvyuvAsVRE
         2Ohi8TipVB3Fpdn/xR0jLlPwhEpIQUQTs85C7ePZZckeKu+mb/ayOFuFYlCorFRIpT
         fczC8eEp9NUMbEN91L1oksm+u5E1W01AO1ElU2OzBYX/A+UKuERtEgJOKc0f16+GBi
         ++BKk8SmuvT9w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld " <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] random: fix data race on crng_node_pool
Date:   Mon, 20 Dec 2021 16:41:56 -0600
Message-Id: <20211220224157.111959-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220224157.111959-1-ebiggers@kernel.org>
References: <20211220224157.111959-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

extract_crng() and crng_backtrack_protect() load crng_node_pool with a
plain load, which causes undefined behavior if do_numa_crng_init()
modifies it concurrently.

Fix this by using READ_ONCE().  Note: as per the previous discussion
https://lore.kernel.org/lkml/20211219025139.31085-1-ebiggers@kernel.org/T/#u,
READ_ONCE() is believed to be sufficient here, and it was requested that
it be used here instead of smp_load_acquire().

Also change do_numa_crng_init() to set crng_node_pool using
cmpxchg_release() instead of mb() + cmpxchg(), as the former is
sufficient here but is more lightweight.

Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly userspace programs")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/char/random.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f96..1294b4527cdd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -843,8 +843,8 @@ static void do_numa_crng_init(struct work_struct *work)
 		crng_initialize_secondary(crng);
 		pool[i] = crng;
 	}
-	mb();
-	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+	/* pairs with READ_ONCE() in select_crng() */
+	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
 		for_each_node(i)
 			kfree(pool[i]);
 		kfree(pool);
@@ -857,8 +857,26 @@ static void numa_crng_init(void)
 {
 	schedule_work(&numa_crng_init_work);
 }
+
+static struct crng_state *select_crng(void)
+{
+	struct crng_state **pool;
+	int nid = numa_node_id();
+
+	/* pairs with cmpxchg_release() in do_numa_crng_init() */
+	pool = READ_ONCE(crng_node_pool);
+	if (pool && pool[nid])
+		return pool[nid];
+
+	return &primary_crng;
+}
 #else
 static void numa_crng_init(void) {}
+
+static struct crng_state *select_crng(void)
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


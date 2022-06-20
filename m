Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D09F551ADA
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbiFTNj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347193AbiFTNiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:38:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3FA1F2E1;
        Mon, 20 Jun 2022 06:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B8C0B811DA;
        Mon, 20 Jun 2022 13:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9BDC3411B;
        Mon, 20 Jun 2022 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730844;
        bh=U66YyZ1t+Wm7G0wK12W5dhdAKSxCoUPe06VVrd3J6Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVIqCIRLKbX7CodTudPCi+LNedF1Syhfz55dskbBlUJAtmTe8OmmAHduEHz6zaC8M
         OQOWRzpt8+lSBUYS5PFmHZUQnLMIo908iccrMmiMxSXuKBKayF6yYQHzP83DmJbuE2
         Ln4+GB9DS4LDb1avR3vJrUAJWyote9leNKnZI0iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 074/240] random: get rid of secondary crngs
Date:   Mon, 20 Jun 2022 14:49:35 +0200
Message-Id: <20220620124740.665412503@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit a9412d510ab9a9ba411fea612903631d2e1f1601 upstream.

As the comment said, this is indeed a "hack". Since it was introduced,
it's been a constant state machine nightmare, with lots of subtle early
boot issues and a wildly complex set of machinery to keep everything in
sync. Rather than continuing to play whack-a-mole with this approach,
this commit simply removes it entirely. This commit is preparation for
"random: use simpler fast key erasure flow on per-cpu keys" in this
series, which introduces a simpler (and faster) mechanism to accomplish
the same thing.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  227 +++++++++++---------------------------------------
 1 file changed, 54 insertions(+), 173 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -323,14 +323,11 @@ static struct crng_state primary_crng =
  * its value (from 0->1->2).
  */
 static int crng_init = 0;
-static bool crng_need_final_init = false;
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
-static unsigned long crng_global_init_time = 0;
 #define CRNG_INIT_CNT_THRESH (2 * CHACHA_KEY_SIZE)
-static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE]);
-static void _crng_backtrack_protect(struct crng_state *crng,
-				    u8 tmp[CHACHA_BLOCK_SIZE], int used);
+static void extract_crng(u8 out[CHACHA_BLOCK_SIZE]);
+static void crng_backtrack_protect(u8 tmp[CHACHA_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -365,7 +362,7 @@ static struct {
 
 static void extract_entropy(void *buf, size_t nbytes);
 
-static void crng_reseed(struct crng_state *crng);
+static void crng_reseed(void);
 
 /*
  * This function adds bytes into the entropy "pool".  It does not
@@ -464,7 +461,7 @@ static void credit_entropy_bits(int nbit
 	trace_credit_entropy_bits(nbits, entropy_count, _RET_IP_);
 
 	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
-		crng_reseed(&primary_crng);
+		crng_reseed();
 }
 
 /*********************************************************************
@@ -477,16 +474,7 @@ static void credit_entropy_bits(int nbit
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
-/*
- * Hack to deal with crazy userspace progams when they are all trying
- * to access /dev/urandom in parallel.  The programs are almost
- * certainly doing something terribly wrong, but we'll work around
- * their brain damage.
- */
-static struct crng_state **crng_node_pool __read_mostly;
-
 static void invalidate_batched_entropy(void);
-static void numa_crng_init(void);
 
 static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
 static int __init parse_trust_cpu(char *arg)
@@ -495,24 +483,6 @@ static int __init parse_trust_cpu(char *
 }
 early_param("random.trust_cpu", parse_trust_cpu);
 
-static bool crng_init_try_arch(struct crng_state *crng)
-{
-	int i;
-	bool arch_init = true;
-	unsigned long rv;
-
-	for (i = 4; i < 16; i++) {
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv)) {
-			rv = random_get_entropy();
-			arch_init = false;
-		}
-		crng->state[i] ^= rv;
-	}
-
-	return arch_init;
-}
-
 static bool __init crng_init_try_arch_early(void)
 {
 	int i;
@@ -531,100 +501,17 @@ static bool __init crng_init_try_arch_ea
 	return arch_init;
 }
 
-static void crng_initialize_secondary(struct crng_state *crng)
-{
-	chacha_init_consts(crng->state);
-	_get_random_bytes(&crng->state[4], sizeof(u32) * 12);
-	crng_init_try_arch(crng);
-	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
-}
-
-static void __init crng_initialize_primary(void)
+static void __init crng_initialize(void)
 {
 	extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
 	if (crng_init_try_arch_early() && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
-		numa_crng_init();
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
 	primary_crng.init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
-static void crng_finalize_init(void)
-{
-	if (!system_wq) {
-		/* We can't call numa_crng_init until we have workqueues,
-		 * so mark this for processing later. */
-		crng_need_final_init = true;
-		return;
-	}
-
-	invalidate_batched_entropy();
-	numa_crng_init();
-	crng_init = 2;
-	crng_need_final_init = false;
-	process_random_ready_list();
-	wake_up_interruptible(&crng_init_wait);
-	kill_fasync(&fasync, SIGIO, POLL_IN);
-	pr_notice("crng init done\n");
-	if (unseeded_warning.missed) {
-		pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
-			  unseeded_warning.missed);
-		unseeded_warning.missed = 0;
-	}
-	if (urandom_warning.missed) {
-		pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
-			  urandom_warning.missed);
-		urandom_warning.missed = 0;
-	}
-}
-
-static void do_numa_crng_init(struct work_struct *work)
-{
-	int i;
-	struct crng_state *crng;
-	struct crng_state **pool;
-
-	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL | __GFP_NOFAIL);
-	for_each_online_node(i) {
-		crng = kmalloc_node(sizeof(struct crng_state),
-				    GFP_KERNEL | __GFP_NOFAIL, i);
-		spin_lock_init(&crng->lock);
-		crng_initialize_secondary(crng);
-		pool[i] = crng;
-	}
-	/* pairs with READ_ONCE() in select_crng() */
-	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
-		for_each_node(i)
-			kfree(pool[i]);
-		kfree(pool);
-	}
-}
-
-static DECLARE_WORK(numa_crng_init_work, do_numa_crng_init);
-
-static void numa_crng_init(void)
-{
-	if (IS_ENABLED(CONFIG_NUMA))
-		schedule_work(&numa_crng_init_work);
-}
-
-static struct crng_state *select_crng(void)
-{
-	if (IS_ENABLED(CONFIG_NUMA)) {
-		struct crng_state **pool;
-		int nid = numa_node_id();
-
-		/* pairs with cmpxchg_release() in do_numa_crng_init() */
-		pool = READ_ONCE(crng_node_pool);
-		if (pool && pool[nid])
-			return pool[nid];
-	}
-
-	return &primary_crng;
-}
-
 /*
  * crng_fast_load() can be called by code in the interrupt service
  * path.  So we can't afford to dilly-dally. Returns the number of
@@ -702,68 +589,71 @@ static int crng_slow_load(const u8 *cp,
 	return 1;
 }
 
-static void crng_reseed(struct crng_state *crng)
+static void crng_reseed(void)
 {
 	unsigned long flags;
-	int i;
+	int i, entropy_count;
 	union {
 		u8 block[CHACHA_BLOCK_SIZE];
 		u32 key[8];
 	} buf;
 
-	if (crng == &primary_crng) {
-		int entropy_count;
-		do {
-			entropy_count = READ_ONCE(input_pool.entropy_count);
-			if (entropy_count < POOL_MIN_BITS)
-				return;
-		} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
-		extract_entropy(buf.key, sizeof(buf.key));
-		wake_up_interruptible(&random_write_wait);
-		kill_fasync(&fasync, SIGIO, POLL_OUT);
-	} else {
-		_extract_crng(&primary_crng, buf.block);
-		_crng_backtrack_protect(&primary_crng, buf.block,
-					CHACHA_KEY_SIZE);
-	}
-	spin_lock_irqsave(&crng->lock, flags);
+	do {
+		entropy_count = READ_ONCE(input_pool.entropy_count);
+		if (entropy_count < POOL_MIN_BITS)
+			return;
+	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
+	extract_entropy(buf.key, sizeof(buf.key));
+	wake_up_interruptible(&random_write_wait);
+	kill_fasync(&fasync, SIGIO, POLL_OUT);
+
+	spin_lock_irqsave(&primary_crng.lock, flags);
 	for (i = 0; i < 8; i++)
-		crng->state[i + 4] ^= buf.key[i];
+		primary_crng.state[i + 4] ^= buf.key[i];
 	memzero_explicit(&buf, sizeof(buf));
-	WRITE_ONCE(crng->init_time, jiffies);
-	spin_unlock_irqrestore(&crng->lock, flags);
-	if (crng == &primary_crng && crng_init < 2)
-		crng_finalize_init();
+	WRITE_ONCE(primary_crng.init_time, jiffies);
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	if (crng_init < 2) {
+		invalidate_batched_entropy();
+		crng_init = 2;
+		process_random_ready_list();
+		wake_up_interruptible(&crng_init_wait);
+		kill_fasync(&fasync, SIGIO, POLL_IN);
+		pr_notice("crng init done\n");
+		if (unseeded_warning.missed) {
+			pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
+				  unseeded_warning.missed);
+			unseeded_warning.missed = 0;
+		}
+		if (urandom_warning.missed) {
+			pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
+				  urandom_warning.missed);
+			urandom_warning.missed = 0;
+		}
+	}
 }
 
-static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE])
+static void extract_crng(u8 out[CHACHA_BLOCK_SIZE])
 {
 	unsigned long flags, init_time;
 
 	if (crng_ready()) {
-		init_time = READ_ONCE(crng->init_time);
-		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
-		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
-			crng_reseed(crng);
-	}
-	spin_lock_irqsave(&crng->lock, flags);
-	chacha20_block(&crng->state[0], out);
-	if (crng->state[12] == 0)
-		crng->state[13]++;
-	spin_unlock_irqrestore(&crng->lock, flags);
-}
-
-static void extract_crng(u8 out[CHACHA_BLOCK_SIZE])
-{
-	_extract_crng(select_crng(), out);
+		init_time = READ_ONCE(primary_crng.init_time);
+		if (time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
+			crng_reseed();
+	}
+	spin_lock_irqsave(&primary_crng.lock, flags);
+	chacha20_block(&primary_crng.state[0], out);
+	if (primary_crng.state[12] == 0)
+		primary_crng.state[13]++;
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
 }
 
 /*
  * Use the leftover bytes from the CRNG block output (if there is
  * enough) to mutate the CRNG key to provide backtracking protection.
  */
-static void _crng_backtrack_protect(struct crng_state *crng,
-				    u8 tmp[CHACHA_BLOCK_SIZE], int used)
+static void crng_backtrack_protect(u8 tmp[CHACHA_BLOCK_SIZE], int used)
 {
 	unsigned long flags;
 	u32 *s, *d;
@@ -774,17 +664,12 @@ static void _crng_backtrack_protect(stru
 		extract_crng(tmp);
 		used = 0;
 	}
-	spin_lock_irqsave(&crng->lock, flags);
+	spin_lock_irqsave(&primary_crng.lock, flags);
 	s = (u32 *)&tmp[used];
-	d = &crng->state[4];
+	d = &primary_crng.state[4];
 	for (i = 0; i < 8; i++)
 		*d++ ^= *s++;
-	spin_unlock_irqrestore(&crng->lock, flags);
-}
-
-static void crng_backtrack_protect(u8 tmp[CHACHA_BLOCK_SIZE], int used)
-{
-	_crng_backtrack_protect(select_crng(), tmp, used);
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
 }
 
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
@@ -1371,10 +1256,7 @@ static void __init init_std_data(void)
 int __init rand_initialize(void)
 {
 	init_std_data();
-	if (crng_need_final_init)
-		crng_finalize_init();
-	crng_initialize_primary();
-	crng_global_init_time = jiffies;
+	crng_initialize();
 	if (ratelimit_disable) {
 		urandom_warning.interval = 0;
 		unseeded_warning.interval = 0;
@@ -1544,8 +1426,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng);
-		WRITE_ONCE(crng_global_init_time, jiffies - 1);
+		crng_reseed();
 		return 0;
 	default:
 		return -EINVAL;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5127C5583C4
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiFWReg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbiFWRdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:33:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C3887B5A;
        Thu, 23 Jun 2022 10:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4DC1B824B7;
        Thu, 23 Jun 2022 17:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4F8C3411B;
        Thu, 23 Jun 2022 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003942;
        bh=tI44r2AVjVezeqjExPEFzuIzFaMaVx7O7Jdko7mPnIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWlzvYtsHfPUjJJL09BaUXYLgdELC+2Oqtoak5Lu2VOq5Y/5yDnh5TMU+O9UitGE/
         3zdOWgvrcNmqZHsxzokZZ9EaJMXd1e1rR2VBa/mUx1w2vIZZkp9srHkh1ab/jMRdWi
         77dA+qWRv9uhvg6Xmz6MiW+E7uNkx/OcR4Ds89F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 096/237] random: use RDSEED instead of RDRAND in entropy extraction
Date:   Thu, 23 Jun 2022 18:42:10 +0200
Message-Id: <20220623164345.912104218@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

commit 28f425e573e906a4c15f8392cc2b1561ef448595 upstream.

When /dev/random was directly connected with entropy extraction, without
any expansion stage, extract_buf() was called for every 10 bytes of data
read from /dev/random. For that reason, RDRAND was used rather than
RDSEED. At the same time, crng_reseed() was still only called every 5
minutes, so there RDSEED made sense.

Those olden days were also a time when the entropy collector did not use
a cryptographic hash function, which meant most bets were off in terms
of real preimage resistance. For that reason too it didn't matter
_that_ much whether RDSEED was mixed in before or after entropy
extraction; both choices were sort of bad.

But now we have a cryptographic hash function at work, and with that we
get real preimage resistance. We also now only call extract_entropy()
every 5 minutes, rather than every 10 bytes. This allows us to do two
important things.

First, we can switch to using RDSEED in extract_entropy(), as Dominik
suggested. Second, we can ensure that RDSEED input always goes into the
cryptographic hash function with other things before being used
directly. This eliminates a category of attacks in which the CPU knows
the current state of the crng and knows that we're going to xor RDSEED
into it, and so it computes a malicious RDSEED. By going through our
hash function, it would require the CPU to compute a preimage on the
fly, which isn't going to happen.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Suggested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  246 ++++++++++++--------------------------------------
 1 file changed, 62 insertions(+), 184 deletions(-)

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
 #define CRNG_INIT_CNT_THRESH (2 * CHACHA20_KEY_SIZE)
-static void _extract_crng(struct crng_state *crng, u8 out[CHACHA20_BLOCK_SIZE]);
-static void _crng_backtrack_protect(struct crng_state *crng,
-				    u8 tmp[CHACHA20_BLOCK_SIZE], int used);
+static void extract_crng(u8 out[CHACHA20_BLOCK_SIZE]);
+static void crng_backtrack_protect(u8 tmp[CHACHA20_BLOCK_SIZE], int used);
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
@@ -477,14 +474,6 @@ static void credit_entropy_bits(int nbit
 
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
 
 static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
@@ -494,24 +483,6 @@ static int __init parse_trust_cpu(char *
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
@@ -530,100 +501,17 @@ static bool __init crng_init_try_arch_ea
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
@@ -701,73 +589,71 @@ static int crng_slow_load(const u8 *cp,
 	return 1;
 }
 
-static void crng_reseed(struct crng_state *crng)
+static void crng_reseed(void)
 {
 	unsigned long flags;
-	int i;
+	int i, entropy_count;
 	union {
 		u8 block[CHACHA20_BLOCK_SIZE];
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
-					CHACHA20_KEY_SIZE);
-	}
-	spin_lock_irqsave(&crng->lock, flags);
-	for (i = 0; i < 8; i++) {
-		unsigned long rv;
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
-			rv = random_get_entropy();
-		crng->state[i + 4] ^= buf.key[i] ^ rv;
-	}
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
+	for (i = 0; i < 8; i++)
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
 
-static void _extract_crng(struct crng_state *crng, u8 out[CHACHA20_BLOCK_SIZE])
+static void extract_crng(u8 out[CHACHA20_BLOCK_SIZE])
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
-static void extract_crng(u8 out[CHACHA20_BLOCK_SIZE])
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
-				    u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+static void crng_backtrack_protect(u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
 	unsigned long flags;
 	u32 *s, *d;
@@ -778,17 +664,12 @@ static void _crng_backtrack_protect(stru
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
-static void crng_backtrack_protect(u8 tmp[CHACHA20_BLOCK_SIZE], int used)
-{
-	_crng_backtrack_protect(select_crng(), tmp, used);
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
 }
 
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
@@ -1053,16 +934,17 @@ static void extract_entropy(void *buf, s
 	unsigned long flags;
 	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
 	struct {
-		unsigned long rdrand[32 / sizeof(long)];
+		unsigned long rdseed[32 / sizeof(long)];
 		size_t counter;
 	} block;
 	size_t i;
 
 	trace_extract_entropy(nbytes, input_pool.entropy_count);
 
-	for (i = 0; i < ARRAY_SIZE(block.rdrand); ++i) {
-		if (!arch_get_random_long(&block.rdrand[i]))
-			block.rdrand[i] = random_get_entropy();
+	for (i = 0; i < ARRAY_SIZE(block.rdseed); ++i) {
+		if (!arch_get_random_seed_long(&block.rdseed[i]) &&
+		    !arch_get_random_long(&block.rdseed[i]))
+			block.rdseed[i] = random_get_entropy();
 	}
 
 	spin_lock_irqsave(&input_pool.lock, flags);
@@ -1070,7 +952,7 @@ static void extract_entropy(void *buf, s
 	/* seed = HASHPRF(last_key, entropy_input) */
 	blake2s_final(&input_pool.hash, seed);
 
-	/* next_key = HASHPRF(seed, RDRAND || 0) */
+	/* next_key = HASHPRF(seed, RDSEED || 0) */
 	block.counter = 0;
 	blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(block), sizeof(seed));
 	blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, sizeof(next_key));
@@ -1080,7 +962,7 @@ static void extract_entropy(void *buf, s
 
 	while (nbytes) {
 		i = min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
-		/* output = HASHPRF(seed, RDRAND || ++counter) */
+		/* output = HASHPRF(seed, RDSEED || ++counter) */
 		++block.counter;
 		blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof(seed));
 		nbytes -= i;
@@ -1374,10 +1256,7 @@ static void __init init_std_data(void)
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
@@ -1547,8 +1426,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng);
-		WRITE_ONCE(crng_global_init_time, jiffies - 1);
+		crng_reseed();
 		return 0;
 	default:
 		return -EINVAL;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A0D558182
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiFWRBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiFWQ7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAA24EF66;
        Thu, 23 Jun 2022 09:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A72BF61FF8;
        Thu, 23 Jun 2022 16:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F6C3411B;
        Thu, 23 Jun 2022 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003238;
        bh=1dqJ2kp4ImREm49gbQGEIRcq9cZDWHwwADfx4vavpSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZRH0l4BtcYZ3A0vo8U+ks4eTnsQvwTkmtoibgJNa1fU5y/TM4oA0I9pj8UFHYVSP
         TSgwAy85EY3pe2kIV8/8LRp3iIIaZMPasKBr7Ar2RDHZPf+LwwVIafCuS65a7sQ0Gp
         gAl+HnPth4hrr5xEt+sxSlPMiP9ltOcgdFDK1JI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 134/264] random: group initialization wait functions
Date:   Thu, 23 Jun 2022 18:42:07 +0200
Message-Id: <20220623164347.857604522@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

commit 5f1bb112006b104b3e2a1e1b39bbb9b2617581e6 upstream.

This pulls all of the readiness waiting-focused functions into the first
labeled section.

No functional changes.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c | 1066 ++++++++++++++++++++++++--------------------------
 1 file changed, 527 insertions(+), 539 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -202,126 +202,144 @@
 #include <asm/irq_regs.h>
 #include <asm/io.h>
 
-enum {
-	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
-	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
-};
-
-/*
- * Static global variables
- */
-static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
-static struct fasync_struct *fasync;
-
-static DEFINE_SPINLOCK(random_ready_list_lock);
-static LIST_HEAD(random_ready_list);
+/*********************************************************************
+ *
+ * Initialization and readiness waiting.
+ *
+ * Much of the RNG infrastructure is devoted to various dependencies
+ * being able to wait until the RNG has collected enough entropy and
+ * is ready for safe consumption.
+ *
+ *********************************************************************/
 
 /*
  * crng_init =  0 --> Uninitialized
  *		1 --> Initialized
  *		2 --> Initialized from input_pool
  *
- * crng_init is protected by primary_crng->lock, and only increases
+ * crng_init is protected by base_crng->lock, and only increases
  * its value (from 0->1->2).
  */
 static int crng_init = 0;
 #define crng_ready() (likely(crng_init > 1))
-static int crng_init_cnt = 0;
-static void process_random_ready_list(void);
-static void _get_random_bytes(void *buf, size_t nbytes);
+/* Various types of waiters for crng_init->2 transition. */
+static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
+static struct fasync_struct *fasync;
+static DEFINE_SPINLOCK(random_ready_list_lock);
+static LIST_HEAD(random_ready_list);
 
+/* Control how we warn userspace. */
 static struct ratelimit_state unseeded_warning =
 	RATELIMIT_STATE_INIT("warn_unseeded_randomness", HZ, 3);
 static struct ratelimit_state urandom_warning =
 	RATELIMIT_STATE_INIT("warn_urandom_randomness", HZ, 3);
-
 static int ratelimit_disable __read_mostly;
-
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
 MODULE_PARM_DESC(ratelimit_disable, "Disable random ratelimit suppression");
 
-/**********************************************************************
- *
- * OS independent entropy store.   Here are the functions which handle
- * storing entropy in an entropy pool.
+/*
+ * Returns whether or not the input pool has been seeded and thus guaranteed
+ * to supply cryptographically secure random numbers. This applies to: the
+ * /dev/urandom device, the get_random_bytes function, and the get_random_{u32,
+ * ,u64,int,long} family of functions.
  *
- **********************************************************************/
-
-static struct {
-	struct blake2s_state hash;
-	spinlock_t lock;
-	unsigned int entropy_count;
-} input_pool = {
-	.hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
-		    BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
-		    BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
-	.hash.outlen = BLAKE2S_HASH_SIZE,
-	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
-};
-
-static void extract_entropy(void *buf, size_t nbytes);
-static bool drain_entropy(void *buf, size_t nbytes);
+ * Returns: true if the input pool has been seeded.
+ *          false if the input pool has not been seeded.
+ */
+bool rng_is_initialized(void)
+{
+	return crng_ready();
+}
+EXPORT_SYMBOL(rng_is_initialized);
 
-static void crng_reseed(void);
+/* Used by wait_for_random_bytes(), and considered an entropy collector, below. */
+static void try_to_generate_entropy(void);
 
 /*
- * This function adds bytes into the entropy "pool".  It does not
- * update the entropy estimate.  The caller should call
- * credit_entropy_bits if this is appropriate.
+ * Wait for the input pool to be seeded and thus guaranteed to supply
+ * cryptographically secure random numbers. This applies to: the /dev/urandom
+ * device, the get_random_bytes function, and the get_random_{u32,u64,int,long}
+ * family of functions. Using any of these functions without first calling
+ * this function forfeits the guarantee of security.
+ *
+ * Returns: 0 if the input pool has been seeded.
+ *          -ERESTARTSYS if the function was interrupted by a signal.
  */
-static void _mix_pool_bytes(const void *in, size_t nbytes)
+int wait_for_random_bytes(void)
 {
-	blake2s_update(&input_pool.hash, in, nbytes);
-}
+	if (likely(crng_ready()))
+		return 0;
 
-static void mix_pool_bytes(const void *in, size_t nbytes)
-{
-	unsigned long flags;
+	do {
+		int ret;
+		ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
+		if (ret)
+			return ret > 0 ? 0 : ret;
 
-	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(in, nbytes);
-	spin_unlock_irqrestore(&input_pool.lock, flags);
-}
+		try_to_generate_entropy();
+	} while (!crng_ready());
 
-struct fast_pool {
-	union {
-		u32 pool32[4];
-		u64 pool64[2];
-	};
-	unsigned long last;
-	u16 reg_idx;
-	u8 count;
-};
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_random_bytes);
 
 /*
- * This is a fast mixing routine used by the interrupt randomness
- * collector.  It's hardcoded for an 128 bit pool and assumes that any
- * locks that might be needed are taken by the caller.
+ * Add a callback function that will be invoked when the input
+ * pool is initialised.
+ *
+ * returns: 0 if callback is successfully added
+ *	    -EALREADY if pool is already initialised (callback not called)
+ *	    -ENOENT if module for callback is not alive
  */
-static void fast_mix(u32 pool[4])
+int add_random_ready_callback(struct random_ready_callback *rdy)
 {
-	u32 a = pool[0],	b = pool[1];
-	u32 c = pool[2],	d = pool[3];
+	struct module *owner;
+	unsigned long flags;
+	int err = -EALREADY;
 
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
+	if (crng_ready())
+		return err;
 
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
+	owner = rdy->owner;
+	if (!try_module_get(owner))
+		return -ENOENT;
 
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
+	spin_lock_irqsave(&random_ready_list_lock, flags);
+	if (crng_ready())
+		goto out;
 
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
+	owner = NULL;
 
-	pool[0] = a;  pool[1] = b;
-	pool[2] = c;  pool[3] = d;
+	list_add(&rdy->list, &random_ready_list);
+	err = 0;
+
+out:
+	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+
+	module_put(owner);
+
+	return err;
 }
+EXPORT_SYMBOL(add_random_ready_callback);
+
+/*
+ * Delete a previously registered readiness callback function.
+ */
+void del_random_ready_callback(struct random_ready_callback *rdy)
+{
+	unsigned long flags;
+	struct module *owner = NULL;
+
+	spin_lock_irqsave(&random_ready_list_lock, flags);
+	if (!list_empty(&rdy->list)) {
+		list_del_init(&rdy->list);
+		owner = rdy->owner;
+	}
+	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+
+	module_put(owner);
+}
+EXPORT_SYMBOL(del_random_ready_callback);
 
 static void process_random_ready_list(void)
 {
@@ -339,27 +357,51 @@ static void process_random_ready_list(vo
 	spin_unlock_irqrestore(&random_ready_list_lock, flags);
 }
 
-static void credit_entropy_bits(size_t nbits)
+#define warn_unseeded_randomness(previous) \
+	_warn_unseeded_randomness(__func__, (void *)_RET_IP_, (previous))
+
+static void _warn_unseeded_randomness(const char *func_name, void *caller, void **previous)
 {
-	unsigned int entropy_count, orig, add;
+#ifdef CONFIG_WARN_ALL_UNSEEDED_RANDOM
+	const bool print_once = false;
+#else
+	static bool print_once __read_mostly;
+#endif
 
-	if (!nbits)
+	if (print_once || crng_ready() ||
+	    (previous && (caller == READ_ONCE(*previous))))
 		return;
-
-	add = min_t(size_t, nbits, POOL_BITS);
-
-	do {
-		orig = READ_ONCE(input_pool.entropy_count);
-		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
-	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
-
-	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
-		crng_reseed();
+	WRITE_ONCE(*previous, caller);
+#ifndef CONFIG_WARN_ALL_UNSEEDED_RANDOM
+	print_once = true;
+#endif
+	if (__ratelimit(&unseeded_warning))
+		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n",
+				func_name, caller, crng_init);
 }
 
+
 /*********************************************************************
  *
- * CRNG using CHACHA20
+ * Fast key erasure RNG, the "crng".
+ *
+ * These functions expand entropy from the entropy extractor into
+ * long streams for external consumption using the "fast key erasure"
+ * RNG described at <https://blog.cr.yp.to/20170723-random.html>.
+ *
+ * There are a few exported interfaces for use by other drivers:
+ *
+ *	void get_random_bytes(void *buf, size_t nbytes)
+ *	u32 get_random_u32()
+ *	u64 get_random_u64()
+ *	unsigned int get_random_int()
+ *	unsigned long get_random_long()
+ *
+ * These interfaces will return the requested number of random bytes
+ * into the given buffer or as a return value. This is equivalent to
+ * a read from /dev/urandom. The integer family of functions may be
+ * higher performance for one-off random integers, because they do a
+ * bit of buffering.
  *
  *********************************************************************/
 
@@ -386,123 +428,14 @@ static DEFINE_PER_CPU(struct crng, crngs
 	.generation = ULONG_MAX
 };
 
-static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
-
-/*
- * crng_fast_load() can be called by code in the interrupt service
- * path.  So we can't afford to dilly-dally. Returns the number of
- * bytes processed from cp.
- */
-static size_t crng_fast_load(const void *cp, size_t len)
-{
-	unsigned long flags;
-	const u8 *src = (const u8 *)cp;
-	size_t ret = 0;
-
-	if (!spin_trylock_irqsave(&base_crng.lock, flags))
-		return 0;
-	if (crng_init != 0) {
-		spin_unlock_irqrestore(&base_crng.lock, flags);
-		return 0;
-	}
-	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
-		base_crng.key[crng_init_cnt % sizeof(base_crng.key)] ^= *src;
-		src++; crng_init_cnt++; len--; ret++;
-	}
-	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-		++base_crng.generation;
-		crng_init = 1;
-	}
-	spin_unlock_irqrestore(&base_crng.lock, flags);
-	if (crng_init == 1)
-		pr_notice("fast init done\n");
-	return ret;
-}
-
-#ifdef CONFIG_NUMA
-static void do_numa_crng_init(struct work_struct *work)
-{
-	int i;
-	struct crng_state *crng;
-	struct crng_state **pool;
-
-	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL|__GFP_NOFAIL);
-	for_each_online_node(i) {
-		crng = kmalloc_node(sizeof(struct crng_state),
-				    GFP_KERNEL | __GFP_NOFAIL, i);
-		spin_lock_init(&crng->lock);
-		crng_initialize(crng);
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
-	schedule_work(&numa_crng_init_work);
-}
-
-static struct crng_state *select_crng(void)
-{
-	struct crng_state **pool;
-	int nid = numa_node_id();
-
-	/* pairs with cmpxchg_release() in do_numa_crng_init() */
-	pool = READ_ONCE(crng_node_pool);
-	if (pool && pool[nid])
-		return pool[nid];
-
-	return &primary_crng;
-}
-#else
-static void numa_crng_init(void) {}
-
-static struct crng_state *select_crng(void)
-{
-	return &primary_crng;
-}
-#endif
+/* Used by crng_reseed() to extract a new seed from the input pool. */
+static bool drain_entropy(void *buf, size_t nbytes);
 
 /*
- * crng_slow_load() is called by add_device_randomness, which has two
- * attributes.  (1) We can't trust the buffer passed to it is
- * guaranteed to be unpredictable (so it might not have any entropy at
- * all), and (2) it doesn't have the performance constraints of
- * crng_fast_load().
- *
- * So, we simply hash the contents in with the current key. Finally,
- * we do *not* advance crng_init_cnt since buffer we may get may be
- * something like a fixed DMI table (for example), which might very
- * well be unique to the machine, but is otherwise unvarying.
+ * This extracts a new crng key from the input pool, but only if there is a
+ * sufficient amount of entropy available, in order to mitigate bruteforcing
+ * of newly added bits.
  */
-static void crng_slow_load(const void *cp, size_t len)
-{
-	unsigned long flags;
-	struct blake2s_state hash;
-
-	blake2s_init(&hash, sizeof(base_crng.key));
-
-	if (!spin_trylock_irqsave(&base_crng.lock, flags))
-		return;
-	if (crng_init != 0) {
-		spin_unlock_irqrestore(&base_crng.lock, flags);
-		return;
-	}
-
-	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
-	blake2s_update(&hash, cp, len);
-	blake2s_final(&hash, base_crng.key);
-
-	spin_unlock_irqrestore(&base_crng.lock, flags);
-}
-
 static void crng_reseed(void)
 {
 	unsigned long flags;
@@ -552,13 +485,11 @@ static void crng_reseed(void)
 }
 
 /*
- * The general form here is based on a "fast key erasure RNG" from
- * <https://blog.cr.yp.to/20170723-random.html>. It generates a ChaCha
- * block using the provided key, and then immediately overwites that
- * key with half the block. It returns the resultant ChaCha state to the
- * user, along with the second half of the block containing 32 bytes of
- * random data that may be used; random_data_len may not be greater than
- * 32.
+ * This generates a ChaCha block using the provided key, and then
+ * immediately overwites that key with half the block. It returns
+ * the resultant ChaCha state to the user, along with the second
+ * half of the block containing 32 bytes of random data that may
+ * be used; random_data_len may not be greater than 32.
  */
 static void crng_fast_key_erasure(u8 key[CHACHA20_KEY_SIZE],
 				  u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)],
@@ -645,6 +576,126 @@ static void crng_make_state(u32 chacha_s
 	local_irq_restore(flags);
 }
 
+/*
+ * This function is for crng_init == 0 only.
+ *
+ * crng_fast_load() can be called by code in the interrupt service
+ * path.  So we can't afford to dilly-dally. Returns the number of
+ * bytes processed from cp.
+ */
+static size_t crng_fast_load(const void *cp, size_t len)
+{
+	static int crng_init_cnt = 0;
+	unsigned long flags;
+	const u8 *src = (const u8 *)cp;
+	size_t ret = 0;
+
+	if (!spin_trylock_irqsave(&base_crng.lock, flags))
+		return 0;
+	if (crng_init != 0) {
+		spin_unlock_irqrestore(&base_crng.lock, flags);
+		return 0;
+	}
+	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
+		base_crng.key[crng_init_cnt % sizeof(base_crng.key)] ^= *src;
+		src++; crng_init_cnt++; len--; ret++;
+	}
+	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
+		++base_crng.generation;
+		crng_init = 1;
+	}
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+	if (crng_init == 1)
+		pr_notice("fast init done\n");
+	return ret;
+}
+
+/*
+ * This function is for crng_init == 0 only.
+ *
+ * crng_slow_load() is called by add_device_randomness, which has two
+ * attributes.  (1) We can't trust the buffer passed to it is
+ * guaranteed to be unpredictable (so it might not have any entropy at
+ * all), and (2) it doesn't have the performance constraints of
+ * crng_fast_load().
+ *
+ * So, we simply hash the contents in with the current key. Finally,
+ * we do *not* advance crng_init_cnt since buffer we may get may be
+ * something like a fixed DMI table (for example), which might very
+ * well be unique to the machine, but is otherwise unvarying.
+ */
+static void crng_slow_load(const void *cp, size_t len)
+{
+	unsigned long flags;
+	struct blake2s_state hash;
+
+	blake2s_init(&hash, sizeof(base_crng.key));
+
+	if (!spin_trylock_irqsave(&base_crng.lock, flags))
+		return;
+	if (crng_init != 0) {
+		spin_unlock_irqrestore(&base_crng.lock, flags);
+		return;
+	}
+
+	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
+	blake2s_update(&hash, cp, len);
+	blake2s_final(&hash, base_crng.key);
+
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+}
+
+static void _get_random_bytes(void *buf, size_t nbytes)
+{
+	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
+	u8 tmp[CHACHA20_BLOCK_SIZE];
+	size_t len;
+
+	if (!nbytes)
+		return;
+
+	len = min_t(size_t, 32, nbytes);
+	crng_make_state(chacha_state, buf, len);
+	nbytes -= len;
+	buf += len;
+
+	while (nbytes) {
+		if (nbytes < CHACHA20_BLOCK_SIZE) {
+			chacha20_block(chacha_state, tmp);
+			memcpy(buf, tmp, nbytes);
+			memzero_explicit(tmp, sizeof(tmp));
+			break;
+		}
+
+		chacha20_block(chacha_state, buf);
+		if (unlikely(chacha_state[12] == 0))
+			++chacha_state[13];
+		nbytes -= CHACHA20_BLOCK_SIZE;
+		buf += CHACHA20_BLOCK_SIZE;
+	}
+
+	memzero_explicit(chacha_state, sizeof(chacha_state));
+}
+
+/*
+ * This function is the exported kernel interface.  It returns some
+ * number of good random numbers, suitable for key generation, seeding
+ * TCP sequence numbers, etc.  It does not rely on the hardware random
+ * number generator.  For random bytes direct from the hardware RNG
+ * (when available), use get_random_bytes_arch(). In order to ensure
+ * that the randomness provided by this function is okay, the function
+ * wait_for_random_bytes() should be called and return 0 at least once
+ * at any point prior.
+ */
+void get_random_bytes(void *buf, size_t nbytes)
+{
+	static void *previous;
+
+	warn_unseeded_randomness(&previous);
+	_get_random_bytes(buf, nbytes);
+}
+EXPORT_SYMBOL(get_random_bytes);
+
 static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
 {
 	bool large_request = nbytes > 256;
@@ -692,6 +743,265 @@ static ssize_t get_random_bytes_user(voi
 	return ret;
 }
 
+/*
+ * Batched entropy returns random integers. The quality of the random
+ * number is good as /dev/urandom. In order to ensure that the randomness
+ * provided by this function is okay, the function wait_for_random_bytes()
+ * should be called and return 0 at least once at any point prior.
+ */
+struct batched_entropy {
+	union {
+		/*
+		 * We make this 1.5x a ChaCha block, so that we get the
+		 * remaining 32 bytes from fast key erasure, plus one full
+		 * block from the detached ChaCha state. We can increase
+		 * the size of this later if needed so long as we keep the
+		 * formula of (integer_blocks + 0.5) * CHACHA20_BLOCK_SIZE.
+		 */
+		u64 entropy_u64[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
+		u32 entropy_u32[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
+	};
+	unsigned long generation;
+	unsigned int position;
+};
+
+
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
+	.position = UINT_MAX
+};
+
+u64 get_random_u64(void)
+{
+	u64 ret;
+	unsigned long flags;
+	struct batched_entropy *batch;
+	static void *previous;
+	unsigned long next_gen;
+
+	warn_unseeded_randomness(&previous);
+
+	local_irq_save(flags);
+	batch = raw_cpu_ptr(&batched_entropy_u64);
+
+	next_gen = READ_ONCE(base_crng.generation);
+	if (batch->position >= ARRAY_SIZE(batch->entropy_u64) ||
+	    next_gen != batch->generation) {
+		_get_random_bytes(batch->entropy_u64, sizeof(batch->entropy_u64));
+		batch->position = 0;
+		batch->generation = next_gen;
+	}
+
+	ret = batch->entropy_u64[batch->position];
+	batch->entropy_u64[batch->position] = 0;
+	++batch->position;
+	local_irq_restore(flags);
+	return ret;
+}
+EXPORT_SYMBOL(get_random_u64);
+
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
+	.position = UINT_MAX
+};
+
+u32 get_random_u32(void)
+{
+	u32 ret;
+	unsigned long flags;
+	struct batched_entropy *batch;
+	static void *previous;
+	unsigned long next_gen;
+
+	warn_unseeded_randomness(&previous);
+
+	local_irq_save(flags);
+	batch = raw_cpu_ptr(&batched_entropy_u32);
+
+	next_gen = READ_ONCE(base_crng.generation);
+	if (batch->position >= ARRAY_SIZE(batch->entropy_u32) ||
+	    next_gen != batch->generation) {
+		_get_random_bytes(batch->entropy_u32, sizeof(batch->entropy_u32));
+		batch->position = 0;
+		batch->generation = next_gen;
+	}
+
+	ret = batch->entropy_u32[batch->position];
+	batch->entropy_u32[batch->position] = 0;
+	++batch->position;
+	local_irq_restore(flags);
+	return ret;
+}
+EXPORT_SYMBOL(get_random_u32);
+
+/**
+ * randomize_page - Generate a random, page aligned address
+ * @start:	The smallest acceptable address the caller will take.
+ * @range:	The size of the area, starting at @start, within which the
+ *		random address must fall.
+ *
+ * If @start + @range would overflow, @range is capped.
+ *
+ * NOTE: Historical use of randomize_range, which this replaces, presumed that
+ * @start was already page aligned.  We now align it regardless.
+ *
+ * Return: A page aligned address within [start, start + range).  On error,
+ * @start is returned.
+ */
+unsigned long randomize_page(unsigned long start, unsigned long range)
+{
+	if (!PAGE_ALIGNED(start)) {
+		range -= PAGE_ALIGN(start) - start;
+		start = PAGE_ALIGN(start);
+	}
+
+	if (start > ULONG_MAX - range)
+		range = ULONG_MAX - start;
+
+	range >>= PAGE_SHIFT;
+
+	if (range == 0)
+		return start;
+
+	return start + (get_random_long() % range << PAGE_SHIFT);
+}
+
+/*
+ * This function will use the architecture-specific hardware random
+ * number generator if it is available. It is not recommended for
+ * use. Use get_random_bytes() instead. It returns the number of
+ * bytes filled in.
+ */
+size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes)
+{
+	size_t left = nbytes;
+	u8 *p = buf;
+
+	while (left) {
+		unsigned long v;
+		size_t chunk = min_t(size_t, left, sizeof(unsigned long));
+
+		if (!arch_get_random_long(&v))
+			break;
+
+		memcpy(p, &v, chunk);
+		p += chunk;
+		left -= chunk;
+	}
+
+	return nbytes - left;
+}
+EXPORT_SYMBOL(get_random_bytes_arch);
+
+enum {
+	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
+	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
+};
+
+/*
+ * Static global variables
+ */
+static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
+
+/**********************************************************************
+ *
+ * OS independent entropy store.   Here are the functions which handle
+ * storing entropy in an entropy pool.
+ *
+ **********************************************************************/
+
+static struct {
+	struct blake2s_state hash;
+	spinlock_t lock;
+	unsigned int entropy_count;
+} input_pool = {
+	.hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
+		    BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
+		    BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
+	.hash.outlen = BLAKE2S_HASH_SIZE,
+	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
+};
+
+static void extract_entropy(void *buf, size_t nbytes);
+static bool drain_entropy(void *buf, size_t nbytes);
+
+static void crng_reseed(void);
+
+/*
+ * This function adds bytes into the entropy "pool".  It does not
+ * update the entropy estimate.  The caller should call
+ * credit_entropy_bits if this is appropriate.
+ */
+static void _mix_pool_bytes(const void *in, size_t nbytes)
+{
+	blake2s_update(&input_pool.hash, in, nbytes);
+}
+
+static void mix_pool_bytes(const void *in, size_t nbytes)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&input_pool.lock, flags);
+	_mix_pool_bytes(in, nbytes);
+	spin_unlock_irqrestore(&input_pool.lock, flags);
+}
+
+struct fast_pool {
+	union {
+		u32 pool32[4];
+		u64 pool64[2];
+	};
+	unsigned long last;
+	u16 reg_idx;
+	u8 count;
+};
+
+/*
+ * This is a fast mixing routine used by the interrupt randomness
+ * collector.  It's hardcoded for an 128 bit pool and assumes that any
+ * locks that might be needed are taken by the caller.
+ */
+static void fast_mix(u32 pool[4])
+{
+	u32 a = pool[0],	b = pool[1];
+	u32 c = pool[2],	d = pool[3];
+
+	a += b;			c += d;
+	b = rol32(b, 6);	d = rol32(d, 27);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(b, 16);	d = rol32(d, 14);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(b, 6);	d = rol32(d, 27);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(b, 16);	d = rol32(d, 14);
+	d ^= a;			b ^= c;
+
+	pool[0] = a;  pool[1] = b;
+	pool[2] = c;  pool[3] = d;
+}
+
+static void credit_entropy_bits(size_t nbits)
+{
+	unsigned int entropy_count, orig, add;
+
+	if (!nbits)
+		return;
+
+	add = min_t(size_t, nbits, POOL_BITS);
+
+	do {
+		orig = READ_ONCE(input_pool.entropy_count);
+		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
+	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
+
+	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
+		crng_reseed();
+}
+
 /*********************************************************************
  *
  * Entropy input management
@@ -959,80 +1269,6 @@ static bool drain_entropy(void *buf, siz
 	return true;
 }
 
-#define warn_unseeded_randomness(previous) \
-	_warn_unseeded_randomness(__func__, (void *)_RET_IP_, (previous))
-
-static void _warn_unseeded_randomness(const char *func_name, void *caller, void **previous)
-{
-#ifdef CONFIG_WARN_ALL_UNSEEDED_RANDOM
-	const bool print_once = false;
-#else
-	static bool print_once __read_mostly;
-#endif
-
-	if (print_once || crng_ready() ||
-	    (previous && (caller == READ_ONCE(*previous))))
-		return;
-	WRITE_ONCE(*previous, caller);
-#ifndef CONFIG_WARN_ALL_UNSEEDED_RANDOM
-	print_once = true;
-#endif
-	if (__ratelimit(&unseeded_warning))
-		pr_notice("random: %s called from %pS with crng_init=%d\n",
-			  func_name, caller, crng_init);
-}
-
-/*
- * This function is the exported kernel interface.  It returns some
- * number of good random numbers, suitable for key generation, seeding
- * TCP sequence numbers, etc.  It does not rely on the hardware random
- * number generator.  For random bytes direct from the hardware RNG
- * (when available), use get_random_bytes_arch(). In order to ensure
- * that the randomness provided by this function is okay, the function
- * wait_for_random_bytes() should be called and return 0 at least once
- * at any point prior.
- */
-static void _get_random_bytes(void *buf, size_t nbytes)
-{
-	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
-	u8 tmp[CHACHA20_BLOCK_SIZE];
-	size_t len;
-
-	if (!nbytes)
-		return;
-
-	len = min_t(size_t, 32, nbytes);
-	crng_make_state(chacha_state, buf, len);
-	nbytes -= len;
-	buf += len;
-
-	while (nbytes) {
-		if (nbytes < CHACHA20_BLOCK_SIZE) {
-			chacha20_block(chacha_state, tmp);
-			memcpy(buf, tmp, nbytes);
-			memzero_explicit(tmp, sizeof(tmp));
-			break;
-		}
-
-		chacha20_block(chacha_state, buf);
-		if (unlikely(chacha_state[12] == 0))
-			++chacha_state[13];
-		nbytes -= CHACHA20_BLOCK_SIZE;
-		buf += CHACHA20_BLOCK_SIZE;
-	}
-
-	memzero_explicit(chacha_state, sizeof(chacha_state));
-}
-
-void get_random_bytes(void *buf, size_t nbytes)
-{
-	static void *previous;
-
-	warn_unseeded_randomness(&previous);
-	_get_random_bytes(buf, nbytes);
-}
-EXPORT_SYMBOL(get_random_bytes);
-
 /*
  * Each time the timer fires, we expect that we got an unpredictable
  * jump in the cycle counter. Even if the timer is running on another
@@ -1082,134 +1318,6 @@ static void try_to_generate_entropy(void
 	mix_pool_bytes(&stack.now, sizeof(stack.now));
 }
 
-/*
- * Wait for the urandom pool to be seeded and thus guaranteed to supply
- * cryptographically secure random numbers. This applies to: the /dev/urandom
- * device, the get_random_bytes function, and the get_random_{u32,u64,int,long}
- * family of functions. Using any of these functions without first calling
- * this function forfeits the guarantee of security.
- *
- * Returns: 0 if the urandom pool has been seeded.
- *          -ERESTARTSYS if the function was interrupted by a signal.
- */
-int wait_for_random_bytes(void)
-{
-	if (likely(crng_ready()))
-		return 0;
-
-	do {
-		int ret;
-		ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
-		if (ret)
-			return ret > 0 ? 0 : ret;
-
-		try_to_generate_entropy();
-	} while (!crng_ready());
-
-	return 0;
-}
-EXPORT_SYMBOL(wait_for_random_bytes);
-
-/*
- * Returns whether or not the urandom pool has been seeded and thus guaranteed
- * to supply cryptographically secure random numbers. This applies to: the
- * /dev/urandom device, the get_random_bytes function, and the get_random_{u32,
- * ,u64,int,long} family of functions.
- *
- * Returns: true if the urandom pool has been seeded.
- *          false if the urandom pool has not been seeded.
- */
-bool rng_is_initialized(void)
-{
-	return crng_ready();
-}
-EXPORT_SYMBOL(rng_is_initialized);
-
-/*
- * Add a callback function that will be invoked when the nonblocking
- * pool is initialised.
- *
- * returns: 0 if callback is successfully added
- *	    -EALREADY if pool is already initialised (callback not called)
- *	    -ENOENT if module for callback is not alive
- */
-int add_random_ready_callback(struct random_ready_callback *rdy)
-{
-	struct module *owner;
-	unsigned long flags;
-	int err = -EALREADY;
-
-	if (crng_ready())
-		return err;
-
-	owner = rdy->owner;
-	if (!try_module_get(owner))
-		return -ENOENT;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (crng_ready())
-		goto out;
-
-	owner = NULL;
-
-	list_add(&rdy->list, &random_ready_list);
-	err = 0;
-
-out:
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
-
-	module_put(owner);
-
-	return err;
-}
-EXPORT_SYMBOL(add_random_ready_callback);
-
-/*
- * Delete a previously registered readiness callback function.
- */
-void del_random_ready_callback(struct random_ready_callback *rdy)
-{
-	unsigned long flags;
-	struct module *owner = NULL;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (!list_empty(&rdy->list)) {
-		list_del_init(&rdy->list);
-		owner = rdy->owner;
-	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
-
-	module_put(owner);
-}
-EXPORT_SYMBOL(del_random_ready_callback);
-
-/*
- * This function will use the architecture-specific hardware random
- * number generator if it is available. It is not recommended for
- * use. Use get_random_bytes() instead. It returns the number of
- * bytes filled in.
- */
-size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes)
-{
-	size_t left = nbytes;
-	u8 *p = buf;
-
-	while (left) {
-		unsigned long v;
-		size_t chunk = min_t(size_t, left, sizeof(unsigned long));
-
-		if (!arch_get_random_long(&v))
-			break;
-
-		memcpy(p, &v, chunk);
-		p += chunk;
-		left -= chunk;
-	}
-
-	return nbytes - left;
-}
-EXPORT_SYMBOL(get_random_bytes_arch);
-
 static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
 static int __init parse_trust_cpu(char *arg)
 {
@@ -1560,126 +1668,6 @@ struct ctl_table random_table[] = {
 };
 #endif	/* CONFIG_SYSCTL */
 
-struct batched_entropy {
-	union {
-		/*
-		 * We make this 1.5x a ChaCha block, so that we get the
-		 * remaining 32 bytes from fast key erasure, plus one full
-		 * block from the detached ChaCha state. We can increase
-		 * the size of this later if needed so long as we keep the
-		 * formula of (integer_blocks + 0.5) * CHACHA20_BLOCK_SIZE.
-		 */
-		u64 entropy_u64[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
-		u32 entropy_u32[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
-	};
-	unsigned long generation;
-	unsigned int position;
-};
-
-/*
- * Get a random word for internal kernel use only. The quality of the random
- * number is good as /dev/urandom. In order to ensure that the randomness
- * provided by this function is okay, the function wait_for_random_bytes()
- * should be called and return 0 at least once at any point prior.
- */
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.position = UINT_MAX
-};
-
-u64 get_random_u64(void)
-{
-	u64 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	static void *previous;
-	unsigned long next_gen;
-
-	warn_unseeded_randomness(&previous);
-
-	local_irq_save(flags);
-	batch = raw_cpu_ptr(&batched_entropy_u64);
-
-	next_gen = READ_ONCE(base_crng.generation);
-	if (batch->position >= ARRAY_SIZE(batch->entropy_u64) ||
-	    next_gen != batch->generation) {
-		_get_random_bytes(batch->entropy_u64, sizeof(batch->entropy_u64));
-		batch->position = 0;
-		batch->generation = next_gen;
-	}
-
-	ret = batch->entropy_u64[batch->position];
-	batch->entropy_u64[batch->position] = 0;
-	++batch->position;
-	local_irq_restore(flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u64);
-
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.position = UINT_MAX
-};
-
-u32 get_random_u32(void)
-{
-	u32 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	static void *previous;
-	unsigned long next_gen;
-
-	warn_unseeded_randomness(&previous);
-
-	local_irq_save(flags);
-	batch = raw_cpu_ptr(&batched_entropy_u32);
-
-	next_gen = READ_ONCE(base_crng.generation);
-	if (batch->position >= ARRAY_SIZE(batch->entropy_u32) ||
-	    next_gen != batch->generation) {
-		_get_random_bytes(batch->entropy_u32, sizeof(batch->entropy_u32));
-		batch->position = 0;
-		batch->generation = next_gen;
-	}
-
-	ret = batch->entropy_u32[batch->position];
-	batch->entropy_u32[batch->position] = 0;
-	++batch->position;
-	local_irq_restore(flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u32);
-
-/**
- * randomize_page - Generate a random, page aligned address
- * @start:	The smallest acceptable address the caller will take.
- * @range:	The size of the area, starting at @start, within which the
- *		random address must fall.
- *
- * If @start + @range would overflow, @range is capped.
- *
- * NOTE: Historical use of randomize_range, which this replaces, presumed that
- * @start was already page aligned.  We now align it regardless.
- *
- * Return: A page aligned address within [start, start + range).  On error,
- * @start is returned.
- */
-unsigned long randomize_page(unsigned long start, unsigned long range)
-{
-	if (!PAGE_ALIGNED(start)) {
-		range -= PAGE_ALIGN(start) - start;
-		start = PAGE_ALIGN(start);
-	}
-
-	if (start > ULONG_MAX - range)
-		range = ULONG_MAX - start;
-
-	range >>= PAGE_SHIFT;
-
-	if (range == 0)
-		return start;
-
-	return start + (get_random_long() % range << PAGE_SHIFT);
-}
-
 /* Interface for in-kernel drivers of true hardware RNGs.
  * Those devices may produce endless random bits and will be throttled
  * when our pool is full.



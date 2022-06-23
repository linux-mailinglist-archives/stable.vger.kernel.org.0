Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6E558364
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiFWR3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiFWR15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019CC51310;
        Thu, 23 Jun 2022 10:03:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447D961C15;
        Thu, 23 Jun 2022 17:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52B4C3411B;
        Thu, 23 Jun 2022 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003825;
        bh=l7BDSU4yDg+TMlJ7jUXLoU5R9zJ/F8HJqoCt98/8aMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gahmByj2LDSdXgefX7fQFY030UUKK+0tm3CLLsfjIPLbJOujMMsXR99OphWr0czYI
         hYJbyHbVCldqomkxMJYVk7J0qhX07VG2w6DH5XX1m4fCCE4U+TI0iLu2+ekOj0x/uv
         tDgfXriCjJ/h2apHjjLIZSnwe2nstwgKfZXx5bKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 100/237] random: absorb fast pool into input pool after fast load
Date:   Thu, 23 Jun 2022 18:42:14 +0200
Message-Id: <20220623164346.026965794@linuxfoundation.org>
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

commit c30c575db4858f0bbe5e315ff2e529c782f33a1f upstream.

During crng_init == 0, we never credit entropy in add_interrupt_
randomness(), but instead dump it directly into the primary_crng. That's
fine, except for the fact that we then wind up throwing away that
entropy later when we switch to extracting from the input pool and
xoring into (and later in this series overwriting) the primary_crng key.
The two other early init sites -- add_hwgenerator_randomness()'s use
crng_fast_load() and add_device_ randomness()'s use of crng_slow_load()
-- always additionally give their inputs to the input pool. But not
add_interrupt_randomness().

This commit fixes that shortcoming by calling mix_pool_bytes() after
crng_fast_load() in add_interrupt_randomness(). That's partially
verboten on PREEMPT_RT, where it implies taking spinlock_t from an IRQ
handler. But this also only happens during early boot and then never
again after that. Plus it's a trylock so it has the same considerations
as calling crng_fast_load(), which we're already using.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Suggested-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  407 +++++++++++++++++++++++++++++---------------------
 1 file changed, 237 insertions(+), 170 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -67,63 +67,19 @@
  * Exported interfaces ---- kernel output
  * --------------------------------------
  *
- * The primary kernel interface is
+ * The primary kernel interfaces are:
  *
  *	void get_random_bytes(void *buf, int nbytes);
- *
- * This interface will return the requested number of random bytes,
- * and place it in the requested buffer.  This is equivalent to a
- * read from /dev/urandom.
- *
- * For less critical applications, there are the functions:
- *
  *	u32 get_random_u32()
  *	u64 get_random_u64()
  *	unsigned int get_random_int()
  *	unsigned long get_random_long()
  *
- * These are produced by a cryptographic RNG seeded from get_random_bytes,
- * and so do not deplete the entropy pool as much.  These are recommended
- * for most in-kernel operations *if the result is going to be stored in
- * the kernel*.
- *
- * Specifically, the get_random_int() family do not attempt to do
- * "anti-backtracking".  If you capture the state of the kernel (e.g.
- * by snapshotting the VM), you can figure out previous get_random_int()
- * return values.  But if the value is stored in the kernel anyway,
- * this is not a problem.
- *
- * It *is* safe to expose get_random_int() output to attackers (e.g. as
- * network cookies); given outputs 1..n, it's not feasible to predict
- * outputs 0 or n+1.  The only concern is an attacker who breaks into
- * the kernel later; the get_random_int() engine is not reseeded as
- * often as the get_random_bytes() one.
- *
- * get_random_bytes() is needed for keys that need to stay secret after
- * they are erased from the kernel.  For example, any key that will
- * be wrapped and stored encrypted.  And session encryption keys: we'd
- * like to know that after the session is closed and the keys erased,
- * the plaintext is unrecoverable to someone who recorded the ciphertext.
- *
- * But for network ports/cookies, stack canaries, PRNG seeds, address
- * space layout randomization, session *authentication* keys, or other
- * applications where the sensitive data is stored in the kernel in
- * plaintext for as long as it's sensitive, the get_random_int() family
- * is just fine.
- *
- * Consider ASLR.  We want to keep the address space secret from an
- * outside attacker while the process is running, but once the address
- * space is torn down, it's of no use to an attacker any more.  And it's
- * stored in kernel data structures as long as it's alive, so worrying
- * about an attacker's ability to extrapolate it from the get_random_int()
- * CRNG is silly.
- *
- * Even some cryptographic keys are safe to generate with get_random_int().
- * In particular, keys for SipHash are generally fine.  Here, knowledge
- * of the key authorizes you to do something to a kernel object (inject
- * packets to a network connection, or flood a hash table), and the
- * key is stored with the object being protected.  Once it goes away,
- * we no longer care if anyone knows the key.
+ * These interfaces will return the requested number of random bytes
+ * into the given buffer or as a return value. This is equivalent to a
+ * read from /dev/urandom. The get_random_{u32,u64,int,long}() family
+ * of functions may be higher performance for one-off random integers,
+ * because they do a bit of buffering.
  *
  * prandom_u32()
  * -------------
@@ -300,20 +256,6 @@ static struct fasync_struct *fasync;
 static DEFINE_SPINLOCK(random_ready_list_lock);
 static LIST_HEAD(random_ready_list);
 
-struct crng_state {
-	u32 state[16];
-	unsigned long init_time;
-	spinlock_t lock;
-};
-
-static struct crng_state primary_crng = {
-	.lock = __SPIN_LOCK_UNLOCKED(primary_crng.lock),
-	.state[0] = CHACHA_CONSTANT_EXPA,
-	.state[1] = CHACHA_CONSTANT_ND_3,
-	.state[2] = CHACHA_CONSTANT_2_BY,
-	.state[3] = CHACHA_CONSTANT_TE_K,
-};
-
 /*
  * crng_init =  0 --> Uninitialized
  *		1 --> Initialized
@@ -325,9 +267,6 @@ static struct crng_state primary_crng =
 static int crng_init = 0;
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
-#define CRNG_INIT_CNT_THRESH (2 * CHACHA20_KEY_SIZE)
-static void extract_crng(u8 out[CHACHA20_BLOCK_SIZE]);
-static void crng_backtrack_protect(u8 tmp[CHACHA20_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -470,7 +409,28 @@ static void credit_entropy_bits(int nbit
  *
  *********************************************************************/
 
-#define CRNG_RESEED_INTERVAL (300 * HZ)
+enum {
+	CRNG_RESEED_INTERVAL = 300 * HZ,
+	CRNG_INIT_CNT_THRESH = 2 * CHACHA20_KEY_SIZE
+};
+
+static struct {
+	u8 key[CHACHA20_KEY_SIZE] __aligned(__alignof__(long));
+	unsigned long birth;
+	unsigned long generation;
+	spinlock_t lock;
+} base_crng = {
+	.lock = __SPIN_LOCK_UNLOCKED(base_crng.lock)
+};
+
+struct crng {
+	u8 key[CHACHA20_KEY_SIZE];
+	unsigned long generation;
+};
+
+static DEFINE_PER_CPU(struct crng, crngs) = {
+	.generation = ULONG_MAX
+};
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
@@ -487,22 +447,22 @@ static size_t crng_fast_load(const u8 *c
 	u8 *p;
 	size_t ret = 0;
 
-	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
+	if (!spin_trylock_irqsave(&base_crng.lock, flags))
 		return 0;
 	if (crng_init != 0) {
-		spin_unlock_irqrestore(&primary_crng.lock, flags);
+		spin_unlock_irqrestore(&base_crng.lock, flags);
 		return 0;
 	}
-	p = (u8 *)&primary_crng.state[4];
+	p = base_crng.key;
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
-		p[crng_init_cnt % CHACHA20_KEY_SIZE] ^= *cp;
+		p[crng_init_cnt % sizeof(base_crng.key)] ^= *cp;
 		cp++; crng_init_cnt++; len--; ret++;
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
 		crng_init = 1;
 	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	spin_unlock_irqrestore(&base_crng.lock, flags);
 	if (crng_init == 1)
 		pr_notice("fast init done\n");
 	return ret;
@@ -527,14 +487,14 @@ static int crng_slow_load(const u8 *cp,
 	unsigned long flags;
 	static u8 lfsr = 1;
 	u8 tmp;
-	unsigned int i, max = CHACHA20_KEY_SIZE;
+	unsigned int i, max = sizeof(base_crng.key);
 	const u8 *src_buf = cp;
-	u8 *dest_buf = (u8 *)&primary_crng.state[4];
+	u8 *dest_buf = base_crng.key;
 
-	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
+	if (!spin_trylock_irqsave(&base_crng.lock, flags))
 		return 0;
 	if (crng_init != 0) {
-		spin_unlock_irqrestore(&primary_crng.lock, flags);
+		spin_unlock_irqrestore(&base_crng.lock, flags);
 		return 0;
 	}
 	if (len > max)
@@ -545,38 +505,50 @@ static int crng_slow_load(const u8 *cp,
 		lfsr >>= 1;
 		if (tmp & 1)
 			lfsr ^= 0xE1;
-		tmp = dest_buf[i % CHACHA20_KEY_SIZE];
-		dest_buf[i % CHACHA20_KEY_SIZE] ^= src_buf[i % len] ^ lfsr;
+		tmp = dest_buf[i % sizeof(base_crng.key)];
+		dest_buf[i % sizeof(base_crng.key)] ^= src_buf[i % len] ^ lfsr;
 		lfsr += (tmp << 3) | (tmp >> 5);
 	}
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	spin_unlock_irqrestore(&base_crng.lock, flags);
 	return 1;
 }
 
 static void crng_reseed(void)
 {
 	unsigned long flags;
-	int i, entropy_count;
-	union {
-		u8 block[CHACHA20_BLOCK_SIZE];
-		u32 key[8];
-	} buf;
+	int entropy_count;
+	unsigned long next_gen;
+	u8 key[CHACHA20_KEY_SIZE];
 
+	/*
+	 * First we make sure we have POOL_MIN_BITS of entropy in the pool,
+	 * and then we drain all of it. Only then can we extract a new key.
+	 */
 	do {
 		entropy_count = READ_ONCE(input_pool.entropy_count);
 		if (entropy_count < POOL_MIN_BITS)
 			return;
 	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
-	extract_entropy(buf.key, sizeof(buf.key));
+	extract_entropy(key, sizeof(key));
 	wake_up_interruptible(&random_write_wait);
 	kill_fasync(&fasync, SIGIO, POLL_OUT);
 
-	spin_lock_irqsave(&primary_crng.lock, flags);
-	for (i = 0; i < 8; i++)
-		primary_crng.state[i + 4] ^= buf.key[i];
-	memzero_explicit(&buf, sizeof(buf));
-	WRITE_ONCE(primary_crng.init_time, jiffies);
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	/*
+	 * We copy the new key into the base_crng, overwriting the old one,
+	 * and update the generation counter. We avoid hitting ULONG_MAX,
+	 * because the per-cpu crngs are initialized to ULONG_MAX, so this
+	 * forces new CPUs that come online to always initialize.
+	 */
+	spin_lock_irqsave(&base_crng.lock, flags);
+	memcpy(base_crng.key, key, sizeof(base_crng.key));
+	next_gen = base_crng.generation + 1;
+	if (next_gen == ULONG_MAX)
+		++next_gen;
+	WRITE_ONCE(base_crng.generation, next_gen);
+	WRITE_ONCE(base_crng.birth, jiffies);
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+	memzero_explicit(key, sizeof(key));
+
 	if (crng_init < 2) {
 		invalidate_batched_entropy();
 		crng_init = 2;
@@ -597,77 +569,143 @@ static void crng_reseed(void)
 	}
 }
 
-static void extract_crng(u8 out[CHACHA20_BLOCK_SIZE])
+/*
+ * The general form here is based on a "fast key erasure RNG" from
+ * <https://blog.cr.yp.to/20170723-random.html>. It generates a ChaCha
+ * block using the provided key, and then immediately overwites that
+ * key with half the block. It returns the resultant ChaCha state to the
+ * user, along with the second half of the block containing 32 bytes of
+ * random data that may be used; random_data_len may not be greater than
+ * 32.
+ */
+static void crng_fast_key_erasure(u8 key[CHACHA20_KEY_SIZE],
+				  u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)],
+				  u8 *random_data, size_t random_data_len)
 {
-	unsigned long flags, init_time;
+	u8 first_block[CHACHA20_BLOCK_SIZE];
 
-	if (crng_ready()) {
-		init_time = READ_ONCE(primary_crng.init_time);
-		if (time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
-			crng_reseed();
-	}
-	spin_lock_irqsave(&primary_crng.lock, flags);
-	chacha20_block(&primary_crng.state[0], out);
-	if (primary_crng.state[12] == 0)
-		primary_crng.state[13]++;
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	BUG_ON(random_data_len > 32);
+
+	chacha_init_consts(chacha_state);
+	memcpy(&chacha_state[4], key, CHACHA20_KEY_SIZE);
+	memset(&chacha_state[12], 0, sizeof(u32) * 4);
+	chacha20_block(chacha_state, first_block);
+
+	memcpy(key, first_block, CHACHA20_KEY_SIZE);
+	memcpy(random_data, first_block + CHACHA20_KEY_SIZE, random_data_len);
+	memzero_explicit(first_block, sizeof(first_block));
 }
 
 /*
- * Use the leftover bytes from the CRNG block output (if there is
- * enough) to mutate the CRNG key to provide backtracking protection.
+ * This function returns a ChaCha state that you may use for generating
+ * random data. It also returns up to 32 bytes on its own of random data
+ * that may be used; random_data_len may not be greater than 32.
  */
-static void crng_backtrack_protect(u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+static void crng_make_state(u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)],
+			    u8 *random_data, size_t random_data_len)
 {
 	unsigned long flags;
-	u32 *s, *d;
-	int i;
+	struct crng *crng;
+
+	BUG_ON(random_data_len > 32);
+
+	/*
+	 * For the fast path, we check whether we're ready, unlocked first, and
+	 * then re-check once locked later. In the case where we're really not
+	 * ready, we do fast key erasure with the base_crng directly, because
+	 * this is what crng_{fast,slow}_load mutate during early init.
+	 */
+	if (unlikely(!crng_ready())) {
+		bool ready;
+
+		spin_lock_irqsave(&base_crng.lock, flags);
+		ready = crng_ready();
+		if (!ready)
+			crng_fast_key_erasure(base_crng.key, chacha_state,
+					      random_data, random_data_len);
+		spin_unlock_irqrestore(&base_crng.lock, flags);
+		if (!ready)
+			return;
+	}
+
+	/*
+	 * If the base_crng is more than 5 minutes old, we reseed, which
+	 * in turn bumps the generation counter that we check below.
+	 */
+	if (unlikely(time_after(jiffies, READ_ONCE(base_crng.birth) + CRNG_RESEED_INTERVAL)))
+		crng_reseed();
+
+	local_irq_save(flags);
+	crng = raw_cpu_ptr(&crngs);
+
+	/*
+	 * If our per-cpu crng is older than the base_crng, then it means
+	 * somebody reseeded the base_crng. In that case, we do fast key
+	 * erasure on the base_crng, and use its output as the new key
+	 * for our per-cpu crng. This brings us up to date with base_crng.
+	 */
+	if (unlikely(crng->generation != READ_ONCE(base_crng.generation))) {
+		spin_lock(&base_crng.lock);
+		crng_fast_key_erasure(base_crng.key, chacha_state,
+				      crng->key, sizeof(crng->key));
+		crng->generation = base_crng.generation;
+		spin_unlock(&base_crng.lock);
+	}
+
+	/*
+	 * Finally, when we've made it this far, our per-cpu crng has an up
+	 * to date key, and we can do fast key erasure with it to produce
+	 * some random data and a ChaCha state for the caller. All other
+	 * branches of this function are "unlikely", so most of the time we
+	 * should wind up here immediately.
+	 */
+	crng_fast_key_erasure(crng->key, chacha_state, random_data, random_data_len);
+	local_irq_restore(flags);
+}
+
+static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
+{
+	bool large_request = nbytes > 256;
+	ssize_t ret = 0, len;
+	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
+	u8 output[CHACHA20_BLOCK_SIZE];
+
+	if (!nbytes)
+		return 0;
 
-	used = round_up(used, sizeof(u32));
-	if (used + CHACHA20_KEY_SIZE > CHACHA20_BLOCK_SIZE) {
-		extract_crng(tmp);
-		used = 0;
-	}
-	spin_lock_irqsave(&primary_crng.lock, flags);
-	s = (u32 *)&tmp[used];
-	d = &primary_crng.state[4];
-	for (i = 0; i < 8; i++)
-		*d++ ^= *s++;
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
-}
-
-static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
-{
-	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
-	u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
-	int large_request = (nbytes > 256);
+	len = min_t(ssize_t, 32, nbytes);
+	crng_make_state(chacha_state, output, len);
+
+	if (copy_to_user(buf, output, len))
+		return -EFAULT;
+	nbytes -= len;
+	buf += len;
+	ret += len;
 
 	while (nbytes) {
 		if (large_request && need_resched()) {
-			if (signal_pending(current)) {
-				if (ret == 0)
-					ret = -ERESTARTSYS;
+			if (signal_pending(current))
 				break;
-			}
 			schedule();
 		}
 
-		extract_crng(tmp);
-		i = min_t(int, nbytes, CHACHA20_BLOCK_SIZE);
-		if (copy_to_user(buf, tmp, i)) {
+		chacha20_block(chacha_state, output);
+		if (unlikely(chacha_state[12] == 0))
+			++chacha_state[13];
+
+		len = min_t(ssize_t, nbytes, CHACHA20_BLOCK_SIZE);
+		if (copy_to_user(buf, output, len)) {
 			ret = -EFAULT;
 			break;
 		}
 
-		nbytes -= i;
-		buf += i;
-		ret += i;
+		nbytes -= len;
+		buf += len;
+		ret += len;
 	}
-	crng_backtrack_protect(tmp, i);
-
-	/* Wipe data just written to memory */
-	memzero_explicit(tmp, sizeof(tmp));
 
+	memzero_explicit(chacha_state, sizeof(chacha_state));
+	memzero_explicit(output, sizeof(output));
 	return ret;
 }
 
@@ -850,6 +888,10 @@ void add_interrupt_randomness(int irq)
 		    crng_fast_load((u8 *)fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
+			if (spin_trylock(&input_pool.lock)) {
+				_mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
+				spin_unlock(&input_pool.lock);
+			}
 		}
 		return;
 	}
@@ -972,23 +1014,36 @@ static void _warn_unseeded_randomness(co
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
+	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
+	u8 tmp[CHACHA20_BLOCK_SIZE];
+	ssize_t len;
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
-	while (nbytes >= CHACHA20_BLOCK_SIZE) {
-		extract_crng(buf);
-		buf += CHACHA20_BLOCK_SIZE;
+	if (!nbytes)
+		return;
+
+	len = min_t(ssize_t, 32, nbytes);
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
 		nbytes -= CHACHA20_BLOCK_SIZE;
+		buf += CHACHA20_BLOCK_SIZE;
 	}
 
-	if (nbytes > 0) {
-		extract_crng(tmp);
-		memcpy(buf, tmp, nbytes);
-		crng_backtrack_protect(tmp, nbytes);
-	} else
-		crng_backtrack_protect(tmp, CHACHA20_BLOCK_SIZE);
-	memzero_explicit(tmp, sizeof(tmp));
+	memzero_explicit(chacha_state, sizeof(chacha_state));
 }
 
 void get_random_bytes(void *buf, int nbytes)
@@ -1219,13 +1274,12 @@ int __init rand_initialize(void)
 	mix_pool_bytes(&now, sizeof(now));
 	mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
-	extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
+	extract_entropy(base_crng.key, sizeof(base_crng.key));
 	if (arch_init && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
-	primary_crng.init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 
 	if (ratelimit_disable) {
 		urandom_warning.interval = 0;
@@ -1257,7 +1311,7 @@ static ssize_t urandom_read_nowarn(struc
 	int ret;
 
 	nbytes = min_t(size_t, nbytes, INT_MAX >> 6);
-	ret = extract_crng_user(buf, nbytes);
+	ret = get_random_bytes_user(buf, nbytes);
 	trace_urandom_read(8 * nbytes, 0, input_pool.entropy_count);
 	return ret;
 }
@@ -1561,8 +1615,15 @@ static atomic_t batch_generation = ATOMI
 
 struct batched_entropy {
 	union {
-		u64 entropy_u64[CHACHA20_BLOCK_SIZE / sizeof(u64)];
-		u32 entropy_u32[CHACHA20_BLOCK_SIZE / sizeof(u32)];
+		/*
+		 * We make this 1.5x a ChaCha block, so that we get the
+		 * remaining 32 bytes from fast key erasure, plus one full
+		 * block from the detached ChaCha state. We can increase
+		 * the size of this later if needed so long as we keep the
+		 * formula of (integer_blocks + 0.5) * CHACHA20_BLOCK_SIZE.
+		 */
+		u64 entropy_u64[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
+		u32 entropy_u32[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
 	};
 	unsigned int position;
 	int generation;
@@ -1570,13 +1631,13 @@ struct batched_entropy {
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
- * number is good as /dev/urandom, but there is no backtrack protection, with
- * the goal of being quite fast and not depleting entropy. In order to ensure
- * that the randomness provided by this function is okay, the function
- * wait_for_random_bytes() should be called and return 0 at least once at any
- * point prior.
+ * number is good as /dev/urandom. In order to ensure that the randomness
+ * provided by this function is okay, the function wait_for_random_bytes()
+ * should be called and return 0 at least once at any point prior.
  */
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
+	.position = UINT_MAX
+};
 
 u64 get_random_u64(void)
 {
@@ -1592,20 +1653,24 @@ u64 get_random_u64(void)
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 
 	next_gen = atomic_read(&batch_generation);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0 ||
+	if (batch->position >= ARRAY_SIZE(batch->entropy_u64) ||
 	    next_gen != batch->generation) {
-		extract_crng((u8 *)batch->entropy_u64);
+		_get_random_bytes(batch->entropy_u64, sizeof(batch->entropy_u64));
 		batch->position = 0;
 		batch->generation = next_gen;
 	}
 
-	ret = batch->entropy_u64[batch->position++];
+	ret = batch->entropy_u64[batch->position];
+	batch->entropy_u64[batch->position] = 0;
+	++batch->position;
 	local_irq_restore(flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u64);
 
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32);
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
+	.position = UINT_MAX
+};
 
 u32 get_random_u32(void)
 {
@@ -1621,14 +1686,16 @@ u32 get_random_u32(void)
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 
 	next_gen = atomic_read(&batch_generation);
-	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0 ||
+	if (batch->position >= ARRAY_SIZE(batch->entropy_u32) ||
 	    next_gen != batch->generation) {
-		extract_crng((u8 *)batch->entropy_u32);
+		_get_random_bytes(batch->entropy_u32, sizeof(batch->entropy_u32));
 		batch->position = 0;
 		batch->generation = next_gen;
 	}
 
-	ret = batch->entropy_u32[batch->position++];
+	ret = batch->entropy_u32[batch->position];
+	batch->entropy_u32[batch->position] = 0;
+	++batch->position;
 	local_irq_restore(flags);
 	return ret;
 }



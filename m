Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3122536010
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351747AbiE0LoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiE0Ln7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927B8692B6;
        Fri, 27 May 2022 04:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C4D461D39;
        Fri, 27 May 2022 11:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E6FC385A9;
        Fri, 27 May 2022 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651654;
        bh=6+TruVl+8B/Q5KlT2xmTbjcQD+q3soumDq7OAvKNIO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyWuh5Gn7dZvgDu0T5kCS3yS1zsqa/tBor2qOb/Oa4kAo6QPjTKGYNkvhxv8UPeJT
         j81eOJcmdEnpmoRUGbPHYxIw3rXdpjlOuQEfiwtCzas+bHEHvf+yK36yKWZ6Dg0nCk
         +wB4e6bUJhIVTGX6vlf7PHMDhxGEk1jI6k6E78/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 027/145] random: rather than entropy_store abstraction, use global
Date:   Fri, 27 May 2022 10:48:48 +0200
Message-Id: <20220527084854.154100904@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 90ed1e67e896cc8040a523f8428fc02f9b164394 upstream.

Originally, the RNG used several pools, so having things abstracted out
over a generic entropy_store object made sense. These days, there's only
one input pool, and then an uneven mix of usage via the abstraction and
usage via &input_pool. Rather than this uneasy mixture, just get rid of
the abstraction entirely and have things always use the global. This
simplifies the code and makes reading it a bit easier.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c         |  219 ++++++++++++++++++------------------------
 include/trace/events/random.h |   56 ++++------
 2 files changed, 117 insertions(+), 158 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -375,7 +375,7 @@
  * credit_entropy_bits() needs to be 64 bits wide.
  */
 #define ENTROPY_SHIFT 3
-#define ENTROPY_BITS(r) ((r)->entropy_count >> ENTROPY_SHIFT)
+#define ENTROPY_BITS() (input_pool.entropy_count >> ENTROPY_SHIFT)
 
 /*
  * If the entropy count falls under this number of bits, then we
@@ -505,33 +505,27 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
  *
  **********************************************************************/
 
-struct entropy_store;
-struct entropy_store {
+static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
+
+static struct {
 	/* read-only data: */
 	u32 *pool;
-	const char *name;
 
 	/* read-write data: */
 	spinlock_t lock;
 	u16 add_ptr;
 	u16 input_rotate;
 	int entropy_count;
-};
-
-static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, int min);
-static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes);
-
-static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
-static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
-
-static struct entropy_store input_pool = {
-	.name = "input",
+} input_pool = {
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 	.pool = input_pool_data
 };
 
+static ssize_t extract_entropy(void *buf, size_t nbytes, int min);
+static ssize_t _extract_entropy(void *buf, size_t nbytes);
+
+static void crng_reseed(struct crng_state *crng, bool use_input_pool);
+
 static u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -546,16 +540,15 @@ static u32 const twist_table[8] = {
  * it's cheap to do so and helps slightly in the expected case where
  * the entropy is concentrated in the low-order bits.
  */
-static void _mix_pool_bytes(struct entropy_store *r, const void *in,
-			    int nbytes)
+static void _mix_pool_bytes(const void *in, int nbytes)
 {
 	unsigned long i;
 	int input_rotate;
 	const u8 *bytes = in;
 	u32 w;
 
-	input_rotate = r->input_rotate;
-	i = r->add_ptr;
+	input_rotate = input_pool.input_rotate;
+	i = input_pool.add_ptr;
 
 	/* mix one byte at a time to simplify size handling and churn faster */
 	while (nbytes--) {
@@ -563,15 +556,15 @@ static void _mix_pool_bytes(struct entro
 		i = (i - 1) & POOL_WORDMASK;
 
 		/* XOR in the various taps */
-		w ^= r->pool[i];
-		w ^= r->pool[(i + POOL_TAP1) & POOL_WORDMASK];
-		w ^= r->pool[(i + POOL_TAP2) & POOL_WORDMASK];
-		w ^= r->pool[(i + POOL_TAP3) & POOL_WORDMASK];
-		w ^= r->pool[(i + POOL_TAP4) & POOL_WORDMASK];
-		w ^= r->pool[(i + POOL_TAP5) & POOL_WORDMASK];
+		w ^= input_pool.pool[i];
+		w ^= input_pool.pool[(i + POOL_TAP1) & POOL_WORDMASK];
+		w ^= input_pool.pool[(i + POOL_TAP2) & POOL_WORDMASK];
+		w ^= input_pool.pool[(i + POOL_TAP3) & POOL_WORDMASK];
+		w ^= input_pool.pool[(i + POOL_TAP4) & POOL_WORDMASK];
+		w ^= input_pool.pool[(i + POOL_TAP5) & POOL_WORDMASK];
 
 		/* Mix the result back in with a twist */
-		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
+		input_pool.pool[i] = (w >> 3) ^ twist_table[w & 7];
 
 		/*
 		 * Normally, we add 7 bits of rotation to the pool.
@@ -582,26 +575,24 @@ static void _mix_pool_bytes(struct entro
 		input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
 	}
 
-	r->input_rotate = input_rotate;
-	r->add_ptr = i;
+	input_pool.input_rotate = input_rotate;
+	input_pool.add_ptr = i;
 }
 
-static void __mix_pool_bytes(struct entropy_store *r, const void *in,
-			     int nbytes)
+static void __mix_pool_bytes(const void *in, int nbytes)
 {
-	trace_mix_pool_bytes_nolock(r->name, nbytes, _RET_IP_);
-	_mix_pool_bytes(r, in, nbytes);
+	trace_mix_pool_bytes_nolock(nbytes, _RET_IP_);
+	_mix_pool_bytes(in, nbytes);
 }
 
-static void mix_pool_bytes(struct entropy_store *r, const void *in,
-			   int nbytes)
+static void mix_pool_bytes(const void *in, int nbytes)
 {
 	unsigned long flags;
 
-	trace_mix_pool_bytes(r->name, nbytes, _RET_IP_);
-	spin_lock_irqsave(&r->lock, flags);
-	_mix_pool_bytes(r, in, nbytes);
-	spin_unlock_irqrestore(&r->lock, flags);
+	trace_mix_pool_bytes(nbytes, _RET_IP_);
+	spin_lock_irqsave(&input_pool.lock, flags);
+	_mix_pool_bytes(in, nbytes);
+	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 
 struct fast_pool {
@@ -663,16 +654,16 @@ static void process_random_ready_list(vo
  * Use credit_entropy_bits_safe() if the value comes from userspace
  * or otherwise should be checked for extreme values.
  */
-static void credit_entropy_bits(struct entropy_store *r, int nbits)
+static void credit_entropy_bits(int nbits)
 {
-	int entropy_count, orig;
+	int entropy_count, entropy_bits, orig;
 	int nfrac = nbits << ENTROPY_SHIFT;
 
 	if (!nbits)
 		return;
 
 retry:
-	entropy_count = orig = READ_ONCE(r->entropy_count);
+	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
 	if (nfrac < 0) {
 		/* Debit */
 		entropy_count += nfrac;
@@ -713,26 +704,21 @@ retry:
 	}
 
 	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("negative entropy/overflow: pool %s count %d\n",
-			r->name, entropy_count);
+		pr_warn("negative entropy/overflow: count %d\n", entropy_count);
 		entropy_count = 0;
 	} else if (entropy_count > POOL_FRACBITS)
 		entropy_count = POOL_FRACBITS;
-	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	trace_credit_entropy_bits(r->name, nbits,
-				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
+	trace_credit_entropy_bits(nbits, entropy_count >> ENTROPY_SHIFT, _RET_IP_);
 
-	if (r == &input_pool) {
-		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
-
-		if (crng_init < 2 && entropy_bits >= 128)
-			crng_reseed(&primary_crng, r);
-	}
+	entropy_bits = entropy_count >> ENTROPY_SHIFT;
+	if (crng_init < 2 && entropy_bits >= 128)
+		crng_reseed(&primary_crng, true);
 }
 
-static int credit_entropy_bits_safe(struct entropy_store *r, int nbits)
+static int credit_entropy_bits_safe(int nbits)
 {
 	if (nbits < 0)
 		return -EINVAL;
@@ -740,7 +726,7 @@ static int credit_entropy_bits_safe(stru
 	/* Cap the value to avoid overflows */
 	nbits = min(nbits,  POOL_BITS);
 
-	credit_entropy_bits(r, nbits);
+	credit_entropy_bits(nbits);
 	return 0;
 }
 
@@ -818,7 +804,7 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	_extract_entropy(&input_pool, &crng->state[4], sizeof(u32) * 12);
+	_extract_entropy(&crng->state[4], sizeof(u32) * 12);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
@@ -979,7 +965,7 @@ static int crng_slow_load(const u8 *cp,
 	return 1;
 }
 
-static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
+static void crng_reseed(struct crng_state *crng, bool use_input_pool)
 {
 	unsigned long	flags;
 	int		i, num;
@@ -988,8 +974,8 @@ static void crng_reseed(struct crng_stat
 		u32	key[8];
 	} buf;
 
-	if (r) {
-		num = extract_entropy(r, &buf, 32, 16);
+	if (use_input_pool) {
+		num = extract_entropy(&buf, 32, 16);
 		if (num == 0)
 			return;
 	} else {
@@ -1020,8 +1006,7 @@ static void _extract_crng(struct crng_st
 		init_time = READ_ONCE(crng->init_time);
 		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
 		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
-			crng_reseed(crng, crng == &primary_crng ?
-				    &input_pool : NULL);
+			crng_reseed(crng, crng == &primary_crng);
 	}
 	spin_lock_irqsave(&crng->lock, flags);
 	chacha20_block(&crng->state[0], out);
@@ -1132,8 +1117,8 @@ void add_device_randomness(const void *b
 
 	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(&input_pool, buf, size);
-	_mix_pool_bytes(&input_pool, &time, sizeof(time));
+	_mix_pool_bytes(buf, size);
+	_mix_pool_bytes(&time, sizeof(time));
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 EXPORT_SYMBOL(add_device_randomness);
@@ -1152,7 +1137,6 @@ static struct timer_rand_state input_tim
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
-	struct entropy_store	*r;
 	struct {
 		long jiffies;
 		unsigned int cycles;
@@ -1163,8 +1147,7 @@ static void add_timer_randomness(struct
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
 	sample.num = num;
-	r = &input_pool;
-	mix_pool_bytes(r, &sample, sizeof(sample));
+	mix_pool_bytes(&sample, sizeof(sample));
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -1196,7 +1179,7 @@ static void add_timer_randomness(struct
 	 * Round down by 1 bit on general principles,
 	 * and limit entropy estimate to 12 bits.
 	 */
-	credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
+	credit_entropy_bits(min_t(int, fls(delta>>1), 11));
 }
 
 void add_input_randomness(unsigned int type, unsigned int code,
@@ -1211,7 +1194,7 @@ void add_input_randomness(unsigned int t
 	last_value = value;
 	add_timer_randomness(&input_timer_state,
 			     (type << 4) ^ code ^ (code >> 4) ^ value);
-	trace_add_input_randomness(ENTROPY_BITS(&input_pool));
+	trace_add_input_randomness(ENTROPY_BITS());
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
@@ -1255,7 +1238,6 @@ static u32 get_reg(struct fast_pool *f,
 
 void add_interrupt_randomness(int irq)
 {
-	struct entropy_store	*r;
 	struct fast_pool	*fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
@@ -1290,18 +1272,17 @@ void add_interrupt_randomness(int irq)
 	    !time_after(now, fast_pool->last + HZ))
 		return;
 
-	r = &input_pool;
-	if (!spin_trylock(&r->lock))
+	if (!spin_trylock(&input_pool.lock))
 		return;
 
 	fast_pool->last = now;
-	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
-	spin_unlock(&r->lock);
+	__mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
+	spin_unlock(&input_pool.lock);
 
 	fast_pool->count = 0;
 
 	/* award one bit for the contents of the fast pool */
-	credit_entropy_bits(r, 1);
+	credit_entropy_bits(1);
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
@@ -1312,7 +1293,7 @@ void add_disk_randomness(struct gendisk
 		return;
 	/* first major is 1, so we get >= 0x200 here */
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-	trace_add_disk_randomness(disk_devt(disk), ENTROPY_BITS(&input_pool));
+	trace_add_disk_randomness(disk_devt(disk), ENTROPY_BITS());
 }
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
@@ -1327,16 +1308,16 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  * This function decides how many bytes to actually take from the
  * given pool, and also debits the entropy count accordingly.
  */
-static size_t account(struct entropy_store *r, size_t nbytes, int min)
+static size_t account(size_t nbytes, int min)
 {
 	int entropy_count, orig, have_bytes;
 	size_t ibytes, nfrac;
 
-	BUG_ON(r->entropy_count > POOL_FRACBITS);
+	BUG_ON(input_pool.entropy_count > POOL_FRACBITS);
 
 	/* Can we pull enough? */
 retry:
-	entropy_count = orig = READ_ONCE(r->entropy_count);
+	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
 	ibytes = nbytes;
 	/* never pull more than available */
 	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
@@ -1348,8 +1329,7 @@ retry:
 		ibytes = 0;
 
 	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("negative entropy count: pool %s count %d\n",
-			r->name, entropy_count);
+		pr_warn("negative entropy count: count %d\n", entropy_count);
 		entropy_count = 0;
 	}
 	nfrac = ibytes << (ENTROPY_SHIFT + 3);
@@ -1358,11 +1338,11 @@ retry:
 	else
 		entropy_count = 0;
 
-	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	trace_debit_entropy(r->name, 8 * ibytes);
-	if (ibytes && ENTROPY_BITS(r) < random_write_wakeup_bits) {
+	trace_debit_entropy(8 * ibytes);
+	if (ibytes && ENTROPY_BITS() < random_write_wakeup_bits) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}
@@ -1375,7 +1355,7 @@ retry:
  *
  * Note: we assume that .poolwords is a multiple of 16 words.
  */
-static void extract_buf(struct entropy_store *r, u8 *out)
+static void extract_buf(u8 *out)
 {
 	struct blake2s_state state __aligned(__alignof__(unsigned long));
 	u8 hash[BLAKE2S_HASH_SIZE];
@@ -1397,8 +1377,8 @@ static void extract_buf(struct entropy_s
 	}
 
 	/* Generate a hash across the pool */
-	spin_lock_irqsave(&r->lock, flags);
-	blake2s_update(&state, (const u8 *)r->pool, POOL_BYTES);
+	spin_lock_irqsave(&input_pool.lock, flags);
+	blake2s_update(&state, (const u8 *)input_pool.pool, POOL_BYTES);
 	blake2s_final(&state, hash); /* final zeros out state */
 
 	/*
@@ -1410,8 +1390,8 @@ static void extract_buf(struct entropy_s
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	__mix_pool_bytes(r, hash, sizeof(hash));
-	spin_unlock_irqrestore(&r->lock, flags);
+	__mix_pool_bytes(hash, sizeof(hash));
+	spin_unlock_irqrestore(&input_pool.lock, flags);
 
 	/* Note that EXTRACT_SIZE is half of hash size here, because above
 	 * we've dumped the full length back into mixer. By reducing the
@@ -1421,14 +1401,13 @@ static void extract_buf(struct entropy_s
 	memzero_explicit(hash, sizeof(hash));
 }
 
-static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes)
+static ssize_t _extract_entropy(void *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i;
 	u8 tmp[EXTRACT_SIZE];
 
 	while (nbytes) {
-		extract_buf(r, tmp);
+		extract_buf(tmp);
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		memcpy(buf, tmp, i);
 		nbytes -= i;
@@ -1449,12 +1428,11 @@ static ssize_t _extract_entropy(struct e
  * The min parameter specifies the minimum amount we can pull before
  * failing to avoid races that defeat catastrophic reseeding.
  */
-static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-				 size_t nbytes, int min)
+static ssize_t extract_entropy(void *buf, size_t nbytes, int min)
 {
-	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	nbytes = account(r, nbytes, min);
-	return _extract_entropy(r, buf, nbytes);
+	trace_extract_entropy(nbytes, ENTROPY_BITS(), _RET_IP_);
+	nbytes = account(nbytes, min);
+	return _extract_entropy(buf, nbytes);
 }
 
 #define warn_unseeded_randomness(previous) \
@@ -1539,7 +1517,7 @@ EXPORT_SYMBOL(get_random_bytes);
  */
 static void entropy_timer(struct timer_list *t)
 {
-	credit_entropy_bits(&input_pool, 1);
+	credit_entropy_bits(1);
 }
 
 /*
@@ -1563,14 +1541,14 @@ static void try_to_generate_entropy(void
 	while (!crng_ready()) {
 		if (!timer_pending(&stack.timer))
 			mod_timer(&stack.timer, jiffies+1);
-		mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+		mix_pool_bytes(&stack.now, sizeof(stack.now));
 		schedule();
 		stack.now = random_get_entropy();
 	}
 
 	del_timer_sync(&stack.timer);
 	destroy_timer_on_stack(&stack.timer);
-	mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+	mix_pool_bytes(&stack.now, sizeof(stack.now));
 }
 
 /*
@@ -1711,26 +1689,24 @@ EXPORT_SYMBOL(get_random_bytes_arch);
 /*
  * init_std_data - initialize pool with system data
  *
- * @r: pool to initialize
- *
  * This function clears the pool's entropy count and mixes some system
  * data into the pool to prepare it for use. The pool is not cleared
  * as that can only decrease the entropy in the pool.
  */
-static void __init init_std_data(struct entropy_store *r)
+static void __init init_std_data(void)
 {
 	int i;
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
 
-	mix_pool_bytes(r, &now, sizeof(now));
+	mix_pool_bytes(&now, sizeof(now));
 	for (i = POOL_BYTES; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv))
 			rv = random_get_entropy();
-		mix_pool_bytes(r, &rv, sizeof(rv));
+		mix_pool_bytes(&rv, sizeof(rv));
 	}
-	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
+	mix_pool_bytes(utsname(), sizeof(*(utsname())));
 }
 
 /*
@@ -1745,7 +1721,7 @@ static void __init init_std_data(struct
  */
 int __init rand_initialize(void)
 {
-	init_std_data(&input_pool);
+	init_std_data();
 	if (crng_need_final_init)
 		crng_finalize_init(&primary_crng);
 	crng_initialize_primary(&primary_crng);
@@ -1782,7 +1758,7 @@ urandom_read_nowarn(struct file *file, c
 
 	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
 	ret = extract_crng_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS(&input_pool));
+	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS());
 	return ret;
 }
 
@@ -1822,13 +1798,13 @@ random_poll(struct file *file, poll_tabl
 	mask = 0;
 	if (crng_ready())
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_bits)
+	if (ENTROPY_BITS() < random_write_wakeup_bits)
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	return mask;
 }
 
 static int
-write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
+write_pool(const char __user *buffer, size_t count)
 {
 	size_t bytes;
 	u32 t, buf[16];
@@ -1850,7 +1826,7 @@ write_pool(struct entropy_store *r, cons
 		count -= bytes;
 		p += bytes;
 
-		mix_pool_bytes(r, buf, bytes);
+		mix_pool_bytes(buf, bytes);
 		cond_resched();
 	}
 
@@ -1862,7 +1838,7 @@ static ssize_t random_write(struct file
 {
 	size_t ret;
 
-	ret = write_pool(&input_pool, buffer, count);
+	ret = write_pool(buffer, count);
 	if (ret)
 		return ret;
 
@@ -1878,7 +1854,7 @@ static long random_ioctl(struct file *f,
 	switch (cmd) {
 	case RNDGETENTCNT:
 		/* inherently racy, no point locking */
-		ent_count = ENTROPY_BITS(&input_pool);
+		ent_count = ENTROPY_BITS();
 		if (put_user(ent_count, p))
 			return -EFAULT;
 		return 0;
@@ -1887,7 +1863,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		return credit_entropy_bits_safe(&input_pool, ent_count);
+		return credit_entropy_bits_safe(ent_count);
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -1897,11 +1873,10 @@ static long random_ioctl(struct file *f,
 			return -EINVAL;
 		if (get_user(size, p++))
 			return -EFAULT;
-		retval = write_pool(&input_pool, (const char __user *)p,
-				    size);
+		retval = write_pool((const char __user *)p, size);
 		if (retval < 0)
 			return retval;
-		return credit_entropy_bits_safe(&input_pool, ent_count);
+		return credit_entropy_bits_safe(ent_count);
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
 		/*
@@ -1920,7 +1895,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng, &input_pool);
+		crng_reseed(&primary_crng, true);
 		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:
@@ -2244,11 +2219,9 @@ randomize_page(unsigned long start, unsi
 void add_hwgenerator_randomness(const char *buffer, size_t count,
 				size_t entropy)
 {
-	struct entropy_store *poolp = &input_pool;
-
 	if (unlikely(crng_init == 0)) {
 		size_t ret = crng_fast_load(buffer, count);
-		mix_pool_bytes(poolp, buffer, ret);
+		mix_pool_bytes(buffer, ret);
 		count -= ret;
 		buffer += ret;
 		if (!count || crng_init == 0)
@@ -2261,9 +2234,9 @@ void add_hwgenerator_randomness(const ch
 	 */
 	wait_event_interruptible(random_write_wait,
 			!system_wq || kthread_should_stop() ||
-			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
-	mix_pool_bytes(poolp, buffer, count);
-	credit_entropy_bits(poolp, entropy);
+			ENTROPY_BITS() <= random_write_wakeup_bits);
+	mix_pool_bytes(buffer, count);
+	credit_entropy_bits(entropy);
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
 
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -28,80 +28,71 @@ TRACE_EVENT(add_device_randomness,
 );
 
 DECLARE_EVENT_CLASS(random__mix_pool_bytes,
-	TP_PROTO(const char *pool_name, int bytes, unsigned long IP),
+	TP_PROTO(int bytes, unsigned long IP),
 
-	TP_ARGS(pool_name, bytes, IP),
+	TP_ARGS(bytes, IP),
 
 	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
 		__field(	  int,	bytes			)
 		__field(unsigned long,	IP			)
 	),
 
 	TP_fast_assign(
-		__entry->pool_name	= pool_name;
 		__entry->bytes		= bytes;
 		__entry->IP		= IP;
 	),
 
-	TP_printk("%s pool: bytes %d caller %pS",
-		  __entry->pool_name, __entry->bytes, (void *)__entry->IP)
+	TP_printk("input pool: bytes %d caller %pS",
+		  __entry->bytes, (void *)__entry->IP)
 );
 
 DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes,
-	TP_PROTO(const char *pool_name, int bytes, unsigned long IP),
+	TP_PROTO(int bytes, unsigned long IP),
 
-	TP_ARGS(pool_name, bytes, IP)
+	TP_ARGS(bytes, IP)
 );
 
 DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes_nolock,
-	TP_PROTO(const char *pool_name, int bytes, unsigned long IP),
+	TP_PROTO(int bytes, unsigned long IP),
 
-	TP_ARGS(pool_name, bytes, IP)
+	TP_ARGS(bytes, IP)
 );
 
 TRACE_EVENT(credit_entropy_bits,
-	TP_PROTO(const char *pool_name, int bits, int entropy_count,
-		 unsigned long IP),
+	TP_PROTO(int bits, int entropy_count, unsigned long IP),
 
-	TP_ARGS(pool_name, bits, entropy_count, IP),
+	TP_ARGS(bits, entropy_count, IP),
 
 	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
 		__field(	  int,	bits			)
 		__field(	  int,	entropy_count		)
 		__field(unsigned long,	IP			)
 	),
 
 	TP_fast_assign(
-		__entry->pool_name	= pool_name;
 		__entry->bits		= bits;
 		__entry->entropy_count	= entropy_count;
 		__entry->IP		= IP;
 	),
 
-	TP_printk("%s pool: bits %d entropy_count %d caller %pS",
-		  __entry->pool_name, __entry->bits,
-		  __entry->entropy_count, (void *)__entry->IP)
+	TP_printk("input pool: bits %d entropy_count %d caller %pS",
+		  __entry->bits, __entry->entropy_count, (void *)__entry->IP)
 );
 
 TRACE_EVENT(debit_entropy,
-	TP_PROTO(const char *pool_name, int debit_bits),
+	TP_PROTO(int debit_bits),
 
-	TP_ARGS(pool_name, debit_bits),
+	TP_ARGS( debit_bits),
 
 	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
 		__field(	  int,	debit_bits		)
 	),
 
 	TP_fast_assign(
-		__entry->pool_name	= pool_name;
 		__entry->debit_bits	= debit_bits;
 	),
 
-	TP_printk("%s: debit_bits %d", __entry->pool_name,
-		  __entry->debit_bits)
+	TP_printk("input pool: debit_bits %d", __entry->debit_bits)
 );
 
 TRACE_EVENT(add_input_randomness,
@@ -170,36 +161,31 @@ DEFINE_EVENT(random__get_random_bytes, g
 );
 
 DECLARE_EVENT_CLASS(random__extract_entropy,
-	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
-		 unsigned long IP),
+	TP_PROTO(int nbytes, int entropy_count, unsigned long IP),
 
-	TP_ARGS(pool_name, nbytes, entropy_count, IP),
+	TP_ARGS(nbytes, entropy_count, IP),
 
 	TP_STRUCT__entry(
-		__field( const char *,	pool_name		)
 		__field(	  int,	nbytes			)
 		__field(	  int,	entropy_count		)
 		__field(unsigned long,	IP			)
 	),
 
 	TP_fast_assign(
-		__entry->pool_name	= pool_name;
 		__entry->nbytes		= nbytes;
 		__entry->entropy_count	= entropy_count;
 		__entry->IP		= IP;
 	),
 
-	TP_printk("%s pool: nbytes %d entropy_count %d caller %pS",
-		  __entry->pool_name, __entry->nbytes, __entry->entropy_count,
-		  (void *)__entry->IP)
+	TP_printk("input pool: nbytes %d entropy_count %d caller %pS",
+		  __entry->nbytes, __entry->entropy_count, (void *)__entry->IP)
 );
 
 
 DEFINE_EVENT(random__extract_entropy, extract_entropy,
-	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
-		 unsigned long IP),
+	TP_PROTO(int nbytes, int entropy_count, unsigned long IP),
 
-	TP_ARGS(pool_name, nbytes, entropy_count, IP)
+	TP_ARGS(nbytes, entropy_count, IP)
 );
 
 TRACE_EVENT(urandom_read,



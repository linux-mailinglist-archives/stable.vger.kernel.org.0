Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470E45360B6
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352230AbiE0Lw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353284AbiE0Lvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:51:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFCE1498DD;
        Fri, 27 May 2022 04:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CA15B824D2;
        Fri, 27 May 2022 11:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC81C385A9;
        Fri, 27 May 2022 11:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652029;
        bh=LIQxmGGWJg49USSO9OKk61ijZPtfrApEmu0KJgP4EKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VivXKucy6AoE2J//35TWE+bbSzmbhpA5R9U2rm0pN9FMkBzCu04XgZc/GwWLxonWn
         28hLeGtB9yiaQsr+0qazskl4Kxty3FoogGLWl1wZZINi6J/dDEf+MdgUAGOyVW6QDs
         ir8ipWyb07b9ksQ8QvsarmSHy8U+6PLmeKDV1uHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 085/163] random: group crng functions
Date:   Fri, 27 May 2022 10:49:25 +0200
Message-Id: <20220527084839.729690752@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

commit 3655adc7089da4f8ca74cec8fcef73ea5101430e upstream.

This pulls all of the crng-focused functions into the second labeled
section.

No functional changes.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  792 +++++++++++++++++++++++++-------------------------
 1 file changed, 410 insertions(+), 382 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -380,122 +380,27 @@ static void _warn_unseeded_randomness(co
 }
 
 
-enum {
-	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
-	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
-};
-
-/*
- * Static global variables
- */
-static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
-
-static int crng_init_cnt = 0;
-
-/**********************************************************************
+/*********************************************************************
  *
- * OS independent entropy store.   Here are the functions which handle
- * storing entropy in an entropy pool.
+ * Fast key erasure RNG, the "crng".
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
-
-static void crng_reseed(void);
-
-/*
- * This function adds bytes into the entropy "pool".  It does not
- * update the entropy estimate.  The caller should call
- * credit_entropy_bits if this is appropriate.
- */
-static void _mix_pool_bytes(const void *in, size_t nbytes)
-{
-	blake2s_update(&input_pool.hash, in, nbytes);
-}
-
-static void mix_pool_bytes(const void *in, size_t nbytes)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(in, nbytes);
-	spin_unlock_irqrestore(&input_pool.lock, flags);
-}
-
-struct fast_pool {
-	union {
-		u32 pool32[4];
-		u64 pool64[2];
-	};
-	unsigned long last;
-	u16 reg_idx;
-	u8 count;
-};
-
-/*
- * This is a fast mixing routine used by the interrupt randomness
- * collector.  It's hardcoded for an 128 bit pool and assumes that any
- * locks that might be needed are taken by the caller.
- */
-static void fast_mix(u32 pool[4])
-{
-	u32 a = pool[0],	b = pool[1];
-	u32 c = pool[2],	d = pool[3];
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
-
-	pool[0] = a;  pool[1] = b;
-	pool[2] = c;  pool[3] = d;
-}
-
-static void credit_entropy_bits(size_t nbits)
-{
-	unsigned int entropy_count, orig, add;
-
-	if (!nbits)
-		return;
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
-}
-
-/*********************************************************************
+ * These functions expand entropy from the entropy extractor into
+ * long streams for external consumption using the "fast key erasure"
+ * RNG described at <https://blog.cr.yp.to/20170723-random.html>.
+ *
+ * There are a few exported interfaces for use by other drivers:
  *
- * CRNG using CHACHA20
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
 
@@ -524,70 +429,14 @@ static DEFINE_PER_CPU(struct crng, crngs
 	.lock = INIT_LOCAL_LOCK(crngs.lock),
 };
 
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
@@ -637,13 +486,11 @@ static void crng_reseed(void)
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
 static void crng_fast_key_erasure(u8 key[CHACHA_KEY_SIZE],
 				  u32 chacha_state[CHACHA_STATE_WORDS],
@@ -730,6 +577,126 @@ static void crng_make_state(u32 chacha_s
 	local_unlock_irqrestore(&crngs.lock, flags);
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
+	u32 chacha_state[CHACHA_STATE_WORDS];
+	u8 tmp[CHACHA_BLOCK_SIZE];
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
+		if (nbytes < CHACHA_BLOCK_SIZE) {
+			chacha20_block(chacha_state, tmp);
+			memcpy(buf, tmp, nbytes);
+			memzero_explicit(tmp, sizeof(tmp));
+			break;
+		}
+
+		chacha20_block(chacha_state, buf);
+		if (unlikely(chacha_state[12] == 0))
+			++chacha_state[13];
+		nbytes -= CHACHA_BLOCK_SIZE;
+		buf += CHACHA_BLOCK_SIZE;
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
@@ -777,6 +744,268 @@ static ssize_t get_random_bytes_user(voi
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
+		 * formula of (integer_blocks + 0.5) * CHACHA_BLOCK_SIZE.
+		 */
+		u64 entropy_u64[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
+		u32 entropy_u32[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
+	};
+	local_lock_t lock;
+	unsigned long generation;
+	unsigned int position;
+};
+
+
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
+	.lock = INIT_LOCAL_LOCK(batched_entropy_u64.lock),
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
+	local_lock_irqsave(&batched_entropy_u64.lock, flags);
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
+	local_unlock_irqrestore(&batched_entropy_u64.lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(get_random_u64);
+
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
+	.lock = INIT_LOCAL_LOCK(batched_entropy_u32.lock),
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
+	local_lock_irqsave(&batched_entropy_u32.lock, flags);
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
+	local_unlock_irqrestore(&batched_entropy_u32.lock, flags);
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
@@ -1045,57 +1274,6 @@ static bool drain_entropy(void *buf, siz
 }
 
 /*
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
-	u32 chacha_state[CHACHA_STATE_WORDS];
-	u8 tmp[CHACHA_BLOCK_SIZE];
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
-		if (nbytes < CHACHA_BLOCK_SIZE) {
-			chacha20_block(chacha_state, tmp);
-			memcpy(buf, tmp, nbytes);
-			memzero_explicit(tmp, sizeof(tmp));
-			break;
-		}
-
-		chacha20_block(chacha_state, buf);
-		if (unlikely(chacha_state[12] == 0))
-			++chacha_state[13];
-		nbytes -= CHACHA_BLOCK_SIZE;
-		buf += CHACHA_BLOCK_SIZE;
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
-/*
  * Each time the timer fires, we expect that we got an unpredictable
  * jump in the cycle counter. Even if the timer is running on another
  * CPU, the timer activity will be touching the stack of the CPU that is
@@ -1144,33 +1322,6 @@ static void try_to_generate_entropy(void
 	mix_pool_bytes(&stack.now, sizeof(stack.now));
 }
 
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
@@ -1523,129 +1674,6 @@ struct ctl_table random_table[] = {
 };
 #endif	/* CONFIG_SYSCTL */
 
-struct batched_entropy {
-	union {
-		/*
-		 * We make this 1.5x a ChaCha block, so that we get the
-		 * remaining 32 bytes from fast key erasure, plus one full
-		 * block from the detached ChaCha state. We can increase
-		 * the size of this later if needed so long as we keep the
-		 * formula of (integer_blocks + 0.5) * CHACHA_BLOCK_SIZE.
-		 */
-		u64 entropy_u64[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
-		u32 entropy_u32[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
-	};
-	local_lock_t lock;
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
-	.lock = INIT_LOCAL_LOCK(batched_entropy_u64.lock),
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
-	local_lock_irqsave(&batched_entropy_u64.lock, flags);
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
-	local_unlock_irqrestore(&batched_entropy_u64.lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u64);
-
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.lock = INIT_LOCAL_LOCK(batched_entropy_u32.lock),
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
-	local_lock_irqsave(&batched_entropy_u32.lock, flags);
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
-	local_unlock_irqrestore(&batched_entropy_u32.lock, flags);
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



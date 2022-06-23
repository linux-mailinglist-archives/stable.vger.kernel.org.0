Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB77558099
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiFWQwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiFWQvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F681B78D;
        Thu, 23 Jun 2022 09:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E6B9B8248F;
        Thu, 23 Jun 2022 16:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBA3C3411B;
        Thu, 23 Jun 2022 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003085;
        bh=sqp3dA/AsC4GCtkTCiInY1DrTaok+qedyNjsh23aKG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCOKCT77y9YgXhVtDbbW6/9G0NUyhn9EeKmphKJYRVN0bPUcwTKs462HQzzKkGCaf
         jMMq8mMIsHGePTRfAqAhWBFdCDyTXkLfT7f8kRFUkopuiWSpt/66LSjMHCBqScC3Nu
         UBjguhli5H0H4YbLNJP01cDckaOPaQoTfeysDmOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 123/264] random: use hash function for crng_slow_load()
Date:   Thu, 23 Jun 2022 18:41:56 +0200
Message-Id: <20220623164347.547026770@linuxfoundation.org>
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

commit 66e4c2b9541503d721e936cc3898c9f25f4591ff upstream.

Since we have a hash function that's really fast, and the goal of
crng_slow_load() is reportedly to "touch all of the crng's state", we
can just hash the old state together with the new state and call it a
day. This way we dont need to reason about another LFSR or worry about
various attacks there. This code is only ever used at early boot and
then never again.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c         |  163 +++++++++++++++++-------------------------
 include/linux/hw_random.h     |    2 
 include/linux/random.h        |   10 +-
 include/trace/events/random.h |   79 +++++++++-----------
 4 files changed, 113 insertions(+), 141 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -69,7 +69,7 @@
  *
  * The primary kernel interfaces are:
  *
- *	void get_random_bytes(void *buf, int nbytes);
+ *	void get_random_bytes(void *buf, size_t nbytes);
  *	u32 get_random_u32()
  *	u64 get_random_u64()
  *	unsigned int get_random_int()
@@ -97,14 +97,14 @@
  * The current exported interfaces for gathering environmental noise
  * from the devices are:
  *
- *	void add_device_randomness(const void *buf, unsigned int size);
+ *	void add_device_randomness(const void *buf, size_t size);
  *	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  *	void add_interrupt_randomness(int irq);
  *	void add_disk_randomness(struct gendisk *disk);
- *	void add_hwgenerator_randomness(const char *buffer, size_t count,
+ *	void add_hwgenerator_randomness(const void *buffer, size_t count,
  *					size_t entropy);
- *	void add_bootloader_randomness(const void *buf, unsigned int size);
+ *	void add_bootloader_randomness(const void *buf, size_t size);
  *
  * add_device_randomness() is for adding data to the random pool that
  * is likely to differ between two devices (or possibly even per boot).
@@ -269,7 +269,7 @@ static int crng_init = 0;
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
 static void process_random_ready_list(void);
-static void _get_random_bytes(void *buf, int nbytes);
+static void _get_random_bytes(void *buf, size_t nbytes);
 
 static struct ratelimit_state unseeded_warning =
 	RATELIMIT_STATE_INIT("warn_unseeded_randomness", HZ, 3);
@@ -291,7 +291,7 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
 static struct {
 	struct blake2s_state hash;
 	spinlock_t lock;
-	int entropy_count;
+	unsigned int entropy_count;
 } input_pool = {
 	.hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
 		    BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
@@ -309,18 +309,12 @@ static void crng_reseed(void);
  * update the entropy estimate.  The caller should call
  * credit_entropy_bits if this is appropriate.
  */
-static void _mix_pool_bytes(const void *in, int nbytes)
+static void _mix_pool_bytes(const void *in, size_t nbytes)
 {
 	blake2s_update(&input_pool.hash, in, nbytes);
 }
 
-static void __mix_pool_bytes(const void *in, int nbytes)
-{
-	trace_mix_pool_bytes_nolock(nbytes, _RET_IP_);
-	_mix_pool_bytes(in, nbytes);
-}
-
-static void mix_pool_bytes(const void *in, int nbytes)
+static void mix_pool_bytes(const void *in, size_t nbytes)
 {
 	unsigned long flags;
 
@@ -384,18 +378,18 @@ static void process_random_ready_list(vo
 	spin_unlock_irqrestore(&random_ready_list_lock, flags);
 }
 
-static void credit_entropy_bits(int nbits)
+static void credit_entropy_bits(size_t nbits)
 {
-	int entropy_count, orig;
+	unsigned int entropy_count, orig, add;
 
-	if (nbits <= 0)
+	if (!nbits)
 		return;
 
-	nbits = min(nbits, POOL_BITS);
+	add = min_t(size_t, nbits, POOL_BITS);
 
 	do {
 		orig = READ_ONCE(input_pool.entropy_count);
-		entropy_count = min(POOL_BITS, orig + nbits);
+		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
 	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
 
 	trace_credit_entropy_bits(nbits, entropy_count, _RET_IP_);
@@ -442,10 +436,10 @@ static void invalidate_batched_entropy(v
  * path.  So we can't afford to dilly-dally. Returns the number of
  * bytes processed from cp.
  */
-static size_t crng_fast_load(const u8 *cp, size_t len)
+static size_t crng_fast_load(const void *cp, size_t len)
 {
 	unsigned long flags;
-	u8 *p;
+	const u8 *src = (const u8 *)cp;
 	size_t ret = 0;
 
 	if (!spin_trylock_irqsave(&base_crng.lock, flags))
@@ -454,10 +448,9 @@ static size_t crng_fast_load(const u8 *c
 		spin_unlock_irqrestore(&base_crng.lock, flags);
 		return 0;
 	}
-	p = base_crng.key;
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
-		p[crng_init_cnt % sizeof(base_crng.key)] ^= *cp;
-		cp++; crng_init_cnt++; len--; ret++;
+		base_crng.key[crng_init_cnt % sizeof(base_crng.key)] ^= *src;
+		src++; crng_init_cnt++; len--; ret++;
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		invalidate_batched_entropy();
@@ -527,42 +520,30 @@ static struct crng_state *select_crng(vo
  * all), and (2) it doesn't have the performance constraints of
  * crng_fast_load().
  *
- * So we do something more comprehensive which is guaranteed to touch
- * all of the primary_crng's state, and which uses a LFSR with a
- * period of 255 as part of the mixing algorithm.  Finally, we do
- * *not* advance crng_init_cnt since buffer we may get may be something
- * like a fixed DMI table (for example), which might very well be
- * unique to the machine, but is otherwise unvarying.
+ * So, we simply hash the contents in with the current key. Finally,
+ * we do *not* advance crng_init_cnt since buffer we may get may be
+ * something like a fixed DMI table (for example), which might very
+ * well be unique to the machine, but is otherwise unvarying.
  */
-static int crng_slow_load(const u8 *cp, size_t len)
+static void crng_slow_load(const void *cp, size_t len)
 {
 	unsigned long flags;
-	static u8 lfsr = 1;
-	u8 tmp;
-	unsigned int i, max = sizeof(base_crng.key);
-	const u8 *src_buf = cp;
-	u8 *dest_buf = base_crng.key;
+	struct blake2s_state hash;
+
+	blake2s_init(&hash, sizeof(base_crng.key));
 
 	if (!spin_trylock_irqsave(&base_crng.lock, flags))
-		return 0;
+		return;
 	if (crng_init != 0) {
 		spin_unlock_irqrestore(&base_crng.lock, flags);
-		return 0;
+		return;
 	}
-	if (len > max)
-		max = len;
 
-	for (i = 0; i < max; i++) {
-		tmp = lfsr;
-		lfsr >>= 1;
-		if (tmp & 1)
-			lfsr ^= 0xE1;
-		tmp = dest_buf[i % sizeof(base_crng.key)];
-		dest_buf[i % sizeof(base_crng.key)] ^= src_buf[i % len] ^ lfsr;
-		lfsr += (tmp << 3) | (tmp >> 5);
-	}
+	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
+	blake2s_update(&hash, cp, len);
+	blake2s_final(&hash, base_crng.key);
+
 	spin_unlock_irqrestore(&base_crng.lock, flags);
-	return 1;
 }
 
 static void crng_reseed(void)
@@ -718,14 +699,15 @@ static void crng_make_state(u32 chacha_s
 static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
 {
 	bool large_request = nbytes > 256;
-	ssize_t ret = 0, len;
+	ssize_t ret = 0;
+	size_t len;
 	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	u8 output[CHACHA20_BLOCK_SIZE];
 
 	if (!nbytes)
 		return 0;
 
-	len = min_t(ssize_t, 32, nbytes);
+	len = min_t(size_t, 32, nbytes);
 	crng_make_state(chacha_state, output, len);
 
 	if (copy_to_user(buf, output, len))
@@ -745,7 +727,7 @@ static ssize_t get_random_bytes_user(voi
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
 
-		len = min_t(ssize_t, nbytes, CHACHA20_BLOCK_SIZE);
+		len = min_t(size_t, nbytes, CHACHA20_BLOCK_SIZE);
 		if (copy_to_user(buf, output, len)) {
 			ret = -EFAULT;
 			break;
@@ -783,7 +765,7 @@ struct timer_rand_state {
  * the entropy pool having similar initial state across largely
  * identical devices.
  */
-void add_device_randomness(const void *buf, unsigned int size)
+void add_device_randomness(const void *buf, size_t size)
 {
 	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
@@ -811,7 +793,7 @@ static struct timer_rand_state input_tim
  * keyboard scan codes, and 256 upwards for interrupts.
  *
  */
-static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
+static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
 {
 	struct {
 		long jiffies;
@@ -855,7 +837,7 @@ static void add_timer_randomness(struct
 	 * Round down by 1 bit on general principles,
 	 * and limit entropy estimate to 12 bits.
 	 */
-	credit_entropy_bits(min_t(int, fls(delta >> 1), 11));
+	credit_entropy_bits(min_t(unsigned int, fls(delta >> 1), 11));
 }
 
 void add_input_randomness(unsigned int type, unsigned int code,
@@ -936,8 +918,8 @@ void add_interrupt_randomness(int irq)
 	add_interrupt_bench(cycles);
 
 	if (unlikely(crng_init == 0)) {
-		if ((fast_pool->count >= 64) &&
-		    crng_fast_load((u8 *)fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
+		if (fast_pool->count >= 64 &&
+		    crng_fast_load(fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
 			if (spin_trylock(&input_pool.lock)) {
@@ -955,7 +937,7 @@ void add_interrupt_randomness(int irq)
 		return;
 
 	fast_pool->last = now;
-	__mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
+	_mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
 	spin_unlock(&input_pool.lock);
 
 	fast_pool->count = 0;
@@ -1064,18 +1046,18 @@ static void _warn_unseeded_randomness(co
  * wait_for_random_bytes() should be called and return 0 at least once
  * at any point prior.
  */
-static void _get_random_bytes(void *buf, int nbytes)
+static void _get_random_bytes(void *buf, size_t nbytes)
 {
 	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	u8 tmp[CHACHA20_BLOCK_SIZE];
-	ssize_t len;
+	size_t len;
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
 	if (!nbytes)
 		return;
 
-	len = min_t(ssize_t, 32, nbytes);
+	len = min_t(size_t, 32, nbytes);
 	crng_make_state(chacha_state, buf, len);
 	nbytes -= len;
 	buf += len;
@@ -1098,7 +1080,7 @@ static void _get_random_bytes(void *buf,
 	memzero_explicit(chacha_state, sizeof(chacha_state));
 }
 
-void get_random_bytes(void *buf, int nbytes)
+void get_random_bytes(void *buf, size_t nbytes)
 {
 	static void *previous;
 
@@ -1259,25 +1241,19 @@ EXPORT_SYMBOL(del_random_ready_callback)
 
 /*
  * This function will use the architecture-specific hardware random
- * number generator if it is available.  The arch-specific hw RNG will
- * almost certainly be faster than what we can do in software, but it
- * is impossible to verify that it is implemented securely (as
- * opposed, to, say, the AES encryption of a sequence number using a
- * key known by the NSA).  So it's useful if we need the speed, but
- * only if we're willing to trust the hardware manufacturer not to
- * have put in a back door.
- *
- * Return number of bytes filled in.
+ * number generator if it is available. It is not recommended for
+ * use. Use get_random_bytes() instead. It returns the number of
+ * bytes filled in.
  */
-int __must_check get_random_bytes_arch(void *buf, int nbytes)
+size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes)
 {
-	int left = nbytes;
+	size_t left = nbytes;
 	u8 *p = buf;
 
 	trace_get_random_bytes_arch(left, _RET_IP_);
 	while (left) {
 		unsigned long v;
-		int chunk = min_t(int, left, sizeof(unsigned long));
+		size_t chunk = min_t(size_t, left, sizeof(unsigned long));
 
 		if (!arch_get_random_long(&v))
 			break;
@@ -1310,12 +1286,12 @@ early_param("random.trust_cpu", parse_tr
  */
 int __init rand_initialize(void)
 {
-	int i;
+	size_t i;
 	ktime_t now = ktime_get_real();
 	bool arch_init = true;
 	unsigned long rv;
 
-	for (i = BLAKE2S_BLOCK_SIZE; i > 0; i -= sizeof(rv)) {
+	for (i = 0; i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
 		if (!arch_get_random_seed_long_early(&rv) &&
 		    !arch_get_random_long_early(&rv)) {
 			rv = random_get_entropy();
@@ -1364,7 +1340,7 @@ static ssize_t urandom_read_nowarn(struc
 
 	nbytes = min_t(size_t, nbytes, INT_MAX >> 6);
 	ret = get_random_bytes_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, input_pool.entropy_count);
+	trace_urandom_read(nbytes, input_pool.entropy_count);
 	return ret;
 }
 
@@ -1408,19 +1384,18 @@ static unsigned int random_poll(struct f
 	return mask;
 }
 
-static int write_pool(const char __user *buffer, size_t count)
+static int write_pool(const char __user *ubuf, size_t count)
 {
-	size_t bytes;
-	u8 buf[BLAKE2S_BLOCK_SIZE];
-	const char __user *p = buffer;
-
-	while (count > 0) {
-		bytes = min(count, sizeof(buf));
-		if (copy_from_user(buf, p, bytes))
+	size_t len;
+	u8 block[BLAKE2S_BLOCK_SIZE];
+
+	while (count) {
+		len = min(count, sizeof(block));
+		if (copy_from_user(block, ubuf, len))
 			return -EFAULT;
-		count -= bytes;
-		p += bytes;
-		mix_pool_bytes(buf, bytes);
+		count -= len;
+		ubuf += len;
+		mix_pool_bytes(block, len);
 		cond_resched();
 	}
 
@@ -1430,7 +1405,7 @@ static int write_pool(const char __user
 static ssize_t random_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *ppos)
 {
-	size_t ret;
+	int ret;
 
 	ret = write_pool(buffer, count);
 	if (ret)
@@ -1524,8 +1499,6 @@ const struct file_operations urandom_fop
 SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count, unsigned int,
 		flags)
 {
-	int ret;
-
 	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
 		return -EINVAL;
 
@@ -1540,6 +1513,8 @@ SYSCALL_DEFINE3(getrandom, char __user *
 		count = INT_MAX;
 
 	if (!(flags & GRND_INSECURE) && !crng_ready()) {
+		int ret;
+
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
 		ret = wait_for_random_bytes();
@@ -1798,7 +1773,7 @@ unsigned long randomize_page(unsigned lo
  * Those devices may produce endless random bits and will be throttled
  * when our pool is full.
  */
-void add_hwgenerator_randomness(const char *buffer, size_t count,
+void add_hwgenerator_randomness(const void *buffer, size_t count,
 				size_t entropy)
 {
 	if (unlikely(crng_init == 0)) {
@@ -1829,7 +1804,7 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_random
  * it would be regarded as device data.
  * The decision is controlled by CONFIG_RANDOM_TRUST_BOOTLOADER.
  */
-void add_bootloader_randomness(const void *buf, unsigned int size)
+void add_bootloader_randomness(const void *buf, size_t size)
 {
 	if (IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER))
 		add_hwgenerator_randomness(buf, size, size * 8);
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -61,6 +61,6 @@ extern int devm_hwrng_register(struct de
 extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
 /** Feed random bits into the pool. */
-extern void add_hwgenerator_randomness(const char *buffer, size_t count, size_t entropy);
+extern void add_hwgenerator_randomness(const void *buffer, size_t count, size_t entropy);
 
 #endif /* LINUX_HWRANDOM_H_ */
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,8 +19,8 @@ struct random_ready_callback {
 	struct module *owner;
 };
 
-extern void add_device_randomness(const void *, unsigned int);
-extern void add_bootloader_randomness(const void *, unsigned int);
+extern void add_device_randomness(const void *, size_t);
+extern void add_bootloader_randomness(const void *, size_t);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
@@ -36,13 +36,13 @@ extern void add_input_randomness(unsigne
 				 unsigned int value) __latent_entropy;
 extern void add_interrupt_randomness(int irq) __latent_entropy;
 
-extern void get_random_bytes(void *buf, int nbytes);
+extern void get_random_bytes(void *buf, size_t nbytes);
 extern int wait_for_random_bytes(void);
 extern int __init rand_initialize(void);
 extern bool rng_is_initialized(void);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
-extern int __must_check get_random_bytes_arch(void *buf, int nbytes);
+extern size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
@@ -65,7 +65,7 @@ static inline unsigned long get_random_l
 
 /* Calls wait_for_random_bytes() and then calls get_random_bytes(buf, nbytes).
  * Returns the result of the call to wait_for_random_bytes. */
-static inline int get_random_bytes_wait(void *buf, int nbytes)
+static inline int get_random_bytes_wait(void *buf, size_t nbytes)
 {
 	int ret = wait_for_random_bytes();
 	get_random_bytes(buf, nbytes);
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -8,13 +8,13 @@
 #include <linux/tracepoint.h>
 
 TRACE_EVENT(add_device_randomness,
-	TP_PROTO(int bytes, unsigned long IP),
+	TP_PROTO(size_t bytes, unsigned long IP),
 
 	TP_ARGS(bytes, IP),
 
 	TP_STRUCT__entry(
-		__field(	  int,	bytes			)
-		__field(unsigned long,	IP			)
+		__field(size_t,		bytes	)
+		__field(unsigned long,	IP	)
 	),
 
 	TP_fast_assign(
@@ -22,18 +22,18 @@ TRACE_EVENT(add_device_randomness,
 		__entry->IP		= IP;
 	),
 
-	TP_printk("bytes %d caller %pS",
+	TP_printk("bytes %zu caller %pS",
 		__entry->bytes, (void *)__entry->IP)
 );
 
 DECLARE_EVENT_CLASS(random__mix_pool_bytes,
-	TP_PROTO(int bytes, unsigned long IP),
+	TP_PROTO(size_t bytes, unsigned long IP),
 
 	TP_ARGS(bytes, IP),
 
 	TP_STRUCT__entry(
-		__field(	  int,	bytes			)
-		__field(unsigned long,	IP			)
+		__field(size_t,		bytes	)
+		__field(unsigned long,	IP	)
 	),
 
 	TP_fast_assign(
@@ -41,12 +41,12 @@ DECLARE_EVENT_CLASS(random__mix_pool_byt
 		__entry->IP		= IP;
 	),
 
-	TP_printk("input pool: bytes %d caller %pS",
+	TP_printk("input pool: bytes %zu caller %pS",
 		  __entry->bytes, (void *)__entry->IP)
 );
 
 DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes,
-	TP_PROTO(int bytes, unsigned long IP),
+	TP_PROTO(size_t bytes, unsigned long IP),
 
 	TP_ARGS(bytes, IP)
 );
@@ -58,13 +58,13 @@ DEFINE_EVENT(random__mix_pool_bytes, mix
 );
 
 TRACE_EVENT(credit_entropy_bits,
-	TP_PROTO(int bits, int entropy_count, unsigned long IP),
+	TP_PROTO(size_t bits, size_t entropy_count, unsigned long IP),
 
 	TP_ARGS(bits, entropy_count, IP),
 
 	TP_STRUCT__entry(
-		__field(	  int,	bits			)
-		__field(	  int,	entropy_count		)
+		__field(size_t,		bits			)
+		__field(size_t,		entropy_count		)
 		__field(unsigned long,	IP			)
 	),
 
@@ -74,34 +74,34 @@ TRACE_EVENT(credit_entropy_bits,
 		__entry->IP		= IP;
 	),
 
-	TP_printk("input pool: bits %d entropy_count %d caller %pS",
+	TP_printk("input pool: bits %zu entropy_count %zu caller %pS",
 		  __entry->bits, __entry->entropy_count, (void *)__entry->IP)
 );
 
 TRACE_EVENT(add_input_randomness,
-	TP_PROTO(int input_bits),
+	TP_PROTO(size_t input_bits),
 
 	TP_ARGS(input_bits),
 
 	TP_STRUCT__entry(
-		__field(	  int,	input_bits		)
+		__field(size_t,	input_bits		)
 	),
 
 	TP_fast_assign(
 		__entry->input_bits	= input_bits;
 	),
 
-	TP_printk("input_pool_bits %d", __entry->input_bits)
+	TP_printk("input_pool_bits %zu", __entry->input_bits)
 );
 
 TRACE_EVENT(add_disk_randomness,
-	TP_PROTO(dev_t dev, int input_bits),
+	TP_PROTO(dev_t dev, size_t input_bits),
 
 	TP_ARGS(dev, input_bits),
 
 	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	  int,	input_bits		)
+		__field(dev_t,		dev			)
+		__field(size_t,		input_bits		)
 	),
 
 	TP_fast_assign(
@@ -109,17 +109,17 @@ TRACE_EVENT(add_disk_randomness,
 		__entry->input_bits	= input_bits;
 	),
 
-	TP_printk("dev %d,%d input_pool_bits %d", MAJOR(__entry->dev),
+	TP_printk("dev %d,%d input_pool_bits %zu", MAJOR(__entry->dev),
 		  MINOR(__entry->dev), __entry->input_bits)
 );
 
 DECLARE_EVENT_CLASS(random__get_random_bytes,
-	TP_PROTO(int nbytes, unsigned long IP),
+	TP_PROTO(size_t nbytes, unsigned long IP),
 
 	TP_ARGS(nbytes, IP),
 
 	TP_STRUCT__entry(
-		__field(	  int,	nbytes			)
+		__field(size_t,		nbytes			)
 		__field(unsigned long,	IP			)
 	),
 
@@ -128,29 +128,29 @@ DECLARE_EVENT_CLASS(random__get_random_b
 		__entry->IP		= IP;
 	),
 
-	TP_printk("nbytes %d caller %pS", __entry->nbytes, (void *)__entry->IP)
+	TP_printk("nbytes %zu caller %pS", __entry->nbytes, (void *)__entry->IP)
 );
 
 DEFINE_EVENT(random__get_random_bytes, get_random_bytes,
-	TP_PROTO(int nbytes, unsigned long IP),
+	TP_PROTO(size_t nbytes, unsigned long IP),
 
 	TP_ARGS(nbytes, IP)
 );
 
 DEFINE_EVENT(random__get_random_bytes, get_random_bytes_arch,
-	TP_PROTO(int nbytes, unsigned long IP),
+	TP_PROTO(size_t nbytes, unsigned long IP),
 
 	TP_ARGS(nbytes, IP)
 );
 
 DECLARE_EVENT_CLASS(random__extract_entropy,
-	TP_PROTO(int nbytes, int entropy_count),
+	TP_PROTO(size_t nbytes, size_t entropy_count),
 
 	TP_ARGS(nbytes, entropy_count),
 
 	TP_STRUCT__entry(
-		__field(	  int,	nbytes			)
-		__field(	  int,	entropy_count		)
+		__field(  size_t,	nbytes			)
+		__field(  size_t,	entropy_count		)
 	),
 
 	TP_fast_assign(
@@ -158,37 +158,34 @@ DECLARE_EVENT_CLASS(random__extract_entr
 		__entry->entropy_count	= entropy_count;
 	),
 
-	TP_printk("input pool: nbytes %d entropy_count %d",
+	TP_printk("input pool: nbytes %zu entropy_count %zu",
 		  __entry->nbytes, __entry->entropy_count)
 );
 
 
 DEFINE_EVENT(random__extract_entropy, extract_entropy,
-	TP_PROTO(int nbytes, int entropy_count),
+	TP_PROTO(size_t nbytes, size_t entropy_count),
 
 	TP_ARGS(nbytes, entropy_count)
 );
 
 TRACE_EVENT(urandom_read,
-	TP_PROTO(int got_bits, int pool_left, int input_left),
+	TP_PROTO(size_t nbytes, size_t entropy_count),
 
-	TP_ARGS(got_bits, pool_left, input_left),
+	TP_ARGS(nbytes, entropy_count),
 
 	TP_STRUCT__entry(
-		__field(	  int,	got_bits		)
-		__field(	  int,	pool_left		)
-		__field(	  int,	input_left		)
+		__field( size_t,	nbytes		)
+		__field( size_t,	entropy_count	)
 	),
 
 	TP_fast_assign(
-		__entry->got_bits	= got_bits;
-		__entry->pool_left	= pool_left;
-		__entry->input_left	= input_left;
+		__entry->nbytes		= nbytes;
+		__entry->entropy_count	= entropy_count;
 	),
 
-	TP_printk("got_bits %d nonblocking_pool_entropy_left %d "
-		  "input_entropy_left %d", __entry->got_bits,
-		  __entry->pool_left, __entry->input_left)
+	TP_printk("reading: nbytes %zu entropy_count %zu",
+		  __entry->nbytes, __entry->entropy_count)
 );
 
 #endif /* _TRACE_RANDOM_H */



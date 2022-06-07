Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE18536080
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346340AbiE0LwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352843AbiE0Lu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFBA132A06;
        Fri, 27 May 2022 04:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 350E1B82466;
        Fri, 27 May 2022 11:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BF0C385A9;
        Fri, 27 May 2022 11:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651957;
        bh=a6Y2bpEkfDxLds1A4gOwdxVWR0dE9BrA1SPfLSictwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tgx52oM05YL2gxqtarQLRk62tcvJ+HahzXSXPcILQfpDMkTVHz4+sEHKprOJQZ4Oc
         onsH8SQwCZd3GfNM6DtjJDDhgb+1hKAhtazB/UrabUbNjyj2Fmgoi6RfS/s+S9UePS
         vsDKi8qi5i2WM3HTxmZG1wCrw4NnyscpEA/qZbYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jann Horn <jannh@google.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 052/145] random: use simpler fast key erasure flow on per-cpu keys
Date:   Fri, 27 May 2022 10:49:13 +0200
Message-Id: <20220527084857.078608181@linuxfoundation.org>
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

commit 186873c549df11b63e17062f863654e1501e1524 upstream.

Rather than the clunky NUMA full ChaCha state system we had prior, this
commit is closer to the original "fast key erasure RNG" proposal from
<https://blog.cr.yp.to/20170723-random.html>, by simply treating ChaCha
keys on a per-cpu basis.

All entropy is extracted to a base crng key of 32 bytes. This base crng
has a birthdate and a generation counter. When we go to take bytes from
the crng, we first check if the birthdate is too old; if it is, we
reseed per usual. Then we start working on a per-cpu crng.

This per-cpu crng makes sure that it has the same generation counter as
the base crng. If it doesn't, it does fast key erasure with the base
crng key and uses the output as its new per-cpu key, and then updates
its local generation counter. Then, using this per-cpu state, we do
ordinary fast key erasure. Half of this first block is used to overwrite
the per-cpu crng key for the next call -- this is the fast key erasure
RNG idea -- and the other half, along with the ChaCha state, is returned
to the caller. If the caller desires more than this remaining half, it
can generate more ChaCha blocks, unlocked, using the now detached ChaCha
state that was just returned. Crypto-wise, this is more or less what we
were doing before, but this simply makes it more explicit and ensures
that we always have backtrack protection by not playing games with a
shared block counter.

The flow looks like this:

──extract()──► base_crng.key ◄──memcpy()───┐
                   │                       │
                   └──chacha()──────┬─► new_base_key
                                    └─► crngs[n].key ◄──memcpy()───┐
                                              │                    │
                                              └──chacha()───┬─► new_key
                                                            └─► random_bytes
                                                                      │
                                                                      └────►

There are a few hairy details around early init. Just as was done
before, prior to having gathered enough entropy, crng_fast_load() and
crng_slow_load() dump bytes directly into the base crng, and when we go
to take bytes from the crng, in that case, we're doing fast key erasure
with the base crng rather than the fast unlocked per-cpu crngs. This is
fine as that's only the state of affairs during very early boot; once
the crng initializes we never use these paths again.

In the process of all this, the APIs into the crng become a bit simpler:
we have get_random_bytes(buf, len) and get_random_bytes_user(buf, len),
which both do what you'd expect. All of the details of fast key erasure
and per-cpu selection happen only in a very short critical section of
crng_make_state(), which selects the right per-cpu key, does the fast
key erasure, and returns a local state to the caller's stack. So, we no
longer have a need for a separate backtrack function, as this happens
all at once here. The API then allows us to extend backtrack protection
to batched entropy without really having to do much at all.

The result is a bit simpler than before and has fewer foot guns. The
init time state machine also gets a lot simpler as we don't need to wait
for workqueues to come online and do deferred work. And the multi-core
performance should be increased significantly, by virtue of having hardly
any locking on the fast path.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  403 ++++++++++++++++++++++++++++----------------------
 1 file changed, 233 insertions(+), 170 deletions(-)

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
-#define CRNG_INIT_CNT_THRESH (2 * CHACHA_KEY_SIZE)
-static void extract_crng(u8 out[CHACHA_BLOCK_SIZE]);
-static void crng_backtrack_protect(u8 tmp[CHACHA_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -470,7 +409,30 @@ static void credit_entropy_bits(int nbit
  *
  *********************************************************************/
 
-#define CRNG_RESEED_INTERVAL (300 * HZ)
+enum {
+	CRNG_RESEED_INTERVAL = 300 * HZ,
+	CRNG_INIT_CNT_THRESH = 2 * CHACHA_KEY_SIZE
+};
+
+static struct {
+	u8 key[CHACHA_KEY_SIZE] __aligned(__alignof__(long));
+	unsigned long birth;
+	unsigned long generation;
+	spinlock_t lock;
+} base_crng = {
+	.lock = __SPIN_LOCK_UNLOCKED(base_crng.lock)
+};
+
+struct crng {
+	u8 key[CHACHA_KEY_SIZE];
+	unsigned long generation;
+	local_lock_t lock;
+};
+
+static DEFINE_PER_CPU(struct crng, crngs) = {
+	.generation = ULONG_MAX,
+	.lock = INIT_LOCAL_LOCK(crngs.lock),
+};
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
@@ -487,22 +449,22 @@ static size_t crng_fast_load(const u8 *c
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
-		p[crng_init_cnt % CHACHA_KEY_SIZE] ^= *cp;
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
@@ -527,14 +489,14 @@ static int crng_slow_load(const u8 *cp,
 	unsigned long flags;
 	static u8 lfsr = 1;
 	u8 tmp;
-	unsigned int i, max = CHACHA_KEY_SIZE;
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
@@ -545,38 +507,50 @@ static int crng_slow_load(const u8 *cp,
 		lfsr >>= 1;
 		if (tmp & 1)
 			lfsr ^= 0xE1;
-		tmp = dest_buf[i % CHACHA_KEY_SIZE];
-		dest_buf[i % CHACHA_KEY_SIZE] ^= src_buf[i % len] ^ lfsr;
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
-		u8 block[CHACHA_BLOCK_SIZE];
-		u32 key[8];
-	} buf;
+	int entropy_count;
+	unsigned long next_gen;
+	u8 key[CHACHA_KEY_SIZE];
 
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
@@ -597,77 +571,143 @@ static void crng_reseed(void)
 	}
 }
 
-static void extract_crng(u8 out[CHACHA_BLOCK_SIZE])
+/*
+ * The general form here is based on a "fast key erasure RNG" from
+ * <https://blog.cr.yp.to/20170723-random.html>. It generates a ChaCha
+ * block using the provided key, and then immediately overwites that
+ * key with half the block. It returns the resultant ChaCha state to the
+ * user, along with the second half of the block containing 32 bytes of
+ * random data that may be used; random_data_len may not be greater than
+ * 32.
+ */
+static void crng_fast_key_erasure(u8 key[CHACHA_KEY_SIZE],
+				  u32 chacha_state[CHACHA_STATE_WORDS],
+				  u8 *random_data, size_t random_data_len)
 {
-	unsigned long flags, init_time;
+	u8 first_block[CHACHA_BLOCK_SIZE];
 
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
+	memcpy(&chacha_state[4], key, CHACHA_KEY_SIZE);
+	memset(&chacha_state[12], 0, sizeof(u32) * 4);
+	chacha20_block(chacha_state, first_block);
+
+	memcpy(key, first_block, CHACHA_KEY_SIZE);
+	memcpy(random_data, first_block + CHACHA_KEY_SIZE, random_data_len);
+	memzero_explicit(first_block, sizeof(first_block));
 }
 
 /*
- * Use the leftover bytes from the CRNG block output (if there is
- * enough) to mutate the CRNG key to provide backtracking protection.
+ * This function returns a ChaCha state that you may use for generating
+ * random data. It also returns up to 32 bytes on its own of random data
+ * that may be used; random_data_len may not be greater than 32.
  */
-static void crng_backtrack_protect(u8 tmp[CHACHA_BLOCK_SIZE], int used)
+static void crng_make_state(u32 chacha_state[CHACHA_STATE_WORDS],
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
+	local_lock_irqsave(&crngs.lock, flags);
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
+	local_unlock_irqrestore(&crngs.lock, flags);
+}
+
+static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
+{
+	bool large_request = nbytes > 256;
+	ssize_t ret = 0, len;
+	u32 chacha_state[CHACHA_STATE_WORDS];
+	u8 output[CHACHA_BLOCK_SIZE];
+
+	if (!nbytes)
+		return 0;
 
-	used = round_up(used, sizeof(u32));
-	if (used + CHACHA_KEY_SIZE > CHACHA_BLOCK_SIZE) {
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
-	ssize_t ret = 0, i = CHACHA_BLOCK_SIZE;
-	u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
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
-		i = min_t(int, nbytes, CHACHA_BLOCK_SIZE);
-		if (copy_to_user(buf, tmp, i)) {
+		chacha20_block(chacha_state, output);
+		if (unlikely(chacha_state[12] == 0))
+			++chacha_state[13];
+
+		len = min_t(ssize_t, nbytes, CHACHA_BLOCK_SIZE);
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
 
@@ -976,23 +1016,36 @@ static void _warn_unseeded_randomness(co
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
+	u32 chacha_state[CHACHA_STATE_WORDS];
+	u8 tmp[CHACHA_BLOCK_SIZE];
+	ssize_t len;
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
-	while (nbytes >= CHACHA_BLOCK_SIZE) {
-		extract_crng(buf);
-		buf += CHACHA_BLOCK_SIZE;
+	if (!nbytes)
+		return;
+
+	len = min_t(ssize_t, 32, nbytes);
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
 		nbytes -= CHACHA_BLOCK_SIZE;
+		buf += CHACHA_BLOCK_SIZE;
 	}
 
-	if (nbytes > 0) {
-		extract_crng(tmp);
-		memcpy(buf, tmp, nbytes);
-		crng_backtrack_protect(tmp, nbytes);
-	} else
-		crng_backtrack_protect(tmp, CHACHA_BLOCK_SIZE);
-	memzero_explicit(tmp, sizeof(tmp));
+	memzero_explicit(chacha_state, sizeof(chacha_state));
 }
 
 void get_random_bytes(void *buf, int nbytes)
@@ -1223,13 +1276,12 @@ int __init rand_initialize(void)
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
@@ -1261,7 +1313,7 @@ static ssize_t urandom_read_nowarn(struc
 	int ret;
 
 	nbytes = min_t(size_t, nbytes, INT_MAX >> 6);
-	ret = extract_crng_user(buf, nbytes);
+	ret = get_random_bytes_user(buf, nbytes);
 	trace_urandom_read(8 * nbytes, 0, input_pool.entropy_count);
 	return ret;
 }
@@ -1567,8 +1619,15 @@ static atomic_t batch_generation = ATOMI
 
 struct batched_entropy {
 	union {
-		u64 entropy_u64[CHACHA_BLOCK_SIZE / sizeof(u64)];
-		u32 entropy_u32[CHACHA_BLOCK_SIZE / sizeof(u32)];
+		/*
+		 * We make this 1.5x a ChaCha block, so that we get the
+		 * remaining 32 bytes from fast key erasure, plus one full
+		 * block from the detached ChaCha state. We can increase
+		 * the size of this later if needed so long as we keep the
+		 * formula of (integer_blocks + 0.5) * CHACHA_BLOCK_SIZE.
+		 */
+		u64 entropy_u64[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
+		u32 entropy_u32[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
 	};
 	local_lock_t lock;
 	unsigned int position;
@@ -1577,14 +1636,13 @@ struct batched_entropy {
 
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
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.lock = INIT_LOCAL_LOCK(batched_entropy_u64.lock)
+	.lock = INIT_LOCAL_LOCK(batched_entropy_u64.lock),
+	.position = UINT_MAX
 };
 
 u64 get_random_u64(void)
@@ -1601,21 +1659,24 @@ u64 get_random_u64(void)
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
 	local_unlock_irqrestore(&batched_entropy_u64.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u64);
 
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.lock = INIT_LOCAL_LOCK(batched_entropy_u32.lock)
+	.lock = INIT_LOCAL_LOCK(batched_entropy_u32.lock),
+	.position = UINT_MAX
 };
 
 u32 get_random_u32(void)
@@ -1632,14 +1693,16 @@ u32 get_random_u32(void)
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
 	local_unlock_irqrestore(&batched_entropy_u32.lock, flags);
 	return ret;
 }



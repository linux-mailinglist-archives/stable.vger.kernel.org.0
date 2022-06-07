Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0805361F9
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352112AbiE0MHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352171AbiE0MDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:03:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F02140868;
        Fri, 27 May 2022 04:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5D28CE251C;
        Fri, 27 May 2022 11:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00989C34100;
        Fri, 27 May 2022 11:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652403;
        bh=o/vpF3BiQyrIGRAKAEx1tRXGpe4IKLgfoQczLVlw3nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hk7oEHA09RRWD9oNISSBVRBylBvCXIROjEMaS91LN92NW0mTBGD3avrdtLhlLJOr0
         8pTgg9/g2OVGUbXOfsB1OUs2XUY0HEReB7TGs/dpUSreWyxJYW13T9SgZfPfERHinr
         ByCgL0PRE7CEoFZ8yTjuK0t4U86sgVOPvZ9uOXcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Nadia Heninger <nadiah@cs.ucsd.edu>,
        Tom Ristenpart <ristenpart@cornell.edu>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 122/145] random: do not pretend to handle premature next security model
Date:   Fri, 27 May 2022 10:50:23 +0200
Message-Id: <20220527084905.418582467@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit e85c0fc1d94c52483a603651748d4c76d6aa1c6b upstream.

Per the thread linked below, "premature next" is not considered to be a
realistic threat model, and leads to more serious security problems.

"Premature next" is the scenario in which:

- Attacker compromises the current state of a fully initialized RNG via
  some kind of infoleak.
- New bits of entropy are added directly to the key used to generate the
  /dev/urandom stream, without any buffering or pooling.
- Attacker then, somehow having read access to /dev/urandom, samples RNG
  output and brute forces the individual new bits that were added.
- Result: the RNG never "recovers" from the initial compromise, a
  so-called violation of what academics term "post-compromise security".

The usual solutions to this involve some form of delaying when entropy
gets mixed into the crng. With Fortuna, this involves multiple input
buckets. With what the Linux RNG was trying to do prior, this involves
entropy estimation.

However, by delaying when entropy gets mixed in, it also means that RNG
compromises are extremely dangerous during the window of time before
the RNG has gathered enough entropy, during which time nonces may become
predictable (or repeated), ephemeral keys may not be secret, and so
forth. Moreover, it's unclear how realistic "premature next" is from an
attack perspective, if these attacks even make sense in practice.

Put together -- and discussed in more detail in the thread below --
these constitute grounds for just doing away with the current code that
pretends to handle premature next. I say "pretends" because it wasn't
doing an especially great job at it either; should we change our mind
about this direction, we would probably implement Fortuna to "fix" the
"problem", in which case, removing the pretend solution still makes
sense.

This also reduces the crng reseed period from 5 minutes down to 1
minute. The rationale from the thread might lead us toward reducing that
even further in the future (or even eliminating it), but that remains a
topic of a future commit.

At a high level, this patch changes semantics from:

    Before: Seed for the first time after 256 "bits" of estimated
    entropy have been accumulated since the system booted. Thereafter,
    reseed once every five minutes, but only if 256 new "bits" have been
    accumulated since the last reseeding.

    After: Seed for the first time after 256 "bits" of estimated entropy
    have been accumulated since the system booted. Thereafter, reseed
    once every minute.

Most of this patch is renaming and removing: POOL_MIN_BITS becomes
POOL_INIT_BITS, credit_entropy_bits() becomes credit_init_bits(),
crng_reseed() loses its "force" parameter since it's now always true,
the drain_entropy() function no longer has any use so it's removed,
entropy estimation is skipped if we've already init'd, the various
notifiers for "low on entropy" are now only active prior to init, and
finally, some documentation comments are cleaned up here and there.

Link: https://lore.kernel.org/lkml/YmlMGx6+uigkGiZ0@zx2c4.com/
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Nadia Heninger <nadiah@cs.ucsd.edu>
Cc: Tom Ristenpart <ristenpart@cornell.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  174 +++++++++++++++++---------------------------------
 1 file changed, 62 insertions(+), 112 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -15,14 +15,12 @@
  *   - Sysctl interface.
  *
  * The high level overview is that there is one input pool, into which
- * various pieces of data are hashed. Some of that data is then "credited" as
- * having a certain number of bits of entropy. When enough bits of entropy are
- * available, the hash is finalized and handed as a key to a stream cipher that
- * expands it indefinitely for various consumers. This key is periodically
- * refreshed as the various entropy collectors, described below, add data to the
- * input pool and credit it. There is currently no Fortuna-like scheduler
- * involved, which can lead to malicious entropy sources causing a premature
- * reseed, and the entropy estimates are, at best, conservative guesses.
+ * various pieces of data are hashed. Prior to initialization, some of that
+ * data is then "credited" as having a certain number of bits of entropy.
+ * When enough bits of entropy are available, the hash is finalized and
+ * handed as a key to a stream cipher that expands it indefinitely for
+ * various consumers. This key is periodically refreshed as the various
+ * entropy collectors, described below, add data to the input pool.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -233,7 +231,10 @@ static void _warn_unseeded_randomness(co
  *
  *********************************************************************/
 
-enum { CRNG_RESEED_INTERVAL = 300 * HZ };
+enum {
+	CRNG_RESEED_START_INTERVAL = HZ,
+	CRNG_RESEED_INTERVAL = 60 * HZ
+};
 
 static struct {
 	u8 key[CHACHA_KEY_SIZE] __aligned(__alignof__(long));
@@ -255,16 +256,10 @@ static DEFINE_PER_CPU(struct crng, crngs
 	.lock = INIT_LOCAL_LOCK(crngs.lock),
 };
 
-/* Used by crng_reseed() to extract a new seed from the input pool. */
-static bool drain_entropy(void *buf, size_t nbytes);
-/* Used by crng_make_state() to extract a new seed when crng_init==0. */
+/* Used by crng_reseed() and crng_make_state() to extract a new seed from the input pool. */
 static void extract_entropy(void *buf, size_t nbytes);
 
-/*
- * This extracts a new crng key from the input pool, but only if there is a
- * sufficient amount of entropy available, in order to mitigate bruteforcing
- * of newly added bits.
- */
+/* This extracts a new crng key from the input pool. */
 static void crng_reseed(void)
 {
 	unsigned long flags;
@@ -272,9 +267,7 @@ static void crng_reseed(void)
 	u8 key[CHACHA_KEY_SIZE];
 	bool finalize_init = false;
 
-	/* Only reseed if we can, to prevent brute forcing a small amount of new bits. */
-	if (!drain_entropy(key, sizeof(key)))
-		return;
+	extract_entropy(key, sizeof(key));
 
 	/*
 	 * We copy the new key into the base_crng, overwriting the old one,
@@ -346,10 +339,10 @@ static void crng_fast_key_erasure(u8 key
 }
 
 /*
- * Return whether the crng seed is considered to be sufficiently
- * old that a reseeding might be attempted. This happens if the last
- * reseeding was CRNG_RESEED_INTERVAL ago, or during early boot, at
- * an interval proportional to the uptime.
+ * Return whether the crng seed is considered to be sufficiently old
+ * that a reseeding is needed. This happens if the last reseeding
+ * was CRNG_RESEED_INTERVAL ago, or during early boot, at an interval
+ * proportional to the uptime.
  */
 static bool crng_has_old_seed(void)
 {
@@ -361,7 +354,7 @@ static bool crng_has_old_seed(void)
 		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)
 			WRITE_ONCE(early_boot, false);
 		else
-			interval = max_t(unsigned int, 5 * HZ,
+			interval = max_t(unsigned int, CRNG_RESEED_START_INTERVAL,
 					 (unsigned int)uptime / 2 * HZ);
 	}
 	return time_after(jiffies, READ_ONCE(base_crng.birth) + interval);
@@ -403,8 +396,8 @@ static void crng_make_state(u32 chacha_s
 	}
 
 	/*
-	 * If the base_crng is old enough, we try to reseed, which in turn
-	 * bumps the generation counter that we check below.
+	 * If the base_crng is old enough, we reseed, which in turn bumps the
+	 * generation counter that we check below.
 	 */
 	if (unlikely(crng_has_old_seed()))
 		crng_reseed();
@@ -736,30 +729,24 @@ EXPORT_SYMBOL(get_random_bytes_arch);
  *
  * After which, if added entropy should be credited:
  *
- *     static void credit_entropy_bits(size_t nbits)
+ *     static void credit_init_bits(size_t nbits)
  *
- * Finally, extract entropy via these two, with the latter one
- * setting the entropy count to zero and extracting only if there
- * is POOL_MIN_BITS entropy credited prior:
+ * Finally, extract entropy via:
  *
  *     static void extract_entropy(void *buf, size_t nbytes)
- *     static bool drain_entropy(void *buf, size_t nbytes)
  *
  **********************************************************************/
 
 enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
-	POOL_MIN_BITS = POOL_BITS, /* No point in settling for less. */
-	POOL_FAST_INIT_BITS = POOL_MIN_BITS / 2
+	POOL_INIT_BITS = POOL_BITS, /* No point in settling for less. */
+	POOL_FAST_INIT_BITS = POOL_INIT_BITS / 2
 };
 
-/* For notifying userspace should write into /dev/random. */
-static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
-
 static struct {
 	struct blake2s_state hash;
 	spinlock_t lock;
-	unsigned int entropy_count;
+	unsigned int init_bits;
 } input_pool = {
 	.hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
 		    BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
@@ -774,9 +761,9 @@ static void _mix_pool_bytes(const void *
 }
 
 /*
- * This function adds bytes into the entropy "pool".  It does not
- * update the entropy estimate.  The caller should call
- * credit_entropy_bits if this is appropriate.
+ * This function adds bytes into the input pool. It does not
+ * update the initialization bit counter; the caller should call
+ * credit_init_bits if this is appropriate.
  */
 static void mix_pool_bytes(const void *in, size_t nbytes)
 {
@@ -833,43 +820,24 @@ static void extract_entropy(void *buf, s
 	memzero_explicit(&block, sizeof(block));
 }
 
-/*
- * First we make sure we have POOL_MIN_BITS of entropy in the pool, and then we
- * set the entropy count to zero (but don't actually touch any data). Only then
- * can we extract a new key with extract_entropy().
- */
-static bool drain_entropy(void *buf, size_t nbytes)
-{
-	unsigned int entropy_count;
-	do {
-		entropy_count = READ_ONCE(input_pool.entropy_count);
-		if (entropy_count < POOL_MIN_BITS)
-			return false;
-	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
-	extract_entropy(buf, nbytes);
-	wake_up_interruptible(&random_write_wait);
-	kill_fasync(&fasync, SIGIO, POLL_OUT);
-	return true;
-}
-
-static void credit_entropy_bits(size_t nbits)
+static void credit_init_bits(size_t nbits)
 {
-	unsigned int entropy_count, orig, add;
+	unsigned int init_bits, orig, add;
 	unsigned long flags;
 
-	if (!nbits)
+	if (crng_ready() || !nbits)
 		return;
 
 	add = min_t(size_t, nbits, POOL_BITS);
 
 	do {
-		orig = READ_ONCE(input_pool.entropy_count);
-		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
-	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
+		orig = READ_ONCE(input_pool.init_bits);
+		init_bits = min_t(unsigned int, POOL_BITS, orig + add);
+	} while (cmpxchg(&input_pool.init_bits, orig, init_bits) != orig);
 
-	if (!crng_ready() && entropy_count >= POOL_MIN_BITS)
+	if (!crng_ready() && init_bits >= POOL_INIT_BITS)
 		crng_reseed();
-	else if (unlikely(crng_init == 0 && entropy_count >= POOL_FAST_INIT_BITS)) {
+	else if (unlikely(crng_init == 0 && init_bits >= POOL_FAST_INIT_BITS)) {
 		spin_lock_irqsave(&base_crng.lock, flags);
 		if (crng_init == 0) {
 			extract_entropy(base_crng.key, sizeof(base_crng.key));
@@ -975,13 +943,10 @@ int __init rand_initialize(void)
 	_mix_pool_bytes(&now, sizeof(now));
 	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
-	extract_entropy(base_crng.key, sizeof(base_crng.key));
-	++base_crng.generation;
-
-	if (arch_init && trust_cpu && !crng_ready()) {
-		crng_init = 2;
-		pr_notice("crng init done (trusting CPU's manufacturer)\n");
-	}
+	if (crng_ready())
+		crng_reseed();
+	else if (arch_init && trust_cpu)
+		credit_init_bits(BLAKE2S_BLOCK_SIZE * 8);
 
 	if (ratelimit_disable) {
 		urandom_warning.interval = 0;
@@ -1035,6 +1000,9 @@ static void add_timer_randomness(struct
 	_mix_pool_bytes(&num, sizeof(num));
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 
+	if (crng_ready())
+		return;
+
 	/*
 	 * Calculate number of bits of randomness we probably added.
 	 * We take into account the first, second and third-order deltas
@@ -1065,7 +1033,7 @@ static void add_timer_randomness(struct
 	 * Round down by 1 bit on general principles,
 	 * and limit entropy estimate to 12 bits.
 	 */
-	credit_entropy_bits(min_t(unsigned int, fls(delta >> 1), 11));
+	credit_init_bits(min_t(unsigned int, fls(delta >> 1), 11));
 }
 
 void add_input_randomness(unsigned int type, unsigned int code,
@@ -1118,18 +1086,15 @@ void rand_initialize_disk(struct gendisk
 void add_hwgenerator_randomness(const void *buffer, size_t count,
 				size_t entropy)
 {
+	mix_pool_bytes(buffer, count);
+	credit_init_bits(entropy);
+
 	/*
-	 * Throttle writing if we're above the trickle threshold.
-	 * We'll be woken up again once below POOL_MIN_BITS, when
-	 * the calling thread is about to terminate, or once
-	 * CRNG_RESEED_INTERVAL has elapsed.
+	 * Throttle writing to once every CRNG_RESEED_INTERVAL, unless
+	 * we're not yet initialized.
 	 */
-	wait_event_interruptible_timeout(random_write_wait,
-			kthread_should_stop() ||
-			input_pool.entropy_count < POOL_MIN_BITS,
-			CRNG_RESEED_INTERVAL);
-	mix_pool_bytes(buffer, count);
-	credit_entropy_bits(entropy);
+	if (!kthread_should_stop() && crng_ready())
+		schedule_timeout_interruptible(CRNG_RESEED_INTERVAL);
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
 
@@ -1141,7 +1106,7 @@ void add_bootloader_randomness(const voi
 {
 	mix_pool_bytes(buf, size);
 	if (trust_bootloader)
-		credit_entropy_bits(size * 8);
+		credit_init_bits(size * 8);
 }
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
@@ -1242,7 +1207,7 @@ static void mix_interrupt_randomness(str
 	local_irq_enable();
 
 	mix_pool_bytes(pool, sizeof(pool));
-	credit_entropy_bits(1);
+	credit_init_bits(1);
 
 	memzero_explicit(pool, sizeof(pool));
 }
@@ -1289,7 +1254,7 @@ EXPORT_SYMBOL_GPL(add_interrupt_randomne
  */
 static void entropy_timer(struct timer_list *t)
 {
-	credit_entropy_bits(1);
+	credit_init_bits(1);
 }
 
 /*
@@ -1382,16 +1347,8 @@ SYSCALL_DEFINE3(getrandom, char __user *
 
 static __poll_t random_poll(struct file *file, poll_table *wait)
 {
-	__poll_t mask;
-
 	poll_wait(file, &crng_init_wait, wait);
-	poll_wait(file, &random_write_wait, wait);
-	mask = 0;
-	if (crng_ready())
-		mask |= EPOLLIN | EPOLLRDNORM;
-	if (input_pool.entropy_count < POOL_MIN_BITS)
-		mask |= EPOLLOUT | EPOLLWRNORM;
-	return mask;
+	return crng_ready() ? EPOLLIN | EPOLLRDNORM : EPOLLOUT | EPOLLWRNORM;
 }
 
 static int write_pool(const char __user *ubuf, size_t count)
@@ -1464,7 +1421,7 @@ static long random_ioctl(struct file *f,
 	switch (cmd) {
 	case RNDGETENTCNT:
 		/* Inherently racy, no point locking. */
-		if (put_user(input_pool.entropy_count, p))
+		if (put_user(input_pool.init_bits, p))
 			return -EFAULT;
 		return 0;
 	case RNDADDTOENTCNT:
@@ -1474,7 +1431,7 @@ static long random_ioctl(struct file *f,
 			return -EFAULT;
 		if (ent_count < 0)
 			return -EINVAL;
-		credit_entropy_bits(ent_count);
+		credit_init_bits(ent_count);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1488,20 +1445,13 @@ static long random_ioctl(struct file *f,
 		retval = write_pool((const char __user *)p, size);
 		if (retval < 0)
 			return retval;
-		credit_entropy_bits(ent_count);
+		credit_init_bits(ent_count);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
-		/*
-		 * Clear the entropy pool counters. We no longer clear
-		 * the entropy pool, as that's silly.
-		 */
+		/* No longer has any effect. */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		if (xchg(&input_pool.entropy_count, 0) >= POOL_MIN_BITS) {
-			wake_up_interruptible(&random_write_wait);
-			kill_fasync(&fasync, SIGIO, POLL_OUT);
-		}
 		return 0;
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1560,7 +1510,7 @@ const struct file_operations urandom_fop
  *
  * - write_wakeup_threshold - the amount of entropy in the input pool
  *   below which write polls to /dev/random will unblock, requesting
- *   more entropy, tied to the POOL_MIN_BITS constant. It is writable
+ *   more entropy, tied to the POOL_INIT_BITS constant. It is writable
  *   to avoid breaking old userspaces, but writing to it does not
  *   change any behavior of the RNG.
  *
@@ -1575,7 +1525,7 @@ const struct file_operations urandom_fop
 #include <linux/sysctl.h>
 
 static int sysctl_random_min_urandom_seed = CRNG_RESEED_INTERVAL / HZ;
-static int sysctl_random_write_wakeup_bits = POOL_MIN_BITS;
+static int sysctl_random_write_wakeup_bits = POOL_INIT_BITS;
 static int sysctl_poolsize = POOL_BITS;
 static u8 sysctl_bootid[UUID_SIZE];
 
@@ -1632,7 +1582,7 @@ struct ctl_table random_table[] = {
 	},
 	{
 		.procname	= "entropy_avail",
-		.data		= &input_pool.entropy_count,
+		.data		= &input_pool.init_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,



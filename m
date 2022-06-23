Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A70558094
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiFWQwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbiFWQv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB281183;
        Thu, 23 Jun 2022 09:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1509F61F90;
        Thu, 23 Jun 2022 16:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA65C3411B;
        Thu, 23 Jun 2022 16:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003116;
        bh=U1sUYjsdCODOkEVxX6hmhbOGC4lzXsujO05zuYz4xnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESwcCt3FtS/CdEdo5KOb9qYiUqqJWYp5uURDUgG7QdoRt1zOdp/cfxTzSmPkPja+i
         g0MZr/Yjrlhg/EYSLSuFc7s2c+7GWaDQAFqrVA23fiNobzEo4VTcl7uIYC7DrRLJMq
         sXq6FMDTxMuGhWvlgvWqjC0pLINpeymKvE5GQCEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 136/264] random: group entropy collection functions
Date:   Thu, 23 Jun 2022 18:42:09 +0200
Message-Id: <20220623164347.913890343@linuxfoundation.org>
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

commit 92c653cf14400946f376a29b828d6af7e01f38dd upstream.

This pulls all of the entropy collection-focused functions into the
fourth labeled section.

No functional changes.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  370 +++++++++++++++++++++++++++-----------------------
 1 file changed, 206 insertions(+), 164 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1035,60 +1035,112 @@ static bool drain_entropy(void *buf, siz
 	return true;
 }
 
-struct fast_pool {
-	union {
-		u32 pool32[4];
-		u64 pool64[2];
-	};
-	unsigned long last;
-	u16 reg_idx;
-	u8 count;
-};
+
+/**********************************************************************
+ *
+ * Entropy collection routines.
+ *
+ * The following exported functions are used for pushing entropy into
+ * the above entropy accumulation routines:
+ *
+ *	void add_device_randomness(const void *buf, size_t size);
+ *	void add_input_randomness(unsigned int type, unsigned int code,
+ *	                          unsigned int value);
+ *	void add_disk_randomness(struct gendisk *disk);
+ *	void add_hwgenerator_randomness(const void *buffer, size_t count,
+ *					size_t entropy);
+ *	void add_bootloader_randomness(const void *buf, size_t size);
+ *	void add_interrupt_randomness(int irq);
+ *
+ * add_device_randomness() adds data to the input pool that
+ * is likely to differ between two devices (or possibly even per boot).
+ * This would be things like MAC addresses or serial numbers, or the
+ * read-out of the RTC. This does *not* credit any actual entropy to
+ * the pool, but it initializes the pool to different values for devices
+ * that might otherwise be identical and have very little entropy
+ * available to them (particularly common in the embedded world).
+ *
+ * add_input_randomness() uses the input layer interrupt timing, as well
+ * as the event type information from the hardware.
+ *
+ * add_disk_randomness() uses what amounts to the seek time of block
+ * layer request events, on a per-disk_devt basis, as input to the
+ * entropy pool. Note that high-speed solid state drives with very low
+ * seek times do not make for good sources of entropy, as their seek
+ * times are usually fairly consistent.
+ *
+ * The above two routines try to estimate how many bits of entropy
+ * to credit. They do this by keeping track of the first and second
+ * order deltas of the event timings.
+ *
+ * add_hwgenerator_randomness() is for true hardware RNGs, and will credit
+ * entropy as specified by the caller. If the entropy pool is full it will
+ * block until more entropy is needed.
+ *
+ * add_bootloader_randomness() is the same as add_hwgenerator_randomness() or
+ * add_device_randomness(), depending on whether or not the configuration
+ * option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
+ *
+ * add_interrupt_randomness() uses the interrupt timing as random
+ * inputs to the entropy pool. Using the cycle counters and the irq source
+ * as inputs, it feeds the input pool roughly once a second or after 64
+ * interrupts, crediting 1 bit of entropy for whichever comes first.
+ *
+ **********************************************************************/
+
+static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static int __init parse_trust_cpu(char *arg)
+{
+	return kstrtobool(arg, &trust_cpu);
+}
+early_param("random.trust_cpu", parse_trust_cpu);
 
 /*
- * This is a fast mixing routine used by the interrupt randomness
- * collector.  It's hardcoded for an 128 bit pool and assumes that any
- * locks that might be needed are taken by the caller.
+ * The first collection of entropy occurs at system boot while interrupts
+ * are still turned off. Here we push in RDSEED, a timestamp, and utsname().
+ * Depending on the above configuration knob, RDSEED may be considered
+ * sufficient for initialization. Note that much earlier setup may already
+ * have pushed entropy into the input pool by the time we get here.
  */
-static void fast_mix(u32 pool[4])
+int __init rand_initialize(void)
 {
-	u32 a = pool[0],	b = pool[1];
-	u32 c = pool[2],	d = pool[3];
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
+	size_t i;
+	ktime_t now = ktime_get_real();
+	bool arch_init = true;
+	unsigned long rv;
 
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
+	for (i = 0; i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
+		if (!arch_get_random_seed_long_early(&rv) &&
+		    !arch_get_random_long_early(&rv)) {
+			rv = random_get_entropy();
+			arch_init = false;
+		}
+		mix_pool_bytes(&rv, sizeof(rv));
+	}
+	mix_pool_bytes(&now, sizeof(now));
+	mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
+	extract_entropy(base_crng.key, sizeof(base_crng.key));
+	++base_crng.generation;
 
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
+	if (arch_init && trust_cpu && crng_init < 2) {
+		crng_init = 2;
+		pr_notice("crng init done (trusting CPU's manufacturer)\n");
+	}
 
-	pool[0] = a;  pool[1] = b;
-	pool[2] = c;  pool[3] = d;
+	if (ratelimit_disable) {
+		urandom_warning.interval = 0;
+		unseeded_warning.interval = 0;
+	}
+	return 0;
 }
 
-/*********************************************************************
- *
- * Entropy input management
- *
- *********************************************************************/
-
 /* There is one of these per entropy source */
 struct timer_rand_state {
 	cycles_t last_time;
 	long last_delta, last_delta2;
 };
 
-#define INIT_TIMER_RAND_STATE { INITIAL_JIFFIES, };
-
 /*
  * Add device- or boot-specific data to the input pool to help
  * initialize it.
@@ -1112,8 +1164,6 @@ void add_device_randomness(const void *b
 }
 EXPORT_SYMBOL(add_device_randomness);
 
-static struct timer_rand_state input_timer_state = INIT_TIMER_RAND_STATE;
-
 /*
  * This function adds entropy to the entropy "pool" by using timing
  * delays.  It uses the timer_rand_state structure to make an estimate
@@ -1175,8 +1225,9 @@ void add_input_randomness(unsigned int t
 			  unsigned int value)
 {
 	static unsigned char last_value;
+	static struct timer_rand_state input_timer_state = { INITIAL_JIFFIES };
 
-	/* ignore autorepeat and the like */
+	/* Ignore autorepeat and the like. */
 	if (value == last_value)
 		return;
 
@@ -1186,6 +1237,119 @@ void add_input_randomness(unsigned int t
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
+#ifdef CONFIG_BLOCK
+void add_disk_randomness(struct gendisk *disk)
+{
+	if (!disk || !disk->random)
+		return;
+	/* First major is 1, so we get >= 0x200 here. */
+	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
+}
+EXPORT_SYMBOL_GPL(add_disk_randomness);
+
+void rand_initialize_disk(struct gendisk *disk)
+{
+	struct timer_rand_state *state;
+
+	/*
+	 * If kzalloc returns null, we just won't use that entropy
+	 * source.
+	 */
+	state = kzalloc(sizeof(struct timer_rand_state), GFP_KERNEL);
+	if (state) {
+		state->last_time = INITIAL_JIFFIES;
+		disk->random = state;
+	}
+}
+#endif
+
+/*
+ * Interface for in-kernel drivers of true hardware RNGs.
+ * Those devices may produce endless random bits and will be throttled
+ * when our pool is full.
+ */
+void add_hwgenerator_randomness(const void *buffer, size_t count,
+				size_t entropy)
+{
+	if (unlikely(crng_init == 0)) {
+		size_t ret = crng_fast_load(buffer, count);
+		mix_pool_bytes(buffer, ret);
+		count -= ret;
+		buffer += ret;
+		if (!count || crng_init == 0)
+			return;
+	}
+
+	/*
+	 * Throttle writing if we're above the trickle threshold.
+	 * We'll be woken up again once below POOL_MIN_BITS, when
+	 * the calling thread is about to terminate, or once
+	 * CRNG_RESEED_INTERVAL has elapsed.
+	 */
+	wait_event_interruptible_timeout(random_write_wait,
+			!system_wq || kthread_should_stop() ||
+			input_pool.entropy_count < POOL_MIN_BITS,
+			CRNG_RESEED_INTERVAL);
+	mix_pool_bytes(buffer, count);
+	credit_entropy_bits(entropy);
+}
+EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+
+/*
+ * Handle random seed passed by bootloader.
+ * If the seed is trustworthy, it would be regarded as hardware RNGs. Otherwise
+ * it would be regarded as device data.
+ * The decision is controlled by CONFIG_RANDOM_TRUST_BOOTLOADER.
+ */
+void add_bootloader_randomness(const void *buf, size_t size)
+{
+	if (IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER))
+		add_hwgenerator_randomness(buf, size, size * 8);
+	else
+		add_device_randomness(buf, size);
+}
+EXPORT_SYMBOL_GPL(add_bootloader_randomness);
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
+ * collector. It's hardcoded for an 128 bit pool and assumes that any
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
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
 static u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
@@ -1255,22 +1419,11 @@ void add_interrupt_randomness(int irq)
 
 	fast_pool->count = 0;
 
-	/* award one bit for the contents of the fast pool */
+	/* Award one bit for the contents of the fast pool. */
 	credit_entropy_bits(1);
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
-#ifdef CONFIG_BLOCK
-void add_disk_randomness(struct gendisk *disk)
-{
-	if (!disk || !disk->random)
-		return;
-	/* first major is 1, so we get >= 0x200 here */
-	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-}
-EXPORT_SYMBOL_GPL(add_disk_randomness);
-#endif
-
 /*
  * Each time the timer fires, we expect that we got an unpredictable
  * jump in the cycle counter. Even if the timer is running on another
@@ -1320,73 +1473,6 @@ static void try_to_generate_entropy(void
 	mix_pool_bytes(&stack.now, sizeof(stack.now));
 }
 
-static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
-static int __init parse_trust_cpu(char *arg)
-{
-	return kstrtobool(arg, &trust_cpu);
-}
-early_param("random.trust_cpu", parse_trust_cpu);
-
-/*
- * Note that setup_arch() may call add_device_randomness()
- * long before we get here. This allows seeding of the pools
- * with some platform dependent data very early in the boot
- * process. But it limits our options here. We must use
- * statically allocated structures that already have all
- * initializations complete at compile time. We should also
- * take care not to overwrite the precious per platform data
- * we were given.
- */
-int __init rand_initialize(void)
-{
-	size_t i;
-	ktime_t now = ktime_get_real();
-	bool arch_init = true;
-	unsigned long rv;
-
-	for (i = 0; i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
-		if (!arch_get_random_seed_long_early(&rv) &&
-		    !arch_get_random_long_early(&rv)) {
-			rv = random_get_entropy();
-			arch_init = false;
-		}
-		mix_pool_bytes(&rv, sizeof(rv));
-	}
-	mix_pool_bytes(&now, sizeof(now));
-	mix_pool_bytes(utsname(), sizeof(*(utsname())));
-
-	extract_entropy(base_crng.key, sizeof(base_crng.key));
-	++base_crng.generation;
-
-	if (arch_init && trust_cpu && crng_init < 2) {
-		crng_init = 2;
-		pr_notice("crng init done (trusting CPU's manufacturer)\n");
-	}
-
-	if (ratelimit_disable) {
-		urandom_warning.interval = 0;
-		unseeded_warning.interval = 0;
-	}
-	return 0;
-}
-
-#ifdef CONFIG_BLOCK
-void rand_initialize_disk(struct gendisk *disk)
-{
-	struct timer_rand_state *state;
-
-	/*
-	 * If kzalloc returns null, we just won't use that entropy
-	 * source.
-	 */
-	state = kzalloc(sizeof(struct timer_rand_state), GFP_KERNEL);
-	if (state) {
-		state->last_time = INITIAL_JIFFIES;
-		disk->random = state;
-	}
-}
-#endif
-
 static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
 			    loff_t *ppos)
 {
@@ -1669,47 +1755,3 @@ struct ctl_table random_table[] = {
 	{ }
 };
 #endif	/* CONFIG_SYSCTL */
-
-/* Interface for in-kernel drivers of true hardware RNGs.
- * Those devices may produce endless random bits and will be throttled
- * when our pool is full.
- */
-void add_hwgenerator_randomness(const void *buffer, size_t count,
-				size_t entropy)
-{
-	if (unlikely(crng_init == 0)) {
-		size_t ret = crng_fast_load(buffer, count);
-		mix_pool_bytes(buffer, ret);
-		count -= ret;
-		buffer += ret;
-		if (!count || crng_init == 0)
-			return;
-	}
-
-	/* Throttle writing if we're above the trickle threshold.
-	 * We'll be woken up again once below POOL_MIN_BITS, when
-	 * the calling thread is about to terminate, or once
-	 * CRNG_RESEED_INTERVAL has elapsed.
-	 */
-	wait_event_interruptible_timeout(random_write_wait,
-			!system_wq || kthread_should_stop() ||
-			input_pool.entropy_count < POOL_MIN_BITS,
-			CRNG_RESEED_INTERVAL);
-	mix_pool_bytes(buffer, count);
-	credit_entropy_bits(entropy);
-}
-EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
-
-/* Handle random seed passed by bootloader.
- * If the seed is trustworthy, it would be regarded as hardware RNGs. Otherwise
- * it would be regarded as device data.
- * The decision is controlled by CONFIG_RANDOM_TRUST_BOOTLOADER.
- */
-void add_bootloader_randomness(const void *buf, size_t size)
-{
-	if (IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER))
-		add_hwgenerator_randomness(buf, size, size * 8);
-	else
-		add_device_randomness(buf, size);
-}
-EXPORT_SYMBOL_GPL(add_bootloader_randomness);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0A65581AF
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiFWRD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiFWRDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:03:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF8C50E1C;
        Thu, 23 Jun 2022 09:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F30A9B82495;
        Thu, 23 Jun 2022 16:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490DBC341C4;
        Thu, 23 Jun 2022 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003301;
        bh=DCaqoVcA1E3F5AX9Gl5pgYBgiGkjrHMpbe25Tsp0Kc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRPVNoktTNEW1+JnrYb+kPRiz2qbzybGCYrvC8NWEPvuLJDVEsTpx59WbEwR5FeuF
         RNW/MHPSpu9t3sbS8/yaaXwf8JP6OdtqAN2mf9goVREFlXc9grq/t2H937d7mczwed
         vv4XPy+r1S1VbbsVgb22qBD51bjoo8+M36vhvZN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 194/264] random: do not use batches when !crng_ready()
Date:   Thu, 23 Jun 2022 18:43:07 +0200
Message-Id: <20220623164349.558650909@linuxfoundation.org>
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

commit cbe89e5a375a51bbb952929b93fa973416fea74e upstream.

It's too hard to keep the batches synchronized, and pointless anyway,
since in !crng_ready(), we're updating the base_crng key really often,
where batching only hurts. So instead, if the crng isn't ready, just
call into get_random_bytes(). At this stage nothing is performance
critical anyhow.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  158 ++++++++++++++++++--------------------------------
 1 file changed, 59 insertions(+), 99 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -234,10 +234,7 @@ static void _warn_unseeded_randomness(co
  *
  *********************************************************************/
 
-enum {
-	CRNG_RESEED_INTERVAL = 300 * HZ,
-	CRNG_INIT_CNT_THRESH = 2 * CHACHA20_KEY_SIZE
-};
+enum { CRNG_RESEED_INTERVAL = 300 * HZ };
 
 static struct {
 	u8 key[CHACHA20_KEY_SIZE] __aligned(__alignof__(long));
@@ -259,6 +256,8 @@ static DEFINE_PER_CPU(struct crng, crngs
 
 /* Used by crng_reseed() to extract a new seed from the input pool. */
 static bool drain_entropy(void *buf, size_t nbytes);
+/* Used by crng_make_state() to extract a new seed when crng_init==0. */
+static void extract_entropy(void *buf, size_t nbytes);
 
 /*
  * This extracts a new crng key from the input pool, but only if there is a
@@ -383,17 +382,20 @@ static void crng_make_state(u32 chacha_s
 	/*
 	 * For the fast path, we check whether we're ready, unlocked first, and
 	 * then re-check once locked later. In the case where we're really not
-	 * ready, we do fast key erasure with the base_crng directly, because
-	 * this is what crng_pre_init_inject() mutates during early init.
+	 * ready, we do fast key erasure with the base_crng directly, extracting
+	 * when crng_init==0.
 	 */
 	if (!crng_ready()) {
 		bool ready;
 
 		spin_lock_irqsave(&base_crng.lock, flags);
 		ready = crng_ready();
-		if (!ready)
+		if (!ready) {
+			if (crng_init == 0)
+				extract_entropy(base_crng.key, sizeof(base_crng.key));
 			crng_fast_key_erasure(base_crng.key, chacha_state,
 					      random_data, random_data_len);
+		}
 		spin_unlock_irqrestore(&base_crng.lock, flags);
 		if (!ready)
 			return;
@@ -434,50 +436,6 @@ static void crng_make_state(u32 chacha_s
 	local_irq_restore(flags);
 }
 
-/*
- * This function is for crng_init == 0 only. It loads entropy directly
- * into the crng's key, without going through the input pool. It is,
- * generally speaking, not very safe, but we use this only at early
- * boot time when it's better to have something there rather than
- * nothing.
- *
- * If account is set, then the crng_init_cnt counter is incremented.
- * This shouldn't be set by functions like add_device_randomness(),
- * where we can't trust the buffer passed to it is guaranteed to be
- * unpredictable (so it might not have any entropy at all).
- */
-static void crng_pre_init_inject(const void *input, size_t len, bool account)
-{
-	static int crng_init_cnt = 0;
-	struct blake2s_state hash;
-	unsigned long flags;
-
-	blake2s_init(&hash, sizeof(base_crng.key));
-
-	spin_lock_irqsave(&base_crng.lock, flags);
-	if (crng_init != 0) {
-		spin_unlock_irqrestore(&base_crng.lock, flags);
-		return;
-	}
-
-	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
-	blake2s_update(&hash, input, len);
-	blake2s_final(&hash, base_crng.key);
-
-	if (account) {
-		crng_init_cnt += min_t(size_t, len, CRNG_INIT_CNT_THRESH - crng_init_cnt);
-		if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-			++base_crng.generation;
-			crng_init = 1;
-		}
-	}
-
-	spin_unlock_irqrestore(&base_crng.lock, flags);
-
-	if (crng_init == 1)
-		pr_notice("fast init done\n");
-}
-
 static void _get_random_bytes(void *buf, size_t nbytes)
 {
 	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
@@ -623,6 +581,11 @@ u64 get_random_u64(void)
 
 	warn_unseeded_randomness(&previous);
 
+	if  (!crng_ready()) {
+		_get_random_bytes(&ret, sizeof(ret));
+		return ret;
+	}
+
 	local_irq_save(flags);
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 
@@ -656,6 +619,11 @@ u32 get_random_u32(void)
 
 	warn_unseeded_randomness(&previous);
 
+	if  (!crng_ready()) {
+		_get_random_bytes(&ret, sizeof(ret));
+		return ret;
+	}
+
 	local_irq_save(flags);
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 
@@ -777,7 +745,8 @@ EXPORT_SYMBOL(get_random_bytes_arch);
 
 enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
-	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
+	POOL_MIN_BITS = POOL_BITS, /* No point in settling for less. */
+	POOL_FAST_INIT_BITS = POOL_MIN_BITS / 2
 };
 
 /* For notifying userspace should write into /dev/random. */
@@ -814,24 +783,6 @@ static void mix_pool_bytes(const void *i
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 
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
-	if (!crng_ready() && entropy_count >= POOL_MIN_BITS)
-		crng_reseed();
-}
-
 /*
  * This is an HKDF-like construction for using the hashed collected entropy
  * as a PRF key, that's then expanded block-by-block.
@@ -897,6 +848,33 @@ static bool drain_entropy(void *buf, siz
 	return true;
 }
 
+static void credit_entropy_bits(size_t nbits)
+{
+	unsigned int entropy_count, orig, add;
+	unsigned long flags;
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
+	if (!crng_ready() && entropy_count >= POOL_MIN_BITS)
+		crng_reseed();
+	else if (unlikely(crng_init == 0 && entropy_count >= POOL_FAST_INIT_BITS)) {
+		spin_lock_irqsave(&base_crng.lock, flags);
+		if (crng_init == 0) {
+			extract_entropy(base_crng.key, sizeof(base_crng.key));
+			crng_init = 1;
+		}
+		spin_unlock_irqrestore(&base_crng.lock, flags);
+	}
+}
+
 
 /**********************************************************************
  *
@@ -939,9 +917,9 @@ static bool drain_entropy(void *buf, siz
  * entropy as specified by the caller. If the entropy pool is full it will
  * block until more entropy is needed.
  *
- * add_bootloader_randomness() is the same as add_hwgenerator_randomness() or
- * add_device_randomness(), depending on whether or not the configuration
- * option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
+ * add_bootloader_randomness() is called by bootloader drivers, such as EFI
+ * and device tree, and credits its input depending on whether or not the
+ * configuration option CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  *
  * add_interrupt_randomness() uses the interrupt timing as random
  * inputs to the entropy pool. Using the cycle counters and the irq source
@@ -1021,9 +999,6 @@ void add_device_randomness(const void *b
 	unsigned long entropy = random_get_entropy();
 	unsigned long flags;
 
-	if (crng_init == 0 && size)
-		crng_pre_init_inject(buf, size, false);
-
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&entropy, sizeof(entropy));
 	_mix_pool_bytes(buf, size);
@@ -1139,12 +1114,6 @@ void rand_initialize_disk(struct gendisk
 void add_hwgenerator_randomness(const void *buffer, size_t count,
 				size_t entropy)
 {
-	if (unlikely(crng_init == 0 && entropy < POOL_MIN_BITS)) {
-		crng_pre_init_inject(buffer, count, true);
-		mix_pool_bytes(buffer, count);
-		return;
-	}
-
 	/*
 	 * Throttle writing if we're above the trickle threshold.
 	 * We'll be woken up again once below POOL_MIN_BITS, when
@@ -1152,7 +1121,7 @@ void add_hwgenerator_randomness(const vo
 	 * CRNG_RESEED_INTERVAL has elapsed.
 	 */
 	wait_event_interruptible_timeout(random_write_wait,
-			!system_wq || kthread_should_stop() ||
+			kthread_should_stop() ||
 			input_pool.entropy_count < POOL_MIN_BITS,
 			CRNG_RESEED_INTERVAL);
 	mix_pool_bytes(buffer, count);
@@ -1161,17 +1130,14 @@ void add_hwgenerator_randomness(const vo
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
 
 /*
- * Handle random seed passed by bootloader.
- * If the seed is trustworthy, it would be regarded as hardware RNGs. Otherwise
- * it would be regarded as device data.
- * The decision is controlled by CONFIG_RANDOM_TRUST_BOOTLOADER.
+ * Handle random seed passed by bootloader, and credit it if
+ * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
 void add_bootloader_randomness(const void *buf, size_t size)
 {
+	mix_pool_bytes(buf, size);
 	if (trust_bootloader)
-		add_hwgenerator_randomness(buf, size, size * 8);
-	else
-		add_device_randomness(buf, size);
+		credit_entropy_bits(size * 8);
 }
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
@@ -1271,13 +1237,8 @@ static void mix_interrupt_randomness(str
 	fast_pool->last = jiffies;
 	local_irq_enable();
 
-	if (unlikely(crng_init == 0)) {
-		crng_pre_init_inject(pool, sizeof(pool), true);
-		mix_pool_bytes(pool, sizeof(pool));
-	} else {
-		mix_pool_bytes(pool, sizeof(pool));
-		credit_entropy_bits(1);
-	}
+	mix_pool_bytes(pool, sizeof(pool));
+	credit_entropy_bits(1);
 
 	memzero_explicit(pool, sizeof(pool));
 }
@@ -1299,8 +1260,7 @@ void add_interrupt_randomness(int irq)
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && (!time_is_before_jiffies(fast_pool->last + HZ) ||
-			       unlikely(crng_init == 0)))
+	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))



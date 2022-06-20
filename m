Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE364551EAB
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350396AbiFTOCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349958AbiFTNwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:52:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C268931386;
        Mon, 20 Jun 2022 06:19:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB92660FEF;
        Mon, 20 Jun 2022 13:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7277C3411B;
        Mon, 20 Jun 2022 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731087;
        bh=QNFWhPH6EmpOsG/robhdQRc0cok7OrO/fWZcbC7D908=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qloDh2IUasQzRBRLP+ySV5GsiQkLlJH35s5HmtDTDo+JGgrDvbJq4nNfKVv5bieyI
         5zFYq3H0fYclrouXQxEIrEoEbECOeVRX1dO27XdvBR2WKvQtBPSiBvfdPIpHr9luEr
         T0EV/NpUWstaS2aKOXfKGtlBgHxzXf/oR14lag2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 147/240] random: use first 128 bits of input as fast init
Date:   Mon, 20 Jun 2022 14:50:48 +0200
Message-Id: <20220620124743.268768254@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

commit 5c3b747ef54fa2a7318776777f6044540d99f721 upstream.

Before, the first 64 bytes of input, regardless of how entropic it was,
would be used to mutate the crng base key directly, and none of those
bytes would be credited as having entropy. Then 256 bits of credited
input would be accumulated, and only then would the rng transition from
the earlier "fast init" phase into being actually initialized.

The thinking was that by mixing and matching fast init and real init, an
attacker who compromised the fast init state, considered easy to do
given how little entropy might be in those first 64 bytes, would then be
able to bruteforce bits from the actual initialization. By keeping these
separate, bruteforcing became impossible.

However, by not crediting potentially creditable bits from those first 64
bytes of input, we delay initialization, and actually make the problem
worse, because it means the user is drawing worse random numbers for a
longer period of time.

Instead, we can take the first 128 bits as fast init, and allow them to
be credited, and then hold off on the next 128 bits until they've
accumulated. This is still a wide enough margin to prevent bruteforcing
the rng state, while still initializing much faster.

Then, rather than trying to piecemeal inject into the base crng key at
various points, instead just extract from the pool when we need it, for
the crng_init==0 phase. Performance may even be better for the various
inputs here, since there are likely more calls to mix_pool_bytes() then
there are to get_random_bytes() during this phase of system execution.

Since the preinit injection code is gone, bootloader randomness can then
do something significantly more straight forward, removing the weird
system_wq hack in hwgenerator randomness.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  146 ++++++++++++++++----------------------------------
 1 file changed, 49 insertions(+), 97 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -233,10 +233,7 @@ static void _warn_unseeded_randomness(co
  *
  *********************************************************************/
 
-enum {
-	CRNG_RESEED_INTERVAL = 300 * HZ,
-	CRNG_INIT_CNT_THRESH = 2 * CHACHA_KEY_SIZE
-};
+enum { CRNG_RESEED_INTERVAL = 300 * HZ };
 
 static struct {
 	u8 key[CHACHA_KEY_SIZE] __aligned(__alignof__(long));
@@ -258,6 +255,8 @@ static DEFINE_PER_CPU(struct crng, crngs
 
 /* Used by crng_reseed() to extract a new seed from the input pool. */
 static bool drain_entropy(void *buf, size_t nbytes);
+/* Used by crng_make_state() to extract a new seed when crng_init==0. */
+static void extract_entropy(void *buf, size_t nbytes);
 
 /*
  * This extracts a new crng key from the input pool, but only if there is a
@@ -382,17 +381,20 @@ static void crng_make_state(u32 chacha_s
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
@@ -433,48 +435,6 @@ static void crng_make_state(u32 chacha_s
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
-		if (crng_init_cnt >= CRNG_INIT_CNT_THRESH)
-			crng_init = 1;
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
 	u32 chacha_state[CHACHA_BLOCK_SIZE / sizeof(u32)];
@@ -784,7 +744,8 @@ EXPORT_SYMBOL(get_random_bytes_arch);
 
 enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
-	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
+	POOL_MIN_BITS = POOL_BITS, /* No point in settling for less. */
+	POOL_FAST_INIT_BITS = POOL_MIN_BITS / 2
 };
 
 /* For notifying userspace should write into /dev/random. */
@@ -821,24 +782,6 @@ static void mix_pool_bytes(const void *i
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
@@ -904,6 +847,33 @@ static bool drain_entropy(void *buf, siz
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
@@ -946,9 +916,9 @@ static bool drain_entropy(void *buf, siz
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
@@ -1028,9 +998,6 @@ void add_device_randomness(const void *b
 	unsigned long entropy = random_get_entropy();
 	unsigned long flags;
 
-	if (crng_init == 0 && size)
-		crng_pre_init_inject(buf, size, false);
-
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&entropy, sizeof(entropy));
 	_mix_pool_bytes(buf, size);
@@ -1146,12 +1113,6 @@ void rand_initialize_disk(struct gendisk
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
@@ -1159,7 +1120,7 @@ void add_hwgenerator_randomness(const vo
 	 * CRNG_RESEED_INTERVAL has elapsed.
 	 */
 	wait_event_interruptible_timeout(random_write_wait,
-			!system_wq || kthread_should_stop() ||
+			kthread_should_stop() ||
 			input_pool.entropy_count < POOL_MIN_BITS,
 			CRNG_RESEED_INTERVAL);
 	mix_pool_bytes(buffer, count);
@@ -1168,17 +1129,14 @@ void add_hwgenerator_randomness(const vo
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
 
@@ -1278,13 +1236,8 @@ static void mix_interrupt_randomness(str
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
@@ -1306,8 +1259,7 @@ void add_interrupt_randomness(int irq)
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && (!time_is_before_jiffies(fast_pool->last + HZ) ||
-			       unlikely(crng_init == 0)))
+	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))



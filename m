Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C421558656
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiFWSLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbiFWSJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:09:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77AABC984;
        Thu, 23 Jun 2022 10:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41651B824C0;
        Thu, 23 Jun 2022 17:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCFEC341C4;
        Thu, 23 Jun 2022 17:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004798;
        bh=BsIlpdE+KmhuIdBEWeiOzWARtdOsO6CnWfQdEYiGL1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7FMB91cHCtyXKs8WjAxRAb8g5QDCrXDthaUTBg/o7QVp/36AXVtNhotmuCLVl5Si
         1sCkz0FD5JKMUwJcfGXi4mLL2oXdK99+CMeM1487eAly82/hrx8kh3AEd6B8rW/ksx
         VXMs+v5VodGUGkJx91TQBSaWaHXWK1s1kDBGpWzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 152/234] random: order timer entropy functions below interrupt functions
Date:   Thu, 23 Jun 2022 18:43:39 +0200
Message-Id: <20220623164347.356364797@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit a4b5c26b79ffdfcfb816c198f2fc2b1e7b5b580f upstream.

There are no code changes here; this is just a reordering of functions,
so that in subsequent commits, the timer entropy functions can call into
the interrupt ones.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  238 +++++++++++++++++++++++++-------------------------
 1 file changed, 119 insertions(+), 119 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -851,13 +851,13 @@ static void credit_init_bits(size_t nbit
  * the above entropy accumulation routines:
  *
  *	void add_device_randomness(const void *buf, size_t size);
- *	void add_input_randomness(unsigned int type, unsigned int code,
- *	                          unsigned int value);
- *	void add_disk_randomness(struct gendisk *disk);
  *	void add_hwgenerator_randomness(const void *buffer, size_t count,
  *					size_t entropy);
  *	void add_bootloader_randomness(const void *buf, size_t size);
  *	void add_interrupt_randomness(int irq);
+ *	void add_input_randomness(unsigned int type, unsigned int code,
+ *	                          unsigned int value);
+ *	void add_disk_randomness(struct gendisk *disk);
  *
  * add_device_randomness() adds data to the input pool that
  * is likely to differ between two devices (or possibly even per boot).
@@ -867,19 +867,6 @@ static void credit_init_bits(size_t nbit
  * that might otherwise be identical and have very little entropy
  * available to them (particularly common in the embedded world).
  *
- * add_input_randomness() uses the input layer interrupt timing, as well
- * as the event type information from the hardware.
- *
- * add_disk_randomness() uses what amounts to the seek time of block
- * layer request events, on a per-disk_devt basis, as input to the
- * entropy pool. Note that high-speed solid state drives with very low
- * seek times do not make for good sources of entropy, as their seek
- * times are usually fairly consistent.
- *
- * The above two routines try to estimate how many bits of entropy
- * to credit. They do this by keeping track of the first and second
- * order deltas of the event timings.
- *
  * add_hwgenerator_randomness() is for true hardware RNGs, and will credit
  * entropy as specified by the caller. If the entropy pool is full it will
  * block until more entropy is needed.
@@ -893,6 +880,19 @@ static void credit_init_bits(size_t nbit
  * as inputs, it feeds the input pool roughly once a second or after 64
  * interrupts, crediting 1 bit of entropy for whichever comes first.
  *
+ * add_input_randomness() uses the input layer interrupt timing, as well
+ * as the event type information from the hardware.
+ *
+ * add_disk_randomness() uses what amounts to the seek time of block
+ * layer request events, on a per-disk_devt basis, as input to the
+ * entropy pool. Note that high-speed solid state drives with very low
+ * seek times do not make for good sources of entropy, as their seek
+ * times are usually fairly consistent.
+ *
+ * The last two routines try to estimate how many bits of entropy
+ * to credit. They do this by keeping track of the first and second
+ * order deltas of the event timings.
+ *
  **********************************************************************/
 
 static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
@@ -970,109 +970,6 @@ void add_device_randomness(const void *b
 }
 EXPORT_SYMBOL(add_device_randomness);
 
-/* There is one of these per entropy source */
-struct timer_rand_state {
-	unsigned long last_time;
-	long last_delta, last_delta2;
-};
-
-/*
- * This function adds entropy to the entropy "pool" by using timing
- * delays.  It uses the timer_rand_state structure to make an estimate
- * of how many bits of entropy this call has added to the pool.
- *
- * The number "num" is also added to the pool - it should somehow describe
- * the type of event which just happened.  This is currently 0-255 for
- * keyboard scan codes, and 256 upwards for interrupts.
- */
-static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
-{
-	unsigned long entropy = random_get_entropy(), now = jiffies, flags;
-	long delta, delta2, delta3;
-
-	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(&entropy, sizeof(entropy));
-	_mix_pool_bytes(&num, sizeof(num));
-	spin_unlock_irqrestore(&input_pool.lock, flags);
-
-	if (crng_ready())
-		return;
-
-	/*
-	 * Calculate number of bits of randomness we probably added.
-	 * We take into account the first, second and third-order deltas
-	 * in order to make our estimate.
-	 */
-	delta = now - READ_ONCE(state->last_time);
-	WRITE_ONCE(state->last_time, now);
-
-	delta2 = delta - READ_ONCE(state->last_delta);
-	WRITE_ONCE(state->last_delta, delta);
-
-	delta3 = delta2 - READ_ONCE(state->last_delta2);
-	WRITE_ONCE(state->last_delta2, delta2);
-
-	if (delta < 0)
-		delta = -delta;
-	if (delta2 < 0)
-		delta2 = -delta2;
-	if (delta3 < 0)
-		delta3 = -delta3;
-	if (delta > delta2)
-		delta = delta2;
-	if (delta > delta3)
-		delta = delta3;
-
-	/*
-	 * delta is now minimum absolute delta.
-	 * Round down by 1 bit on general principles,
-	 * and limit entropy estimate to 12 bits.
-	 */
-	credit_init_bits(min_t(unsigned int, fls(delta >> 1), 11));
-}
-
-void add_input_randomness(unsigned int type, unsigned int code,
-			  unsigned int value)
-{
-	static unsigned char last_value;
-	static struct timer_rand_state input_timer_state = { INITIAL_JIFFIES };
-
-	/* Ignore autorepeat and the like. */
-	if (value == last_value)
-		return;
-
-	last_value = value;
-	add_timer_randomness(&input_timer_state,
-			     (type << 4) ^ code ^ (code >> 4) ^ value);
-}
-EXPORT_SYMBOL_GPL(add_input_randomness);
-
-#ifdef CONFIG_BLOCK
-void add_disk_randomness(struct gendisk *disk)
-{
-	if (!disk || !disk->random)
-		return;
-	/* First major is 1, so we get >= 0x200 here. */
-	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-}
-EXPORT_SYMBOL_GPL(add_disk_randomness);
-
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
 /*
  * Interface for in-kernel drivers of true hardware RNGs.
  * Those devices may produce endless random bits and will be throttled
@@ -1234,6 +1131,109 @@ void add_interrupt_randomness(int irq)
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
+/* There is one of these per entropy source */
+struct timer_rand_state {
+	unsigned long last_time;
+	long last_delta, last_delta2;
+};
+
+/*
+ * This function adds entropy to the entropy "pool" by using timing
+ * delays.  It uses the timer_rand_state structure to make an estimate
+ * of how many bits of entropy this call has added to the pool.
+ *
+ * The number "num" is also added to the pool - it should somehow describe
+ * the type of event which just happened.  This is currently 0-255 for
+ * keyboard scan codes, and 256 upwards for interrupts.
+ */
+static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
+{
+	unsigned long entropy = random_get_entropy(), now = jiffies, flags;
+	long delta, delta2, delta3;
+
+	spin_lock_irqsave(&input_pool.lock, flags);
+	_mix_pool_bytes(&entropy, sizeof(entropy));
+	_mix_pool_bytes(&num, sizeof(num));
+	spin_unlock_irqrestore(&input_pool.lock, flags);
+
+	if (crng_ready())
+		return;
+
+	/*
+	 * Calculate number of bits of randomness we probably added.
+	 * We take into account the first, second and third-order deltas
+	 * in order to make our estimate.
+	 */
+	delta = now - READ_ONCE(state->last_time);
+	WRITE_ONCE(state->last_time, now);
+
+	delta2 = delta - READ_ONCE(state->last_delta);
+	WRITE_ONCE(state->last_delta, delta);
+
+	delta3 = delta2 - READ_ONCE(state->last_delta2);
+	WRITE_ONCE(state->last_delta2, delta2);
+
+	if (delta < 0)
+		delta = -delta;
+	if (delta2 < 0)
+		delta2 = -delta2;
+	if (delta3 < 0)
+		delta3 = -delta3;
+	if (delta > delta2)
+		delta = delta2;
+	if (delta > delta3)
+		delta = delta3;
+
+	/*
+	 * delta is now minimum absolute delta.
+	 * Round down by 1 bit on general principles,
+	 * and limit entropy estimate to 12 bits.
+	 */
+	credit_init_bits(min_t(unsigned int, fls(delta >> 1), 11));
+}
+
+void add_input_randomness(unsigned int type, unsigned int code,
+			  unsigned int value)
+{
+	static unsigned char last_value;
+	static struct timer_rand_state input_timer_state = { INITIAL_JIFFIES };
+
+	/* Ignore autorepeat and the like. */
+	if (value == last_value)
+		return;
+
+	last_value = value;
+	add_timer_randomness(&input_timer_state,
+			     (type << 4) ^ code ^ (code >> 4) ^ value);
+}
+EXPORT_SYMBOL_GPL(add_input_randomness);
+
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
 /*
  * Each time the timer fires, we expect that we got an unpredictable
  * jump in the cycle counter. Even if the timer is running on another



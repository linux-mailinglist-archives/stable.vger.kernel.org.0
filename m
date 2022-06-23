Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB705583AD
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiFWRdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiFWRcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:32:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A375794EA;
        Thu, 23 Jun 2022 10:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7208CB82490;
        Thu, 23 Jun 2022 17:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1B1C3411B;
        Thu, 23 Jun 2022 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003918;
        bh=tcAM/eC3BOdTwND22cwidycAGAxgoJ+85Pt40fd/sjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyjqLuRYznDvK/vmJLw0TMa1a69Z4vNW0HXyylvH25UOwUPYY7BOLwgUtkeUbf5/o
         a1vg+td3iNJAUP05cQfq/47/9u6cCz7LITXev+i0pGhOwxVJTtH9nW24k1A7i9nmrs
         87h9G4htaoWXc6ZzC/zckbt37ZAU75cwtSFMUMgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 128/237] random: do crng pre-init loading in worker rather than irq
Date:   Thu, 23 Jun 2022 18:42:42 +0200
Message-Id: <20220623164346.836548669@linuxfoundation.org>
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

commit c2a7de4feb6e09f23af7accc0f882a8fa92e7ae5 upstream.

Taking spinlocks from IRQ context is generally problematic for
PREEMPT_RT. That is, in part, why we take trylocks instead. However, a
spin_try_lock() is also problematic since another spin_lock() invocation
can potentially PI-boost the wrong task, as the spin_try_lock() is
invoked from an IRQ-context, so the task on CPU (random task or idle) is
not the actual owner.

Additionally, by deferring the crng pre-init loading to the worker, we
can use the cryptographic hash function rather than xor, which is
perhaps a meaningful difference when considering this data has only been
through the relatively weak fast_mix() function.

The biggest downside of this approach is that the pre-init loading is
now deferred until later, which means things that need random numbers
after interrupts are enabled, but before workqueues are running -- or
before this particular worker manages to run -- are going to get into
trouble. Hopefully in the real world, this window is rather small,
especially since this code won't run until 64 interrupts had occurred.

Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   65 ++++++++++++++------------------------------------
 1 file changed, 19 insertions(+), 46 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -441,10 +441,6 @@ static void crng_make_state(u32 chacha_s
  * boot time when it's better to have something there rather than
  * nothing.
  *
- * There are two paths, a slow one and a fast one. The slow one
- * hashes the input along with the current key. The fast one simply
- * xors it in, and should only be used from interrupt context.
- *
  * If account is set, then the crng_init_cnt counter is incremented.
  * This shouldn't be set by functions like add_device_randomness(),
  * where we can't trust the buffer passed to it is guaranteed to be
@@ -453,19 +449,15 @@ static void crng_make_state(u32 chacha_s
  * Returns the number of bytes processed from input, which is bounded
  * by CRNG_INIT_CNT_THRESH if account is true.
  */
-static size_t crng_pre_init_inject(const void *input, size_t len,
-				   bool fast, bool account)
+static size_t crng_pre_init_inject(const void *input, size_t len, bool account)
 {
 	static int crng_init_cnt = 0;
+	struct blake2s_state hash;
 	unsigned long flags;
 
-	if (fast) {
-		if (!spin_trylock_irqsave(&base_crng.lock, flags))
-			return 0;
-	} else {
-		spin_lock_irqsave(&base_crng.lock, flags);
-	}
+	blake2s_init(&hash, sizeof(base_crng.key));
 
+	spin_lock_irqsave(&base_crng.lock, flags);
 	if (crng_init != 0) {
 		spin_unlock_irqrestore(&base_crng.lock, flags);
 		return 0;
@@ -474,21 +466,9 @@ static size_t crng_pre_init_inject(const
 	if (account)
 		len = min_t(size_t, len, CRNG_INIT_CNT_THRESH - crng_init_cnt);
 
-	if (fast) {
-		const u8 *src = input;
-		size_t i;
-
-		for (i = 0; i < len; ++i)
-			base_crng.key[(crng_init_cnt + i) %
-				      sizeof(base_crng.key)] ^= src[i];
-	} else {
-		struct blake2s_state hash;
-
-		blake2s_init(&hash, sizeof(base_crng.key));
-		blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
-		blake2s_update(&hash, input, len);
-		blake2s_final(&hash, base_crng.key);
-	}
+	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
+	blake2s_update(&hash, input, len);
+	blake2s_final(&hash, base_crng.key);
 
 	if (account) {
 		crng_init_cnt += len;
@@ -1029,7 +1009,7 @@ void add_device_randomness(const void *b
 	unsigned long flags, now = jiffies;
 
 	if (crng_init == 0 && size)
-		crng_pre_init_inject(buf, size, false, false);
+		crng_pre_init_inject(buf, size, false);
 
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&cycles, sizeof(cycles));
@@ -1150,7 +1130,7 @@ void add_hwgenerator_randomness(const vo
 				size_t entropy)
 {
 	if (unlikely(crng_init == 0)) {
-		size_t ret = crng_pre_init_inject(buffer, count, false, true);
+		size_t ret = crng_pre_init_inject(buffer, count, true);
 		mix_pool_bytes(buffer, ret);
 		count -= ret;
 		buffer += ret;
@@ -1290,8 +1270,14 @@ static void mix_interrupt_randomness(str
 	fast_pool->last = jiffies;
 	local_irq_enable();
 
-	mix_pool_bytes(pool, sizeof(pool));
-	credit_entropy_bits(1);
+	if (unlikely(crng_init == 0)) {
+		crng_pre_init_inject(pool, sizeof(pool), true);
+		mix_pool_bytes(pool, sizeof(pool));
+	} else {
+		mix_pool_bytes(pool, sizeof(pool));
+		credit_entropy_bits(1);
+	}
+
 	memzero_explicit(pool, sizeof(pool));
 }
 
@@ -1324,24 +1310,11 @@ void add_interrupt_randomness(int irq)
 	fast_mix(fast_pool->pool32);
 	new_count = ++fast_pool->count;
 
-	if (unlikely(crng_init == 0)) {
-		if (new_count >= 64 &&
-		    crng_pre_init_inject(fast_pool->pool32, sizeof(fast_pool->pool32),
-					 true, true) > 0) {
-			fast_pool->count = 0;
-			fast_pool->last = now;
-			if (spin_trylock(&input_pool.lock)) {
-				_mix_pool_bytes(&fast_pool->pool32, sizeof(fast_pool->pool32));
-				spin_unlock(&input_pool.lock);
-			}
-		}
-		return;
-	}
-
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && !time_after(now, fast_pool->last + HZ))
+	if (new_count < 64 && (!time_after(now, fast_pool->last + HZ) ||
+			       unlikely(crng_init == 0)))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))



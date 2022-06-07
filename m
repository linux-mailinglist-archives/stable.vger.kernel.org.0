Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1240536176
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiE0L4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352449AbiE0LzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E9A15AB09;
        Fri, 27 May 2022 04:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 949F6B824D8;
        Fri, 27 May 2022 11:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A7EC385A9;
        Fri, 27 May 2022 11:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652106;
        bh=ucDUMGX37eDIy4saYwPoYkShV8xHADijJcGiVrrzHbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf27RQhx1CqPkrvhYVGuQJ8nVJGW6VxEIgou2T86uIKO9PTAfP8lveqagHOG+6dS+
         rjchnNBaWVu5Rjda7SQkDRYhnsaQJ1+MO15XmVkNvA5UM4ldw4f96ePBIjM+4s0CTY
         XWArr+79hysOyqU3uFPqbBAfeDsyU2VSeLeqhP3I=
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
Subject: [PATCH 5.15 083/145] random: do crng pre-init loading in worker rather than irq
Date:   Fri, 27 May 2022 10:49:44 +0200
Message-Id: <20220527084900.691053723@linuxfoundation.org>
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
@@ -443,10 +443,6 @@ static void crng_make_state(u32 chacha_s
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
@@ -455,19 +451,15 @@ static void crng_make_state(u32 chacha_s
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
@@ -476,21 +468,9 @@ static size_t crng_pre_init_inject(const
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
@@ -1034,7 +1014,7 @@ void add_device_randomness(const void *b
 	unsigned long flags, now = jiffies;
 
 	if (crng_init == 0 && size)
-		crng_pre_init_inject(buf, size, false, false);
+		crng_pre_init_inject(buf, size, false);
 
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&cycles, sizeof(cycles));
@@ -1155,7 +1135,7 @@ void add_hwgenerator_randomness(const vo
 				size_t entropy)
 {
 	if (unlikely(crng_init == 0)) {
-		size_t ret = crng_pre_init_inject(buffer, count, false, true);
+		size_t ret = crng_pre_init_inject(buffer, count, true);
 		mix_pool_bytes(buffer, ret);
 		count -= ret;
 		buffer += ret;
@@ -1295,8 +1275,14 @@ static void mix_interrupt_randomness(str
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
 
@@ -1329,24 +1315,11 @@ void add_interrupt_randomness(int irq)
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



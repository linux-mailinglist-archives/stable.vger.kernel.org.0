Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB61536115
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiE0L4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352359AbiE0LzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FAB15A74F;
        Fri, 27 May 2022 04:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2CC061D56;
        Fri, 27 May 2022 11:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC785C385A9;
        Fri, 27 May 2022 11:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652097;
        bh=R5S11L18U+ycjIsCbQywW4B/Thxu/hrtB6rymJ6gJS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJmH2ff7mfBVjNn/jzawJboZ91Xukyf/E9u163R/rRP0rQ0L9Ra8GMgn7APt0/yMb
         pGzO9waDIl2h5II+y/kKo67hTsbqdlzvEcE/EJKSb7Uwt48aoPswikid9lIh2LXilP
         znFzitLpiJ5yyyWEe/yegzlyu2jYfboKAipxJQ5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 082/145] random: unify cycles_t and jiffies usage and types
Date:   Fri, 27 May 2022 10:49:43 +0200
Message-Id: <20220527084900.565605669@linuxfoundation.org>
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

commit abded93ec1e9692920fe309f07f40bd1035f2940 upstream.

random_get_entropy() returns a cycles_t, not an unsigned long, which is
sometimes 64 bits on various 32-bit platforms, including x86.
Conversely, jiffies is always unsigned long. This commit fixes things to
use cycles_t for fields that use random_get_entropy(), named "cycles",
and unsigned long for fields that use jiffies, named "now". It's also
good to mix in a cycles_t and a jiffies in the same way for both
add_device_randomness and add_timer_randomness, rather than using xor in
one case. Finally, we unify the order of these volatile reads, always
reading the more precise cycles counter, and then jiffies, so that the
cycle counter is as close to the event as possible.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   56 ++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1020,12 +1020,6 @@ int __init rand_initialize(void)
 	return 0;
 }
 
-/* There is one of these per entropy source */
-struct timer_rand_state {
-	cycles_t last_time;
-	long last_delta, last_delta2;
-};
-
 /*
  * Add device- or boot-specific data to the input pool to help
  * initialize it.
@@ -1036,19 +1030,26 @@ struct timer_rand_state {
  */
 void add_device_randomness(const void *buf, size_t size)
 {
-	unsigned long time = random_get_entropy() ^ jiffies;
-	unsigned long flags;
+	cycles_t cycles = random_get_entropy();
+	unsigned long flags, now = jiffies;
 
 	if (crng_init == 0 && size)
 		crng_pre_init_inject(buf, size, false, false);
 
 	spin_lock_irqsave(&input_pool.lock, flags);
+	_mix_pool_bytes(&cycles, sizeof(cycles));
+	_mix_pool_bytes(&now, sizeof(now));
 	_mix_pool_bytes(buf, size);
-	_mix_pool_bytes(&time, sizeof(time));
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 EXPORT_SYMBOL(add_device_randomness);
 
+/* There is one of these per entropy source */
+struct timer_rand_state {
+	unsigned long last_time;
+	long last_delta, last_delta2;
+};
+
 /*
  * This function adds entropy to the entropy "pool" by using timing
  * delays.  It uses the timer_rand_state structure to make an estimate
@@ -1057,29 +1058,26 @@ EXPORT_SYMBOL(add_device_randomness);
  * The number "num" is also added to the pool - it should somehow describe
  * the type of event which just happened.  This is currently 0-255 for
  * keyboard scan codes, and 256 upwards for interrupts.
- *
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
 {
-	struct {
-		long jiffies;
-		unsigned int cycles;
-		unsigned int num;
-	} sample;
+	cycles_t cycles = random_get_entropy();
+	unsigned long flags, now = jiffies;
 	long delta, delta2, delta3;
 
-	sample.jiffies = jiffies;
-	sample.cycles = random_get_entropy();
-	sample.num = num;
-	mix_pool_bytes(&sample, sizeof(sample));
+	spin_lock_irqsave(&input_pool.lock, flags);
+	_mix_pool_bytes(&cycles, sizeof(cycles));
+	_mix_pool_bytes(&now, sizeof(now));
+	_mix_pool_bytes(&num, sizeof(num));
+	spin_unlock_irqrestore(&input_pool.lock, flags);
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
 	 * We take into account the first, second and third-order deltas
 	 * in order to make our estimate.
 	 */
-	delta = sample.jiffies - READ_ONCE(state->last_time);
-	WRITE_ONCE(state->last_time, sample.jiffies);
+	delta = now - READ_ONCE(state->last_time);
+	WRITE_ONCE(state->last_time, now);
 
 	delta2 = delta - READ_ONCE(state->last_delta);
 	WRITE_ONCE(state->last_delta, delta);
@@ -1305,10 +1303,10 @@ static void mix_interrupt_randomness(str
 void add_interrupt_randomness(int irq)
 {
 	enum { MIX_INFLIGHT = 1U << 31 };
+	cycles_t cycles = random_get_entropy();
+	unsigned long now = jiffies;
 	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs *regs = get_irq_regs();
-	unsigned long now = jiffies;
-	cycles_t cycles = random_get_entropy();
 	unsigned int new_count;
 
 	if (cycles == 0)
@@ -1383,28 +1381,28 @@ static void entropy_timer(struct timer_l
 static void try_to_generate_entropy(void)
 {
 	struct {
-		unsigned long now;
+		cycles_t cycles;
 		struct timer_list timer;
 	} stack;
 
-	stack.now = random_get_entropy();
+	stack.cycles = random_get_entropy();
 
 	/* Slow counter - or none. Don't even bother */
-	if (stack.now == random_get_entropy())
+	if (stack.cycles == random_get_entropy())
 		return;
 
 	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
 	while (!crng_ready()) {
 		if (!timer_pending(&stack.timer))
 			mod_timer(&stack.timer, jiffies + 1);
-		mix_pool_bytes(&stack.now, sizeof(stack.now));
+		mix_pool_bytes(&stack.cycles, sizeof(stack.cycles));
 		schedule();
-		stack.now = random_get_entropy();
+		stack.cycles = random_get_entropy();
 	}
 
 	del_timer_sync(&stack.timer);
 	destroy_timer_on_stack(&stack.timer);
-	mix_pool_bytes(&stack.now, sizeof(stack.now));
+	mix_pool_bytes(&stack.cycles, sizeof(stack.cycles));
 }
 
 



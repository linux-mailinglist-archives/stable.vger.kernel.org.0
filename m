Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D055583BE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiFWReU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbiFWRc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:32:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC18C794E6;
        Thu, 23 Jun 2022 10:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70E4AB8248E;
        Thu, 23 Jun 2022 17:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE853C3411B;
        Thu, 23 Jun 2022 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003915;
        bh=qy+mcBOZibGTPH8Xnp59S+ttPXMaFUfHQ9McGWl18NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQMg6SGrnYA4lEkOJWiicY8q4B2BRoWp4CI32tJsLP5va5hrV1T8JDRtI81i2fMnf
         n4NUzuI2+WDIz1xiS/rm1wZuB2mwD8eSIB0cOsR3RIi6001VEiXRzWZGnY9+jkbNC0
         yJ7ghyHmyUgGLObc8rY0WJNa9CKlnwFc96JIYTQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 127/237] random: unify cycles_t and jiffies usage and types
Date:   Thu, 23 Jun 2022 18:42:41 +0200
Message-Id: <20220623164346.808339914@linuxfoundation.org>
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
@@ -1015,12 +1015,6 @@ int __init rand_initialize(void)
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
@@ -1031,19 +1025,26 @@ struct timer_rand_state {
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
@@ -1052,29 +1053,26 @@ EXPORT_SYMBOL(add_device_randomness);
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
-	delta = sample.jiffies - state->last_time;
-	state->last_time = sample.jiffies;
+	delta = now - READ_ONCE(state->last_time);
+	WRITE_ONCE(state->last_time, now);
 
 	delta2 = delta - state->last_delta;
 	state->last_delta = delta;
@@ -1300,10 +1298,10 @@ static void mix_interrupt_randomness(str
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
@@ -1378,28 +1376,28 @@ static void entropy_timer(unsigned long
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
 
 	__setup_timer_on_stack(&stack.timer, entropy_timer, 0, 0);
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
 
 



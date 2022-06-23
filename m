Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2A7558678
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbiFWSNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236632AbiFWSMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:12:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E59ABEAAA;
        Thu, 23 Jun 2022 10:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C102561E07;
        Thu, 23 Jun 2022 17:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A560BC3411B;
        Thu, 23 Jun 2022 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004852;
        bh=dYx8PdSREqiQ5TasPNKE71jnKx6CBu7ljjQxcwdD4tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsPYeaRE0OPtzK/Jtc95j2TOA3eZrY2vhs9oKcmZPfhwMuTYuZFnppSjuGJUFBeeZ
         fQuvpZpae1aGuLFfw5tnbQOFb7C2wiRrlFRzPxjq+oxN1w7MZ9Uvut5JnMrqo1lMsj
         +gavF5ric/TvdpK6FiuVQJfryz5PnILUj2erIXTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Tso <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 131/234] random: make random_get_entropy() return an unsigned long
Date:   Thu, 23 Jun 2022 18:43:18 +0200
Message-Id: <20220623164346.765491277@linuxfoundation.org>
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

commit b0c3e796f24b588b862b61ce235d3c9417dc8983 upstream.

Some implementations were returning type `unsigned long`, while others
that fell back to get_cycles() were implicitly returning a `cycles_t` or
an untyped constant int literal. That makes for weird and confusing
code, and basically all code in the kernel already handled it like it
was an `unsigned long`. I recently tried to handle it as the largest
type it could be, a `cycles_t`, but doing so doesn't really help with
much.

Instead let's just make random_get_entropy() return an unsigned long all
the time. This also matches the commonly used `arch_get_random_long()`
function, so now RDRAND and RDTSC return the same sized integer, which
means one can fallback to the other more gracefully.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   20 +++++++-------------
 include/linux/timex.h |    2 +-
 2 files changed, 8 insertions(+), 14 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1010,7 +1010,7 @@ int __init rand_initialize(void)
  */
 void add_device_randomness(const void *buf, size_t size)
 {
-	cycles_t cycles = random_get_entropy();
+	unsigned long cycles = random_get_entropy();
 	unsigned long flags, now = jiffies;
 
 	if (crng_init == 0 && size)
@@ -1041,8 +1041,7 @@ struct timer_rand_state {
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
 {
-	cycles_t cycles = random_get_entropy();
-	unsigned long flags, now = jiffies;
+	unsigned long cycles = random_get_entropy(), now = jiffies, flags;
 	long delta, delta2, delta3;
 
 	spin_lock_irqsave(&input_pool.lock, flags);
@@ -1297,8 +1296,7 @@ static void mix_interrupt_randomness(str
 void add_interrupt_randomness(int irq)
 {
 	enum { MIX_INFLIGHT = 1U << 31 };
-	cycles_t cycles = random_get_entropy();
-	unsigned long now = jiffies;
+	unsigned long cycles = random_get_entropy(), now = jiffies;
 	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs *regs = get_irq_regs();
 	unsigned int new_count;
@@ -1311,16 +1309,12 @@ void add_interrupt_randomness(int irq)
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
 
-	if (sizeof(cycles) == 8)
+	if (sizeof(unsigned long) == 8) {
 		irq_data.u64[0] = cycles ^ rol64(now, 32) ^ irq;
-	else {
+		irq_data.u64[1] = regs ? instruction_pointer(regs) : _RET_IP_;
+	} else {
 		irq_data.u32[0] = cycles ^ irq;
 		irq_data.u32[1] = now;
-	}
-
-	if (sizeof(unsigned long) == 8)
-		irq_data.u64[1] = regs ? instruction_pointer(regs) : _RET_IP_;
-	else {
 		irq_data.u32[2] = regs ? instruction_pointer(regs) : _RET_IP_;
 		irq_data.u32[3] = get_reg(fast_pool, regs);
 	}
@@ -1367,7 +1361,7 @@ static void entropy_timer(struct timer_l
 static void try_to_generate_entropy(void)
 {
 	struct {
-		cycles_t cycles;
+		unsigned long cycles;
 		struct timer_list timer;
 	} stack;
 
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -75,7 +75,7 @@
  * By default we use get_cycles() for this purpose, but individual
  * architectures may override this in their asm/timex.h header file.
  */
-#define random_get_entropy()	get_cycles()
+#define random_get_entropy()	((unsigned long)get_cycles())
 #endif
 
 /*



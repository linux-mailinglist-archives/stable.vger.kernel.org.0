Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40115361F8
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbiE0MEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbiE0MDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:03:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FADC13F901;
        Fri, 27 May 2022 04:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FC3FB824DB;
        Fri, 27 May 2022 11:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0362AC34113;
        Fri, 27 May 2022 11:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652400;
        bh=FVpHXI555YUQmGU2P4miUy2Og3ZlmqL89Ww1emC9GE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVuEdC1QB9WiKpWV+tYCywaJqwOr0ER/IVcPqKgzMmzYYaBNo1z5BdpcSB8Ldz+0K
         JNxVW+rOsmY9wq6rG0rluJcPum7Tco76codhfe/xVojcadQ/bCXbIk4riUD/kBU2/z
         gNzR5v7SjmulG1jEPQBW1t3qInYUGSvWSpl07Cos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 137/163] random: insist on random_get_entropy() existing in order to simplify
Date:   Fri, 27 May 2022 10:50:17 +0200
Message-Id: <20220527084847.284765124@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

commit 4b758eda851eb9336ca86a0041a4d3da55f66511 upstream.

All platforms are now guaranteed to provide some value for
random_get_entropy(). In case some bug leads to this not being so, we
print a warning, because that indicates that something is really very
wrong (and likely other things are impacted too). This should never be
hit, but it's a good and cheap way of finding out if something ever is
problematic.

Since we now have viable fallback code for random_get_entropy() on all
platforms, which is, in the worst case, not worse than jiffies, we can
count on getting the best possible value out of it. That means there's
no longer a use for using jiffies as entropy input. It also means we no
longer have a reason for doing the round-robin register flow in the IRQ
handler, which was always of fairly dubious value.

Instead we can greatly simplify the IRQ handler inputs and also unify
the construction between 64-bits and 32-bits. We now collect the cycle
counter and the return address, since those are the two things that
matter. Because the return address and the irq number are likely
related, to the extent we mix in the irq number, we can just xor it into
the top unchanging bytes of the return address, rather than the bottom
changing bytes of the cycle counter as before. Then, we can do a fixed 2
rounds of SipHash/HSipHash. Finally, we use the same construction of
hashing only half of the [H]SipHash state on 32-bit and 64-bit. We're
not actually discarding any entropy, since that entropy is carried
through until the next time. And more importantly, it lets us do the
same sponge-like construction everywhere.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   86 +++++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 60 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1022,15 +1022,14 @@ int __init rand_initialize(void)
  */
 void add_device_randomness(const void *buf, size_t size)
 {
-	unsigned long cycles = random_get_entropy();
-	unsigned long flags, now = jiffies;
+	unsigned long entropy = random_get_entropy();
+	unsigned long flags;
 
 	if (crng_init == 0 && size)
 		crng_pre_init_inject(buf, size, false);
 
 	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(&cycles, sizeof(cycles));
-	_mix_pool_bytes(&now, sizeof(now));
+	_mix_pool_bytes(&entropy, sizeof(entropy));
 	_mix_pool_bytes(buf, size);
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
@@ -1053,12 +1052,11 @@ struct timer_rand_state {
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned int num)
 {
-	unsigned long cycles = random_get_entropy(), now = jiffies, flags;
+	unsigned long entropy = random_get_entropy(), now = jiffies, flags;
 	long delta, delta2, delta3;
 
 	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(&cycles, sizeof(cycles));
-	_mix_pool_bytes(&now, sizeof(now));
+	_mix_pool_bytes(&entropy, sizeof(entropy));
 	_mix_pool_bytes(&num, sizeof(num));
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 
@@ -1186,7 +1184,6 @@ struct fast_pool {
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
-	u16 reg_idx;
 };
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
@@ -1204,13 +1201,13 @@ static DEFINE_PER_CPU(struct fast_pool,
  * This is [Half]SipHash-1-x, starting from an empty key. Because
  * the key is fixed, it assumes that its inputs are non-malicious,
  * and therefore this has no security on its own. s represents the
- * 128 or 256-bit SipHash state, while v represents a 128-bit input.
+ * four-word SipHash state, while v represents a two-word input.
  */
-static void fast_mix(unsigned long s[4], const unsigned long *v)
+static void fast_mix(unsigned long s[4], const unsigned long v[2])
 {
 	size_t i;
 
-	for (i = 0; i < 16 / sizeof(long); ++i) {
+	for (i = 0; i < 2; ++i) {
 		s[3] ^= v[i];
 #ifdef CONFIG_64BIT
 		s[0] += s[1]; s[1] = rol64(s[1], 13); s[1] ^= s[0]; s[0] = rol64(s[0], 32);
@@ -1250,33 +1247,17 @@ int random_online_cpu(unsigned int cpu)
 }
 #endif
 
-static unsigned long get_reg(struct fast_pool *f, struct pt_regs *regs)
-{
-	unsigned long *ptr = (unsigned long *)regs;
-	unsigned int idx;
-
-	if (regs == NULL)
-		return 0;
-	idx = READ_ONCE(f->reg_idx);
-	if (idx >= sizeof(struct pt_regs) / sizeof(unsigned long))
-		idx = 0;
-	ptr += idx++;
-	WRITE_ONCE(f->reg_idx, idx);
-	return *ptr;
-}
-
 static void mix_interrupt_randomness(struct work_struct *work)
 {
 	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
 	/*
-	 * The size of the copied stack pool is explicitly 16 bytes so that we
-	 * tax mix_pool_byte()'s compression function the same amount on all
-	 * platforms. This means on 64-bit we copy half the pool into this,
-	 * while on 32-bit we copy all of it. The entropy is supposed to be
-	 * sufficiently dispersed between bits that in the sponge-like
-	 * half case, on average we don't wind up "losing" some.
+	 * The size of the copied stack pool is explicitly 2 longs so that we
+	 * only ever ingest half of the siphash output each time, retaining
+	 * the other half as the next "key" that carries over. The entropy is
+	 * supposed to be sufficiently dispersed between bits so on average
+	 * we don't wind up "losing" some.
 	 */
-	u8 pool[16];
+	unsigned long pool[2];
 
 	/* Check to see if we're running on the wrong CPU due to hotplug. */
 	local_irq_disable();
@@ -1308,36 +1289,21 @@ static void mix_interrupt_randomness(str
 void add_interrupt_randomness(int irq)
 {
 	enum { MIX_INFLIGHT = 1U << 31 };
-	unsigned long cycles = random_get_entropy(), now = jiffies;
+	unsigned long entropy = random_get_entropy();
 	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs *regs = get_irq_regs();
 	unsigned int new_count;
-	union {
-		u32 u32[4];
-		u64 u64[2];
-		unsigned long longs[16 / sizeof(long)];
-	} irq_data;
-
-	if (cycles == 0)
-		cycles = get_reg(fast_pool, regs);
-
-	if (sizeof(unsigned long) == 8) {
-		irq_data.u64[0] = cycles ^ rol64(now, 32) ^ irq;
-		irq_data.u64[1] = regs ? instruction_pointer(regs) : _RET_IP_;
-	} else {
-		irq_data.u32[0] = cycles ^ irq;
-		irq_data.u32[1] = now;
-		irq_data.u32[2] = regs ? instruction_pointer(regs) : _RET_IP_;
-		irq_data.u32[3] = get_reg(fast_pool, regs);
-	}
 
-	fast_mix(fast_pool->pool, irq_data.longs);
+	fast_mix(fast_pool->pool, (unsigned long[2]){
+		entropy,
+		(regs ? instruction_pointer(regs) : _RET_IP_) ^ swab(irq)
+	});
 	new_count = ++fast_pool->count;
 
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && (!time_after(now, fast_pool->last + HZ) ||
+	if (new_count < 64 && (!time_is_before_jiffies(fast_pool->last + HZ) ||
 			       unlikely(crng_init == 0)))
 		return;
 
@@ -1373,28 +1339,28 @@ static void entropy_timer(struct timer_l
 static void try_to_generate_entropy(void)
 {
 	struct {
-		unsigned long cycles;
+		unsigned long entropy;
 		struct timer_list timer;
 	} stack;
 
-	stack.cycles = random_get_entropy();
+	stack.entropy = random_get_entropy();
 
 	/* Slow counter - or none. Don't even bother */
-	if (stack.cycles == random_get_entropy())
+	if (stack.entropy == random_get_entropy())
 		return;
 
 	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
 	while (!crng_ready() && !signal_pending(current)) {
 		if (!timer_pending(&stack.timer))
 			mod_timer(&stack.timer, jiffies + 1);
-		mix_pool_bytes(&stack.cycles, sizeof(stack.cycles));
+		mix_pool_bytes(&stack.entropy, sizeof(stack.entropy));
 		schedule();
-		stack.cycles = random_get_entropy();
+		stack.entropy = random_get_entropy();
 	}
 
 	del_timer_sync(&stack.timer);
 	destroy_timer_on_stack(&stack.timer);
-	mix_pool_bytes(&stack.cycles, sizeof(stack.cycles));
+	mix_pool_bytes(&stack.entropy, sizeof(stack.entropy));
 }
 
 



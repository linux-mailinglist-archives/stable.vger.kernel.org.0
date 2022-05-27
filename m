Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209545360EF
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbiE0Lyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352167AbiE0LyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25CE15897C;
        Fri, 27 May 2022 04:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F7561D96;
        Fri, 27 May 2022 11:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBE2C385A9;
        Fri, 27 May 2022 11:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652067;
        bh=kK+727lFJ/EMNk+O4EfQALlAPBxYd7tgSmT3zvBhMYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaZRa9Uh7ZIMp9M/gw2qCzfe0+PLCEcecVcE4X57r2zgeT0d45DHFKfNBaiUFOani
         zsw3k/FsUmvnMxmJhvz1vFd43ESpibN1iATSTKK/ZiWe3b8tV8WUeT42YDSP+xx2bW
         CIOP3vNGFwGaHjZoe4giO85L391+e2+uMwbZp7HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Theodore Tso <tytso@mit.edu>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 073/145] random: defer fast pool mixing to worker
Date:   Fri, 27 May 2022 10:49:34 +0200
Message-Id: <20220527084859.383947660@linuxfoundation.org>
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

commit 58340f8e952b613e0ead0bed58b97b05bf4743c5 upstream.

On PREEMPT_RT, it's problematic to take spinlocks from hard irq
handlers. We can fix this by deferring to a workqueue the dumping of
the fast pool into the input pool.

We accomplish this with some careful rules on fast_pool->count:

  - When it's incremented to >= 64, we schedule the work.
  - If the top bit is set, we never schedule the work, even if >= 64.
  - The worker is responsible for setting it back to 0 when it's done.

There are two small issues around using workqueues for this purpose that
we work around.

The first issue is that mix_interrupt_randomness() might be migrated to
another CPU during CPU hotplug. This issue is rectified by checking that
it hasn't been migrated (after disabling irqs). If it has been migrated,
then we set the count to zero, so that when the CPU comes online again,
it can requeue the work. As part of this, we switch to using an
atomic_t, so that the increment in the irq handler doesn't wipe out the
zeroing if the CPU comes back online while this worker is running.

The second issue is that, though relatively minor in effect, we probably
want to make sure we get a consistent view of the pool onto the stack,
in case it's interrupted by an irq while reading. To do this, we don't
reenable irqs until after the copy. There are only 18 instructions
between the cli and sti, so this is a pretty tiny window.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sultan Alsawaf <sultan@kerneltoast.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   63 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 14 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1178,9 +1178,10 @@ struct fast_pool {
 		u32 pool32[4];
 		u64 pool64[2];
 	};
+	struct work_struct mix;
 	unsigned long last;
+	atomic_t count;
 	u16 reg_idx;
-	u8 count;
 };
 
 /*
@@ -1230,12 +1231,49 @@ static u32 get_reg(struct fast_pool *f,
 	return *ptr;
 }
 
+static void mix_interrupt_randomness(struct work_struct *work)
+{
+	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
+	u32 pool[4];
+
+	/* Check to see if we're running on the wrong CPU due to hotplug. */
+	local_irq_disable();
+	if (fast_pool != this_cpu_ptr(&irq_randomness)) {
+		local_irq_enable();
+		/*
+		 * If we are unlucky enough to have been moved to another CPU,
+		 * during CPU hotplug while the CPU was shutdown then we set
+		 * our count to zero atomically so that when the CPU comes
+		 * back online, it can enqueue work again. The _release here
+		 * pairs with the atomic_inc_return_acquire in
+		 * add_interrupt_randomness().
+		 */
+		atomic_set_release(&fast_pool->count, 0);
+		return;
+	}
+
+	/*
+	 * Copy the pool to the stack so that the mixer always has a
+	 * consistent view, before we reenable irqs again.
+	 */
+	memcpy(pool, fast_pool->pool32, sizeof(pool));
+	atomic_set(&fast_pool->count, 0);
+	fast_pool->last = jiffies;
+	local_irq_enable();
+
+	mix_pool_bytes(pool, sizeof(pool));
+	credit_entropy_bits(1);
+	memzero_explicit(pool, sizeof(pool));
+}
+
 void add_interrupt_randomness(int irq)
 {
+	enum { MIX_INFLIGHT = 1U << 31 };
 	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs *regs = get_irq_regs();
 	unsigned long now = jiffies;
 	cycles_t cycles = random_get_entropy();
+	unsigned int new_count;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1255,12 +1293,13 @@ void add_interrupt_randomness(int irq)
 	}
 
 	fast_mix(fast_pool->pool32);
-	++fast_pool->count;
+	/* The _acquire here pairs with the atomic_set_release in mix_interrupt_randomness(). */
+	new_count = (unsigned int)atomic_inc_return_acquire(&fast_pool->count);
 
 	if (unlikely(crng_init == 0)) {
-		if (fast_pool->count >= 64 &&
+		if (new_count >= 64 &&
 		    crng_fast_load(fast_pool->pool32, sizeof(fast_pool->pool32)) > 0) {
-			fast_pool->count = 0;
+			atomic_set(&fast_pool->count, 0);
 			fast_pool->last = now;
 			if (spin_trylock(&input_pool.lock)) {
 				_mix_pool_bytes(&fast_pool->pool32, sizeof(fast_pool->pool32));
@@ -1270,20 +1309,16 @@ void add_interrupt_randomness(int irq)
 		return;
 	}
 
-	if ((fast_pool->count < 64) && !time_after(now, fast_pool->last + HZ))
+	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (!spin_trylock(&input_pool.lock))
+	if (new_count < 64 && !time_after(now, fast_pool->last + HZ))
 		return;
 
-	fast_pool->last = now;
-	_mix_pool_bytes(&fast_pool->pool32, sizeof(fast_pool->pool32));
-	spin_unlock(&input_pool.lock);
-
-	fast_pool->count = 0;
-
-	/* Award one bit for the contents of the fast pool. */
-	credit_entropy_bits(1);
+	if (unlikely(!fast_pool->mix.func))
+		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
+	atomic_or(MIX_INFLIGHT, &fast_pool->count);
+	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 



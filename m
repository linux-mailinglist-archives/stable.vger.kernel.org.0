Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A3F558056
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiFWQqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiFWQqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433E049264;
        Thu, 23 Jun 2022 09:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1316B82486;
        Thu, 23 Jun 2022 16:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCFDC3411B;
        Thu, 23 Jun 2022 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002774;
        bh=iB1+qzG8LI8uqYcAj/yF5Vz5fcVlgJ6e25IFzF7B2o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROdmonJZ0R06XBpUfJK4LmurKhMyrSe9MFWOAJREv1Ufk3BHOoEYhs4BeZvHQTb19
         Zu+6nmZ1rnyV+CYXK+ZcDqjkm8GaA41l7X8alVLu/XZNicO5NUabd2teOSl9Wzd4/g
         3mdQ8QntWTw43+srXpu848oojt05Pe7Mv5lyp1qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 021/264] random: add a spinlock_t to struct batched_entropy
Date:   Thu, 23 Jun 2022 18:40:14 +0200
Message-Id: <20220623164344.665965711@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit b7d5dc21072cda7124d13eae2aefb7343ef94197 ]

The per-CPU variable batched_entropy_uXX is protected by get_cpu_var().
This is just a preempt_disable() which ensures that the variable is only
from the local CPU. It does not protect against users on the same CPU
from another context. It is possible that a preemptible context reads
slot 0 and then an interrupt occurs and the same value is read again.

The above scenario is confirmed by lockdep if we add a spinlock:
| ================================
| WARNING: inconsistent lock state
| 5.1.0-rc3+ #42 Not tainted
| --------------------------------
| inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
| ksoftirqd/9/56 [HC0[0]:SC1[1]:HE0:SE0] takes:
| (____ptrval____) (batched_entropy_u32.lock){+.?.}, at: get_random_u32+0x3e/0xe0
| {SOFTIRQ-ON-W} state was registered at:
|   _raw_spin_lock+0x2a/0x40
|   get_random_u32+0x3e/0xe0
|   new_slab+0x15c/0x7b0
|   ___slab_alloc+0x492/0x620
|   __slab_alloc.isra.73+0x53/0xa0
|   kmem_cache_alloc_node+0xaf/0x2a0
|   copy_process.part.41+0x1e1/0x2370
|   _do_fork+0xdb/0x6d0
|   kernel_thread+0x20/0x30
|   kthreadd+0x1ba/0x220
|   ret_from_fork+0x3a/0x50
…
| other info that might help us debug this:
|  Possible unsafe locking scenario:
|
|        CPU0
|        ----
|   lock(batched_entropy_u32.lock);
|   <Interrupt>
|     lock(batched_entropy_u32.lock);
|
|  *** DEADLOCK ***
|
| stack backtrace:
| Call Trace:
…
|  kmem_cache_alloc_trace+0x20e/0x270
|  ipmi_alloc_recv_msg+0x16/0x40
…
|  __do_softirq+0xec/0x48d
|  run_ksoftirqd+0x37/0x60
|  smpboot_thread_fn+0x191/0x290
|  kthread+0xfe/0x130
|  ret_from_fork+0x3a/0x50

Add a spinlock_t to the batched_entropy data structure and acquire the
lock while accessing it. Acquire the lock with disabled interrupts
because this function may be used from interrupt context.

Remove the batched_entropy_reset_lock lock. Now that we have a lock for
the data scructure, we can access it from a remote CPU.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   52 +++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2228,8 +2228,8 @@ struct batched_entropy {
 		u32 entropy_u32[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	};
 	unsigned int position;
+	spinlock_t batch_lock;
 };
-static rwlock_t batched_entropy_reset_lock = __RW_LOCK_UNLOCKED(batched_entropy_reset_lock);
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
@@ -2239,12 +2239,14 @@ static rwlock_t batched_entropy_reset_lo
  * wait_for_random_bytes() should be called and return 0 at least once
  * at any point prior.
  */
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
+	.batch_lock	= __SPIN_LOCK_UNLOCKED(batched_entropy_u64.lock),
+};
+
 u64 get_random_u64(void)
 {
 	u64 ret;
-	bool use_lock;
-	unsigned long flags = 0;
+	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
 
@@ -2259,28 +2261,25 @@ u64 get_random_u64(void)
 
 	warn_unseeded_randomness(&previous);
 
-	use_lock = READ_ONCE(crng_init) < 2;
-	batch = &get_cpu_var(batched_entropy_u64);
-	if (use_lock)
-		read_lock_irqsave(&batched_entropy_reset_lock, flags);
+	batch = raw_cpu_ptr(&batched_entropy_u64);
+	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
 		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u64[batch->position++];
-	if (use_lock)
-		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
-	put_cpu_var(batched_entropy_u64);
+	spin_unlock_irqrestore(&batch->batch_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u64);
 
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32);
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
+	.batch_lock	= __SPIN_LOCK_UNLOCKED(batched_entropy_u32.lock),
+};
 u32 get_random_u32(void)
 {
 	u32 ret;
-	bool use_lock;
-	unsigned long flags = 0;
+	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
 
@@ -2289,18 +2288,14 @@ u32 get_random_u32(void)
 
 	warn_unseeded_randomness(&previous);
 
-	use_lock = READ_ONCE(crng_init) < 2;
-	batch = &get_cpu_var(batched_entropy_u32);
-	if (use_lock)
-		read_lock_irqsave(&batched_entropy_reset_lock, flags);
+	batch = raw_cpu_ptr(&batched_entropy_u32);
+	spin_lock_irqsave(&batch->batch_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
 		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u32[batch->position++];
-	if (use_lock)
-		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
-	put_cpu_var(batched_entropy_u32);
+	spin_unlock_irqrestore(&batch->batch_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u32);
@@ -2314,12 +2309,19 @@ static void invalidate_batched_entropy(v
 	int cpu;
 	unsigned long flags;
 
-	write_lock_irqsave(&batched_entropy_reset_lock, flags);
 	for_each_possible_cpu (cpu) {
-		per_cpu_ptr(&batched_entropy_u32, cpu)->position = 0;
-		per_cpu_ptr(&batched_entropy_u64, cpu)->position = 0;
+		struct batched_entropy *batched_entropy;
+
+		batched_entropy = per_cpu_ptr(&batched_entropy_u32, cpu);
+		spin_lock_irqsave(&batched_entropy->batch_lock, flags);
+		batched_entropy->position = 0;
+		spin_unlock(&batched_entropy->batch_lock);
+
+		batched_entropy = per_cpu_ptr(&batched_entropy_u64, cpu);
+		spin_lock(&batched_entropy->batch_lock);
+		batched_entropy->position = 0;
+		spin_unlock_irqrestore(&batched_entropy->batch_lock, flags);
 	}
-	write_unlock_irqrestore(&batched_entropy_reset_lock, flags);
 }
 
 /**



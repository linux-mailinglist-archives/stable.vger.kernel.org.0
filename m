Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E832F5F9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfE3DKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbfE3DKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7FFD244BB;
        Thu, 30 May 2019 03:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185845;
        bh=oH0YCFAp+soncbqg6ny+iS5tZ+uDyJS+4jsJAbEtK2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1wFQjeMsaAK74/oJvbbQa8MTjrbn+8tMkXxWtKNbvB2hYlgAEXoMbhk4ydeYVfw+
         FnCmLSbJNV1Li6+HCvSxsthAP8qry2Y6eq32lMpdE9MVCcg1FP0KIfwf+NF4FnTO09
         q7X1Lpr2KjnH1eAWpaF688MRiu9dtFlnxfdtQbxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 166/405] random: add a spinlock_t to struct batched_entropy
Date:   Wed, 29 May 2019 20:02:44 -0700
Message-Id: <20190530030549.530838478@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/char/random.c | 52 ++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d4d45ccfeefc0..af6e240f98ff4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2214,8 +2214,8 @@ struct batched_entropy {
 		u32 entropy_u32[CHACHA_BLOCK_SIZE / sizeof(u32)];
 	};
 	unsigned int position;
+	spinlock_t batch_lock;
 };
-static rwlock_t batched_entropy_reset_lock = __RW_LOCK_UNLOCKED(batched_entropy_reset_lock);
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
@@ -2225,12 +2225,14 @@ static rwlock_t batched_entropy_reset_lock = __RW_LOCK_UNLOCKED(batched_entropy_
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
 
@@ -2245,28 +2247,25 @@ u64 get_random_u64(void)
 
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
 
@@ -2275,18 +2274,14 @@ u32 get_random_u32(void)
 
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
@@ -2300,12 +2295,19 @@ static void invalidate_batched_entropy(void)
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
-- 
2.20.1




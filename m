Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF15558112
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbiFWQzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiFWQyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513CB7676;
        Thu, 23 Jun 2022 09:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C77861FC3;
        Thu, 23 Jun 2022 16:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13978C3411B;
        Thu, 23 Jun 2022 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003171;
        bh=OMQBd6cKcALUPWD1drsS9JXU9+cL/uEe2R8NbRrPWvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAMDV/8zk9KdxlwIUohEf+6jY1T/iqdXZ4oqlO3GY3Es3vVbthzYW0Tvi8F3WcY7J
         CUV/jfLCs+NQr0bTZHMUZQUdhXQ5l7JNVvpJtRI+5T2YXodEVN+9z/HeeUuVfpt/Lr
         wpcYez46v3YiiBHtvISJ/hnozdFR9s23fq7vJsjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Theodore Tso <tytso@mit.edu>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 153/264] random: clear fast pool, crng, and batches in cpuhp bring up
Date:   Thu, 23 Jun 2022 18:42:26 +0200
Message-Id: <20220623164348.393461570@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 3191dd5a1179ef0fad5a050a1702ae98b6251e8f upstream.

For the irq randomness fast pool, rather than having to use expensive
atomics, which were visibly the most expensive thing in the entire irq
handler, simply take care of the extreme edge case of resetting count to
zero in the cpuhp online handler, just after workqueues have been
reenabled. This simplifies the code a bit and lets us use vanilla
variables rather than atomics, and performance should be improved.

As well, very early on when the CPU comes up, while interrupts are still
disabled, we clear out the per-cpu crng and its batches, so that it
always starts with fresh randomness.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c      |   62 ++++++++++++++++++++++++++++++++++-----------
 include/linux/cpuhotplug.h |    2 +
 include/linux/random.h     |    5 +++
 kernel/cpu.c               |   11 +++++++
 4 files changed, 65 insertions(+), 15 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -694,6 +694,25 @@ u32 get_random_u32(void)
 }
 EXPORT_SYMBOL(get_random_u32);
 
+#ifdef CONFIG_SMP
+/*
+ * This function is called when the CPU is coming up, with entry
+ * CPUHP_RANDOM_PREPARE, which comes before CPUHP_WORKQUEUE_PREP.
+ */
+int random_prepare_cpu(unsigned int cpu)
+{
+	/*
+	 * When the cpu comes back online, immediately invalidate both
+	 * the per-cpu crng and all batches, so that we serve fresh
+	 * randomness.
+	 */
+	per_cpu_ptr(&crngs, cpu)->generation = ULONG_MAX;
+	per_cpu_ptr(&batched_entropy_u32, cpu)->position = UINT_MAX;
+	per_cpu_ptr(&batched_entropy_u64, cpu)->position = UINT_MAX;
+	return 0;
+}
+#endif
+
 /**
  * randomize_page - Generate a random, page aligned address
  * @start:	The smallest acceptable address the caller will take.
@@ -1179,7 +1198,7 @@ struct fast_pool {
 	};
 	struct work_struct mix;
 	unsigned long last;
-	atomic_t count;
+	unsigned int count;
 	u16 reg_idx;
 };
 
@@ -1215,6 +1234,29 @@ static void fast_mix(u32 pool[4])
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
+#ifdef CONFIG_SMP
+/*
+ * This function is called when the CPU has just come online, with
+ * entry CPUHP_AP_RANDOM_ONLINE, just after CPUHP_AP_WORKQUEUE_ONLINE.
+ */
+int random_online_cpu(unsigned int cpu)
+{
+	/*
+	 * During CPU shutdown and before CPU onlining, add_interrupt_
+	 * randomness() may schedule mix_interrupt_randomness(), and
+	 * set the MIX_INFLIGHT flag. However, because the worker can
+	 * be scheduled on a different CPU during this period, that
+	 * flag will never be cleared. For that reason, we zero out
+	 * the flag here, which runs just after workqueues are onlined
+	 * for the CPU again. This also has the effect of setting the
+	 * irq randomness count to zero so that new accumulated irqs
+	 * are fresh.
+	 */
+	per_cpu_ptr(&irq_randomness, cpu)->count = 0;
+	return 0;
+}
+#endif
+
 static u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
 {
 	u32 *ptr = (u32 *)regs;
@@ -1239,15 +1281,6 @@ static void mix_interrupt_randomness(str
 	local_irq_disable();
 	if (fast_pool != this_cpu_ptr(&irq_randomness)) {
 		local_irq_enable();
-		/*
-		 * If we are unlucky enough to have been moved to another CPU,
-		 * during CPU hotplug while the CPU was shutdown then we set
-		 * our count to zero atomically so that when the CPU comes
-		 * back online, it can enqueue work again. The _release here
-		 * pairs with the atomic_inc_return_acquire in
-		 * add_interrupt_randomness().
-		 */
-		atomic_set_release(&fast_pool->count, 0);
 		return;
 	}
 
@@ -1256,7 +1289,7 @@ static void mix_interrupt_randomness(str
 	 * consistent view, before we reenable irqs again.
 	 */
 	memcpy(pool, fast_pool->pool32, sizeof(pool));
-	atomic_set(&fast_pool->count, 0);
+	fast_pool->count = 0;
 	fast_pool->last = jiffies;
 	local_irq_enable();
 
@@ -1292,14 +1325,13 @@ void add_interrupt_randomness(int irq)
 	}
 
 	fast_mix(fast_pool->pool32);
-	/* The _acquire here pairs with the atomic_set_release in mix_interrupt_randomness(). */
-	new_count = (unsigned int)atomic_inc_return_acquire(&fast_pool->count);
+	new_count = ++fast_pool->count;
 
 	if (unlikely(crng_init == 0)) {
 		if (new_count >= 64 &&
 		    crng_pre_init_inject(fast_pool->pool32, sizeof(fast_pool->pool32),
 					 true, true) > 0) {
-			atomic_set(&fast_pool->count, 0);
+			fast_pool->count = 0;
 			fast_pool->last = now;
 			if (spin_trylock(&input_pool.lock)) {
 				_mix_pool_bytes(&fast_pool->pool32, sizeof(fast_pool->pool32));
@@ -1317,7 +1349,7 @@ void add_interrupt_randomness(int irq)
 
 	if (unlikely(!fast_pool->mix.func))
 		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
-	atomic_or(MIX_INFLIGHT, &fast_pool->count);
+	fast_pool->count |= MIX_INFLIGHT;
 	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -29,6 +29,7 @@ enum cpuhp_state {
 	CPUHP_ACPI_CPUDRV_DEAD,
 	CPUHP_S390_PFAULT_DEAD,
 	CPUHP_BLK_MQ_DEAD,
+	CPUHP_RANDOM_PREPARE,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
@@ -119,6 +120,7 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_ARM_CCN_ONLINE,
 	CPUHP_AP_PERF_ARM_L2X0_ONLINE,
 	CPUHP_AP_WORKQUEUE_ONLINE,
+	CPUHP_AP_RANDOM_ONLINE,
 	CPUHP_AP_RCUTREE_ONLINE,
 	CPUHP_AP_NOTIFY_ONLINE,
 	CPUHP_AP_ONLINE_DYN,
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -135,4 +135,9 @@ static inline bool __init arch_get_rando
 }
 #endif
 
+#ifdef CONFIG_SMP
+extern int random_prepare_cpu(unsigned int cpu);
+extern int random_online_cpu(unsigned int cpu);
+#endif
+
 #endif /* _LINUX_RANDOM_H */
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -26,6 +26,7 @@
 #include <linux/smpboot.h>
 #include <linux/relay.h>
 #include <linux/slab.h>
+#include <linux/random.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -1404,6 +1405,11 @@ static struct cpuhp_step cpuhp_bp_states
 		.startup.single		= perf_event_init_cpu,
 		.teardown.single	= perf_event_exit_cpu,
 	},
+	[CPUHP_RANDOM_PREPARE] = {
+		.name			= "random:prepare",
+		.startup.single		= random_prepare_cpu,
+		.teardown.single	= NULL,
+	},
 	[CPUHP_WORKQUEUE_PREP] = {
 		.name			= "workqueue:prepare",
 		.startup.single		= workqueue_prepare_cpu,
@@ -1529,6 +1535,11 @@ static struct cpuhp_step cpuhp_ap_states
 		.startup.single		= workqueue_online_cpu,
 		.teardown.single	= workqueue_offline_cpu,
 	},
+	[CPUHP_AP_RANDOM_ONLINE] = {
+		.name			= "random:online",
+		.startup.single		= random_online_cpu,
+		.teardown.single	= NULL,
+	},
 	[CPUHP_AP_RCUTREE_ONLINE] = {
 		.name			= "RCU/tree:online",
 		.startup.single		= rcutree_online_cpu,



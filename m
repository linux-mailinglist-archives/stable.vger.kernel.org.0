Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DDC66C565
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjAPQFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjAPQFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:05:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EE0241C7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11400B80DF9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6024DC433D2;
        Mon, 16 Jan 2023 16:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885010;
        bh=Q47cmWA6ELrGU1ifV5bIE2FNBcedm1V7wy/28WF+JhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEA/lqmL/0EriL+wyEGBX00roXPr0miRzzB91z7QzDej640bQDKY4zKMlWhTEKuAA
         wLdsX0x7hH6JGWzdr90pGWGbfV8tGhS/xcXuvlgLi5YCWSacwiADzZ6rN66AI4HuqF
         4jbVW9+w+oxId6LgVQG1Ft6kxQZ8OyYMKz0gN5P4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 41/86] powerpc/imc-pmu: Fix use of mutex in IRQs disabled section
Date:   Mon, 16 Jan 2023 16:51:15 +0100
Message-Id: <20230116154748.777100140@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

commit 76d588dddc459fefa1da96e0a081a397c5c8e216 upstream.

Current imc-pmu code triggers a WARNING with CONFIG_DEBUG_ATOMIC_SLEEP
and CONFIG_PROVE_LOCKING enabled, while running a thread_imc event.

Command to trigger the warning:
  # perf stat -e thread_imc/CPM_CS_FROM_L4_MEM_X_DPTEG/ sleep 5

   Performance counter stats for 'sleep 5':

                   0      thread_imc/CPM_CS_FROM_L4_MEM_X_DPTEG/

         5.002117947 seconds time elapsed

         0.000131000 seconds user
         0.001063000 seconds sys

Below is snippet of the warning in dmesg:

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 2869, name: perf-exec
  preempt_count: 2, expected: 0
  4 locks held by perf-exec/2869:
   #0: c00000004325c540 (&sig->cred_guard_mutex){+.+.}-{3:3}, at: bprm_execve+0x64/0xa90
   #1: c00000004325c5d8 (&sig->exec_update_lock){++++}-{3:3}, at: begin_new_exec+0x460/0xef0
   #2: c0000003fa99d4e0 (&cpuctx_lock){-...}-{2:2}, at: perf_event_exec+0x290/0x510
   #3: c000000017ab8418 (&ctx->lock){....}-{2:2}, at: perf_event_exec+0x29c/0x510
  irq event stamp: 4806
  hardirqs last  enabled at (4805): [<c000000000f65b94>] _raw_spin_unlock_irqrestore+0x94/0xd0
  hardirqs last disabled at (4806): [<c0000000003fae44>] perf_event_exec+0x394/0x510
  softirqs last  enabled at (0): [<c00000000013c404>] copy_process+0xc34/0x1ff0
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  CPU: 36 PID: 2869 Comm: perf-exec Not tainted 6.2.0-rc2-00011-g1247637727f2 #61
  Hardware name: 8375-42A POWER9 0x4e1202 opal:v7.0-16-g9b85f7d961 PowerNV
  Call Trace:
    dump_stack_lvl+0x98/0xe0 (unreliable)
    __might_resched+0x2f8/0x310
    __mutex_lock+0x6c/0x13f0
    thread_imc_event_add+0xf4/0x1b0
    event_sched_in+0xe0/0x210
    merge_sched_in+0x1f0/0x600
    visit_groups_merge.isra.92.constprop.166+0x2bc/0x6c0
    ctx_flexible_sched_in+0xcc/0x140
    ctx_sched_in+0x20c/0x2a0
    ctx_resched+0x104/0x1c0
    perf_event_exec+0x340/0x510
    begin_new_exec+0x730/0xef0
    load_elf_binary+0x3f8/0x1e10
  ...
  do not call blocking ops when !TASK_RUNNING; state=2001 set at [<00000000fd63e7cf>] do_nanosleep+0x60/0x1a0
  WARNING: CPU: 36 PID: 2869 at kernel/sched/core.c:9912 __might_sleep+0x9c/0xb0
  CPU: 36 PID: 2869 Comm: sleep Tainted: G        W          6.2.0-rc2-00011-g1247637727f2 #61
  Hardware name: 8375-42A POWER9 0x4e1202 opal:v7.0-16-g9b85f7d961 PowerNV
  NIP:  c000000000194a1c LR: c000000000194a18 CTR: c000000000a78670
  REGS: c00000004d2134e0 TRAP: 0700   Tainted: G        W           (6.2.0-rc2-00011-g1247637727f2)
  MSR:  9000000000021033 <SF,HV,ME,IR,DR,RI,LE>  CR: 48002824  XER: 00000000
  CFAR: c00000000013fb64 IRQMASK: 1

The above warning triggered because the current imc-pmu code uses mutex
lock in interrupt disabled sections. The function mutex_lock()
internally calls __might_resched(), which will check if IRQs are
disabled and in case IRQs are disabled, it will trigger the warning.

Fix the issue by changing the mutex lock to spinlock.

Fixes: 8f95faaac56c ("powerpc/powernv: Detect and create IMC device")
Reported-by: Michael Petlan <mpetlan@redhat.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
[mpe: Fix comments, trim oops in change log, add reported-by tags]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230106065157.182648-1-kjain@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/imc-pmu.h |    2 
 arch/powerpc/perf/imc-pmu.c        |  136 +++++++++++++++++--------------------
 2 files changed, 67 insertions(+), 71 deletions(-)

--- a/arch/powerpc/include/asm/imc-pmu.h
+++ b/arch/powerpc/include/asm/imc-pmu.h
@@ -137,7 +137,7 @@ struct imc_pmu {
  * are inited.
  */
 struct imc_pmu_ref {
-	struct mutex lock;
+	spinlock_t lock;
 	unsigned int id;
 	int refc;
 };
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -13,6 +13,7 @@
 #include <asm/cputhreads.h>
 #include <asm/smp.h>
 #include <linux/string.h>
+#include <linux/spinlock.h>
 
 /* Nest IMC data structures and variables */
 
@@ -20,7 +21,7 @@
  * Used to avoid races in counting the nest-pmu units during hotplug
  * register and unregister
  */
-static DEFINE_MUTEX(nest_init_lock);
+static DEFINE_SPINLOCK(nest_init_lock);
 static DEFINE_PER_CPU(struct imc_pmu_ref *, local_nest_imc_refc);
 static struct imc_pmu **per_nest_pmu_arr;
 static cpumask_t nest_imc_cpumask;
@@ -49,7 +50,7 @@ static int trace_imc_mem_size;
  * core and trace-imc
  */
 static struct imc_pmu_ref imc_global_refc = {
-	.lock = __MUTEX_INITIALIZER(imc_global_refc.lock),
+	.lock = __SPIN_LOCK_INITIALIZER(imc_global_refc.lock),
 	.id = 0,
 	.refc = 0,
 };
@@ -393,7 +394,7 @@ static int ppc_nest_imc_cpu_offline(unsi
 				       get_hard_smp_processor_id(cpu));
 		/*
 		 * If this is the last cpu in this chip then, skip the reference
-		 * count mutex lock and make the reference count on this chip zero.
+		 * count lock and make the reference count on this chip zero.
 		 */
 		ref = get_nest_pmu_ref(cpu);
 		if (!ref)
@@ -455,15 +456,15 @@ static void nest_imc_counters_release(st
 	/*
 	 * See if we need to disable the nest PMU.
 	 * If no events are currently in use, then we have to take a
-	 * mutex to ensure that we don't race with another task doing
+	 * lock to ensure that we don't race with another task doing
 	 * enable or disable the nest counters.
 	 */
 	ref = get_nest_pmu_ref(event->cpu);
 	if (!ref)
 		return;
 
-	/* Take the mutex lock for this node and then decrement the reference count */
-	mutex_lock(&ref->lock);
+	/* Take the lock for this node and then decrement the reference count */
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		/*
 		 * The scenario where this is true is, when perf session is
@@ -475,7 +476,7 @@ static void nest_imc_counters_release(st
 		 * an OPAL call to disable the engine in that node.
 		 *
 		 */
-		mutex_unlock(&ref->lock);
+		spin_unlock(&ref->lock);
 		return;
 	}
 	ref->refc--;
@@ -483,7 +484,7 @@ static void nest_imc_counters_release(st
 		rc = opal_imc_counters_stop(OPAL_IMC_COUNTERS_NEST,
 					    get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("nest-imc: Unable to stop the counters for core %d\n", node_id);
 			return;
 		}
@@ -491,7 +492,7 @@ static void nest_imc_counters_release(st
 		WARN(1, "nest-imc: Invalid event reference count\n");
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 }
 
 static int nest_imc_event_init(struct perf_event *event)
@@ -550,26 +551,25 @@ static int nest_imc_event_init(struct pe
 
 	/*
 	 * Get the imc_pmu_ref struct for this node.
-	 * Take the mutex lock and then increment the count of nest pmu events
-	 * inited.
+	 * Take the lock and then increment the count of nest pmu events inited.
 	 */
 	ref = get_nest_pmu_ref(event->cpu);
 	if (!ref)
 		return -EINVAL;
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		rc = opal_imc_counters_start(OPAL_IMC_COUNTERS_NEST,
 					     get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("nest-imc: Unable to start the counters for node %d\n",
 									node_id);
 			return rc;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	event->destroy = nest_imc_counters_release;
 	return 0;
@@ -605,9 +605,8 @@ static int core_imc_mem_init(int cpu, in
 		return -ENOMEM;
 	mem_info->vbase = page_address(page);
 
-	/* Init the mutex */
 	core_imc_refc[core_id].id = core_id;
-	mutex_init(&core_imc_refc[core_id].lock);
+	spin_lock_init(&core_imc_refc[core_id].lock);
 
 	rc = opal_imc_counters_init(OPAL_IMC_COUNTERS_CORE,
 				__pa((void *)mem_info->vbase),
@@ -696,9 +695,8 @@ static int ppc_core_imc_cpu_offline(unsi
 		perf_pmu_migrate_context(&core_imc_pmu->pmu, cpu, ncpu);
 	} else {
 		/*
-		 * If this is the last cpu in this core then, skip taking refernce
-		 * count mutex lock for this core and directly zero "refc" for
-		 * this core.
+		 * If this is the last cpu in this core then skip taking reference
+		 * count lock for this core and directly zero "refc" for this core.
 		 */
 		opal_imc_counters_stop(OPAL_IMC_COUNTERS_CORE,
 				       get_hard_smp_processor_id(cpu));
@@ -713,11 +711,11 @@ static int ppc_core_imc_cpu_offline(unsi
 		 * last cpu in this core and core-imc event running
 		 * in this cpu.
 		 */
-		mutex_lock(&imc_global_refc.lock);
+		spin_lock(&imc_global_refc.lock);
 		if (imc_global_refc.id == IMC_DOMAIN_CORE)
 			imc_global_refc.refc--;
 
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 	}
 	return 0;
 }
@@ -732,7 +730,7 @@ static int core_imc_pmu_cpumask_init(voi
 
 static void reset_global_refc(struct perf_event *event)
 {
-		mutex_lock(&imc_global_refc.lock);
+		spin_lock(&imc_global_refc.lock);
 		imc_global_refc.refc--;
 
 		/*
@@ -744,7 +742,7 @@ static void reset_global_refc(struct per
 			imc_global_refc.refc = 0;
 			imc_global_refc.id = 0;
 		}
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 }
 
 static void core_imc_counters_release(struct perf_event *event)
@@ -757,17 +755,17 @@ static void core_imc_counters_release(st
 	/*
 	 * See if we need to disable the IMC PMU.
 	 * If no events are currently in use, then we have to take a
-	 * mutex to ensure that we don't race with another task doing
+	 * lock to ensure that we don't race with another task doing
 	 * enable or disable the core counters.
 	 */
 	core_id = event->cpu / threads_per_core;
 
-	/* Take the mutex lock and decrement the refernce count for this core */
+	/* Take the lock and decrement the refernce count for this core */
 	ref = &core_imc_refc[core_id];
 	if (!ref)
 		return;
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		/*
 		 * The scenario where this is true is, when perf session is
@@ -779,7 +777,7 @@ static void core_imc_counters_release(st
 		 * an OPAL call to disable the engine in that core.
 		 *
 		 */
-		mutex_unlock(&ref->lock);
+		spin_unlock(&ref->lock);
 		return;
 	}
 	ref->refc--;
@@ -787,7 +785,7 @@ static void core_imc_counters_release(st
 		rc = opal_imc_counters_stop(OPAL_IMC_COUNTERS_CORE,
 					    get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("IMC: Unable to stop the counters for core %d\n", core_id);
 			return;
 		}
@@ -795,7 +793,7 @@ static void core_imc_counters_release(st
 		WARN(1, "core-imc: Invalid event reference count\n");
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	reset_global_refc(event);
 }
@@ -833,7 +831,6 @@ static int core_imc_event_init(struct pe
 	if ((!pcmi->vbase))
 		return -ENODEV;
 
-	/* Get the core_imc mutex for this core */
 	ref = &core_imc_refc[core_id];
 	if (!ref)
 		return -EINVAL;
@@ -841,22 +838,22 @@ static int core_imc_event_init(struct pe
 	/*
 	 * Core pmu units are enabled only when it is used.
 	 * See if this is triggered for the first time.
-	 * If yes, take the mutex lock and enable the core counters.
+	 * If yes, take the lock and enable the core counters.
 	 * If not, just increment the count in core_imc_refc struct.
 	 */
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		rc = opal_imc_counters_start(OPAL_IMC_COUNTERS_CORE,
 					     get_hard_smp_processor_id(event->cpu));
 		if (rc) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("core-imc: Unable to start the counters for core %d\n",
 									core_id);
 			return rc;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	/*
 	 * Since the system can run either in accumulation or trace-mode
@@ -867,7 +864,7 @@ static int core_imc_event_init(struct pe
 	 * to know whether any other trace/thread imc
 	 * events are running.
 	 */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == 0 || imc_global_refc.id == IMC_DOMAIN_CORE) {
 		/*
 		 * No other trace/thread imc events are running in
@@ -876,10 +873,10 @@ static int core_imc_event_init(struct pe
 		imc_global_refc.id = IMC_DOMAIN_CORE;
 		imc_global_refc.refc++;
 	} else {
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	event->hw.event_base = (u64)pcmi->vbase + (config & IMC_EVENT_OFFSET_MASK);
 	event->destroy = core_imc_counters_release;
@@ -951,10 +948,10 @@ static int ppc_thread_imc_cpu_offline(un
 	mtspr(SPRN_LDBAR, (mfspr(SPRN_LDBAR) & (~(1UL << 63))));
 
 	/* Reduce the refc if thread-imc event running on this cpu */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == IMC_DOMAIN_THREAD)
 		imc_global_refc.refc--;
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	return 0;
 }
@@ -994,7 +991,7 @@ static int thread_imc_event_init(struct
 	if (!target)
 		return -EINVAL;
 
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	/*
 	 * Check if any other trace/core imc events are running in the
 	 * system, if not set the global id to thread-imc.
@@ -1003,10 +1000,10 @@ static int thread_imc_event_init(struct
 		imc_global_refc.id = IMC_DOMAIN_THREAD;
 		imc_global_refc.refc++;
 	} else {
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	event->pmu->task_ctx_nr = perf_sw_context;
 	event->destroy = reset_global_refc;
@@ -1128,25 +1125,25 @@ static int thread_imc_event_add(struct p
 	/*
 	 * imc pmus are enabled only when it is used.
 	 * See if this is triggered for the first time.
-	 * If yes, take the mutex lock and enable the counters.
+	 * If yes, take the lock and enable the counters.
 	 * If not, just increment the count in ref count struct.
 	 */
 	ref = &core_imc_refc[core_id];
 	if (!ref)
 		return -EINVAL;
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		if (opal_imc_counters_start(OPAL_IMC_COUNTERS_CORE,
 		    get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("thread-imc: Unable to start the counter\
 				for core %d\n", core_id);
 			return -EINVAL;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 	return 0;
 }
 
@@ -1163,12 +1160,12 @@ static void thread_imc_event_del(struct
 		return;
 	}
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	ref->refc--;
 	if (ref->refc == 0) {
 		if (opal_imc_counters_stop(OPAL_IMC_COUNTERS_CORE,
 		    get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("thread-imc: Unable to stop the counters\
 				for core %d\n", core_id);
 			return;
@@ -1176,7 +1173,7 @@ static void thread_imc_event_del(struct
 	} else if (ref->refc < 0) {
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	/* Set bit 0 of LDBAR to zero, to stop posting updates to memory */
 	mtspr(SPRN_LDBAR, (mfspr(SPRN_LDBAR) & (~(1UL << 63))));
@@ -1217,9 +1214,8 @@ static int trace_imc_mem_alloc(int cpu_i
 		}
 	}
 
-	/* Init the mutex, if not already */
 	trace_imc_refc[core_id].id = core_id;
-	mutex_init(&trace_imc_refc[core_id].lock);
+	spin_lock_init(&trace_imc_refc[core_id].lock);
 
 	mtspr(SPRN_LDBAR, 0);
 	return 0;
@@ -1239,10 +1235,10 @@ static int ppc_trace_imc_cpu_offline(uns
 	 * Reduce the refc if any trace-imc event running
 	 * on this cpu.
 	 */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == IMC_DOMAIN_TRACE)
 		imc_global_refc.refc--;
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	return 0;
 }
@@ -1364,17 +1360,17 @@ static int trace_imc_event_add(struct pe
 	}
 
 	mtspr(SPRN_LDBAR, ldbar_value);
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	if (ref->refc == 0) {
 		if (opal_imc_counters_start(OPAL_IMC_COUNTERS_TRACE,
 				get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("trace-imc: Unable to start the counters for core %d\n", core_id);
 			return -EINVAL;
 		}
 	}
 	++ref->refc;
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 	return 0;
 }
 
@@ -1407,19 +1403,19 @@ static void trace_imc_event_del(struct p
 		return;
 	}
 
-	mutex_lock(&ref->lock);
+	spin_lock(&ref->lock);
 	ref->refc--;
 	if (ref->refc == 0) {
 		if (opal_imc_counters_stop(OPAL_IMC_COUNTERS_TRACE,
 				get_hard_smp_processor_id(smp_processor_id()))) {
-			mutex_unlock(&ref->lock);
+			spin_unlock(&ref->lock);
 			pr_err("trace-imc: Unable to stop the counters for core %d\n", core_id);
 			return;
 		}
 	} else if (ref->refc < 0) {
 		ref->refc = 0;
 	}
-	mutex_unlock(&ref->lock);
+	spin_unlock(&ref->lock);
 
 	trace_imc_event_stop(event, flags);
 }
@@ -1441,7 +1437,7 @@ static int trace_imc_event_init(struct p
 	 * no other thread is running any core/thread imc
 	 * events
 	 */
-	mutex_lock(&imc_global_refc.lock);
+	spin_lock(&imc_global_refc.lock);
 	if (imc_global_refc.id == 0 || imc_global_refc.id == IMC_DOMAIN_TRACE) {
 		/*
 		 * No core/thread imc events are running in the
@@ -1450,10 +1446,10 @@ static int trace_imc_event_init(struct p
 		imc_global_refc.id = IMC_DOMAIN_TRACE;
 		imc_global_refc.refc++;
 	} else {
-		mutex_unlock(&imc_global_refc.lock);
+		spin_unlock(&imc_global_refc.lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&imc_global_refc.lock);
+	spin_unlock(&imc_global_refc.lock);
 
 	event->hw.idx = -1;
 
@@ -1526,10 +1522,10 @@ static int init_nest_pmu_ref(void)
 	i = 0;
 	for_each_node(nid) {
 		/*
-		 * Mutex lock to avoid races while tracking the number of
+		 * Take the lock to avoid races while tracking the number of
 		 * sessions using the chip's nest pmu units.
 		 */
-		mutex_init(&nest_imc_refc[i].lock);
+		spin_lock_init(&nest_imc_refc[i].lock);
 
 		/*
 		 * Loop to init the "id" with the node_id. Variable "i" initialized to
@@ -1626,7 +1622,7 @@ static void imc_common_mem_free(struct i
 static void imc_common_cpuhp_mem_free(struct imc_pmu *pmu_ptr)
 {
 	if (pmu_ptr->domain == IMC_DOMAIN_NEST) {
-		mutex_lock(&nest_init_lock);
+		spin_lock(&nest_init_lock);
 		if (nest_pmus == 1) {
 			cpuhp_remove_state(CPUHP_AP_PERF_POWERPC_NEST_IMC_ONLINE);
 			kfree(nest_imc_refc);
@@ -1636,7 +1632,7 @@ static void imc_common_cpuhp_mem_free(st
 
 		if (nest_pmus > 0)
 			nest_pmus--;
-		mutex_unlock(&nest_init_lock);
+		spin_unlock(&nest_init_lock);
 	}
 
 	/* Free core_imc memory */
@@ -1793,11 +1789,11 @@ int init_imc_pmu(struct device_node *par
 		* rest. To handle the cpuhotplug callback unregister, we track
 		* the number of nest pmus in "nest_pmus".
 		*/
-		mutex_lock(&nest_init_lock);
+		spin_lock(&nest_init_lock);
 		if (nest_pmus == 0) {
 			ret = init_nest_pmu_ref();
 			if (ret) {
-				mutex_unlock(&nest_init_lock);
+				spin_unlock(&nest_init_lock);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
 				goto err_free_mem;
@@ -1805,7 +1801,7 @@ int init_imc_pmu(struct device_node *par
 			/* Register for cpu hotplug notification. */
 			ret = nest_pmu_cpumask_init();
 			if (ret) {
-				mutex_unlock(&nest_init_lock);
+				spin_unlock(&nest_init_lock);
 				kfree(nest_imc_refc);
 				kfree(per_nest_pmu_arr);
 				per_nest_pmu_arr = NULL;
@@ -1813,7 +1809,7 @@ int init_imc_pmu(struct device_node *par
 			}
 		}
 		nest_pmus++;
-		mutex_unlock(&nest_init_lock);
+		spin_unlock(&nest_init_lock);
 		break;
 	case IMC_DOMAIN_CORE:
 		ret = core_imc_pmu_cpumask_init();



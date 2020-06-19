Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CAB200D96
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbgFSO7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390442AbgFSO6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:58:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6E8218AC;
        Fri, 19 Jun 2020 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578733;
        bh=d3O9zOtYniC+zJb0zbzXf97OfdLaMig2KROpDOE/psc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYMYXTG88uS3kfFk6P3F37KEDu32gQsHB4DXy2GnFOxNuwMVxaoAXl89ux9Hq7jgt
         7h4WDdD8BYFPXgWyYPt+A2uOUwEGvVRVsK+sxzsm8cdtNP7KPjBePRqqhdLQV6MIoY
         +T55ePkyrEZWcYTfAB3bicTYWQY/fWf8rBUhy6os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Qian Cai <cai@lca.pw>, Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 136/267] sched/core: Fix illegal RCU from offline CPUs
Date:   Fri, 19 Jun 2020 16:32:01 +0200
Message-Id: <20200619141655.349082479@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit bf2c59fce4074e55d622089b34be3a6bc95484fb ]

In the CPU-offline process, it calls mmdrop() after idle entry and the
subsequent call to cpuhp_report_idle_dead(). Once execution passes the
call to rcu_report_dead(), RCU is ignoring the CPU, which results in
lockdep complaining when mmdrop() uses RCU from either memcg or
debugobjects below.

Fix it by cleaning up the active_mm state from BP instead. Every arch
which has CONFIG_HOTPLUG_CPU should have already called idle_task_exit()
from AP. The only exception is parisc because it switches them to
&init_mm unconditionally (see smp_boot_one_cpu() and smp_cpu_init()),
but the patch will still work there because it calls mmgrab(&init_mm) in
smp_cpu_init() and then should call mmdrop(&init_mm) in finish_cpu().

  WARNING: suspicious RCU usage
  -----------------------------
  kernel/workqueue.c:710 RCU or wq_pool_mutex should be held!

  other info that might help us debug this:

  RCU used illegally from offline CPU!
  Call Trace:
   dump_stack+0xf4/0x164 (unreliable)
   lockdep_rcu_suspicious+0x140/0x164
   get_work_pool+0x110/0x150
   __queue_work+0x1bc/0xca0
   queue_work_on+0x114/0x120
   css_release+0x9c/0xc0
   percpu_ref_put_many+0x204/0x230
   free_pcp_prepare+0x264/0x570
   free_unref_page+0x38/0xf0
   __mmdrop+0x21c/0x2c0
   idle_task_exit+0x170/0x1b0
   pnv_smp_cpu_kill_self+0x38/0x2e0
   cpu_die+0x48/0x64
   arch_cpu_idle_dead+0x30/0x50
   do_idle+0x2f4/0x470
   cpu_startup_entry+0x38/0x40
   start_secondary+0x7a8/0xa80
   start_secondary_resume+0x10/0x14

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Link: https://lkml.kernel.org/r/20200401214033.8448-1-cai@lca.pw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/smp.c |  1 -
 include/linux/sched/mm.h             |  2 ++
 kernel/cpu.c                         | 18 +++++++++++++++++-
 kernel/sched/core.c                  |  5 +++--
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 3d3c989e44dd..8d49ba370c50 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -171,7 +171,6 @@ static void pnv_smp_cpu_kill_self(void)
 	/* Standard hot unplug procedure */
 
 	idle_task_exit();
-	current->active_mm = NULL; /* for sanity */
 	cpu = smp_processor_id();
 	DBG("CPU%d offline\n", cpu);
 	generic_set_cpu_dead(cpu);
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index e9d4e389aed9..766bbe813861 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -49,6 +49,8 @@ static inline void mmdrop(struct mm_struct *mm)
 		__mmdrop(mm);
 }
 
+void mmdrop(struct mm_struct *mm);
+
 /*
  * This has to be called after a get_task_mm()/mmget_not_zero()
  * followed by taking the mmap_sem for writing before modifying the
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6d6c106a495c..08b9d6ba0807 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -3,6 +3,7 @@
  *
  * This code is licenced under the GPL.
  */
+#include <linux/sched/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/smp.h>
 #include <linux/init.h>
@@ -532,6 +533,21 @@ static int bringup_cpu(unsigned int cpu)
 	return bringup_wait_for_ap(cpu);
 }
 
+static int finish_cpu(unsigned int cpu)
+{
+	struct task_struct *idle = idle_thread_get(cpu);
+	struct mm_struct *mm = idle->active_mm;
+
+	/*
+	 * idle_task_exit() will have switched to &init_mm, now
+	 * clean up any remaining active_mm state.
+	 */
+	if (mm != &init_mm)
+		idle->active_mm = &init_mm;
+	mmdrop(mm);
+	return 0;
+}
+
 /*
  * Hotplug state machine related functions
  */
@@ -1379,7 +1395,7 @@ static struct cpuhp_step cpuhp_hp_states[] = {
 	[CPUHP_BRINGUP_CPU] = {
 		.name			= "cpu:bringup",
 		.startup.single		= bringup_cpu,
-		.teardown.single	= NULL,
+		.teardown.single	= finish_cpu,
 		.cant_stop		= true,
 	},
 	/* Final state before CPU kills itself */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2befd2c4ce9e..0325ccf3a8e4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5571,13 +5571,14 @@ void idle_task_exit(void)
 	struct mm_struct *mm = current->active_mm;
 
 	BUG_ON(cpu_online(smp_processor_id()));
+	BUG_ON(current != this_rq()->idle);
 
 	if (mm != &init_mm) {
 		switch_mm(mm, &init_mm, current);
-		current->active_mm = &init_mm;
 		finish_arch_post_lock_switch();
 	}
-	mmdrop(mm);
+
+	/* finish_cpu(), as ran on the BP, will clean up the active_mm state */
 }
 
 /*
-- 
2.25.1




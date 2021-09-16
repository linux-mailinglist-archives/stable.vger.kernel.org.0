Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F6140D9A5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 14:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbhIPMRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 08:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239367AbhIPMRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 08:17:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBAF460F4A;
        Thu, 16 Sep 2021 12:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631794570;
        bh=7h3NyJpMbuyKhJbRDijEfzWZZarVy6pIX9tDAzhitW4=;
        h=Subject:To:Cc:From:Date:From;
        b=BjbtQwD5UR+fLWYjzFJr26P8DAVMZoucEKf2M521Ja+lV5RALjz/tCwnyXIHVfjkF
         m3vXRsGz98qqDCQ2WaShVfwnGgWOindYwQA72MUltQ8F3ZZA7DP6DLGt88xcXzlNrw
         oaOS33fCA3tAzyLNhwa0iL2k+aZ0aQ2X125ZAt8I=
Subject: FAILED: patch "[PATCH] s390/topology: fix topology information when calling cpu" failed to apply to 5.10-stable tree
To:     svens@linux.ibm.com, hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 14:16:08 +0200
Message-ID: <163179456820396@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a052096bdd6809eeab809202726634d1ac975aa1 Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Fri, 27 Aug 2021 20:21:05 +0200
Subject: [PATCH] s390/topology: fix topology information when calling cpu
 hotplug notifiers

The cpu hotplug notifiers are called without updating the core/thread
masks when a new CPU is added. This causes problems with code setting
up data structures in a cpu hotplug notifier, and relying on that later
in normal code.

This caused a crash in the new core scheduling code (SCHED_CORE),
where rq->core was set up in a notifier depending on cpu masks.

To fix this, add a cpu_setup_mask which is used in update_cpu_masks()
instead of the cpu_online_mask to determine whether the cpu masks should
be set for a certain cpu. Also move update_cpu_masks() to update the
masks before calling notify_cpu_starting() so that the notifiers are
seeing the updated masks.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Cc: <stable@vger.kernel.org>
[hca@linux.ibm.com: get rid of cpu_online_mask handling]
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index e317fd4866c1..f16f4d054ae2 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -18,6 +18,7 @@ extern struct mutex smp_cpu_state_mutex;
 extern unsigned int smp_cpu_mt_shift;
 extern unsigned int smp_cpu_mtid;
 extern __vector128 __initdata boot_cpu_vector_save_area[__NUM_VXRS];
+extern cpumask_t cpu_setup_mask;
 
 extern int __cpu_up(unsigned int cpu, struct task_struct *tidle);
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 2a991e43ead3..1a04e5bdf655 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -95,6 +95,7 @@ __vector128 __initdata boot_cpu_vector_save_area[__NUM_VXRS];
 #endif
 
 static unsigned int smp_max_threads __initdata = -1U;
+cpumask_t cpu_setup_mask;
 
 static int __init early_nosmt(char *s)
 {
@@ -902,13 +903,14 @@ static void smp_start_secondary(void *cpuvoid)
 	vtime_init();
 	vdso_getcpu_init();
 	pfault_init();
+	cpumask_set_cpu(cpu, &cpu_setup_mask);
+	update_cpu_masks();
 	notify_cpu_starting(cpu);
 	if (topology_cpu_dedicated(cpu))
 		set_cpu_flag(CIF_DEDICATED_CPU);
 	else
 		clear_cpu_flag(CIF_DEDICATED_CPU);
 	set_cpu_online(cpu, true);
-	update_cpu_masks();
 	inc_irq_stat(CPU_RST);
 	local_irq_enable();
 	cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
@@ -950,10 +952,13 @@ early_param("possible_cpus", _setup_possible_cpus);
 int __cpu_disable(void)
 {
 	unsigned long cregs[16];
+	int cpu;
 
 	/* Handle possible pending IPIs */
 	smp_handle_ext_call();
-	set_cpu_online(smp_processor_id(), false);
+	cpu = smp_processor_id();
+	set_cpu_online(cpu, false);
+	cpumask_clear_cpu(cpu, &cpu_setup_mask);
 	update_cpu_masks();
 	/* Disable pseudo page faults on this cpu. */
 	pfault_fini();
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index d2458a29618f..58f8291950cb 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -67,7 +67,7 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 	static cpumask_t mask;
 
 	cpumask_clear(&mask);
-	if (!cpu_online(cpu))
+	if (!cpumask_test_cpu(cpu, &cpu_setup_mask))
 		goto out;
 	cpumask_set_cpu(cpu, &mask);
 	switch (topology_mode) {
@@ -88,7 +88,7 @@ static void cpu_group_map(cpumask_t *dst, struct mask_info *info, unsigned int c
 	case TOPOLOGY_MODE_SINGLE:
 		break;
 	}
-	cpumask_and(&mask, &mask, cpu_online_mask);
+	cpumask_and(&mask, &mask, &cpu_setup_mask);
 out:
 	cpumask_copy(dst, &mask);
 }
@@ -99,16 +99,16 @@ static void cpu_thread_map(cpumask_t *dst, unsigned int cpu)
 	int i;
 
 	cpumask_clear(&mask);
-	if (!cpu_online(cpu))
+	if (!cpumask_test_cpu(cpu, &cpu_setup_mask))
 		goto out;
 	cpumask_set_cpu(cpu, &mask);
 	if (topology_mode != TOPOLOGY_MODE_HW)
 		goto out;
 	cpu -= cpu % (smp_cpu_mtid + 1);
-	for (i = 0; i <= smp_cpu_mtid; i++)
-		if (cpu_present(cpu + i))
+	for (i = 0; i <= smp_cpu_mtid; i++) {
+		if (cpumask_test_cpu(cpu + i, &cpu_setup_mask))
 			cpumask_set_cpu(cpu + i, &mask);
-	cpumask_and(&mask, &mask, cpu_online_mask);
+	}
 out:
 	cpumask_copy(dst, &mask);
 }
@@ -569,6 +569,7 @@ void __init topology_init_early(void)
 	alloc_masks(info, &book_info, 2);
 	alloc_masks(info, &drawer_info, 3);
 out:
+	cpumask_set_cpu(0, &cpu_setup_mask);
 	__arch_update_cpu_topology();
 	__arch_update_dedicated_flag(NULL);
 }


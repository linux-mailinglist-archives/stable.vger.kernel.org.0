Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8831D40E503
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347956AbhIPRGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349172AbhIPRDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D20861268;
        Thu, 16 Sep 2021 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810068;
        bh=jZTT1EGsWwgZLxMN9FaJxmNT8OaXS7ODP6cR+l/zhes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6UGfUnVpnz8DWMYQQnsviOPDFyKPp7X02s2m0mQ6trBCitJ1rRSO0JZiebiR3aGL
         dpqCw9CrMM9Gv5aSu0rrW/SPfExxMzzHD6akniwe8gd4qJzdssGUrgGOJVnjp0jQx+
         ilMD4FNQhDlhs3BeVvY7X/LdUSqIHPr8CZH5izrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.13 356/380] s390/topology: fix topology information when calling cpu hotplug notifiers
Date:   Thu, 16 Sep 2021 18:01:53 +0200
Message-Id: <20210916155816.167690739@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit a052096bdd6809eeab809202726634d1ac975aa1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/smp.h |    1 +
 arch/s390/kernel/smp.c      |    9 +++++++--
 arch/s390/kernel/topology.c |   13 +++++++------
 3 files changed, 15 insertions(+), 8 deletions(-)

--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -18,6 +18,7 @@ extern struct mutex smp_cpu_state_mutex;
 extern unsigned int smp_cpu_mt_shift;
 extern unsigned int smp_cpu_mtid;
 extern __vector128 __initdata boot_cpu_vector_save_area[__NUM_VXRS];
+extern cpumask_t cpu_setup_mask;
 
 extern int __cpu_up(unsigned int cpu, struct task_struct *tidle);
 
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -96,6 +96,7 @@ __vector128 __initdata boot_cpu_vector_s
 #endif
 
 static unsigned int smp_max_threads __initdata = -1U;
+cpumask_t cpu_setup_mask;
 
 static int __init early_nosmt(char *s)
 {
@@ -883,13 +884,14 @@ static void smp_init_secondary(void)
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
@@ -945,10 +947,13 @@ early_param("possible_cpus", _setup_poss
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
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -67,7 +67,7 @@ static void cpu_group_map(cpumask_t *dst
 	static cpumask_t mask;
 
 	cpumask_clear(&mask);
-	if (!cpu_online(cpu))
+	if (!cpumask_test_cpu(cpu, &cpu_setup_mask))
 		goto out;
 	cpumask_set_cpu(cpu, &mask);
 	switch (topology_mode) {
@@ -88,7 +88,7 @@ static void cpu_group_map(cpumask_t *dst
 	case TOPOLOGY_MODE_SINGLE:
 		break;
 	}
-	cpumask_and(&mask, &mask, cpu_online_mask);
+	cpumask_and(&mask, &mask, &cpu_setup_mask);
 out:
 	cpumask_copy(dst, &mask);
 }
@@ -99,16 +99,16 @@ static void cpu_thread_map(cpumask_t *ds
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



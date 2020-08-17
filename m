Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F6E247652
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392378AbgHQTgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730044AbgHQP24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7663323A9B;
        Mon, 17 Aug 2020 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678136;
        bh=7peFGOZdvDxp3lFbxjZEQUd0we5xW49Vo4dYyLrz9Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3poYV6n8TUr0zLS0gy7qLdg/eZ6LBIZT1E3cWOywMItm9smhWJa0wHcVnSCCYkxS
         q+XgZfrD6Q31Cr+HAUndsENnTsKJraOPKhnFJeYeIrCo0g2q87M3IPJ8wLaWnpSf1C
         Y3XgJmSAG4saFR6Sj0b4SaL3bH04TyiyVkrlJyas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 231/464] powerpc/pseries: remove cede offline state for CPUs
Date:   Mon, 17 Aug 2020 17:13:04 +0200
Message-Id: <20200817143844.865760715@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 48f6e7f6d948b56489da027bc3284c709b939d28 ]

This effectively reverts commit 3aa565f53c39 ("powerpc/pseries: Add
hooks to put the CPU into an appropriate offline state"), which added
an offline mode for CPUs which uses the H_CEDE hcall instead of the
architected stop-self RTAS function in order to facilitate "folding"
of dedicated mode processors on PowerVM platforms to achieve energy
savings. This has been the default offline mode since its
introduction.

There's nothing about stop-self that would prevent the hypervisor from
achieving the energy savings available via H_CEDE, so the original
premise of this change appears to be flawed.

I also have encountered the claim that the transition to and from
ceded state is much faster than stop-self/start-cpu. Certainly we
would not want to use stop-self as an *idle* mode. That is what H_CEDE
is for. However, this difference is insignificant in the context of
Linux CPU hotplug, where the latency of an offline or online operation
on current systems is on the order of 100ms, mainly attributable to
all the various subsystems' cpuhp callbacks.

The cede offline mode also prevents accurate accounting, as discussed
before:
https://lore.kernel.org/linuxppc-dev/1571740391-3251-1-git-send-email-ego@linux.vnet.ibm.com/

Unconditionally use stop-self to offline processor threads. This is
the architected method for offlining CPUs on PAPR systems.

The "cede_offline" boot parameter is rendered obsolete.

Removing this code enables the removal of the partition suspend code
which temporarily onlines all present CPUs.

Fixes: 3aa565f53c39 ("powerpc/pseries: Add hooks to put the CPU into an appropriate offline state")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200612051238.1007764-2-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/core-api/cpu_hotplug.rst        |   7 -
 arch/powerpc/platforms/pseries/hotplug-cpu.c  | 170 ++----------------
 .../platforms/pseries/offline_states.h        |  38 ----
 arch/powerpc/platforms/pseries/pmem.c         |   1 -
 arch/powerpc/platforms/pseries/smp.c          |  28 +--
 5 files changed, 15 insertions(+), 229 deletions(-)
 delete mode 100644 arch/powerpc/platforms/pseries/offline_states.h

diff --git a/Documentation/core-api/cpu_hotplug.rst b/Documentation/core-api/cpu_hotplug.rst
index 4a50ab7817f77..b1ae1ac159cf9 100644
--- a/Documentation/core-api/cpu_hotplug.rst
+++ b/Documentation/core-api/cpu_hotplug.rst
@@ -50,13 +50,6 @@ Command Line Switches
 
   This option is limited to the X86 and S390 architecture.
 
-``cede_offline={"off","on"}``
-  Use this option to disable/enable putting offlined processors to an extended
-  ``H_CEDE`` state on supported pseries platforms. If nothing is specified,
-  ``cede_offline`` is set to "on".
-
-  This option is limited to the PowerPC architecture.
-
 ``cpu0_hotplug``
   Allow to shutdown CPU0.
 
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 3e8cbfe7a80fd..d4b346355bb9e 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -35,54 +35,10 @@
 #include <asm/topology.h>
 
 #include "pseries.h"
-#include "offline_states.h"
 
 /* This version can't take the spinlock, because it never returns */
 static int rtas_stop_self_token = RTAS_UNKNOWN_SERVICE;
 
-static DEFINE_PER_CPU(enum cpu_state_vals, preferred_offline_state) =
-							CPU_STATE_OFFLINE;
-static DEFINE_PER_CPU(enum cpu_state_vals, current_state) = CPU_STATE_OFFLINE;
-
-static enum cpu_state_vals default_offline_state = CPU_STATE_OFFLINE;
-
-static bool cede_offline_enabled __read_mostly = true;
-
-/*
- * Enable/disable cede_offline when available.
- */
-static int __init setup_cede_offline(char *str)
-{
-	return (kstrtobool(str, &cede_offline_enabled) == 0);
-}
-
-__setup("cede_offline=", setup_cede_offline);
-
-enum cpu_state_vals get_cpu_current_state(int cpu)
-{
-	return per_cpu(current_state, cpu);
-}
-
-void set_cpu_current_state(int cpu, enum cpu_state_vals state)
-{
-	per_cpu(current_state, cpu) = state;
-}
-
-enum cpu_state_vals get_preferred_offline_state(int cpu)
-{
-	return per_cpu(preferred_offline_state, cpu);
-}
-
-void set_preferred_offline_state(int cpu, enum cpu_state_vals state)
-{
-	per_cpu(preferred_offline_state, cpu) = state;
-}
-
-void set_default_offline_state(int cpu)
-{
-	per_cpu(preferred_offline_state, cpu) = default_offline_state;
-}
-
 static void rtas_stop_self(void)
 {
 	static struct rtas_args args;
@@ -101,9 +57,7 @@ static void rtas_stop_self(void)
 
 static void pseries_mach_cpu_die(void)
 {
-	unsigned int cpu = smp_processor_id();
 	unsigned int hwcpu = hard_smp_processor_id();
-	u8 cede_latency_hint = 0;
 
 	local_irq_disable();
 	idle_task_exit();
@@ -112,49 +66,6 @@ static void pseries_mach_cpu_die(void)
 	else
 		xics_teardown_cpu();
 
-	if (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
-		set_cpu_current_state(cpu, CPU_STATE_INACTIVE);
-		if (ppc_md.suspend_disable_cpu)
-			ppc_md.suspend_disable_cpu();
-
-		cede_latency_hint = 2;
-
-		get_lppaca()->idle = 1;
-		if (!lppaca_shared_proc(get_lppaca()))
-			get_lppaca()->donate_dedicated_cpu = 1;
-
-		while (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
-			while (!prep_irq_for_idle()) {
-				local_irq_enable();
-				local_irq_disable();
-			}
-
-			extended_cede_processor(cede_latency_hint);
-		}
-
-		local_irq_disable();
-
-		if (!lppaca_shared_proc(get_lppaca()))
-			get_lppaca()->donate_dedicated_cpu = 0;
-		get_lppaca()->idle = 0;
-
-		if (get_preferred_offline_state(cpu) == CPU_STATE_ONLINE) {
-			unregister_slb_shadow(hwcpu);
-
-			hard_irq_disable();
-			/*
-			 * Call to start_secondary_resume() will not return.
-			 * Kernel stack will be reset and start_secondary()
-			 * will be called to continue the online operation.
-			 */
-			start_secondary_resume();
-		}
-	}
-
-	/* Requested state is CPU_STATE_OFFLINE at this point */
-	WARN_ON(get_preferred_offline_state(cpu) != CPU_STATE_OFFLINE);
-
-	set_cpu_current_state(cpu, CPU_STATE_OFFLINE);
 	unregister_slb_shadow(hwcpu);
 	rtas_stop_self();
 
@@ -200,24 +111,13 @@ static void pseries_cpu_die(unsigned int cpu)
 	int cpu_status = 1;
 	unsigned int pcpu = get_hard_smp_processor_id(cpu);
 
-	if (get_preferred_offline_state(cpu) == CPU_STATE_INACTIVE) {
-		cpu_status = 1;
-		for (tries = 0; tries < 5000; tries++) {
-			if (get_cpu_current_state(cpu) == CPU_STATE_INACTIVE) {
-				cpu_status = 0;
-				break;
-			}
-			msleep(1);
-		}
-	} else if (get_preferred_offline_state(cpu) == CPU_STATE_OFFLINE) {
+	for (tries = 0; tries < 25; tries++) {
+		cpu_status = smp_query_cpu_stopped(pcpu);
+		if (cpu_status == QCSS_STOPPED ||
+		    cpu_status == QCSS_HARDWARE_ERROR)
+			break;
+		cpu_relax();
 
-		for (tries = 0; tries < 25; tries++) {
-			cpu_status = smp_query_cpu_stopped(pcpu);
-			if (cpu_status == QCSS_STOPPED ||
-			    cpu_status == QCSS_HARDWARE_ERROR)
-				break;
-			cpu_relax();
-		}
 	}
 
 	if (cpu_status != 0) {
@@ -359,28 +259,15 @@ static int dlpar_offline_cpu(struct device_node *dn)
 			if (get_hard_smp_processor_id(cpu) != thread)
 				continue;
 
-			if (get_cpu_current_state(cpu) == CPU_STATE_OFFLINE)
+			if (!cpu_online(cpu))
 				break;
 
-			if (get_cpu_current_state(cpu) == CPU_STATE_ONLINE) {
-				set_preferred_offline_state(cpu,
-							    CPU_STATE_OFFLINE);
-				cpu_maps_update_done();
-				timed_topology_update(1);
-				rc = device_offline(get_cpu_device(cpu));
-				if (rc)
-					goto out;
-				cpu_maps_update_begin();
-				break;
-			}
-
-			/*
-			 * The cpu is in CPU_STATE_INACTIVE.
-			 * Upgrade it's state to CPU_STATE_OFFLINE.
-			 */
-			set_preferred_offline_state(cpu, CPU_STATE_OFFLINE);
-			WARN_ON(plpar_hcall_norets(H_PROD, thread) != H_SUCCESS);
-			__cpu_die(cpu);
+			cpu_maps_update_done();
+			timed_topology_update(1);
+			rc = device_offline(get_cpu_device(cpu));
+			if (rc)
+				goto out;
+			cpu_maps_update_begin();
 			break;
 		}
 		if (cpu == num_possible_cpus()) {
@@ -414,8 +301,6 @@ static int dlpar_online_cpu(struct device_node *dn)
 		for_each_present_cpu(cpu) {
 			if (get_hard_smp_processor_id(cpu) != thread)
 				continue;
-			BUG_ON(get_cpu_current_state(cpu)
-					!= CPU_STATE_OFFLINE);
 			cpu_maps_update_done();
 			timed_topology_update(1);
 			find_and_online_cpu_nid(cpu);
@@ -1013,27 +898,8 @@ static struct notifier_block pseries_smp_nb = {
 	.notifier_call = pseries_smp_notifier,
 };
 
-#define MAX_CEDE_LATENCY_LEVELS		4
-#define	CEDE_LATENCY_PARAM_LENGTH	10
-#define CEDE_LATENCY_PARAM_MAX_LENGTH	\
-	(MAX_CEDE_LATENCY_LEVELS * CEDE_LATENCY_PARAM_LENGTH * sizeof(char))
-#define CEDE_LATENCY_TOKEN		45
-
-static char cede_parameters[CEDE_LATENCY_PARAM_MAX_LENGTH];
-
-static int parse_cede_parameters(void)
-{
-	memset(cede_parameters, 0, CEDE_LATENCY_PARAM_MAX_LENGTH);
-	return rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-			 NULL,
-			 CEDE_LATENCY_TOKEN,
-			 __pa(cede_parameters),
-			 CEDE_LATENCY_PARAM_MAX_LENGTH);
-}
-
 static int __init pseries_cpu_hotplug_init(void)
 {
-	int cpu;
 	int qcss_tok;
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
@@ -1056,16 +922,8 @@ static int __init pseries_cpu_hotplug_init(void)
 	smp_ops->cpu_die = pseries_cpu_die;
 
 	/* Processors can be added/removed only on LPAR */
-	if (firmware_has_feature(FW_FEATURE_LPAR)) {
+	if (firmware_has_feature(FW_FEATURE_LPAR))
 		of_reconfig_notifier_register(&pseries_smp_nb);
-		cpu_maps_update_begin();
-		if (cede_offline_enabled && parse_cede_parameters() == 0) {
-			default_offline_state = CPU_STATE_INACTIVE;
-			for_each_online_cpu(cpu)
-				set_default_offline_state(cpu);
-		}
-		cpu_maps_update_done();
-	}
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/pseries/offline_states.h b/arch/powerpc/platforms/pseries/offline_states.h
deleted file mode 100644
index 51414aee28625..0000000000000
--- a/arch/powerpc/platforms/pseries/offline_states.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _OFFLINE_STATES_H_
-#define _OFFLINE_STATES_H_
-
-/* Cpu offline states go here */
-enum cpu_state_vals {
-	CPU_STATE_OFFLINE,
-	CPU_STATE_INACTIVE,
-	CPU_STATE_ONLINE,
-	CPU_MAX_OFFLINE_STATES
-};
-
-#ifdef CONFIG_HOTPLUG_CPU
-extern enum cpu_state_vals get_cpu_current_state(int cpu);
-extern void set_cpu_current_state(int cpu, enum cpu_state_vals state);
-extern void set_preferred_offline_state(int cpu, enum cpu_state_vals state);
-extern void set_default_offline_state(int cpu);
-#else
-static inline enum cpu_state_vals get_cpu_current_state(int cpu)
-{
-	return CPU_STATE_ONLINE;
-}
-
-static inline void set_cpu_current_state(int cpu, enum cpu_state_vals state)
-{
-}
-
-static inline void set_preferred_offline_state(int cpu, enum cpu_state_vals state)
-{
-}
-
-static inline void set_default_offline_state(int cpu)
-{
-}
-#endif
-
-extern enum cpu_state_vals get_preferred_offline_state(int cpu);
-#endif
diff --git a/arch/powerpc/platforms/pseries/pmem.c b/arch/powerpc/platforms/pseries/pmem.c
index f860a897a9e05..f827de7087e9b 100644
--- a/arch/powerpc/platforms/pseries/pmem.c
+++ b/arch/powerpc/platforms/pseries/pmem.c
@@ -24,7 +24,6 @@
 #include <asm/topology.h>
 
 #include "pseries.h"
-#include "offline_states.h"
 
 static struct device_node *pmem_node;
 
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 6891710833be5..7ebacac03dc36 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -44,8 +44,6 @@
 #include <asm/svm.h>
 
 #include "pseries.h"
-#include "offline_states.h"
-
 
 /*
  * The Primary thread of each non-boot processor was started from the OF client
@@ -108,10 +106,7 @@ static inline int smp_startup_cpu(unsigned int lcpu)
 
 	/* Fixup atomic count: it exited inside IRQ handler. */
 	task_thread_info(paca_ptrs[lcpu]->__current)->preempt_count	= 0;
-#ifdef CONFIG_HOTPLUG_CPU
-	if (get_cpu_current_state(lcpu) == CPU_STATE_INACTIVE)
-		goto out;
-#endif
+
 	/* 
 	 * If the RTAS start-cpu token does not exist then presume the
 	 * cpu is already spinning.
@@ -126,9 +121,6 @@ static inline int smp_startup_cpu(unsigned int lcpu)
 		return 0;
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
-out:
-#endif
 	return 1;
 }
 
@@ -143,10 +135,6 @@ static void smp_setup_cpu(int cpu)
 		vpa_init(cpu);
 
 	cpumask_clear_cpu(cpu, of_spin_mask);
-#ifdef CONFIG_HOTPLUG_CPU
-	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
-	set_default_offline_state(cpu);
-#endif
 }
 
 static int smp_pSeries_kick_cpu(int nr)
@@ -163,20 +151,6 @@ static int smp_pSeries_kick_cpu(int nr)
 	 * the processor will continue on to secondary_start
 	 */
 	paca_ptrs[nr]->cpu_start = 1;
-#ifdef CONFIG_HOTPLUG_CPU
-	set_preferred_offline_state(nr, CPU_STATE_ONLINE);
-
-	if (get_cpu_current_state(nr) == CPU_STATE_INACTIVE) {
-		long rc;
-		unsigned long hcpuid;
-
-		hcpuid = get_hard_smp_processor_id(nr);
-		rc = plpar_hcall_norets(H_PROD, hcpuid);
-		if (rc != H_SUCCESS)
-			printk(KERN_ERR "Error: Prod to wake up processor %d "
-						"Ret= %ld\n", nr, rc);
-	}
-#endif
 
 	return 0;
 }
-- 
2.25.1




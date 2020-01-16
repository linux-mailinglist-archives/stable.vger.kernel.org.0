Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE413F86F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgAPQyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731991AbgAPQyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D5A22525;
        Thu, 16 Jan 2020 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193670;
        bh=1+Bt01W5dmc2vbQUMNlQA0sITApzXtOYMPiixaFAWXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uu6LmwA4870zB9grI71UQlwFZZ8dhmJInv8tOgwXpKH8ISD8jqhAU2rU+LSBL23Yf
         5XWc2pmQqTOH+xTRmigI+pvbTsT0iTgYe762SVMhZ3sXmz6JqMtfeSexPqVtz6M69p
         okXQideyUX6YkbSqG/l0Scv+QurwPiozJgl1PtwI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Ondrej Jirman <megous@megous.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 196/205] ARM: 8943/1: Fix topology setup in case of CPU hotplug for CONFIG_SCHED_MC
Date:   Thu, 16 Jan 2020 11:42:51 -0500
Message-Id: <20200116164300.6705-196-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

[ Upstream commit ff98a5f624d2910de050f1fc7f2a32769da86b51 ]

Commit ca74b316df96 ("arm: Use common cpu_topology structure and
functions.") changed cpu_coregroup_mask() from the ARM32 specific
implementation in arch/arm/include/asm/topology.h to the one shared
with ARM64 and RISCV in drivers/base/arch_topology.c.

Currently on ARM32 (TC2 w/ CONFIG_SCHED_MC) the task scheduler setup
code (w/ CONFIG_SCHED_DEBUG) shows this during CPU hotplug:

  ERROR: groups don't span domain->span

It happens to CPUs of the cluster of the CPU which gets hot-plugged
out on scheduler domain MC.

Turns out that the shared cpu_coregroup_mask() requires that the
hot-plugged CPU is removed from the core_sibling mask via
remove_cpu_topology(). Otherwise the 'is core_sibling subset of
cpumask_of_node()' doesn't work. In this case the task scheduler has to
deal with cpumask_of_node instead of core_sibling which is wrong on
scheduler domain MC.

e.g. CPU3 hot-plugged out on TC2 [cluster0: 0,3-4 cluster1: 1-2]:

  cpu_coregroup_mask(): CPU3 cpumask_of_node=0-2,4 core_sibling=0,3-4
                                                                  ^
should be:

  cpu_coregroup_mask(): CPU3 cpumask_of_node=0-2,4 core_sibling=0,4

Add remove_cpu_topology() to __cpu_disable() to remove the CPU from the
topology masks in case of a CPU hotplug out operation.

At the same time tweak store_cpu_topology() slightly so it will call
update_siblings_masks() in case of CPU hotplug in operation via
secondary_start_kernel()->smp_store_cpu_info().

This aligns the ARM32 implementation with the ARM64 one.

Guarding remove_cpu_topology() with CONFIG_GENERIC_ARCH_TOPOLOGY is
necessary since some Arm32 defconfigs (aspeed_g5_defconfig,
milbeaut_m10v_defconfig, spear13xx_defconfig) specify an explicit

 # CONFIG_ARM_CPU_TOPOLOGY is not set

w/ ./arch/arm/Kconfig: select GENERIC_ARCH_TOPOLOGY if ARM_CPU_TOPOLOGY

Fixes: ca74b316df96 ("arm: Use common cpu_topology structure and functions")
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/smp.c      |  4 ++++
 arch/arm/kernel/topology.c | 10 +++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 4b0bab2607e4..46e1be9e57a8 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -240,6 +240,10 @@ int __cpu_disable(void)
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_GENERIC_ARCH_TOPOLOGY
+	remove_cpu_topology(cpu);
+#endif
+
 	/*
 	 * Take this CPU offline.  Once we clear this, we can't return,
 	 * and we must not schedule until we're ready to give up the cpu.
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 5b9faba03afb..8d2e61d9e7a6 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -196,9 +196,8 @@ void store_cpu_topology(unsigned int cpuid)
 	struct cpu_topology *cpuid_topo = &cpu_topology[cpuid];
 	unsigned int mpidr;
 
-	/* If the cpu topology has been already set, just return */
-	if (cpuid_topo->core_id != -1)
-		return;
+	if (cpuid_topo->package_id != -1)
+		goto topology_populated;
 
 	mpidr = read_cpuid_mpidr();
 
@@ -231,14 +230,15 @@ void store_cpu_topology(unsigned int cpuid)
 		cpuid_topo->package_id = -1;
 	}
 
-	update_siblings_masks(cpuid);
-
 	update_cpu_capacity(cpuid);
 
 	pr_info("CPU%u: thread %d, cpu %d, socket %d, mpidr %x\n",
 		cpuid, cpu_topology[cpuid].thread_id,
 		cpu_topology[cpuid].core_id,
 		cpu_topology[cpuid].package_id, mpidr);
+
+topology_populated:
+	update_siblings_masks(cpuid);
 }
 
 static inline int cpu_corepower_flags(void)
-- 
2.20.1


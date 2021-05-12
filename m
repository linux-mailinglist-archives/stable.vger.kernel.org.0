Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA8C37CE6F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245006AbhELRFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231289AbhELQoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:44:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C95E6619A9;
        Wed, 12 May 2021 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836049;
        bh=/YIHPP1mkB4P7DXq9hZEPgh/WfTWUGzOdo8UpwGp7JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTEShp400fyRDqiXPtSVnSX6YnD8EderOuSYtgsZJZklXmOBdQE7s/riJWQzvLUOJ
         GKAqrI3YQ7G81cpi4NMvOq+dxqqK8wsiZOAqRoNlIIlyL4/AEBFz6J10IVJUshjsz/
         /D/ZFZANnajk129nbjPokdbTQahcyp4+ejwSaAfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 589/677] powerpc/smp: Reintroduce cpu_core_mask
Date:   Wed, 12 May 2021 16:50:35 +0200
Message-Id: <20210512144856.952796189@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

[ Upstream commit c47f892d7aa62765bf0689073f75990b4517a4cf ]

Daniel reported that with Commit 4ca234a9cbd7 ("powerpc/smp: Stop
updating cpu_core_mask") QEMU was unable to set single NUMA node SMP
topologies such as:
 -smp 8,maxcpus=8,cores=2,threads=2,sockets=2
 i.e he expected 2 sockets in one NUMA node.

The above commit helped to reduce boot time on Large Systems for
example 4096 vCPU single socket QEMU instance. PAPR is silent on
having more than one socket within a NUMA node.

cpu_core_mask and cpu_cpu_mask for any CPU would be same unless the
number of sockets is different from the number of NUMA nodes.

One option is to reintroduce cpu_core_mask but use a slightly
different method to arrive at the cpu_core_mask. Previously each CPU's
chip-id would be compared with all other CPU's chip-id to verify if
both the CPUs were related at the chip level. Now if a CPU 'A' is
found related / (unrelated) to another CPU 'B', all the thread
siblings of 'A' and thread siblings of 'B' are automatically marked as
related / (unrelated).

Also if a platform doesn't support ibm,chip-id property, i.e its
cpu_to_chip_id returns -1, cpu_core_map holds a copy of
cpu_cpu_mask().

Fixes: 4ca234a9cbd7 ("powerpc/smp: Stop updating cpu_core_mask")
Reported-by: Daniel Henrique Barboza <danielhb413@gmail.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Tested-by: Daniel Henrique Barboza <danielhb413@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210415120934.232271-2-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/smp.h |  5 +++++
 arch/powerpc/kernel/smp.c      | 39 ++++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index 7a13bc20f0a0..47081a9e13ca 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -121,6 +121,11 @@ static inline struct cpumask *cpu_sibling_mask(int cpu)
 	return per_cpu(cpu_sibling_map, cpu);
 }
 
+static inline struct cpumask *cpu_core_mask(int cpu)
+{
+	return per_cpu(cpu_core_map, cpu);
+}
+
 static inline struct cpumask *cpu_l2_cache_mask(int cpu)
 {
 	return per_cpu(cpu_l2_cache_map, cpu);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 5a4d59a1070d..5c7ce1d50631 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1057,17 +1057,12 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 				local_memory_node(numa_cpu_lookup_table[cpu]));
 		}
 #endif
-		/*
-		 * cpu_core_map is now more updated and exists only since
-		 * its been exported for long. It only will have a snapshot
-		 * of cpu_cpu_mask.
-		 */
-		cpumask_copy(per_cpu(cpu_core_map, cpu), cpu_cpu_mask(cpu));
 	}
 
 	/* Init the cpumasks so the boot CPU is related to itself */
 	cpumask_set_cpu(boot_cpuid, cpu_sibling_mask(boot_cpuid));
 	cpumask_set_cpu(boot_cpuid, cpu_l2_cache_mask(boot_cpuid));
+	cpumask_set_cpu(boot_cpuid, cpu_core_mask(boot_cpuid));
 
 	if (has_coregroup_support())
 		cpumask_set_cpu(boot_cpuid, cpu_coregroup_mask(boot_cpuid));
@@ -1408,6 +1403,9 @@ static void remove_cpu_from_masks(int cpu)
 			set_cpus_unrelated(cpu, i, cpu_smallcore_mask);
 	}
 
+	for_each_cpu(i, cpu_core_mask(cpu))
+		set_cpus_unrelated(cpu, i, cpu_core_mask);
+
 	if (has_coregroup_support()) {
 		for_each_cpu(i, cpu_coregroup_mask(cpu))
 			set_cpus_unrelated(cpu, i, cpu_coregroup_mask);
@@ -1468,8 +1466,11 @@ static void update_coregroup_mask(int cpu, cpumask_var_t *mask)
 
 static void add_cpu_to_masks(int cpu)
 {
+	struct cpumask *(*submask_fn)(int) = cpu_sibling_mask;
 	int first_thread = cpu_first_thread_sibling(cpu);
+	int chip_id = cpu_to_chip_id(cpu);
 	cpumask_var_t mask;
+	bool ret;
 	int i;
 
 	/*
@@ -1485,12 +1486,36 @@ static void add_cpu_to_masks(int cpu)
 	add_cpu_to_smallcore_masks(cpu);
 
 	/* In CPU-hotplug path, hence use GFP_ATOMIC */
-	alloc_cpumask_var_node(&mask, GFP_ATOMIC, cpu_to_node(cpu));
+	ret = alloc_cpumask_var_node(&mask, GFP_ATOMIC, cpu_to_node(cpu));
 	update_mask_by_l2(cpu, &mask);
 
 	if (has_coregroup_support())
 		update_coregroup_mask(cpu, &mask);
 
+	if (chip_id == -1 || !ret) {
+		cpumask_copy(per_cpu(cpu_core_map, cpu), cpu_cpu_mask(cpu));
+		goto out;
+	}
+
+	if (shared_caches)
+		submask_fn = cpu_l2_cache_mask;
+
+	/* Update core_mask with all the CPUs that are part of submask */
+	or_cpumasks_related(cpu, cpu, submask_fn, cpu_core_mask);
+
+	/* Skip all CPUs already part of current CPU core mask */
+	cpumask_andnot(mask, cpu_online_mask, cpu_core_mask(cpu));
+
+	for_each_cpu(i, mask) {
+		if (chip_id == cpu_to_chip_id(i)) {
+			or_cpumasks_related(cpu, i, submask_fn, cpu_core_mask);
+			cpumask_andnot(mask, mask, submask_fn(i));
+		} else {
+			cpumask_andnot(mask, mask, cpu_core_mask(i));
+		}
+	}
+
+out:
 	free_cpumask_var(mask);
 }
 
-- 
2.30.2




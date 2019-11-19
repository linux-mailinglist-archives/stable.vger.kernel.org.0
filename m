Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B001B101754
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbfKSFpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbfKSFpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:45:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AE822084D;
        Tue, 19 Nov 2019 05:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142320;
        bh=uDCGXaCPSzUDmEXiC4cE9ce1ty5IHGYHkXnabqtaQDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+TAi5LCo7kEXR5x+bw9p12dxFNZTntl/l1ZbP/0a2+MfPmW4ZzfmdOpGKt0px4b2
         pOYlAwywdDTcQtip7+j30Olc9J7tALdoB8ktD7Z2V7hyrhQWL1Uq8eWWegqnw4ZEO+
         IdAELMeM9SRxFmoRCyv3vaQ4uDQQjPlStNa5Y3Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.14 006/239] powerpc/perf: Fix IMC_MAX_PMU macro
Date:   Tue, 19 Nov 2019 06:16:46 +0100
Message-Id: <20191119051258.425251463@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

commit 73ce9aec65b17433e18163d07eb5cb6bf114bd6c upstream.

IMC_MAX_PMU is used for static storage (per_nest_pmu_arr) which holds
nest pmu information. Current value for the macro is 32 based on
the initial number of nest pmu units supported by the nest microcode.
But going forward, microcode could support more nest units. Instead
of static storage, patch to fix the code to dynamically allocate an
array based on the number of nest imc units found in the device tree.

Fixes:8f95faaac56c1 ('powerpc/powernv: Detect and create IMC device')
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/imc-pmu.h        |    6 +-----
 arch/powerpc/perf/imc-pmu.c               |   15 ++++++++++++---
 arch/powerpc/platforms/powernv/opal-imc.c |   16 ++++++++++++++++
 3 files changed, 29 insertions(+), 8 deletions(-)

--- a/arch/powerpc/include/asm/imc-pmu.h
+++ b/arch/powerpc/include/asm/imc-pmu.h
@@ -21,11 +21,6 @@
 #include <asm/opal.h>
 
 /*
- * For static allocation of some of the structures.
- */
-#define IMC_MAX_PMUS			32
-
-/*
  * Compatibility macros for IMC devices
  */
 #define IMC_DTB_COMPAT			"ibm,opal-in-memory-counters"
@@ -125,4 +120,5 @@ enum {
 extern int init_imc_pmu(struct device_node *parent,
 				struct imc_pmu *pmu_ptr, int pmu_id);
 extern void thread_imc_disable(void);
+extern int get_max_nest_dev(void);
 #endif /* __ASM_POWERPC_IMC_PMU_H */
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -26,7 +26,7 @@
  */
 static DEFINE_MUTEX(nest_init_lock);
 static DEFINE_PER_CPU(struct imc_pmu_ref *, local_nest_imc_refc);
-static struct imc_pmu *per_nest_pmu_arr[IMC_MAX_PMUS];
+static struct imc_pmu **per_nest_pmu_arr;
 static cpumask_t nest_imc_cpumask;
 struct imc_pmu_ref *nest_imc_refc;
 static int nest_pmus;
@@ -286,13 +286,14 @@ static struct imc_pmu_ref *get_nest_pmu_
 static void nest_change_cpu_context(int old_cpu, int new_cpu)
 {
 	struct imc_pmu **pn = per_nest_pmu_arr;
-	int i;
 
 	if (old_cpu < 0 || new_cpu < 0)
 		return;
 
-	for (i = 0; *pn && i < IMC_MAX_PMUS; i++, pn++)
+	while (*pn) {
 		perf_pmu_migrate_context(&(*pn)->pmu, old_cpu, new_cpu);
+		pn++;
+	}
 }
 
 static int ppc_nest_imc_cpu_offline(unsigned int cpu)
@@ -1212,6 +1213,7 @@ static void imc_common_cpuhp_mem_free(st
 		kfree(pmu_ptr->attr_groups[IMC_EVENT_ATTR]->attrs);
 	kfree(pmu_ptr->attr_groups[IMC_EVENT_ATTR]);
 	kfree(pmu_ptr);
+	kfree(per_nest_pmu_arr);
 	return;
 }
 
@@ -1236,6 +1238,13 @@ static int imc_mem_init(struct imc_pmu *
 			return -ENOMEM;
 
 		/* Needed for hotplug/migration */
+		if (!per_nest_pmu_arr) {
+			per_nest_pmu_arr = kcalloc(get_max_nest_dev() + 1,
+						sizeof(struct imc_pmu *),
+						GFP_KERNEL);
+			if (!per_nest_pmu_arr)
+				return -ENOMEM;
+		}
 		per_nest_pmu_arr[pmu_index] = pmu_ptr;
 		break;
 	case IMC_DOMAIN_CORE:
--- a/arch/powerpc/platforms/powernv/opal-imc.c
+++ b/arch/powerpc/platforms/powernv/opal-imc.c
@@ -159,6 +159,22 @@ static void disable_core_pmu_counters(vo
 	put_online_cpus();
 }
 
+int get_max_nest_dev(void)
+{
+	struct device_node *node;
+	u32 pmu_units = 0, type;
+
+	for_each_compatible_node(node, NULL, IMC_DTB_UNIT_COMPAT) {
+		if (of_property_read_u32(node, "type", &type))
+			continue;
+
+		if (type == IMC_TYPE_CHIP)
+			pmu_units++;
+	}
+
+	return pmu_units;
+}
+
 static int opal_imc_counters_probe(struct platform_device *pdev)
 {
 	struct device_node *imc_dev = pdev->dev.of_node;



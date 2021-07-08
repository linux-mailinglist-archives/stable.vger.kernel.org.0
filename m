Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A459D3C1A39
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 21:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhGHT65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 15:58:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:42935 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230129AbhGHT64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 15:58:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="209627615"
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="209627615"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 12:56:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="411558364"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2021 12:56:09 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Apply early ACK for small core
Date:   Thu,  8 Jul 2021 12:54:33 -0700
Message-Id: <1625774073-153697-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

A warning as below may be occasionally triggered in an ADL machine when
these conditions occur,
- Two perf record commands run one by one. Both record a PEBS event.
- Both runs on small cores.
- They have different adaptive PEBS configuration (PEBS_DATA_CFG).

[  673.663291] WARNING: CPU: 4 PID: 9874 at
arch/x86/events/intel/ds.c:1743
setup_pebs_adaptive_sample_data+0x55e/0x5b0
[  673.663348] RIP: 0010:setup_pebs_adaptive_sample_data+0x55e/0x5b0
[  673.663357] Call Trace:
[  673.663357]  <NMI>
[  673.663357]  intel_pmu_drain_pebs_icl+0x48b/0x810
[  673.663360]  perf_event_nmi_handler+0x41/0x80
[  673.663368]  </NMI>
[  673.663370]  __perf_event_task_sched_in+0x2c2/0x3a0

Different from the big core, the small core requires the ACK before
re-enabling counters in the NMI handler, otherwise a stale PEBS record
may be dumped into the later NMI handler, which trigger the warning.

Add late_ack in the struct x86_hybrid_pmu to track the late_ack flag for
different types of PMUs. Apply late ACK only for the big cores on an
Alder Lake machine.

The existing hybrid() macro has a compile error when taking address of a
bit-field variable. Add a new macro hybrid_bit() to get the bit-field
value of a given PMU.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 11 +++++------
 arch/x86/events/perf_event.h | 12 ++++++++++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a0dfa82..430a24d 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2904,14 +2904,13 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
  */
 static int intel_pmu_handle_irq(struct pt_regs *regs)
 {
-	struct cpu_hw_events *cpuc;
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	bool late_ack = hybrid_bit(cpuc->pmu, late_ack);
 	int loops;
 	u64 status;
 	int handled;
 	int pmu_enabled;
 
-	cpuc = this_cpu_ptr(&cpu_hw_events);
-
 	/*
 	 * Save the PMU state.
 	 * It needs to be restored when leaving the handler.
@@ -2921,7 +2920,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 * No known reason to not always do late ACK,
 	 * but just in case do it opt-in.
 	 */
-	if (!x86_pmu.late_ack)
+	if (!late_ack)
 		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	intel_bts_disable_local();
 	cpuc->enabled = 0;
@@ -2969,7 +2968,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 * have been reset. This avoids spurious NMIs on
 	 * Haswell CPUs.
 	 */
-	if (x86_pmu.late_ack)
+	if (late_ack)
 		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	return handled;
 }
@@ -6116,7 +6115,6 @@ __init int intel_pmu_init(void)
 		static_branch_enable(&perf_is_hybrid);
 		x86_pmu.num_hybrid_pmus = X86_HYBRID_NUM_PMUS;
 
-		x86_pmu.late_ack = true;
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
@@ -6154,6 +6152,7 @@ __init int intel_pmu_init(void)
 		pmu = &x86_pmu.hybrid_pmu[X86_HYBRID_PMU_CORE_IDX];
 		pmu->name = "cpu_core";
 		pmu->cpu_type = hybrid_big;
+		pmu->late_ack = true;
 		if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
 			pmu->num_counters = x86_pmu.num_counters + 2;
 			pmu->num_counters_fixed = x86_pmu.num_counters_fixed + 1;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index bc8836b..40fa3b1 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -656,6 +656,8 @@ struct x86_hybrid_pmu {
 	struct event_constraint		*event_constraints;
 	struct event_constraint		*pebs_constraints;
 	struct extra_reg		*extra_regs;
+
+	unsigned int			late_ack:1;
 };
 
 static __always_inline struct x86_hybrid_pmu *hybrid_pmu(struct pmu *pmu)
@@ -686,6 +688,16 @@ extern struct static_key_false perf_is_hybrid;
 	__Fp;						\
 }))
 
+#define hybrid_bit(_pmu, _field)			\
+({							\
+	bool __Fp = x86_pmu._field;			\
+							\
+	if (is_hybrid() && (_pmu))			\
+		__Fp = hybrid_pmu(_pmu)->_field;	\
+							\
+	__Fp;						\
+})
+
 enum hybrid_pmu_type {
 	hybrid_big		= 0x40,
 	hybrid_small		= 0x20,
-- 
2.7.4


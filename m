Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2D3B6117
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhF1Obz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhF1Oaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A50A61CC5;
        Mon, 28 Jun 2021 14:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890416;
        bh=1YGfHW07SUdDwNIERwJY4Vt3nnKgSun2SpX6zc/2/cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mY3iARXaCIhROYA/0FoiftM4STsJN/dAS4nSN/hx1DQGd48mMXH/tjdWWfWNc/KFP
         4Zou6PKneMolwwFJgAlXbMgDiAFrSUBKDMuHkYpiqEq3cUpOZ20pIieoIS2IWBgdrC
         bpFusjhYOEIBJTTXz1caZ6wCITaDzsJbPbZxjESfhEuvf/oGHxjStP7hn/JLbEI/Qe
         ntuckcKOKDuTOj2mYQ1IsZgXIafLbRm7MVKnBBffKRFHwXEirxXNg8b9EmVGXO+bKR
         hRRpYM1hzQ8fKKE5B+9ZShZpUdzzRCLKasIliZ/FTf+JBvEgyhdpN1108XQKlol0OK
         jN30ktZkexhKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/101] perf/x86: Track pmu in per-CPU cpu_hw_events
Date:   Mon, 28 Jun 2021 10:25:23 -0400
Message-Id: <20210628142607.32218-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 61e76d53c39bb768ad264d379837cfc56b9e35b4 ]

Some platforms, e.g. Alder Lake, have hybrid architecture. In the same
package, there may be more than one type of CPU. The PMU capabilities
are different among different types of CPU. Perf will register a
dedicated PMU for each type of CPU.

Add a 'pmu' variable in the struct cpu_hw_events to track the dedicated
PMU of the current CPU.

Current x86_get_pmu() use the global 'pmu', which will be broken on a
hybrid platform. Modify it to apply the 'pmu' of the specific CPU.

Initialize the per-CPU 'pmu' variable with the global 'pmu'. There is
nothing changed for the non-hybrid platforms.

The is_x86_event() will be updated in the later patch ("perf/x86:
Register hybrid PMUs") for hybrid platforms. For the non-hybrid
platforms, nothing is changed here.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/1618237865-33448-4-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c       | 17 +++++++++++++----
 arch/x86/events/intel/core.c |  2 +-
 arch/x86/events/intel/ds.c   |  4 ++--
 arch/x86/events/intel/lbr.c  |  9 +++++----
 arch/x86/events/perf_event.h |  4 +++-
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index b7f8ed87bfbc..e6db1a1f22d7 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -45,9 +45,11 @@
 #include "perf_event.h"
 
 struct x86_pmu x86_pmu __read_mostly;
+static struct pmu pmu;
 
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
+	.pmu = &pmu,
 };
 
 DEFINE_STATIC_KEY_FALSE(rdpmc_never_available_key);
@@ -712,16 +714,23 @@ void x86_pmu_enable_all(int added)
 	}
 }
 
-static struct pmu pmu;
-
 static inline int is_x86_event(struct perf_event *event)
 {
 	return event->pmu == &pmu;
 }
 
-struct pmu *x86_get_pmu(void)
+struct pmu *x86_get_pmu(unsigned int cpu)
 {
-	return &pmu;
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+
+	/*
+	 * All CPUs of the hybrid type have been offline.
+	 * The x86_get_pmu() should not be invoked.
+	 */
+	if (WARN_ON_ONCE(!cpuc->pmu))
+		return &pmu;
+
+	return cpuc->pmu;
 }
 /*
  * Event scheduler state:
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ee659b5faf71..3b8b8eede1a8 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4747,7 +4747,7 @@ static void update_tfa_sched(void *ignored)
 	 * and if so force schedule out for all event types all contexts
 	 */
 	if (test_bit(3, cpuc->active_mask))
-		perf_pmu_resched(x86_get_pmu());
+		perf_pmu_resched(x86_get_pmu(smp_processor_id()));
 }
 
 static ssize_t show_sysctl_tfa(struct device *cdev,
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 31a7a6566d07..945d470f62d0 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2076,7 +2076,7 @@ void __init intel_ds_init(void)
 					PERF_SAMPLE_TIME;
 				x86_pmu.flags |= PMU_FL_PEBS_ALL;
 				pebs_qual = "-baseline";
-				x86_get_pmu()->capabilities |= PERF_PMU_CAP_EXTENDED_REGS;
+				x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_EXTENDED_REGS;
 			} else {
 				/* Only basic record supported */
 				x86_pmu.large_pebs_flags &=
@@ -2091,7 +2091,7 @@ void __init intel_ds_init(void)
 
 			if (x86_pmu.intel_cap.pebs_output_pt_available) {
 				pr_cont("PEBS-via-PT, ");
-				x86_get_pmu()->capabilities |= PERF_PMU_CAP_AUX_OUTPUT;
+				x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_AUX_OUTPUT;
 			}
 
 			break;
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 29ec4fe48507..9c1a013d5682 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -699,7 +699,7 @@ void intel_pmu_lbr_add(struct perf_event *event)
 
 void release_lbr_buffers(void)
 {
-	struct kmem_cache *kmem_cache = x86_get_pmu()->task_ctx_cache;
+	struct kmem_cache *kmem_cache;
 	struct cpu_hw_events *cpuc;
 	int cpu;
 
@@ -708,6 +708,7 @@ void release_lbr_buffers(void)
 
 	for_each_possible_cpu(cpu) {
 		cpuc = per_cpu_ptr(&cpu_hw_events, cpu);
+		kmem_cache = x86_get_pmu(cpu)->task_ctx_cache;
 		if (kmem_cache && cpuc->lbr_xsave) {
 			kmem_cache_free(kmem_cache, cpuc->lbr_xsave);
 			cpuc->lbr_xsave = NULL;
@@ -1624,7 +1625,7 @@ void intel_pmu_lbr_init_hsw(void)
 	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
 	x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
 
-	x86_get_pmu()->task_ctx_cache = create_lbr_kmem_cache(size, 0);
+	x86_get_pmu(smp_processor_id())->task_ctx_cache = create_lbr_kmem_cache(size, 0);
 
 	if (lbr_from_signext_quirk_needed())
 		static_branch_enable(&lbr_from_quirk_key);
@@ -1644,7 +1645,7 @@ __init void intel_pmu_lbr_init_skl(void)
 	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
 	x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
 
-	x86_get_pmu()->task_ctx_cache = create_lbr_kmem_cache(size, 0);
+	x86_get_pmu(smp_processor_id())->task_ctx_cache = create_lbr_kmem_cache(size, 0);
 
 	/*
 	 * SW branch filter usage:
@@ -1741,7 +1742,7 @@ static bool is_arch_lbr_xsave_available(void)
 
 void __init intel_pmu_arch_lbr_init(void)
 {
-	struct pmu *pmu = x86_get_pmu();
+	struct pmu *pmu = x86_get_pmu(smp_processor_id());
 	union cpuid28_eax eax;
 	union cpuid28_ebx ebx;
 	union cpuid28_ecx ecx;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index d4f2ea2d9a9e..f07d77cffb3c 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -326,6 +326,8 @@ struct cpu_hw_events {
 	int				n_pair; /* Large increment events */
 
 	void				*kfree_on_online[X86_PERF_KFREE_MAX];
+
+	struct pmu			*pmu;
 };
 
 #define __EVENT_CONSTRAINT_RANGE(c, e, n, m, w, o, f) {	\
@@ -897,7 +899,7 @@ static struct perf_pmu_events_ht_attr event_attr_##v = {		\
 	.event_str_ht	= ht,						\
 }
 
-struct pmu *x86_get_pmu(void);
+struct pmu *x86_get_pmu(unsigned int cpu);
 extern struct x86_pmu x86_pmu __read_mostly;
 
 static __always_inline struct x86_perf_task_context_opt *task_context_opt(void *ctx)
-- 
2.30.2


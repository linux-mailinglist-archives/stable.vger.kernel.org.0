Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08037F288
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391397AbfHBJrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391343AbfHBJrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:47:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 006A52086A;
        Fri,  2 Aug 2019 09:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739261;
        bh=HFYpAkImQwdfq98gnaX2hFhnnTZc7kRHb6Nn5TDNOrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5f/4+y7aP2RrpbUvgEGMdsFwRWA2ifrkud5Gu/tun7GYB5xz54UcHEB/2pQQL8bP
         0eFoDJi5ojRxmFI9lI2UVQSsKVoHIe3gl1fXPx8TC5M2iy3CTmIrUW/y12dxwmXIFp
         OzOMOfK8lIxyiYHDfw3Uya3uU9VfCsZYJiY8QLsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 151/223] perf/x86/amd/uncore: Rename L2 to LLC
Date:   Fri,  2 Aug 2019 11:36:16 +0200
Message-Id: <20190802092248.244613008@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch renames L2 counters to LLC counters. In AMD Family17h
processors, L3 cache counter is supported.

Since older families have at most L2 counters, last level cache (LLC)
indicates L2/L3 based on the family.

Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: http://lkml.kernel.org/r/5d8cd8736d8d578354597a548e64ff16210c319b.1484598705.git.Janakarajan.Natarajan@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/events/amd/uncore.c | 98 ++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 65577f081d07..094973313037 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -25,7 +25,7 @@
 #define MAX_COUNTERS		NUM_COUNTERS_NB
 
 #define RDPMC_BASE_NB		6
-#define RDPMC_BASE_L2		10
+#define RDPMC_BASE_LLC		10
 
 #define COUNTER_SHIFT		16
 
@@ -45,30 +45,30 @@ struct amd_uncore {
 };
 
 static struct amd_uncore * __percpu *amd_uncore_nb;
-static struct amd_uncore * __percpu *amd_uncore_l2;
+static struct amd_uncore * __percpu *amd_uncore_llc;
 
 static struct pmu amd_nb_pmu;
-static struct pmu amd_l2_pmu;
+static struct pmu amd_llc_pmu;
 
 static cpumask_t amd_nb_active_mask;
-static cpumask_t amd_l2_active_mask;
+static cpumask_t amd_llc_active_mask;
 
 static bool is_nb_event(struct perf_event *event)
 {
 	return event->pmu->type == amd_nb_pmu.type;
 }
 
-static bool is_l2_event(struct perf_event *event)
+static bool is_llc_event(struct perf_event *event)
 {
-	return event->pmu->type == amd_l2_pmu.type;
+	return event->pmu->type == amd_llc_pmu.type;
 }
 
 static struct amd_uncore *event_to_amd_uncore(struct perf_event *event)
 {
 	if (is_nb_event(event) && amd_uncore_nb)
 		return *per_cpu_ptr(amd_uncore_nb, event->cpu);
-	else if (is_l2_event(event) && amd_uncore_l2)
-		return *per_cpu_ptr(amd_uncore_l2, event->cpu);
+	else if (is_llc_event(event) && amd_uncore_llc)
+		return *per_cpu_ptr(amd_uncore_llc, event->cpu);
 
 	return NULL;
 }
@@ -183,16 +183,16 @@ static int amd_uncore_event_init(struct perf_event *event)
 		return -ENOENT;
 
 	/*
-	 * NB and L2 counters (MSRs) are shared across all cores that share the
-	 * same NB / L2 cache. Interrupts can be directed to a single target
-	 * core, however, event counts generated by processes running on other
-	 * cores cannot be masked out. So we do not support sampling and
-	 * per-thread events.
+	 * NB and Last level cache counters (MSRs) are shared across all cores
+	 * that share the same NB / Last level cache. Interrupts can be directed
+	 * to a single target core, however, event counts generated by processes
+	 * running on other cores cannot be masked out. So we do not support
+	 * sampling and per-thread events.
 	 */
 	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
 		return -EINVAL;
 
-	/* NB and L2 counters do not have usr/os/guest/host bits */
+	/* NB and Last level cache counters do not have usr/os/guest/host bits */
 	if (event->attr.exclude_user || event->attr.exclude_kernel ||
 	    event->attr.exclude_host || event->attr.exclude_guest)
 		return -EINVAL;
@@ -226,8 +226,8 @@ static ssize_t amd_uncore_attr_show_cpumask(struct device *dev,
 
 	if (pmu->type == amd_nb_pmu.type)
 		active_mask = &amd_nb_active_mask;
-	else if (pmu->type == amd_l2_pmu.type)
-		active_mask = &amd_l2_active_mask;
+	else if (pmu->type == amd_llc_pmu.type)
+		active_mask = &amd_llc_active_mask;
 	else
 		return 0;
 
@@ -276,7 +276,7 @@ static struct pmu amd_nb_pmu = {
 	.read		= amd_uncore_read,
 };
 
-static struct pmu amd_l2_pmu = {
+static struct pmu amd_llc_pmu = {
 	.task_ctx_nr	= perf_invalid_context,
 	.attr_groups	= amd_uncore_attr_groups,
 	.name		= "amd_l2",
@@ -296,7 +296,7 @@ static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)
 
 static int amd_uncore_cpu_up_prepare(unsigned int cpu)
 {
-	struct amd_uncore *uncore_nb = NULL, *uncore_l2;
+	struct amd_uncore *uncore_nb = NULL, *uncore_llc;
 
 	if (amd_uncore_nb) {
 		uncore_nb = amd_uncore_alloc(cpu);
@@ -312,18 +312,18 @@ static int amd_uncore_cpu_up_prepare(unsigned int cpu)
 		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore_nb;
 	}
 
-	if (amd_uncore_l2) {
-		uncore_l2 = amd_uncore_alloc(cpu);
-		if (!uncore_l2)
+	if (amd_uncore_llc) {
+		uncore_llc = amd_uncore_alloc(cpu);
+		if (!uncore_llc)
 			goto fail;
-		uncore_l2->cpu = cpu;
-		uncore_l2->num_counters = NUM_COUNTERS_L2;
-		uncore_l2->rdpmc_base = RDPMC_BASE_L2;
-		uncore_l2->msr_base = MSR_F16H_L2I_PERF_CTL;
-		uncore_l2->active_mask = &amd_l2_active_mask;
-		uncore_l2->pmu = &amd_l2_pmu;
-		uncore_l2->id = -1;
-		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore_l2;
+		uncore_llc->cpu = cpu;
+		uncore_llc->num_counters = NUM_COUNTERS_L2;
+		uncore_llc->rdpmc_base = RDPMC_BASE_LLC;
+		uncore_llc->msr_base = MSR_F16H_L2I_PERF_CTL;
+		uncore_llc->active_mask = &amd_llc_active_mask;
+		uncore_llc->pmu = &amd_llc_pmu;
+		uncore_llc->id = -1;
+		*per_cpu_ptr(amd_uncore_llc, cpu) = uncore_llc;
 	}
 
 	return 0;
@@ -376,17 +376,17 @@ static int amd_uncore_cpu_starting(unsigned int cpu)
 		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
 	}
 
-	if (amd_uncore_l2) {
+	if (amd_uncore_llc) {
 		unsigned int apicid = cpu_data(cpu).apicid;
 		unsigned int nshared;
 
-		uncore = *per_cpu_ptr(amd_uncore_l2, cpu);
+		uncore = *per_cpu_ptr(amd_uncore_llc, cpu);
 		cpuid_count(0x8000001d, 2, &eax, &ebx, &ecx, &edx);
 		nshared = ((eax >> 14) & 0xfff) + 1;
 		uncore->id = apicid - (apicid % nshared);
 
-		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_l2);
-		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_llc);
+		*per_cpu_ptr(amd_uncore_llc, cpu) = uncore;
 	}
 
 	return 0;
@@ -419,8 +419,8 @@ static int amd_uncore_cpu_online(unsigned int cpu)
 	if (amd_uncore_nb)
 		uncore_online(cpu, amd_uncore_nb);
 
-	if (amd_uncore_l2)
-		uncore_online(cpu, amd_uncore_l2);
+	if (amd_uncore_llc)
+		uncore_online(cpu, amd_uncore_llc);
 
 	return 0;
 }
@@ -456,8 +456,8 @@ static int amd_uncore_cpu_down_prepare(unsigned int cpu)
 	if (amd_uncore_nb)
 		uncore_down_prepare(cpu, amd_uncore_nb);
 
-	if (amd_uncore_l2)
-		uncore_down_prepare(cpu, amd_uncore_l2);
+	if (amd_uncore_llc)
+		uncore_down_prepare(cpu, amd_uncore_llc);
 
 	return 0;
 }
@@ -479,8 +479,8 @@ static int amd_uncore_cpu_dead(unsigned int cpu)
 	if (amd_uncore_nb)
 		uncore_dead(cpu, amd_uncore_nb);
 
-	if (amd_uncore_l2)
-		uncore_dead(cpu, amd_uncore_l2);
+	if (amd_uncore_llc)
+		uncore_dead(cpu, amd_uncore_llc);
 
 	return 0;
 }
@@ -510,16 +510,16 @@ static int __init amd_uncore_init(void)
 	}
 
 	if (boot_cpu_has(X86_FEATURE_PERFCTR_L2)) {
-		amd_uncore_l2 = alloc_percpu(struct amd_uncore *);
-		if (!amd_uncore_l2) {
+		amd_uncore_llc = alloc_percpu(struct amd_uncore *);
+		if (!amd_uncore_llc) {
 			ret = -ENOMEM;
-			goto fail_l2;
+			goto fail_llc;
 		}
-		ret = perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
+		ret = perf_pmu_register(&amd_llc_pmu, amd_llc_pmu.name, -1);
 		if (ret)
-			goto fail_l2;
+			goto fail_llc;
 
-		pr_info("perf: AMD L2I counters detected\n");
+		pr_info("perf: AMD LLC counters detected\n");
 		ret = 0;
 	}
 
@@ -529,7 +529,7 @@ static int __init amd_uncore_init(void)
 	if (cpuhp_setup_state(CPUHP_PERF_X86_AMD_UNCORE_PREP,
 			      "PERF_X86_AMD_UNCORE_PREP",
 			      amd_uncore_cpu_up_prepare, amd_uncore_cpu_dead))
-		goto fail_l2;
+		goto fail_llc;
 
 	if (cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_UNCORE_STARTING,
 			      "AP_PERF_X86_AMD_UNCORE_STARTING",
@@ -546,11 +546,11 @@ static int __init amd_uncore_init(void)
 	cpuhp_remove_state(CPUHP_AP_PERF_X86_AMD_UNCORE_STARTING);
 fail_prep:
 	cpuhp_remove_state(CPUHP_PERF_X86_AMD_UNCORE_PREP);
-fail_l2:
+fail_llc:
 	if (boot_cpu_has(X86_FEATURE_PERFCTR_NB))
 		perf_pmu_unregister(&amd_nb_pmu);
-	if (amd_uncore_l2)
-		free_percpu(amd_uncore_l2);
+	if (amd_uncore_llc)
+		free_percpu(amd_uncore_llc);
 fail_nb:
 	if (amd_uncore_nb)
 		free_percpu(amd_uncore_nb);
-- 
2.20.1




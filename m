Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89671671A6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgBUH4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbgBUH4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:56:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1165A20658;
        Fri, 21 Feb 2020 07:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271763;
        bh=b8RJsYpvF1Q+Tn7nBm8uiHgkJbJ2rIKXICWRWJJPqAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xpu5f0MI1TzuFXUQDAD9KYh0vpaDEo80T73SroDXUaPs+TjzXT22SOBGpcyOq/AS2
         7+DpdggCbGEHJs6Wx05E6LfOPiclc1DefgMoqisoJudqrmsGGvdWecJr0LzR0L9gdl
         2xHgT2alIc+sRf0zZvs69IiwNwWQUE0AV3iMfot8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 290/399] perf/x86/amd: Constrain Large Increment per Cycle events
Date:   Fri, 21 Feb 2020 08:40:15 +0100
Message-Id: <20200221072430.007681489@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 471af006a747f1c535c8a8c6c0973c320fe01b22 ]

AMD Family 17h processors and above gain support for Large Increment
per Cycle events.  Unfortunately there is no CPUID or equivalent bit
that indicates whether the feature exists or not, so we continue to
determine eligibility based on a CPU family number comparison.

For Large Increment per Cycle events, we add a f17h-and-compatibles
get_event_constraints_f17h() that returns an even counter bitmask:
Large Increment per Cycle events can only be placed on PMCs 0, 2,
and 4 out of the currently available 0-5.  The only currently
public event that requires this feature to report valid counts
is PMCx003 "Retired SSE/AVX Operations".

Note that the CPU family logic in amd_core_pmu_init() is changed
so as to be able to selectively add initialization for features
available in ranges of backward-compatible CPU families.  This
Large Increment per Cycle feature is expected to be retained
in future families.

A side-effect of assigning a new get_constraints function for f17h
disables calling the old (prior to f15h) amd_get_event_constraints
implementation left enabled by commit e40ed1542dd7 ("perf/x86: Add perf
support for AMD family-17h processors"), which is no longer
necessary since those North Bridge event codes are obsoleted.

Also fix a spelling mistake whilst in the area (calulating ->
calculating).

Fixes: e40ed1542dd7 ("perf/x86: Add perf support for AMD family-17h processors")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191114183720.19887-2-kim.phillips@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c   | 91 ++++++++++++++++++++++++------------
 arch/x86/events/perf_event.h |  2 +
 2 files changed, 63 insertions(+), 30 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index dede714b46e83..3253797fa8a14 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -302,6 +302,25 @@ static inline int amd_pmu_addr_offset(int index, bool eventsel)
 	return offset;
 }
 
+/*
+ * AMD64 events are detected based on their event codes.
+ */
+static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
+{
+	return ((hwc->config >> 24) & 0x0f00) | (hwc->config & 0x00ff);
+}
+
+static inline bool amd_is_pair_event_code(struct hw_perf_event *hwc)
+{
+	if (!(x86_pmu.flags & PMU_FL_PAIR))
+		return false;
+
+	switch (amd_get_event_code(hwc)) {
+	case 0x003:	return true;	/* Retired SSE/AVX FLOPs */
+	default:	return false;
+	}
+}
+
 static int amd_core_hw_config(struct perf_event *event)
 {
 	if (event->attr.exclude_host && event->attr.exclude_guest)
@@ -320,14 +339,6 @@ static int amd_core_hw_config(struct perf_event *event)
 	return 0;
 }
 
-/*
- * AMD64 events are detected based on their event codes.
- */
-static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
-{
-	return ((hwc->config >> 24) & 0x0f00) | (hwc->config & 0x00ff);
-}
-
 static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 {
 	return (hwc->config & 0xe0) == 0xe0;
@@ -856,6 +867,20 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, int idx,
 	}
 }
 
+static struct event_constraint pair_constraint;
+
+static struct event_constraint *
+amd_get_event_constraints_f17h(struct cpu_hw_events *cpuc, int idx,
+			       struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (amd_is_pair_event_code(hwc))
+		return &pair_constraint;
+
+	return &unconstrained;
+}
+
 static ssize_t amd_event_sysfs_show(char *page, u64 config)
 {
 	u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
@@ -899,33 +924,15 @@ static __initconst const struct x86_pmu amd_pmu = {
 
 static int __init amd_core_pmu_init(void)
 {
+	u64 even_ctr_mask = 0ULL;
+	int i;
+
 	if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
 		return 0;
 
-	/* Avoid calulating the value each time in the NMI handler */
+	/* Avoid calculating the value each time in the NMI handler */
 	perf_nmi_window = msecs_to_jiffies(100);
 
-	switch (boot_cpu_data.x86) {
-	case 0x15:
-		pr_cont("Fam15h ");
-		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
-		break;
-	case 0x17:
-		pr_cont("Fam17h ");
-		/*
-		 * In family 17h, there are no event constraints in the PMC hardware.
-		 * We fallback to using default amd_get_event_constraints.
-		 */
-		break;
-	case 0x18:
-		pr_cont("Fam18h ");
-		/* Using default amd_get_event_constraints. */
-		break;
-	default:
-		pr_err("core perfctr but no constraints; unknown hardware!\n");
-		return -ENODEV;
-	}
-
 	/*
 	 * If core performance counter extensions exists, we must use
 	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
@@ -940,6 +947,30 @@ static int __init amd_core_pmu_init(void)
 	 */
 	x86_pmu.amd_nb_constraints = 0;
 
+	if (boot_cpu_data.x86 == 0x15) {
+		pr_cont("Fam15h ");
+		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
+	}
+	if (boot_cpu_data.x86 >= 0x17) {
+		pr_cont("Fam17h+ ");
+		/*
+		 * Family 17h and compatibles have constraints for Large
+		 * Increment per Cycle events: they may only be assigned an
+		 * even numbered counter that has a consecutive adjacent odd
+		 * numbered counter following it.
+		 */
+		for (i = 0; i < x86_pmu.num_counters - 1; i += 2)
+			even_ctr_mask |= 1 << i;
+
+		pair_constraint = (struct event_constraint)
+				    __EVENT_CONSTRAINT(0, even_ctr_mask, 0,
+				    x86_pmu.num_counters / 2, 0,
+				    PERF_X86_EVENT_PAIR);
+
+		x86_pmu.get_event_constraints = amd_get_event_constraints_f17h;
+		x86_pmu.flags |= PMU_FL_PAIR;
+	}
+
 	pr_cont("core perfctr, ");
 	return 0;
 }
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 930611db8f9ad..e2fd363de6490 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -77,6 +77,7 @@ static inline bool constraint_match(struct event_constraint *c, u64 ecode)
 #define PERF_X86_EVENT_AUTO_RELOAD	0x0200 /* use PEBS auto-reload */
 #define PERF_X86_EVENT_LARGE_PEBS	0x0400 /* use large PEBS */
 #define PERF_X86_EVENT_PEBS_VIA_PT	0x0800 /* use PT buffer for PEBS */
+#define PERF_X86_EVENT_PAIR		0x1000 /* Large Increment per Cycle */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -743,6 +744,7 @@ do {									\
 #define PMU_FL_EXCL_ENABLED	0x8 /* exclusive counter active */
 #define PMU_FL_PEBS_ALL		0x10 /* all events are valid PEBS events */
 #define PMU_FL_TFA		0x20 /* deal with TSX force abort */
+#define PMU_FL_PAIR		0x40 /* merge counters for large incr. events */
 
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
-- 
2.20.1




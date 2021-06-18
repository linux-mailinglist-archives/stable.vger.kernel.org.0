Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346643ACF00
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 17:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhFRPcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:32:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:7105 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235306AbhFRPbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 11:31:32 -0400
IronPort-SDR: 07FW9mVOTbmmQEqzly8rhgUY3OKh11FLwiMDeKVEjuh4kDb7SlQw4HSVsPKgvqy5TFP1lJMh6C
 8eDZjkf++o3Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="228099642"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="228099642"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 08:27:38 -0700
IronPort-SDR: v5rRBib0A9KxqgFZyDwtrpraOCDkSDYTkjmEuYHeOK0ssOEv5srJwRLOTgIPlM5ZZz94aR1tND
 zrFY14US10RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="405004802"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2021 08:27:31 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org,
        ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 1/3] perf/x86/intel: Fix fixed counter check warning for some Alder Lake
Date:   Fri, 18 Jun 2021 08:12:52 -0700
Message-Id: <1624029174-122219-2-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624029174-122219-1-git-send-email-kan.liang@linux.intel.com>
References: <1624029174-122219-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

For some Alder Lake machine, the below fixed counter check warning may be
triggered.

[    2.010766] hw perf events fixed 5 > max(4), clipping!

Current perf unconditionally increases the number of the GP counters and
the fixed counters for a big core PMU on an Alder Lake system, because
the number enumerated in the CPUID only reflects the common counters.
The big core may has more counters. However, Alder Lake may have an
alternative configuration. With that configuration,
the X86_FEATURE_HYBRID_CPU is not set. The number of the GP counters and
fixed counters enumerated in the CPUID is accurate. Perf mistakenly
increases the number of counters. The warning is triggered.

Directly use the enumerated value on the system with the alternative
configuration.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Reported-by: Jin Yao <yao.jin@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---

The original post can be found at
https://lkml.kernel.org/r/1623413662-18373-1-git-send-email-kan.liang@linux.intel.com

 arch/x86/events/intel/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2521d03..d39991b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6157,8 +6157,13 @@ __init int intel_pmu_init(void)
 		pmu = &x86_pmu.hybrid_pmu[X86_HYBRID_PMU_CORE_IDX];
 		pmu->name = "cpu_core";
 		pmu->cpu_type = hybrid_big;
-		pmu->num_counters = x86_pmu.num_counters + 2;
-		pmu->num_counters_fixed = x86_pmu.num_counters_fixed + 1;
+		if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
+			pmu->num_counters = x86_pmu.num_counters + 2;
+			pmu->num_counters_fixed = x86_pmu.num_counters_fixed + 1;
+		} else {
+			pmu->num_counters = x86_pmu.num_counters;
+			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
+		}
 		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
 		pmu->unconstrained = (struct event_constraint)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
-- 
2.7.4


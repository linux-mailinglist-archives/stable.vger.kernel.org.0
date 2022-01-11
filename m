Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B9F48B0B6
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbiAKPWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:22:34 -0500
Received: from mga04.intel.com ([192.55.52.120]:54788 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244282AbiAKPWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jan 2022 10:22:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641914553; x=1673450553;
  h=from:to:cc:subject:date:message-id;
  bh=qHDvV49FVKi25DFlOBn1BHHv0zAKCi/3qZvAOG1WG/E=;
  b=hcz9h+EyJQL2DCnCbi+A/lV14IAztJM/nV6R1V8NnIim9ESzFoEH4CfD
   SoRid+Kvqylbcb7g/2D64S/RLXpDuSvQB3g/4rgoIVKiy7jjCRB14QIoz
   EjMNF2xFq1aUTNSZD5qil56IYMQ73mK76Xr7zmkkXMFGlmweqdp5ICHLE
   /VF0n3ajw5KymP7EBQIq+SAYGHrmAj3mz5Baqd4oEdFAbrQyoCRcatjsj
   HAiLt8q7aC5yBeclOa9LjbjdAGXbPa2EB21waQ6WOmWnDAGvxZBEAhl2f
   qamlL9uLUTQyzWABQqmdrPnTonvU4DNGWG0M3zgW/nWJ4Xx3bgiuPiFhk
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="242320539"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="242320539"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 07:22:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="474562855"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga006.jf.intel.com with ESMTP; 11 Jan 2022 07:22:18 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, damarion@cisco.com, edison_chan_gz@hotmail.com,
        ray.kinsella@intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Add a quirk for the calculation of the number of counters on Alder Lake
Date:   Tue, 11 Jan 2022 10:20:38 -0800
Message-Id: <1641925238-149288-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

For some Alder Lake machine with all E-cores disabled in a BIOS, the
below warning may be triggered.

[ 2.010766] hw perf events fixed 5 > max(4), clipping!

Current perf code relies on the CPUID leaf 0xA and leaf 7.EDX[15] to
calculate the number of the counters and follow the below assumption.

For a hybrid configuration, the leaf 7.EDX[15] (X86_FEATURE_HYBRID_CPU)
is set. The leaf 0xA only enumerate the common counters. Linux perf has
to manually add the extra GP counters and fixed counters for P-cores.
For a non-hybrid configuration, the X86_FEATURE_HYBRID_CPU should not
be set. The leaf 0xA enumerates all counters.

However, that's not the case when all E-cores are disabled in a BIOS.
Although there are only P-cores in the system, the leaf 7.EDX[15]
(X86_FEATURE_HYBRID_CPU) is still set. But the leaf 0xA is updated
to enumerate all counters of P-cores. The inconsistency triggers the
warning.

Several software ways were considered to handle the inconsistency.
- Drop the leaf 0xA and leaf 7.EDX[15] CPUID enumeration support.
  Hardcode the number of counters. This solution may be a problem for
  virtualization. A hypervisor cannot control the number of counters
  in a Linux guest via changing the guest CPUID enumeration anymore.
- Find another CPUID bit that is also updated with E-cores disabled.
  There may be a problem in the virtualization environment too. Because
  a hypervisor may disable the feature/CPUID bit.
- The P-cores have a maximum of 8 GP counters and 4 fixed counters on
  ADL. The maximum number can be used to detect the case.
  This solution is implemented in this patch.

Fixes: ee72a94ea4a6 ("perf/x86/intel: Fix fixed counter check warning for some Alder Lake")
Reported-by: Damjan Marion (damarion) <damarion@cisco.com>
Tested-by: Damjan Marion (damarion) <damarion@cisco.com>
Reported-by: Chan Edison <edison_chan_gz@hotmail.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 187906e..f1201e8 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6239,6 +6239,18 @@ __init int intel_pmu_init(void)
 			pmu->num_counters = x86_pmu.num_counters;
 			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
 		}
+
+		/* Quirk: For some Alder Lake machine, when all E-cores are disabled in
+		 * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
+		 * the X86_FEATURE_HYBRID_CPU is still set. The above codes will
+		 * mistakenly add extra counters for P-cores. Correct the number of
+		 * counters here.
+		 */
+		if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
+			pmu->num_counters = x86_pmu.num_counters;
+			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
+		}
+
 		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
 		pmu->unconstrained = (struct event_constraint)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
-- 
2.7.4


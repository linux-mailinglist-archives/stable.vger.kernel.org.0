Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1BF67BC8A
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 21:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjAYU2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 15:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbjAYU2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 15:28:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F0918B1E;
        Wed, 25 Jan 2023 12:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674678526; x=1706214526;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NHhfbEA3+ALiNjZfOCrhagTrZL43nqVOc3EIo2NrQz4=;
  b=SU4htNjbtf30zndJObs/uVTo1SHIVkio20+sX5afGeBPpRkCdaNEZ7Vd
   rBve3eUICA8z0KcsQinFvcEKcLKvqkkWp948fBhOJqzigxDO/IUn3Hbq6
   LSU5QeXGEC/lHHmAT/4n12ynpO+nCBjoCpl8P1n+6Z7A9OUGAxcErx8lf
   cs817ZZbPW8PSXM01ntJnJ0J7KdqNx+1RpizHuKpMBTq35/j3IzVLvMvF
   EBdi45jtfiW5kx6YuKJDyW4rmeib7MrX8jFUktUgimtLYaXXsIlyKy2p2
   iSKkHgcUc2WKju3KkuUehYUvakcShoLw9J/5su0HZ4uUqDB2hTAhio9f8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="310247043"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="310247043"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 12:28:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="726022748"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="726022748"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by fmsmga008.fm.intel.com with ESMTP; 25 Jan 2023 12:28:44 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, ak@linux.intel.com, pengfei.xu@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel: Fix guest vPMU warning on hybrid CPUs
Date:   Wed, 25 Jan 2023 12:28:35 -0800
Message-Id: <20230125202835.924016-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The below error can be observed in a Linux guest, when the hypervisor
is on a hybrid machine.

[    0.118214] unchecked MSR access error: WRMSR to 0x38f (tried to
write 0x00011000f0000003f) at rIP: 0xffffffff83082124
(native_write_msr+0x4/0x30)
[    0.118949] Call Trace:
[    0.119092]  <TASK>
[    0.119215]  ? __intel_pmu_enable_all.constprop.0+0x88/0xe0
[    0.119533]  intel_pmu_enable_all+0x15/0x20
[    0.119778]  x86_pmu_enable+0x17c/0x320

The current perf wrongly assumes that the perf metrics feature is always
enabled on p-core. It unconditionally enables the feature to workaround
the unreliable enumeration of the PERF_CAPABILITIES MSR. The assumption
is safe to bare metal. However, KVM doesn't support the perf metrics
feature yet. Setting the corresponding bit triggers MSR access error
in a guest.

Only unconditionally enable the core specific PMU feature for bare metal
on ADL and RPL, which includes the perf metrics on p-core and
PEBS-via-PT on e-core.
For the future platforms, perf doesn't need to hardcode the PMU feature.
The per-core PMU features can be enumerated by the enhanced
PERF_CAPABILITIES MSR and CPUID leaf 0x23. There is no such issue.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Link: https://lore.kernel.org/lkml/e161b7c0-f0be-23c8-9a25-002260c2a085@linux.intel.com/
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---


Based on my limit knowledge regarding KVM and guest, I use the
HYPERVISOR bit to tell whether it's a guest. But I'm not sure whether
it's reliable. Please let me know if there is a better way. Thanks.


 arch/x86/events/intel/core.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index bbb7846d3c1e..8d08929a7250 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6459,8 +6459,17 @@ __init int intel_pmu_init(void)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
 							   0, pmu->num_counters, 0, 0);
 		pmu->intel_cap.capabilities = x86_pmu.intel_cap.capabilities;
-		pmu->intel_cap.perf_metrics = 1;
-		pmu->intel_cap.pebs_output_pt_available = 0;
+		/*
+		 * The capability bits are not reliable on ADL and RPL.
+		 * For bare metal, it's safe to assume that some features
+		 * are always enabled, e.g., the perf metrics on p-core,
+		 * but we cannot do the same assumption for a hypervisor.
+		 * Only update the core specific PMU feature for bare metal.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+			pmu->intel_cap.perf_metrics = 1;
+			pmu->intel_cap.pebs_output_pt_available = 0;
+		}
 
 		memcpy(pmu->hw_cache_event_ids, spr_hw_cache_event_ids, sizeof(pmu->hw_cache_event_ids));
 		memcpy(pmu->hw_cache_extra_regs, spr_hw_cache_extra_regs, sizeof(pmu->hw_cache_extra_regs));
@@ -6480,8 +6489,10 @@ __init int intel_pmu_init(void)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
 							   0, pmu->num_counters, 0, 0);
 		pmu->intel_cap.capabilities = x86_pmu.intel_cap.capabilities;
-		pmu->intel_cap.perf_metrics = 0;
-		pmu->intel_cap.pebs_output_pt_available = 1;
+		if (!boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+			pmu->intel_cap.perf_metrics = 0;
+			pmu->intel_cap.pebs_output_pt_available = 1;
+		}
 
 		memcpy(pmu->hw_cache_event_ids, glp_hw_cache_event_ids, sizeof(pmu->hw_cache_event_ids));
 		memcpy(pmu->hw_cache_extra_regs, tnt_hw_cache_extra_regs, sizeof(pmu->hw_cache_extra_regs));
-- 
2.35.1


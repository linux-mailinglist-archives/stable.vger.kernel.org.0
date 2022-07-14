Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064095754EE
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 20:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiGNS1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 14:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGNS1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 14:27:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD8C2F67F;
        Thu, 14 Jul 2022 11:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657823224; x=1689359224;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ONPbwadEFPaJq6FRTJMZTyZ98gk4Ml1qAm6cr+oQAwY=;
  b=FMr1vveyhFEQoIHML4WpdQ4TACQMGNzNE96UejscZH4tVRPOvsyBMhTf
   b4zdlgiYi8UwwOg24GmrcU9UH+96oPR/afhbDBQH1al5nTrL5hrm88HWo
   0jODBk3Iwo93Adk4jvxBEDkMbBtHUjYUAkZ0fwm+wGzkztQZ41VeGlQBD
   WKJUSGwJHADnw6xjJv/YqC1Uj+P849g9jLPoGMBODz2+kmm/N6TjBECkN
   8BGqds8PxBDPJ7+PqoMfnXjGUK3GIu0xbf+RX4QPPt/5Zw9QwabVNfwso
   7k9kVUhsxAajiuLmO0VG4HNfRb2VhWdCIIFEGhsL6EJP+39vv8fqeRqs+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="285623054"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="285623054"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:27:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="571210455"
Received: from kanliang-dev.jf.intel.com ([10.165.154.102])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2022 11:27:03 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        vincent.weaver@maine.edu, linux-kernel@vger.kernel.org
Cc:     mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, namhyung@kernel.org,
        pawan.kumar.gupta@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel/lbr: Fix unchecked MSR access error on HSW
Date:   Thu, 14 Jul 2022 11:26:30 -0700
Message-Id: <20220714182630.342107-1-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

The fuzzer triggers the below trace.

[ 7763.384369] unchecked MSR access error: WRMSR to 0x689
(tried to write 0x1fffffff8101349e) at rIP: 0xffffffff810704a4
(native_write_msr+0x4/0x20)
[ 7763.397420] Call Trace:
[ 7763.399881]  <TASK>
[ 7763.401994]  intel_pmu_lbr_restore+0x9a/0x1f0
[ 7763.406363]  intel_pmu_lbr_sched_task+0x91/0x1c0
[ 7763.410992]  __perf_event_task_sched_in+0x1cd/0x240

On a machine with the LBR format LBR_FORMAT_EIP_FLAGS2, when the TSX is
disabled, a TSX quirk is required to access LBR from registers.
The lbr_from_signext_quirk_needed() is introduced to determine whether
the TSX quirk should be applied. However, the
lbr_from_signext_quirk_needed() is invoked before the
intel_pmu_lbr_init(), which parses the LBR format information. Without
the correct LBR format information, the TSX quirk never be applied.

Move the lbr_from_signext_quirk_needed() into the intel_pmu_lbr_init().
Checking x86_pmu.lbr_has_tsx in the lbr_from_signext_quirk_needed() is
not required anymore.

Both LBR_FORMAT_EIP_FLAGS2 and LBR_FORMAT_INFO have LBR_TSX flag, but
only the LBR_FORMAT_EIP_FLAGS2 requirs the quirk. Update the comments
accordingly.

Fixes: 1ac7fd8159a8 ("perf/x86/intel/lbr: Support LBR format V7")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/lbr.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 13179f31fe10..4f70fb6c2c1e 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -278,9 +278,9 @@ enum {
 };
 
 /*
- * For formats with LBR_TSX flags (e.g. LBR_FORMAT_EIP_FLAGS2), bits 61:62 in
- * MSR_LAST_BRANCH_FROM_x are the TSX flags when TSX is supported, but when
- * TSX is not supported they have no consistent behavior:
+ * For format LBR_FORMAT_EIP_FLAGS2, bits 61:62 in MSR_LAST_BRANCH_FROM_x
+ * are the TSX flags when TSX is supported, but when TSX is not supported
+ * they have no consistent behavior:
  *
  *   - For wrmsr(), bits 61:62 are considered part of the sign extension.
  *   - For HW updates (branch captures) bits 61:62 are always OFF and are not
@@ -288,7 +288,7 @@ enum {
  *
  * Therefore, if:
  *
- *   1) LBR has TSX format
+ *   1) LBR format LBR_FORMAT_EIP_FLAGS2
  *   2) CPU has no TSX support enabled
  *
  * ... then any value passed to wrmsr() must be sign extended to 63 bits and any
@@ -300,7 +300,7 @@ static inline bool lbr_from_signext_quirk_needed(void)
 	bool tsx_support = boot_cpu_has(X86_FEATURE_HLE) ||
 			   boot_cpu_has(X86_FEATURE_RTM);
 
-	return !tsx_support && x86_pmu.lbr_has_tsx;
+	return !tsx_support;
 }
 
 static DEFINE_STATIC_KEY_FALSE(lbr_from_quirk_key);
@@ -1609,9 +1609,6 @@ void intel_pmu_lbr_init_hsw(void)
 	x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
 
 	x86_get_pmu(smp_processor_id())->task_ctx_cache = create_lbr_kmem_cache(size, 0);
-
-	if (lbr_from_signext_quirk_needed())
-		static_branch_enable(&lbr_from_quirk_key);
 }
 
 /* skylake */
@@ -1702,7 +1699,11 @@ void intel_pmu_lbr_init(void)
 	switch (x86_pmu.intel_cap.lbr_format) {
 	case LBR_FORMAT_EIP_FLAGS2:
 		x86_pmu.lbr_has_tsx = 1;
-		fallthrough;
+		x86_pmu.lbr_from_flags = 1;
+		if (lbr_from_signext_quirk_needed())
+			static_branch_enable(&lbr_from_quirk_key);
+		break;
+
 	case LBR_FORMAT_EIP_FLAGS:
 		x86_pmu.lbr_from_flags = 1;
 		break;
-- 
2.35.1


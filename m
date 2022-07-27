Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D9B583123
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243078AbiG0RrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243080AbiG0Rqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A8D8C76A;
        Wed, 27 Jul 2022 09:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 319D161743;
        Wed, 27 Jul 2022 16:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEFCC433C1;
        Wed, 27 Jul 2022 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940823;
        bh=BgXZK7+K8o2mjyPze4zimnYbMgx7vzX+PZeG7dtgKOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHrs3mDEgNVBKOLCVawVIkuhhh5AdJ1q6zPSiw8oalHmyLE6sDguGoSydU35ou1or
         RYxaUyy1pugQiRjRGs2WuNZXgAd0UtT9aEqum9vTHsY8+8dClfaJAcgD2pUUNyUgSG
         1CufDvF7rbiVRfbv8tpAx/1JPV+HwphuixsgXslk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.18 136/158] perf/x86/intel/lbr: Fix unchecked MSR access error on HSW
Date:   Wed, 27 Jul 2022 18:13:20 +0200
Message-Id: <20220727161026.822310872@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit b0380e13502adf7dd8be4c47d622c3522aae6c63 upstream.

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
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220714182630.342107-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/lbr.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

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
@@ -300,7 +300,7 @@ static inline bool lbr_from_signext_quir
 	bool tsx_support = boot_cpu_has(X86_FEATURE_HLE) ||
 			   boot_cpu_has(X86_FEATURE_RTM);
 
-	return !tsx_support && x86_pmu.lbr_has_tsx;
+	return !tsx_support;
 }
 
 static DEFINE_STATIC_KEY_FALSE(lbr_from_quirk_key);
@@ -1611,9 +1611,6 @@ void intel_pmu_lbr_init_hsw(void)
 	x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
 
 	x86_get_pmu(smp_processor_id())->task_ctx_cache = create_lbr_kmem_cache(size, 0);
-
-	if (lbr_from_signext_quirk_needed())
-		static_branch_enable(&lbr_from_quirk_key);
 }
 
 /* skylake */
@@ -1704,7 +1701,11 @@ void intel_pmu_lbr_init(void)
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD957C678
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 10:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiGUIhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 04:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiGUIhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 04:37:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2541B7E814;
        Thu, 21 Jul 2022 01:37:29 -0700 (PDT)
Date:   Thu, 21 Jul 2022 08:37:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658392647;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgmm6P5NStO8xQ9Jrqqxsf80/LCa4/tYLCbiRKhzguA=;
        b=HBuml7YcoHb8XBbiXTirAmcBQVrF6oec6399mBoC/OyJsvEpOhBL1Lt5wg++wb0A6MAVQ9
        7zijwpb9OfqFxIf/Wvwp/qfGDf4woUAEZJ3vc9GFSfoiX8waIMEP1CqbJ7wYCy7+biev2V
        XNF1wEVsyaOJ9J6cCA9xsNY3JnYBORukNcaIBvo5AXbCcXqqloL7v5wnQP8T8SNgEOVZw3
        DGk/grEMeGEEYXuqfMBP6jNX2aGx2NglvIB9kxFSQyt8SuoP8UxyRr4cx7aGkBRhqvzHY3
        xetOOlSxK9UB2n1hA9idX+DtboVZ9LANa5pZbaZIZdRbMrYE+costKKW41OfLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658392647;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgmm6P5NStO8xQ9Jrqqxsf80/LCa4/tYLCbiRKhzguA=;
        b=vldcFe6JfaN5r1jUx0N+VeHShRHY6hwGLwp8E37H18eOgSznrlUslK8JD8fkg+k5cO2spH
        zmNCQ8Stgy6TBjBQ==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel/lbr: Fix unchecked MSR access error on HSW
Cc:     Vince Weaver <vincent.weaver@maine.edu>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220714182630.342107-1-kan.liang@linux.intel.com>
References: <20220714182630.342107-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <165839264629.15455.15614431211200025269.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     b0380e13502adf7dd8be4c47d622c3522aae6c63
Gitweb:        https://git.kernel.org/tip/b0380e13502adf7dd8be4c47d622c3522aae6c63
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Thu, 14 Jul 2022 11:26:30 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 20 Jul 2022 19:24:55 +02:00

perf/x86/intel/lbr: Fix unchecked MSR access error on HSW

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
---
 arch/x86/events/intel/lbr.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 13179f3..4f70fb6 100644
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

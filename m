Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5739350530A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiDRMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240353AbiDRMys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:54:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AFF14012;
        Mon, 18 Apr 2022 05:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32FA060F0E;
        Mon, 18 Apr 2022 12:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC4CC385A7;
        Mon, 18 Apr 2022 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285304;
        bh=PR1E3ZPlJQI92WZdb6Vzp2GTXD7XvS1wO5FB00WKHTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+5w2x2+Xy7MlMipHBOSSZ5Cd856gFepm+fPo7bHmg155mJ2LHkwI3aIHtU4dotUx
         dYvWX3RnSQIbnR2TZO+b76eZW9y6pOp71LHS+Hdrygs63fZ0PHEKRl9uH0dB8ans9Y
         z2pSDMo439B4HG1Sf2N65ty0xvyjb1PhpJExSsq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>
Subject: [PATCH 5.15 165/189] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Date:   Mon, 18 Apr 2022 14:13:05 +0200
Message-Id: <20220418121207.139650216@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 258f3b8c3210b03386e4ad92b4bd8652b5c1beb3 upstream.

tsx_clear_cpuid() uses MSR_TSX_FORCE_ABORT to clear CPUID.RTM and
CPUID.HLE. Not all CPUs support MSR_TSX_FORCE_ABORT, alternatively use
MSR_IA32_TSX_CTRL when supported.

  [ bp: Document how and why TSX gets disabled. ]

Fixes: 293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5b323e77e251a9c8bcdda498c5cc0095be1e1d3c.1646943780.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel.c |    1 
 arch/x86/kernel/cpu/tsx.c   |   54 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -722,6 +722,7 @@ static void init_intel(struct cpuinfo_x8
 	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
 		tsx_disable();
 	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
+		/* See comment over that function for more details. */
 		tsx_clear_cpuid();
 
 	split_lock_init();
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -58,7 +58,7 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
+static bool tsx_ctrl_is_supported(void)
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
 
@@ -84,6 +84,44 @@ static enum tsx_ctrl_states x86_get_tsx_
 	return TSX_CTRL_ENABLE;
 }
 
+/*
+ * Disabling TSX is not a trivial business.
+ *
+ * First of all, there's a CPUID bit: X86_FEATURE_RTM_ALWAYS_ABORT
+ * which says that TSX is practically disabled (all transactions are
+ * aborted by default). When that bit is set, the kernel unconditionally
+ * disables TSX.
+ *
+ * In order to do that, however, it needs to dance a bit:
+ *
+ * 1. The first method to disable it is through MSR_TSX_FORCE_ABORT and
+ * the MSR is present only when *two* CPUID bits are set:
+ *
+ * - X86_FEATURE_RTM_ALWAYS_ABORT
+ * - X86_FEATURE_TSX_FORCE_ABORT
+ *
+ * 2. The second method is for CPUs which do not have the above-mentioned
+ * MSR: those use a different MSR - MSR_IA32_TSX_CTRL and disable TSX
+ * through that one. Those CPUs can also have the initially mentioned
+ * CPUID bit X86_FEATURE_RTM_ALWAYS_ABORT set and for those the same strategy
+ * applies: TSX gets disabled unconditionally.
+ *
+ * When either of the two methods are present, the kernel disables TSX and
+ * clears the respective RTM and HLE feature flags.
+ *
+ * An additional twist in the whole thing presents late microcode loading
+ * which, when done, may cause for the X86_FEATURE_RTM_ALWAYS_ABORT CPUID
+ * bit to be set after the update.
+ *
+ * A subsequent hotplug operation on any logical CPU except the BSP will
+ * cause for the supported CPUID feature bits to get re-detected and, if
+ * RTM and HLE get cleared all of a sudden, but, userspace did consult
+ * them before the update, then funny explosions will happen. Long story
+ * short: the kernel doesn't modify CPUID feature bits after booting.
+ *
+ * That's why, this function's call in init_intel() doesn't clear the
+ * feature flags.
+ */
 void tsx_clear_cpuid(void)
 {
 	u64 msr;
@@ -97,6 +135,10 @@ void tsx_clear_cpuid(void)
 		rdmsrl(MSR_TSX_FORCE_ABORT, msr);
 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
 		wrmsrl(MSR_TSX_FORCE_ABORT, msr);
+	} else if (tsx_ctrl_is_supported()) {
+		rdmsrl(MSR_IA32_TSX_CTRL, msr);
+		msr |= TSX_CTRL_CPUID_CLEAR;
+		wrmsrl(MSR_IA32_TSX_CTRL, msr);
 	}
 }
 
@@ -106,13 +148,11 @@ void __init tsx_init(void)
 	int ret;
 
 	/*
-	 * Hardware will always abort a TSX transaction if both CPUID bits
-	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
-	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
-	 * here.
+	 * Hardware will always abort a TSX transaction when the CPUID bit
+	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
+	 * CPUID.RTM and CPUID.HLE bits. Clear them here.
 	 */
-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
-	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
+	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT)) {
 		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
 		tsx_clear_cpuid();
 		setup_clear_cpu_cap(X86_FEATURE_RTM);



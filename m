Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC51863F8E8
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 21:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiLAUTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 15:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiLAUTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 15:19:38 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865AABEE23
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 12:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669925977; x=1701461977;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z8GVoPoVTPKiK9uqGccWeMGrKYOAISoOdWoZZ2K/tAs=;
  b=GQB13SP7dnqg/5Fo3O3gMcuika4sfuXQQGXZhp1QKcM6HPccfpjdJ2Z7
   4uh2Dsy5C7aLvT+rV1+5m+dA1Rp91Mc97i6k/Ii+choXnw9p9wkRi8qEW
   p+FjzwdRPENvE0wY/hOxJ6+dVvS+gM+koi8w9VcvaHdCMIBhhEvDOL36l
   yurz5Zlap9JWfq1xz7j1MrKNHqxpEcy4zB9qxSvKk+t2vzzzKiyWbZYQP
   AQ6Ci45sCssg0duBK4BZbMmzWY59JDOaBMbOZT4QvEoaRPwvyvh9BwWsh
   NsLKFaTEKAi+OJzgofDsqWf6MHzvpbBj6Wnocw405jvQaSdlRtm9Ple1x
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317656980"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="317656980"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 12:19:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="889879850"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="889879850"
Received: from subratad-mobl1.amr.corp.intel.com (HELO desk) ([10.209.101.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 12:19:36 -0800
Date:   Thu, 1 Dec 2022 12:19:35 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     bp@suse.de, dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org
Subject: [PATCH 5.10 1/2] x86/tsx: Add a feature bit for TSX control MSR
 support
Message-ID: <4427d80ee35e1a6f26f7383dcca320d04ce36575.1669925645.git.pawan.kumar.gupta@linux.intel.com>
References: <Y4hCnMlrnLe98IQ4@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4hCnMlrnLe98IQ4@kroah.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit aaa65d17eec372c6a9756833f3964ba05b05ea14 upstream.

Support for the TSX control MSR is enumerated in MSR_IA32_ARCH_CAPABILITIES.
This is different from how other CPU features are enumerated i.e. via
CPUID. Currently, a call to tsx_ctrl_is_supported() is required for
enumerating the feature. In the absence of a feature bit for TSX control,
any code that relies on checking feature bits directly will not work.

In preparation for adding a feature bit check in MSR save/restore
during suspend/resume, set a new feature bit X86_FEATURE_TSX_CTRL when
MSR_IA32_TSX_CTRL is present.

  [ bp: Remove tsx_ctrl_is_supported()]

  [Pawan: Resolved conflicts in backport; Removed parts of commit message
          referring to removed function tsx_ctrl_is_supported()]

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/de619764e1d98afbb7a5fa58424f1278ede37b45.1668539735.git.pawan.kumar.gupta@linux.intel.com
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/tsx.c          | 33 +++++++++++++-----------------
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f507ad7c7fd7..1fcda8263554 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -300,6 +300,7 @@
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
+#define X86_FEATURE_MSR_TSX_CTRL	(11*32+18) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index e2ad30e474f8..da06bbb5d68e 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -58,24 +58,6 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
-{
-	u64 ia32_cap = x86_read_arch_cap_msr();
-
-	/*
-	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
-	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
-	 *
-	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
-	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
-	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
-	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
-	 * tsx= cmdline requests will do nothing on CPUs without
-	 * MSR_IA32_TSX_CTRL support.
-	 */
-	return !!(ia32_cap & ARCH_CAP_TSX_CTRL_MSR);
-}
-
 static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 {
 	if (boot_cpu_has_bug(X86_BUG_TAA))
@@ -89,9 +71,22 @@ void __init tsx_init(void)
 	char arg[5] = {};
 	int ret;
 
-	if (!tsx_ctrl_is_supported())
+	/*
+	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
+	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
+	 *
+	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
+	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
+	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
+	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
+	 * tsx= cmdline requests will do nothing on CPUs without
+	 * MSR_IA32_TSX_CTRL support.
+	 */
+	if (!(x86_read_arch_cap_msr() & ARCH_CAP_TSX_CTRL_MSR))
 		return;
 
+	setup_force_cpu_cap(X86_FEATURE_MSR_TSX_CTRL);
+
 	ret = cmdline_find_option(boot_command_line, "tsx", arg, sizeof(arg));
 	if (ret >= 0) {
 		if (!strcmp(arg, "on")) {

base-commit: 6d46ef50b123f2da3871690e619f5169eb97af92
-- 
2.37.3



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9FB63FF73
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 05:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiLBEXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 23:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLBEXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 23:23:15 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC0E537CC
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 20:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669954993; x=1701490993;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yu8PRokKj1Wu7bi4Y01mg2snJrmUYZr2pv0OCCSFjZU=;
  b=DPsZuKwwcOWsCheJuDtAYiNFs/mZ9OEmxY2TLGNaLo8pssEI/A984Ttv
   Ridj0CZdHPyqtRCVD7MAWww0WZ1I4YZsJaCvysff8NhampYJIKo/GZpTw
   ZH34164AsdUnks6p4YsQHD3zJ0AoYTeyN0da7hUBoi9YLaBTU/iueIjOD
   zHT7GOiJWPv6x+oBZmawq7Be/uETIz+RUyJrvnt3yJKjtTRMUWy1Zkljn
   CyDR7egNbjg6r7mUT8tXkCSqahkNT7crRCi+z4I/44G512IvaDShw25ND
   9ahwBSWvfAKCX9II9zkWhOpjwaog8pygmodJlMo2IMPKHErFPrku1hPPJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="303470403"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="303470403"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 20:23:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="890005877"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="890005877"
Received: from subratad-mobl1.amr.corp.intel.com (HELO desk) ([10.209.101.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 20:23:12 -0800
Date:   Thu, 1 Dec 2022 20:23:12 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org
Subject: [PATCH 4.9 1/2] x86/tsx: Add a feature bit for TSX control MSR
 support
Message-ID: <c8782ff7b938a77294d2f4518a0ec52058035a53.1669954772.git.pawan.kumar.gupta@linux.intel.com>
References: <16698114414161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16698114414161@kroah.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index a033fa5c596d..429e6fc5069f 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -196,6 +196,7 @@
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	( 7*32+11) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_RETPOLINE	( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_MSR_TSX_CTRL	( 7*32+14) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 
 #define X86_FEATURE_MSR_SPEC_CTRL ( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
 #define X86_FEATURE_SSBD	( 7*32+17) /* Speculative Store Bypass Disable */
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 032509adf9de..88a553ee7704 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -55,24 +55,6 @@ void tsx_enable(void)
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
@@ -86,9 +68,22 @@ void __init tsx_init(void)
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

base-commit: ce705e13578d8a17d2b2fb1d1e6efe29f39231e3
-- 
2.37.3



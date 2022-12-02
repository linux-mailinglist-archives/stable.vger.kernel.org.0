Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7BD63FE1C
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 03:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiLBC3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 21:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiLBC3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 21:29:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AF3C86A7
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 18:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669948156; x=1701484156;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cHEsTCGNn21c06AHhpbG3xIy5Sy4sVbvFmNasZdeo7k=;
  b=DuL+NNfjDxKY4XFapswN6uKjEXjr/cjoiw/PUCK7NxJ9i+Dg0agABzit
   PnhaqJ24b4GLjOPF8DWy9p0INo6O+tMec/ZKDM/zH3O5FFwWDk2EjU1nn
   /YnCEu7SuQp+cLXjKsE9fnZxVHWwPi300mKlHCTwNOY0kr1C1Io3320Ru
   yFoELs9SyqFvB7E6gC8L4qXg/AzskcL1P0ZQwa89jL9KXRaqlfg8D3rJY
   hIxUn0j/YVPEvgUqV8BS94tBEVGcF8xe671rfXla8/LsLWiBb0NVYYou7
   nkUcwfvhHm4oamI1IRysl60nRKK3IGWX1vgjfwnCAWGIkYb3XvJHcxq0w
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317001939"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="317001939"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 18:29:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733650698"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="733650698"
Received: from subratad-mobl1.amr.corp.intel.com (HELO desk) ([10.209.101.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 18:29:14 -0800
Date:   Thu, 1 Dec 2022 18:29:14 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org
Subject: [PATCH 4.19 1/2] x86/tsx: Add a feature bit for TSX control MSR
 support
Message-ID: <d327fea6b9df0bfb38a41cc1de34603dbbc8f02e.1669948009.git.pawan.kumar.gupta@linux.intel.com>
References: <166981147130161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166981147130161@kroah.com>
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
index caaab0a20e26..bd4374f56651 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -292,6 +292,7 @@
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
+#define X86_FEATURE_MSR_TSX_CTRL	(11*32+18) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
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

base-commit: c1ccef20f08e192228a2056808113b453d18c094
-- 
2.37.3



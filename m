Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8027063FF74
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 05:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiLBEXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 23:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLBEXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 23:23:20 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6EF59FF7
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 20:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669954999; x=1701490999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V3rGg03XXMugA/40TxpDL3hMXZdKQbggC0M5DqQP+zA=;
  b=BmNATDIRFX4NC/z2fl8Wx3rOEOOFI2pD0yYQuCAQZl1a8t11GJcAhL9/
   SqOkSr+monV1e4QK2RIuGz7YV2PBu3Zv82EDukHYkLycYsVP+v1DyK7fc
   SbMXv6etCHiU6jMOCDFgOGc5+wVPyHSwY/p6ICzs+Wd5n/xaeFPlmK6kZ
   WSnbj8SYaMZ8wHAvy3VT+s5WIdzIDNAG1fuVDwiMA1VDDqpGMYwRRen1v
   fdyxb6ogUxWJa1l5Hs6gKWQnLD3TkyTwMil0ipF9dBZXRnX7g06AGfyxb
   NDn6+Zd1OB2GWIY3kn/LFWoHeTLIw3GwWgQhHPk3AvsXU37DR5COp9ucU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="303470413"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="303470413"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 20:23:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="890005895"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="890005895"
Received: from subratad-mobl1.amr.corp.intel.com (HELO desk) ([10.209.101.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 20:23:18 -0800
Date:   Thu, 1 Dec 2022 20:23:18 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org
Subject: [PATCH 4.9 2/2] x86/pm: Add enumeration check before spec MSRs
 save/restore setup
Message-ID: <58d3eafb5d10b85279a65f22fa71228a9a014a79.1669954772.git.pawan.kumar.gupta@linux.intel.com>
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

commit 50bcceb7724e471d9b591803889df45dcbb584bc upstream.

pm_save_spec_msr() keeps a list of all the MSRs which _might_ need
to be saved and restored at hibernate and resume. However, it has
zero awareness of CPU support for these MSRs. It mostly works by
unconditionally attempting to manipulate these MSRs and relying on
rdmsrl_safe() being able to handle a #GP on CPUs where the support is
unavailable.

However, it's possible for reads (RDMSR) to be supported for a given MSR
while writes (WRMSR) are not. In this case, msr_build_context() sees
a successful read (RDMSR) and marks the MSR as valid. Then, later, a
write (WRMSR) fails, producing a nasty (but harmless) error message.
This causes restore_processor_state() to try and restore it, but writing
this MSR is not allowed on the Intel Atom N2600 leading to:

  unchecked MSR access error: WRMSR to 0x122 (tried to write 0x0000000000000002) \
     at rIP: 0xffffffff8b07a574 (native_write_msr+0x4/0x20)
  Call Trace:
   <TASK>
   restore_processor_state
   x86_acpi_suspend_lowlevel
   acpi_suspend_enter
   suspend_devices_and_enter
   pm_suspend.cold
   state_store
   kernfs_fop_write_iter
   vfs_write
   ksys_write
   do_syscall_64
   ? do_syscall_64
   ? up_read
   ? lock_is_held_type
   ? asm_exc_page_fault
   ? lockdep_hardirqs_on
   entry_SYSCALL_64_after_hwframe

To fix this, add the corresponding X86_FEATURE bit for each MSR.  Avoid
trying to manipulate the MSR when the feature bit is clear. This
required adding a X86_FEATURE bit for MSRs that do not have one already,
but it's a small price to pay.

  [ bp: Move struct msr_enumeration inside the only function that uses it. ]
  [Pawan: Resolve build issue in backport]

Fixes: 73924ec4d560 ("x86/pm: Save the MSR validity status at context setup")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/c24db75d69df6e66c0465e13676ad3f2837a2ed8.1668539735.git.pawan.kumar.gupta@linux.intel.com
---
 arch/x86/power/cpu.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 4c073926ab93..2f32cdba589a 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -520,16 +520,23 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 
 static void pm_save_spec_msr(void)
 {
-	u32 spec_msr_id[] = {
-		MSR_IA32_SPEC_CTRL,
-		MSR_IA32_TSX_CTRL,
-		MSR_TSX_FORCE_ABORT,
-		MSR_IA32_MCU_OPT_CTRL,
-		MSR_AMD64_LS_CFG,
-		MSR_AMD64_DE_CFG,
+	struct msr_enumeration {
+		u32 msr_no;
+		u32 feature;
+	} msr_enum[] = {
+		{ MSR_IA32_SPEC_CTRL,	 X86_FEATURE_MSR_SPEC_CTRL },
+		{ MSR_IA32_TSX_CTRL,	 X86_FEATURE_MSR_TSX_CTRL },
+		{ MSR_TSX_FORCE_ABORT,	 X86_FEATURE_TSX_FORCE_ABORT },
+		{ MSR_IA32_MCU_OPT_CTRL, X86_FEATURE_SRBDS_CTRL },
+		{ MSR_AMD64_LS_CFG,	 X86_FEATURE_LS_CFG_SSBD },
+		{ MSR_AMD64_DE_CFG,	 X86_FEATURE_LFENCE_RDTSC },
 	};
+	int i;
 
-	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
+	for (i = 0; i < ARRAY_SIZE(msr_enum); i++) {
+		if (boot_cpu_has(msr_enum[i].feature))
+			msr_build_context(&msr_enum[i].msr_no, 1);
+	}
 }
 
 static int pm_check_save_msr(void)
-- 
2.37.3



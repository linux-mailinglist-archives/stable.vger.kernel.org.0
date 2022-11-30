Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D6A63D5A1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiK3Mbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiK3Mbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:31:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2AE4AF13
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:31:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CD67CE188D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789CAC433D6;
        Wed, 30 Nov 2022 12:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669811489;
        bh=D8zWvErqbvRo5NSC+Pzt9v4odIfDLtf/VX/LwylpyaU=;
        h=Subject:To:Cc:From:Date:From;
        b=HVTpegkgAquzWd2Nn/XB9HLIoHgTKQk2D+L4USk3peQ2urYgqX3ACBlL8LMyeZkY8
         okTtJN9TUlIj7TyzNrWmdVYYJYVhiiBBqQmaTgDHy8mb2cfSxAJ1YLfPw6oMnfmlOa
         gKw6U3bBbtLKEpBtK0X1c1t9Iyzr0xY7CsgpDhB8=
Subject: FAILED: patch "[PATCH] x86/pm: Add enumeration check before spec MSRs save/restore" failed to apply to 5.4-stable tree
To:     pawan.kumar.gupta@linux.intel.com, bp@suse.de,
        dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:31:27 +0100
Message-ID: <166981148766189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

50bcceb7724e ("x86/pm: Add enumeration check before spec MSRs save/restore setup")
2632daebafd0 ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
e2a1256b17b1 ("x86/speculation: Restore speculation related MSRs during S3 resume")
46a010dd6896 ("kVM SVM: Move SVM related files to own sub-directory")
444e2ff34df8 ("tools arch x86: Grab a copy of the file containing the MSR numbers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50bcceb7724e471d9b591803889df45dcbb584bc Mon Sep 17 00:00:00 2001
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date: Tue, 15 Nov 2022 11:17:06 -0800
Subject: [PATCH] x86/pm: Add enumeration check before spec MSRs save/restore
 setup

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

Fixes: 73924ec4d560 ("x86/pm: Save the MSR validity status at context setup")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/c24db75d69df6e66c0465e13676ad3f2837a2ed8.1668539735.git.pawan.kumar.gupta@linux.intel.com

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 4cd39f304e20..93ae33248f42 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -513,16 +513,23 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 
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


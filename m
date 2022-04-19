Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87A507A57
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 21:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355729AbiDSThx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 15:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355423AbiDSThv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 15:37:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D8A3B3CA;
        Tue, 19 Apr 2022 12:35:06 -0700 (PDT)
Date:   Tue, 19 Apr 2022 19:35:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650396905;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nbIJjJ7zAJgCtZ98KUNjBmW7JumOj1R8lXHy2F+YP2M=;
        b=ta9Aq0PAmmry1IEMuyQP39LT0s0E9CJ/M6l5JraXD1Tk+D7iPQePE/La4lUnoCAUkSoym1
        XLxXB3nnPQbSvk1x+VT/wXIoBgeYl9H3SJxudZGEPLHfsSbjkaI1p288p/REFCcBuusU1c
        QFy177LXm5vi8ahXGPPm3KG7JRHpz8f/iP8VOmDlYmlVkECsH3qfU6ID+hmc7vp5hhkLsh
        ZD3r9EDyZmbkBEbrKmjvM6oYv+Abmav65FydRYWM86QWf6U7HMZSkyAYf9O8GfhHyiBQAB
        IsyjvHH614DYRqw+JyR5vdGsamNR27wRsxBaGvf52wZEr3xVdZJyOdNcibeADA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650396905;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nbIJjJ7zAJgCtZ98KUNjBmW7JumOj1R8lXHy2F+YP2M=;
        b=pEYwF/m4sGtcQfd9qxeyRFNyTbStMILPfl+bk4RDkJuSP2L+dkapgXka2mNnjlr15/feHr
        rn4Kyu8c514J2RBA==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/cpu: Load microcode during restore_processor_state()
Cc:     "Kyle D. Pelton" <kyle.d.pelton@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C4350dfbf785cd482d3fafa72b2b49c83102df3ce=2E16503?=
 =?utf-8?q?86317=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
References: =?utf-8?q?=3C4350dfbf785cd482d3fafa72b2b49c83102df3ce=2E165038?=
 =?utf-8?q?6317=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <165039690410.4207.7017996280520369008.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     f9e14dbbd454581061c736bf70bf5cbb15ac927c
Gitweb:        https://git.kernel.org/tip/f9e14dbbd454581061c736bf70bf5cbb15ac927c
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Tue, 19 Apr 2022 09:52:41 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 19 Apr 2022 19:37:05 +02:00

x86/cpu: Load microcode during restore_processor_state()

When resuming from system sleep state, restore_processor_state()
restores the boot CPU MSRs. These MSRs could be emulated by microcode.
If microcode is not loaded yet, writing to emulated MSRs leads to
unchecked MSR access error:

  ...
  PM: Calling lapic_suspend+0x0/0x210
  unchecked MSR access error: WRMSR to 0x10f (tried to write 0x0...0) at rIP: ... (native_write_msr)
  Call Trace:
    <TASK>
    ? restore_processor_state
    x86_acpi_suspend_lowlevel
    acpi_suspend_enter
    suspend_devices_and_enter
    pm_suspend.cold
    state_store
    kobj_attr_store
    sysfs_kf_write
    kernfs_fop_write_iter
    new_sync_write
    vfs_write
    ksys_write
    __x64_sys_write
    do_syscall_64
    entry_SYSCALL_64_after_hwframe
   RIP: 0033:0x7fda13c260a7

To ensure microcode emulated MSRs are available for restoration, load
the microcode on the boot CPU before restoring these MSRs.

  [ Pawan: write commit message and productize it. ]

Fixes: e2a1256b17b1 ("x86/speculation: Restore speculation related MSRs during S3 resume")
Reported-by: Kyle D. Pelton <kyle.d.pelton@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Tested-by: Kyle D. Pelton <kyle.d.pelton@intel.com>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215841
Link: https://lore.kernel.org/r/4350dfbf785cd482d3fafa72b2b49c83102df3ce.1650386317.git.pawan.kumar.gupta@linux.intel.com
---
 arch/x86/include/asm/microcode.h     |  2 ++
 arch/x86/kernel/cpu/microcode/core.c |  6 +++---
 arch/x86/power/cpu.c                 | 10 +++++++++-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index d6bfdfb..0c3d344 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -131,10 +131,12 @@ extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
 void reload_early_microcode(void);
 extern bool initrd_gone;
+void microcode_bsp_resume(void);
 #else
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
 static inline void reload_early_microcode(void)			{ }
+static inline void microcode_bsp_resume(void)			{ }
 #endif
 
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index f955d25..239ff5f 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -758,9 +758,9 @@ static struct subsys_interface mc_cpu_interface = {
 };
 
 /**
- * mc_bp_resume - Update boot CPU microcode during resume.
+ * microcode_bsp_resume - Update boot CPU microcode during resume.
  */
-static void mc_bp_resume(void)
+void microcode_bsp_resume(void)
 {
 	int cpu = smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -772,7 +772,7 @@ static void mc_bp_resume(void)
 }
 
 static struct syscore_ops mc_syscore_ops = {
-	.resume			= mc_bp_resume,
+	.resume			= microcode_bsp_resume,
 };
 
 static int mc_cpu_starting(unsigned int cpu)
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 3822666..bb176c7 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -25,6 +25,7 @@
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
+#include <asm/microcode.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -262,11 +263,18 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	x86_platform.restore_sched_clock_state();
 	mtrr_bp_restore();
 	perf_restore_debug_store();
-	msr_restore_context(ctxt);
 
 	c = &cpu_data(smp_processor_id());
 	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
 		init_ia32_feat_ctl(c);
+
+	microcode_bsp_resume();
+
+	/*
+	 * This needs to happen after the microcode has been updated upon resume
+	 * because some of the MSRs are "emulated" in microcode.
+	 */
+	msr_restore_context(ctxt);
 }
 
 /* Needed by apm.c */

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C25051A65F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354203AbiEDQzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354440AbiEDQyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:54:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB51749270;
        Wed,  4 May 2022 09:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49E7761776;
        Wed,  4 May 2022 16:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC18C385A4;
        Wed,  4 May 2022 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682971;
        bh=A+5cstA8LLgZPNQw0zRgG2KI0zg32uxsksxSQzyBulw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ+leYrEzOw+QCz5No6pHtbMhhjMmPmOy+hDiKVDoI+vaescf/0geA9BPhg3yXi5l
         0q+gVbrNE2FH+l7vaH1+1QW1BJ1jOcUMjEJTSrF3gcJRB+oVqZsC20GO2WuPpPnSnK
         lohJwRtJbSJvfgg+xhutwK7AaseHNf/yXwt1+gfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kyle D. Pelton" <kyle.d.pelton@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.4 74/84] x86/cpu: Load microcode during restore_processor_state()
Date:   Wed,  4 May 2022 18:44:55 +0200
Message-Id: <20220504152933.255211083@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit f9e14dbbd454581061c736bf70bf5cbb15ac927c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/microcode.h     |    2 ++
 arch/x86/kernel/cpu/microcode/core.c |    6 +++---
 arch/x86/power/cpu.c                 |    8 ++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -133,11 +133,13 @@ extern void load_ucode_ap(void);
 void reload_early_microcode(void);
 extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
+void microcode_bsp_resume(void);
 #else
 static inline int __init microcode_init(void)			{ return 0; };
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
 static inline void reload_early_microcode(void)			{ }
+static inline void microcode_bsp_resume(void)			{ }
 static inline bool
 get_builtin_firmware(struct cpio_data *cd, const char *name)	{ return false; }
 #endif
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -772,9 +772,9 @@ static struct subsys_interface mc_cpu_in
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
@@ -786,7 +786,7 @@ static void mc_bp_resume(void)
 }
 
 static struct syscore_ops mc_syscore_ops = {
-	.resume			= mc_bp_resume,
+	.resume			= microcode_bsp_resume,
 };
 
 static int mc_cpu_starting(unsigned int cpu)
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -25,6 +25,7 @@
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
+#include <asm/microcode.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -263,6 +264,13 @@ static void notrace __restore_processor_
 	x86_platform.restore_sched_clock_state();
 	mtrr_bp_restore();
 	perf_restore_debug_store();
+
+	microcode_bsp_resume();
+
+	/*
+	 * This needs to happen after the microcode has been updated upon resume
+	 * because some of the MSRs are "emulated" in microcode.
+	 */
 	msr_restore_context(ctxt);
 }
 



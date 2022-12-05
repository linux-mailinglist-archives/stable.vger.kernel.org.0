Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81206433C0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiLETjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbiLETit (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787C925E80
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2102AB811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBB4C433D6;
        Mon,  5 Dec 2022 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268954;
        bh=tt/Qv9Bz1rBYvsydv/OIonqIoAdKlR8AHo5tqlgaA1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffdWU/fZKHxUxoF5dld5tS9u6x7umUrNP9wTJTtFiczyXN9Vzkgah0VeWkMAGxYNu
         H+5LeT6r6mPztxxNgIDlIc9CPG9M60IW4phPiBtC3Ja+kewtbdYPYcn7WKl/FVRvyC
         cI8SROCMdXM8x6c7IAJ5nSStPd9cjR//ssCn/jIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 072/120] x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3
Date:   Mon,  5 Dec 2022 20:10:12 +0100
Message-Id: <20221205190808.780858065@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 66065157420c5b9b3f078f43d313c153e1ff7f83 upstream.

The "force" argument to write_spec_ctrl_current() is currently ambiguous
as it does not guarantee the MSR write. This is due to the optimization
that writes to the MSR happen only when the new value differs from the
cached value.

This is fine in most cases, but breaks for S3 resume when the cached MSR
value gets out of sync with the hardware MSR value due to S3 resetting
it.

When x86_spec_ctrl_current is same as x86_spec_ctrl_base, the MSR write
is skipped. Which results in SPEC_CTRL mitigations not getting restored.

Move the MSR write from write_spec_ctrl_current() to a new function that
unconditionally writes to the MSR. Update the callers accordingly and
rename functions.

  [ bp: Rework a bit. ]

Fixes: caa0ff24d5d0 ("x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value")
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/806d39b0bfec2fe8f50dc5446dff20f5bb24a959.1669821572.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    2 +-
 arch/x86/kernel/cpu/bugs.c           |   21 ++++++++++++++-------
 arch/x86/kernel/process.c            |    2 +-
 3 files changed, 16 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -310,7 +310,7 @@ static inline void indirect_branch_predi
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
 DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
-extern void write_spec_ctrl_current(u64 val, bool force);
+extern void update_spec_ctrl_cond(u64 val);
 extern u64 spec_ctrl_current(void);
 
 /*
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -60,11 +60,18 @@ EXPORT_SYMBOL_GPL(x86_spec_ctrl_current)
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+/* Update SPEC_CTRL MSR and its cached copy unconditionally */
+static void update_spec_ctrl(u64 val)
+{
+	this_cpu_write(x86_spec_ctrl_current, val);
+	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
 /*
  * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
  * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
  */
-void write_spec_ctrl_current(u64 val, bool force)
+void update_spec_ctrl_cond(u64 val)
 {
 	if (this_cpu_read(x86_spec_ctrl_current) == val)
 		return;
@@ -75,7 +82,7 @@ void write_spec_ctrl_current(u64 val, bo
 	 * When KERNEL_IBRS this MSR is written on return-to-user, unless
 	 * forced the update can be delayed until that time.
 	 */
-	if (force || !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
+	if (!cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
 		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
@@ -1328,7 +1335,7 @@ static void __init spec_ctrl_disable_ker
 
 	if (ia32_cap & ARCH_CAP_RRSBA) {
 		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 }
 
@@ -1450,7 +1457,7 @@ static void __init spectre_v2_select_mit
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 
 	switch (mode) {
@@ -1564,7 +1571,7 @@ static void __init spectre_v2_select_mit
 static void update_stibp_msr(void * __unused)
 {
 	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
-	write_spec_ctrl_current(val, true);
+	update_spec_ctrl(val);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1797,7 +1804,7 @@ static enum ssb_mitigation __init __ssb_
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+			update_spec_ctrl(x86_spec_ctrl_base);
 		}
 	}
 
@@ -2048,7 +2055,7 @@ int arch_prctl_spec_ctrl_get(struct task
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -584,7 +584,7 @@ static __always_inline void __speculatio
 	}
 
 	if (updmsr)
-		write_spec_ctrl_current(msr, false);
+		update_spec_ctrl_cond(msr);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)



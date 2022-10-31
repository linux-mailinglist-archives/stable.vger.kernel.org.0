Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC8F6130E1
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJaHC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJaHCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63285BF59
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:02:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0BC760FEC
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE587C433C1;
        Mon, 31 Oct 2022 07:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199755;
        bh=Oa3PuvMYWO0v9a6qZlwYMsf3n5G3UILOlLNcvmFyBcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Egzuic/Myn7l/Y0Y6x6GoVwIjUKM19yt500EI3SmRE4a0G3CM/fSubVwvRxj6hCx+
         w4dbF4bhhfdeLtQCK/AtqK8haBCYoC/jkRUaYu39425MbQt8jrlV/Fnb8iA5PHwXCn
         cI4HCuZ2bJFBo+zvMa5LU/JRZ12iFMeHdYlVrPu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 11/34] x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
Date:   Mon, 31 Oct 2022 08:02:44 +0100
Message-Id: <20221031070140.377979423@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit caa0ff24d5d0e02abce5e65c3d2b7f20a6617be5 upstream.

Due to TIF_SSBD and TIF_SPEC_IB the actual IA32_SPEC_CTRL value can
differ from x86_spec_ctrl_base. As such, keep a per-CPU value
reflecting the current task's MSR content.

  [jpoimboe: rename]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    1 +
 arch/x86/kernel/cpu/bugs.c           |   28 +++++++++++++++++++++++-----
 arch/x86/kernel/process.c            |    2 +-
 3 files changed, 25 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -291,6 +291,7 @@ static inline void indirect_branch_predi
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern void write_spec_ctrl_current(u64 val);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -47,12 +47,30 @@ static void __init taa_select_mitigation
 static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
 
-/* The base value of the SPEC_CTRL MSR that always has to be preserved. */
+/* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
+
+/* The current value of the SPEC_CTRL MSR with task-specific bits set */
+DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
+EXPORT_SYMBOL_GPL(x86_spec_ctrl_current);
+
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
 /*
+ * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
+ * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
+ */
+void write_spec_ctrl_current(u64 val)
+{
+	if (this_cpu_read(x86_spec_ctrl_current) == val)
+		return;
+
+	this_cpu_write(x86_spec_ctrl_current, val);
+	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
+/*
  * The vendor and possibly platform specific bits which can be modified in
  * x86_spec_ctrl_base.
  */
@@ -1173,7 +1191,7 @@ static void __init spectre_v2_select_mit
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base);
 	}
 
 	switch (mode) {
@@ -1228,7 +1246,7 @@ static void __init spectre_v2_select_mit
 
 static void update_stibp_msr(void * __unused)
 {
-	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+	write_spec_ctrl_current(x86_spec_ctrl_base);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1471,7 +1489,7 @@ static enum ssb_mitigation __init __ssb_
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base);
 		}
 	}
 
@@ -1676,7 +1694,7 @@ int arch_prctl_spec_ctrl_get(struct task
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -435,7 +435,7 @@ static __always_inline void __speculatio
 	}
 
 	if (updmsr)
-		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
+		write_spec_ctrl_current(msr);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E53257AD11
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbiGTBaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242285AbiGTB3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:29:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1F5D89;
        Tue, 19 Jul 2022 18:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C449B81DEA;
        Wed, 20 Jul 2022 01:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FE3C341CE;
        Wed, 20 Jul 2022 01:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279956;
        bh=cWHhfD6Qlnxr+ZGPXrBMDYBBG9eeap8CAr8u03/Q4MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iycUV45028+1NKXpP0/0rasMWmOL68gmJlJDeGJVdbD8dhFqDZRs7pf/nmVMwXxjZ
         nRfpr3jwak61zPOCDE5yUNEummPzrrupZ2w37hzFjnFdzSOl/kXmPNTnWOybOeiYHZ
         nebFIj9Bm3g4+bgszG+y7FFmCCgvW0Qcn3PVDxTaBe+XP6nuN1DfgKw+TQC44NIFBG
         kqWJ8BVJJM888TWS8pfDzqnOjyWgJMxkJyabWLVfWSrYIYjgeqJuMHWCq807vlju6L
         5BbkCsUOcSC65997DM+lBbPbJRsrC45K6kwHZWrT/NJVPz0kUzJ6KHzFUpelLaRVIP
         tCCsHF+//oGRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, pawan.kumar.gupta@linux.intel.com,
        alexandre.chartre@oracle.com, kim.phillips@amd.com,
        sblbir@amazon.com, chang.seok.bae@intel.com, keescook@chromium.org,
        ebiederm@xmission.com, zhengqi.arch@bytedance.com
Subject: [PATCH AUTOSEL 4.9 3/6] x86/bugs: Optimize SPEC_CTRL MSR writes
Date:   Tue, 19 Jul 2022 21:18:54 -0400
Message-Id: <20220720011858.1025523-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011858.1025523-1-sashal@kernel.org>
References: <20220720011858.1025523-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c779bc1a9002fa474175b80e72b85c9bf628abb0 ]

When changing SPEC_CTRL for user control, the WRMSR can be delayed
until return-to-user when KERNEL_IBRS has been enabled.

This avoids an MSR write during context switch.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h |  2 +-
 arch/x86/kernel/cpu/bugs.c           | 18 ++++++++++++------
 arch/x86/kernel/process.c            |  2 +-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 6bc5a324dd65..884f3472ad4f 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -291,7 +291,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
-extern void write_spec_ctrl_current(u64 val);
+extern void write_spec_ctrl_current(u64 val, bool force);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index b4f62f8b47d6..6f5d6c391874 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,13 +59,19 @@ static DEFINE_MUTEX(spec_ctrl_mutex);
  * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
  * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
  */
-void write_spec_ctrl_current(u64 val)
+void write_spec_ctrl_current(u64 val, bool force)
 {
 	if (this_cpu_read(x86_spec_ctrl_current) == val)
 		return;
 
 	this_cpu_write(x86_spec_ctrl_current, val);
-	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+
+	/*
+	 * When KERNEL_IBRS this MSR is written on return-to-user, unless
+	 * forced the update can be delayed until that time.
+	 */
+	if (force || !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
+		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
 /*
@@ -1119,7 +1125,7 @@ static void __init spectre_v2_select_mitigation(void)
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}
 
 	switch (mode) {
@@ -1174,7 +1180,7 @@ static void __init spectre_v2_select_mitigation(void)
 
 static void update_stibp_msr(void * __unused)
 {
-	write_spec_ctrl_current(x86_spec_ctrl_base);
+	write_spec_ctrl_current(x86_spec_ctrl_base, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1417,7 +1423,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			write_spec_ctrl_current(x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
 		}
 	}
 
@@ -1622,7 +1628,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		write_spec_ctrl_current(x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f4c7fc3e5721..810812809d65 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -358,7 +358,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		write_spec_ctrl_current(msr);
+		write_spec_ctrl_current(msr, false);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
-- 
2.35.1


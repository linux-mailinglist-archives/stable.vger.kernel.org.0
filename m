Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0417A57AD08
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbiGTBaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242026AbiGTB2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:28:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44CB66ACB;
        Tue, 19 Jul 2022 18:18:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA74B81DF6;
        Wed, 20 Jul 2022 01:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91576C341C6;
        Wed, 20 Jul 2022 01:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279933;
        bh=ORL7wS/3M7VQUVqQCs2IhzTo9+F2SHUZQbgy1i5NiQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lACSDYBhzccq+k4nnw/gIRdhh7uQZ/sRFjjn/6LFfLaGrs6qxkw3wLNmuH424n7wq
         7f4CDHYUu2gcPX7X/yTTDgfsFti8s05E91LrqHGa7kZZNsLFzI/404k75z1/UA4VwF
         gGHW+n06A59D515NJr/0y/Vn0pH+v4ZO9VXnZE2qZmcrqj+11g2tnfmg7JVBNbgzxU
         7m7Nz4Aokf/dT0qtwI+0Ymos8kn18VJinGmkrIK7DRvDY9STm/Tq0D/JZwcelEo1t2
         5uM/Owop07LldSCnurpPL9ro99x4Wyqt5s5d1au0N+sgiJVlHILZBwScD75jbjfUza
         QTKeUBABJ4ppw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, pawan.kumar.gupta@linux.intel.com,
        alexandre.chartre@oracle.com, sblbir@amazon.com,
        kim.phillips@amd.com, chang.seok.bae@intel.com,
        ebiederm@xmission.com, zhengqi.arch@bytedance.com
Subject: [PATCH AUTOSEL 4.14 3/6] x86/bugs: Optimize SPEC_CTRL MSR writes
Date:   Tue, 19 Jul 2022 21:18:33 -0400
Message-Id: <20220720011836.1025430-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011836.1025430-1-sashal@kernel.org>
References: <20220720011836.1025430-1-sashal@kernel.org>
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
index cf67e31d7dfd..35e6e3b37b1d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -60,13 +60,19 @@ static DEFINE_MUTEX(spec_ctrl_mutex);
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
@@ -1120,7 +1126,7 @@ static void __init spectre_v2_select_mitigation(void)
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}
 
 	switch (mode) {
@@ -1175,7 +1181,7 @@ static void __init spectre_v2_select_mitigation(void)
 
 static void update_stibp_msr(void * __unused)
 {
-	write_spec_ctrl_current(x86_spec_ctrl_base);
+	write_spec_ctrl_current(x86_spec_ctrl_base, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1418,7 +1424,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			write_spec_ctrl_current(x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
 		}
 	}
 
@@ -1623,7 +1629,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		write_spec_ctrl_current(x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 6e000c6ec6be..baa9254149e7 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -435,7 +435,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		write_spec_ctrl_current(msr);
+		write_spec_ctrl_current(msr, false);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3096457EE2E
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbiGWKH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiGWKHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:07:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873E8C47F9;
        Sat, 23 Jul 2022 03:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9BD9B82C1F;
        Sat, 23 Jul 2022 10:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DCCC341C0;
        Sat, 23 Jul 2022 10:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570481;
        bh=kcMSOh3DA5LA50BmAg8peRwkcHb2FZBw+YEVoL5xv/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfJd0RMxPwZ647VcF6MVqwHnL6E0KlE79pfIqqkVuW5iLxiy2MVd//FF71ZUV4bj5
         w24WGvnZBScwgjt2qNuyXCqC4poA2kUNbkrRYUJ5yEV5P5/PsLVRH9BS3tcemVWW+t
         9+ngstt07AL83mvknI4EVfXbhAya2luDT0n0MQKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 101/148] x86/bugs: Optimize SPEC_CTRL MSR writes
Date:   Sat, 23 Jul 2022 11:55:13 +0200
Message-Id: <20220723095252.687980835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit c779bc1a9002fa474175b80e72b85c9bf628abb0 upstream.

When changing SPEC_CTRL for user control, the WRMSR can be delayed
until return-to-user when KERNEL_IBRS has been enabled.

This avoids an MSR write during context switch.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    2 +-
 arch/x86/kernel/cpu/bugs.c           |   18 ++++++++++++------
 arch/x86/kernel/process.c            |    2 +-
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -254,7 +254,7 @@ static inline void indirect_branch_predi
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
-extern void write_spec_ctrl_current(u64 val);
+extern void write_spec_ctrl_current(u64 val, bool force);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -62,13 +62,19 @@ static DEFINE_MUTEX(spec_ctrl_mutex);
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
@@ -1253,7 +1259,7 @@ static void __init spectre_v2_select_mit
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 	}
 
 	switch (mode) {
@@ -1308,7 +1314,7 @@ static void __init spectre_v2_select_mit
 
 static void update_stibp_msr(void * __unused)
 {
-	write_spec_ctrl_current(x86_spec_ctrl_base);
+	write_spec_ctrl_current(x86_spec_ctrl_base, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1551,7 +1557,7 @@ static enum ssb_mitigation __init __ssb_
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			write_spec_ctrl_current(x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
 		}
 	}
 
@@ -1769,7 +1775,7 @@ int arch_prctl_spec_ctrl_get(struct task
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		write_spec_ctrl_current(x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -556,7 +556,7 @@ static __always_inline void __speculatio
 	}
 
 	if (updmsr)
-		write_spec_ctrl_current(msr);
+		write_spec_ctrl_current(msr, false);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)



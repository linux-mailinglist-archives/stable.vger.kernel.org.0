Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9123D5F30EE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiJCNNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiJCNNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:13:12 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE47252DE5;
        Mon,  3 Oct 2022 06:12:52 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 4566342FB2;
        Mon,  3 Oct 2022 13:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802762;
        bh=gCQExeLe37Q7R6Il5MDEmYGxpV9fYPubIgKT/+cI5jU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=QYrsERquI4hB/Pw5p2+jZIpoSIuCxpVCW5uV3yrvLiED3l/xgeXW0Yzr4V9VQ5MS5
         M2q8biPcKNL2CHl5s7CmD2B5loVM59HrzIn43VcBMb2UpNEfkqJRo0YGf7k5FeQxwe
         Cc0admvY/JXk+GSR/ScaI594SHV6yZ18KNkMJcIHPCGcDdxBzF+yxBn6cg6Najexr1
         o7PWFE/+tPMpYMk2ZEBHtb4uPAvSf5yeW68TcGWEhhz8LcYDhvi7LQJAc8kPJKrP/L
         vKNXnzUbKffWOB2JgivxbeopAABXNayCphV3gZ5bjNHbOAZhWpSJEFUkK71Dc9Djac
         dncr8/R3iFg+Q==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 30/37] x86/speculation: Fill RSB on vmexit for IBRS
Date:   Mon,  3 Oct 2022 10:10:31 -0300
Message-Id: <20221003131038.12645-31-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 9756bba28470722dacb79ffce554336dd1f6a6cd upstream.

Prevent RSB underflow/poisoning attacks with RSB.  While at it, add a
bunch of comments to attempt to document the current state of tribal
knowledge about RSB attacks and what exactly is being mitigated.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/include/asm/cpufeatures.h |  2 +-
 arch/x86/kernel/cpu/bugs.c         | 63 +++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmenter.S         |  6 +--
 3 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 0c0afb91c7c2..611efccdc742 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -204,7 +204,7 @@
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
-/* FREE!				( 7*32+13) */
+#define X86_FEATURE_RSB_VMEXIT		( 7*32+13) /* "" Fill RSB on VM-Exit */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 223282a5dc1c..3b7cc3380b54 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1278,16 +1278,69 @@ static void __init spectre_v2_select_mitigation(void)
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
 	/*
-	 * If spectre v2 protection has been enabled, unconditionally fill
-	 * RSB during a context switch; this protects against two independent
-	 * issues:
+	 * If Spectre v2 protection has been enabled, fill the RSB during a
+	 * context switch.  In general there are two types of RSB attacks
+	 * across context switches, for which the CALLs/RETs may be unbalanced.
 	 *
-	 *	- RSB underflow (and switch to BTB) on Skylake+
-	 *	- SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 CPUs
+	 * 1) RSB underflow
+	 *
+	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
+	 *    speculated return targets may come from the branch predictor,
+	 *    which could have a user-poisoned BTB or BHB entry.
+	 *
+	 *    AMD has it even worse: *all* returns are speculated from the BTB,
+	 *    regardless of the state of the RSB.
+	 *
+	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
+	 *    scenario is mitigated by the IBRS branch prediction isolation
+	 *    properties, so the RSB buffer filling wouldn't be necessary to
+	 *    protect against this type of attack.
+	 *
+	 *    The "user -> user" attack scenario is mitigated by RSB filling.
+	 *
+	 * 2) Poisoned RSB entry
+	 *
+	 *    If the 'next' in-kernel return stack is shorter than 'prev',
+	 *    'next' could be tricked into speculating with a user-poisoned RSB
+	 *    entry.
+	 *
+	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
+	 *    eIBRS.
+	 *
+	 *    The "user -> user" scenario, also known as SpectreBHB, requires
+	 *    RSB clearing.
+	 *
+	 * So to mitigate all cases, unconditionally fill RSB on context
+	 * switches.
+	 *
+	 * FIXME: Is this pointless for retbleed-affected AMD?
 	 */
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
+	/*
+	 * Similar to context switches, there are two types of RSB attacks
+	 * after vmexit:
+	 *
+	 * 1) RSB underflow
+	 *
+	 * 2) Poisoned RSB entry
+	 *
+	 * When retpoline is enabled, both are mitigated by filling/clearing
+	 * the RSB.
+	 *
+	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
+	 * prediction isolation protections, RSB still needs to be cleared
+	 * because of #2.  Note that SMEP provides no protection here, unlike
+	 * user-space-poisoned RSB entries.
+	 *
+	 * eIBRS, on the other hand, has RSB-poisoning protections, so it
+	 * doesn't need RSB clearing after vmexit.
+	 */
+	if (boot_cpu_has(X86_FEATURE_RETPOLINE) ||
+	    boot_cpu_has(X86_FEATURE_KERNEL_IBRS))
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
 	 * and Enhanced IBRS protect firmware too, so enable IBRS around
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 2d68dc96e672..ebd4f2f4dc1d 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -181,15 +181,15 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
 	 * the first unbalanced RET after vmexit!
 	 *
-	 * For retpoline, RSB filling is needed to prevent poisoned RSB entries
-	 * and (in some cases) RSB underflow.
+	 * For retpoline or IBRS, RSB filling is needed to prevent poisoned RSB
+	 * entries and (in some cases) RSB underflow.
 	 *
 	 * eIBRS has its own protection against poisoned RSB, so it doesn't
 	 * need the RSB filling sequence.  But it does need to be enabled
 	 * before the first unbalanced RET.
          */
 
-	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
 
 	pop %_ASM_ARG2	/* @flags */
 	pop %_ASM_ARG1	/* @vmx */
-- 
2.34.1


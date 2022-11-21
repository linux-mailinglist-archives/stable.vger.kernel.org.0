Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0FF6322C9
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiKUMpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiKUMpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:45:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59FEC051B
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55842B80EFF
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD97C433C1;
        Mon, 21 Nov 2022 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034740;
        bh=qd2yU9oQqBsuuiF3pUQrVGefx7AmWkGDc8sJXofkuOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7455J4uqzVaL1Zt9DedHFs9q3nIOA9XpqKqOdBCg2gf3YJlThX759FqT2vDDWHCb
         pAHM+WsU+Mc9r2a7emuilmBx+h/0360Dkm171xsZrCX0iHGtTgflpqEO3k4NIqTFHD
         44WcW6gW58qmK4IVDD8lhWxuedIaTGkl5DbSRkcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 27/34] x86/speculation: Fill RSB on vmexit for IBRS
Date:   Mon, 21 Nov 2022 13:43:49 +0100
Message-Id: <20221121124151.862146768@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 9756bba28470722dacb79ffce554336dd1f6a6cd upstream.

Prevent RSB underflow/poisoning attacks with RSB.  While at it, add a
bunch of comments to attempt to document the current state of tribal
knowledge about RSB attacks and what exactly is being mitigated.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust for the fact that vmexit is in inline assembly ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h   |    2 -
 arch/x86/include/asm/nospec-branch.h |    2 -
 arch/x86/kernel/cpu/bugs.c           |   63 ++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx.c                   |    4 +-
 4 files changed, 62 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -203,7 +203,7 @@
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
-/* FREE!				( 7*32+13) */
+#define X86_FEATURE_RSB_VMEXIT		( 7*32+13) /* "" Fill RSB on VM-Exit */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -279,7 +279,7 @@ static __always_inline void vmexit_fill_
 	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
 		      ALTERNATIVE("jmp 910f",
 				  __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1)),
-				  X86_FEATURE_RETPOLINE)
+				  X86_FEATURE_RSB_VMEXIT)
 		      "910:"
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1278,17 +1278,70 @@ static void __init spectre_v2_select_mit
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
 
 	/*
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
+	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
 	 * and Enhanced IBRS protect firmware too, so enable IBRS around
 	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11018,8 +11018,8 @@ static void __noclone vmx_vcpu_run(struc
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



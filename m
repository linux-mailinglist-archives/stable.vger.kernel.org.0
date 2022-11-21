Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A47632286
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiKUMoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiKUMoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:44:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14D0BF815
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F0BF6119C
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B2BC433C1;
        Mon, 21 Nov 2022 12:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034640;
        bh=UXHUmThJwObSpNYFI8+euoshzfpfi/QIlM6ao6Mz9e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2S+GS/D9Bs9mTl9pyqHIH3/41bTtJomWUjC4ZYsA/buMxyiMnFj12wjdeiEsdZQb
         DbfYbszVWaOzie+hTLAHWeLz25tBCh66mQ1qZHHEujQFrzKLLQ53DbMdMR/z9WkkTW
         HFfwRwbyfemm8xGw1Hx17YFmIV1TJ9Hpc5lPahXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 01/34] Revert "x86/speculation: Add RSB VM Exit protections"
Date:   Mon, 21 Nov 2022 13:43:23 +0100
Message-Id: <20221121124150.932772783@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Suleiman Souhlal <suleiman@google.com>

This reverts commit b6c5011934a15762cd694e36fe74f2f2f93eac9b.

In order to apply IBRS mitigation for Retbleed, PBRSB mitigations must be
reverted and the reapplied, so the backports can look sane.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |    8 ---
 arch/x86/include/asm/cpufeatures.h            |    2 
 arch/x86/include/asm/msr-index.h              |    4 -
 arch/x86/include/asm/nospec-branch.h          |   15 ------
 arch/x86/kernel/cpu/bugs.c                    |   61 --------------------------
 arch/x86/kernel/cpu/common.c                  |   14 +----
 arch/x86/kvm/vmx.c                            |    6 +-
 7 files changed, 7 insertions(+), 103 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -422,14 +422,6 @@ The possible values in this file are:
   'RSB filling'   Protection of RSB on context switch enabled
   =============   ===========================================
 
-  - EIBRS Post-barrier Return Stack Buffer (PBRSB) protection status:
-
-  ===========================  =======================================================
-  'PBRSB-eIBRS: SW sequence'   CPU is affected and protection of RSB on VMEXIT enabled
-  'PBRSB-eIBRS: Vulnerable'    CPU is vulnerable
-  'PBRSB-eIBRS: Not affected'  CPU is not affected by PBRSB
-  ===========================  =======================================================
-
 Full mitigation might require a microcode update from the CPU
 vendor. When the necessary microcode is not available, the kernel will
 report vulnerability.
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -283,7 +283,6 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
-#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+ 6) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
@@ -397,6 +396,5 @@
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
-#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -120,10 +120,6 @@
 						 * bit available to control VERW
 						 * behavior.
 						 */
-#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
-						 * Not susceptible to Post-Barrier
-						 * Return Stack Buffer Predictions.
-						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -70,14 +70,6 @@
 	add	$(BITS_PER_LONG/8) * nr, sp;
 #endif
 
-/* Sequence to mitigate PBRSB on eIBRS CPUs */
-#define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
-	call	881f;				\
-	int3;					\
-881:						\
-	add	$(BITS_PER_LONG/8), sp;		\
-	lfence;
-
 #ifdef __ASSEMBLY__
 
 /*
@@ -293,13 +285,6 @@ static inline void vmexit_fill_RSB(void)
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
 #endif
-	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
-		      ALTERNATIVE("jmp 920f",
-				  __stringify(__ISSUE_UNBALANCED_RET_GUARD(%0)),
-				  X86_FEATURE_RSB_VMEXIT_LITE)
-		      "920:"
-		      : ASM_CALL_CONSTRAINT
-		      : : "memory" );
 }
 
 static __always_inline
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1046,49 +1046,6 @@ static enum spectre_v2_mitigation __init
 	return SPECTRE_V2_RETPOLINE;
 }
 
-static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
-{
-	/*
-	 * Similar to context switches, there are two types of RSB attacks
-	 * after VM exit:
-	 *
-	 * 1) RSB underflow
-	 *
-	 * 2) Poisoned RSB entry
-	 *
-	 * When retpoline is enabled, both are mitigated by filling/clearing
-	 * the RSB.
-	 *
-	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
-	 * prediction isolation protections, RSB still needs to be cleared
-	 * because of #2.  Note that SMEP provides no protection here, unlike
-	 * user-space-poisoned RSB entries.
-	 *
-	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
-	 * bug is present then a LITE version of RSB protection is required,
-	 * just a single call needs to retire before a RET is executed.
-	 */
-	switch (mode) {
-	case SPECTRE_V2_NONE:
-	/* These modes already fill RSB at vmexit */
-	case SPECTRE_V2_LFENCE:
-	case SPECTRE_V2_RETPOLINE:
-	case SPECTRE_V2_EIBRS_RETPOLINE:
-		return;
-
-	case SPECTRE_V2_EIBRS_LFENCE:
-	case SPECTRE_V2_EIBRS:
-		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
-			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
-		}
-		return;
-	}
-
-	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
-	dump_stack();
-}
-
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1181,8 +1138,6 @@ static void __init spectre_v2_select_mit
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
-
 	/*
 	 * Retpoline means the kernel is safe because it has no indirect
 	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
@@ -1918,19 +1873,6 @@ static char *ibpb_state(void)
 	return "";
 }
 
-static char *pbrsb_eibrs_state(void)
-{
-	if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-		if (boot_cpu_has(X86_FEATURE_RSB_VMEXIT_LITE) ||
-		    boot_cpu_has(X86_FEATURE_RETPOLINE))
-			return ", PBRSB-eIBRS: SW sequence";
-		else
-			return ", PBRSB-eIBRS: Vulnerable";
-	} else {
-		return ", PBRSB-eIBRS: Not affected";
-	}
-}
-
 static ssize_t spectre_v2_show_state(char *buf)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
@@ -1943,13 +1885,12 @@ static ssize_t spectre_v2_show_state(cha
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sprintf(buf, "%s%s%s%s%s%s%s\n",
+	return sprintf(buf, "%s%s%s%s%s%s\n",
 		       spectre_v2_strings[spectre_v2_enabled],
 		       ibpb_state(),
 		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
 		       stibp_state(),
 		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
-		       pbrsb_eibrs_state(),
 		       spectre_v2_module_string());
 }
 
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -954,8 +954,7 @@ static void identify_cpu_without_cpuid(s
 #define MSBDS_ONLY		BIT(5)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
-#define NO_EIBRS_PBRSB		BIT(8)
-#define NO_MMIO			BIT(9)
+#define NO_MMIO			BIT(8)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -997,7 +996,7 @@ static const __initconst struct x86_cpu_
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1007,9 +1006,7 @@ static const __initconst struct x86_cpu_
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -1169,11 +1166,6 @@ static void __init cpu_set_bug_bits(stru
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
-	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
-	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
-	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
-
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10988,9 +10988,6 @@ static void __noclone vmx_vcpu_run(struc
 #endif
 	      );
 
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
-
 	vmx_enable_fb_clear(vmx);
 
 	/*
@@ -11013,6 +11010,9 @@ static void __noclone vmx_vcpu_run(struc
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
+	/* Eliminate branch target predictions from guest mode */
+	vmexit_fill_RSB();
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=



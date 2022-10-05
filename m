Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13A55F5356
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJELc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJELc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:32:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526F472EF0;
        Wed,  5 Oct 2022 04:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8BA20CE12DC;
        Wed,  5 Oct 2022 11:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6560C433C1;
        Wed,  5 Oct 2022 11:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969572;
        bh=R2zatfwqPcwdj+AMFhwt6nmmp5CBSbEm0wsQ+0Xei8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWkXFlQO/ou0J2/sP9k6g8PE6+0thonkAllSOTvYiX0Bjs/S2XsDw+nCu9itcMte/
         MVp6yMPVTdekxoB2kvqtZpBIVCZfirkmx804UuQEWgIa7iIzawvDKaeLTZvLMAAA8x
         Yy+nHq6hlbAeijJvJTy60Vl4OFhCEznE6r29Pows=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 01/51] Revert "x86/speculation: Add RSB VM Exit protections"
Date:   Wed,  5 Oct 2022 13:31:49 +0200
Message-Id: <20221005113210.333783784@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

This reverts commit f2f41ef0352db9679bfae250d7a44b3113f3a3cc.

This is commit 2b1299322016731d56807aa49254a5ea3080b6b3 upstream.

In order to apply IBRS mitigation for Retbleed, PBRSB mitigations must be
reverted and the reapplied, so the backports can look sane.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |    8 ---
 arch/x86/include/asm/cpufeatures.h            |    2 
 arch/x86/include/asm/msr-index.h              |    4 -
 arch/x86/include/asm/nospec-branch.h          |   15 ------
 arch/x86/kernel/cpu/bugs.c                    |   61 --------------------------
 arch/x86/kernel/cpu/common.c                  |   12 -----
 arch/x86/kvm/vmx/vmenter.S                    |    1 
 tools/arch/x86/include/asm/cpufeatures.h      |    1 
 8 files changed, 3 insertions(+), 101 deletions(-)

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
@@ -286,7 +286,6 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
-#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+ 6) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
@@ -408,6 +407,5 @@
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
-#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -129,10 +129,6 @@
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
@@ -79,13 +79,6 @@
 	add	$(BITS_PER_LONG/8) * nr, sp;
 #endif
 
-#define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
-	call	881f;				\
-	int3;					\
-881:						\
-	add	$(BITS_PER_LONG/8), sp;		\
-	lfence;
-
 #ifdef __ASSEMBLY__
 
 /*
@@ -155,14 +148,6 @@
 #endif
 .endm
 
-.macro ISSUE_UNBALANCED_RET_GUARD ftr:req
-	ANNOTATE_NOSPEC_ALTERNATIVE
-	ALTERNATIVE "jmp .Lskip_pbrsb_\@",				\
-		__stringify(__ISSUE_UNBALANCED_RET_GUARD(%_ASM_SP))	\
-		\ftr
-.Lskip_pbrsb_\@:
-.endm
-
  /*
   * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
   * monstrosity above, manually.
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
@@ -1930,19 +1885,6 @@ static char *ibpb_state(void)
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
@@ -1955,13 +1897,12 @@ static ssize_t spectre_v2_show_state(cha
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
@@ -1025,7 +1025,6 @@ static void identify_cpu_without_cpuid(s
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_SPECTRE_V2		BIT(8)
-#define NO_EIBRS_PBRSB		BIT(9)
 #define NO_MMIO			BIT(10)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
@@ -1072,7 +1071,7 @@ static const __initconst struct x86_cpu_
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1082,9 +1081,7 @@ static const __initconst struct x86_cpu_
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -1251,11 +1248,6 @@ static void __init cpu_set_bug_bits(stru
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
-	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
-	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
-	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
-
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -92,7 +92,6 @@ ENTRY(vmx_vmexit)
 	pop %_ASM_AX
 .Lvmexit_skip_rsb:
 #endif
-	ISSUE_UNBALANCED_RET_GUARD X86_FEATURE_RSB_VMEXIT_LITE
 	ret
 ENDPROC(vmx_vmexit)
 
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -284,7 +284,6 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
-#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+ 6) /* "" Fill RSB on VM-Exit when EIBRS is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */



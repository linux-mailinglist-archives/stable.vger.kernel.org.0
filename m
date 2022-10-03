Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACCC5F30B5
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJCNLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiJCNLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:11:05 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB154D4FD;
        Mon,  3 Oct 2022 06:11:01 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 430D842FB2;
        Mon,  3 Oct 2022 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802659;
        bh=94aI+JjH8h0b/9TWJsurjQMeK7REnDGaq8C8E9z6W54=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=plP9Of+gFH7yMQdK+4Fx+6rDyuM9NedwHap4uVtYzRRSZu5+EvN1mh7AAZKZYLsMf
         iRXqdXcP6mLzIvtsGS6EYKebFbpe6JH+VOToDLy2Je6DNPSsSmojL40OPNuCQ4bACs
         k51eZQAbzJFDqLUBOAmPWE1AtM/7EZsQvQD2b+e+T0KUnVymUFPJnDCCn7wC70qfBa
         4pFO5W0AW2Xy1Hw5FI9ylVvVdY/agyHn0BPet7M0sWaiMMvNu1ddZ8e49h/PrY2iyR
         OAk9kFtuVSsfUhm9ZM7HQh/AWMP71RG0pcjUZJ+8jikdTs2eB6YOupqq6gLNsA2VLF
         Wo2x7w+TGWmkQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 01/37] Revert "x86/speculation: Add RSB VM Exit protections"
Date:   Mon,  3 Oct 2022 10:10:02 -0300
Message-Id: <20221003131038.12645-2-cascardo@canonical.com>
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

This reverts commit f2f41ef0352db9679bfae250d7a44b3113f3a3cc.

This is commit 2b1299322016731d56807aa49254a5ea3080b6b3 upstream.

In order to apply IBRS mitigation for Retbleed, PBRSB mitigations must be
reverted and the reapplied, so the backports can look sane.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |  8 ---
 arch/x86/include/asm/cpufeatures.h            |  2 -
 arch/x86/include/asm/msr-index.h              |  4 --
 arch/x86/include/asm/nospec-branch.h          | 15 -----
 arch/x86/kernel/cpu/bugs.c                    | 61 +------------------
 arch/x86/kernel/cpu/common.c                  | 12 +---
 arch/x86/kvm/vmx/vmenter.S                    |  1 -
 tools/arch/x86/include/asm/cpufeatures.h      |  1 -
 8 files changed, 3 insertions(+), 101 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 7e061ed449aa..6bd97cd50d62 100644
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
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 736b0e412344..e5d2bf3b3fa2 100644
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
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index cef4eba03ff3..c56042916a7c 100644
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
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index a1ee1a760c3e..33b4d1df01f7 100644
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
@@ -153,14 +146,6 @@
 #else
 	call	*\reg
 #endif
-.endm
-
-.macro ISSUE_UNBALANCED_RET_GUARD ftr:req
-	ANNOTATE_NOSPEC_ALTERNATIVE
-	ALTERNATIVE "jmp .Lskip_pbrsb_\@",				\
-		__stringify(__ISSUE_UNBALANCED_RET_GUARD(%_ASM_SP))	\
-		\ftr
-.Lskip_pbrsb_\@:
 .endm
 
  /*
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c90d91cb1434..163e9a88f282 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1046,49 +1046,6 @@ static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
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
@@ -1181,8 +1138,6 @@ static void __init spectre_v2_select_mitigation(void)
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
@@ -1955,13 +1897,12 @@ static ssize_t spectre_v2_show_state(char *buf)
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
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 59413e741ecf..5f8eec65f1c4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1025,7 +1025,6 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_SPECTRE_V2		BIT(8)
-#define NO_EIBRS_PBRSB		BIT(9)
 #define NO_MMIO			BIT(10)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
@@ -1072,7 +1071,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1082,9 +1081,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -1251,11 +1248,6 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
-	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
-	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
-	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
-
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 946d9205c3b6..ca4252f81bf8 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -92,7 +92,6 @@ ENTRY(vmx_vmexit)
 	pop %_ASM_AX
 .Lvmexit_skip_rsb:
 #endif
-	ISSUE_UNBALANCED_RET_GUARD X86_FEATURE_RSB_VMEXIT_LITE
 	ret
 ENDPROC(vmx_vmexit)
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 59f924e92c28..4133c721af6e 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -284,7 +284,6 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
-#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+ 6) /* "" Fill RSB on VM-Exit when EIBRS is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
-- 
2.34.1


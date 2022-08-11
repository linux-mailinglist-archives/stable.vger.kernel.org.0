Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003E558FB76
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbiHKLh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiHKLh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E486531207;
        Thu, 11 Aug 2022 04:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62294612DB;
        Thu, 11 Aug 2022 11:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38122C433D7;
        Thu, 11 Aug 2022 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660217842;
        bh=CWDu1ilZL+1pjehaf+YIwUSHw8A4Rll0JW8v+VQg16k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkIfmkfyyIv+Je4FfZMfBoJADz14L3uCmOd4fmxZ57xnhmF2BRP28hmtvba4jEozh
         xpwzGGevNji7jonL64QDW5Hqk41L6YEuJ9ZY0sFJCE6Urv9qv0WW+LNh+X1kPiRLv1
         iyfOO9d5wmZehkFVgiHFl6d6abefB9X6RItb25A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.18.17
Date:   Thu, 11 Aug 2022 13:37:11 +0200
Message-Id: <1660217830358@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <166021783012854@kroah.com>
References: <166021783012854@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 9e9556826450..2ce2a38cdd55 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -422,6 +422,14 @@ The possible values in this file are:
   'RSB filling'   Protection of RSB on context switch enabled
   =============   ===========================================
 
+  - EIBRS Post-barrier Return Stack Buffer (PBRSB) protection status:
+
+  ===========================  =======================================================
+  'PBRSB-eIBRS: SW sequence'   CPU is affected and protection of RSB on VMEXIT enabled
+  'PBRSB-eIBRS: Vulnerable'    CPU is vulnerable
+  'PBRSB-eIBRS: Not affected'  CPU is not affected by PBRSB
+  ===========================  =======================================================
+
 Full mitigation might require a microcode update from the CPU
 vendor. When the necessary microcode is not available, the kernel will
 report vulnerability.
diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index 5aac094fd217..58ecafc1b7f9 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -23,6 +23,7 @@ properties:
       - brcm,bcm4345c5
       - brcm,bcm43540-bt
       - brcm,bcm4335a0
+      - brcm,bcm4349-bt
 
   shutdown-gpios:
     maxItems: 1
diff --git a/Makefile b/Makefile
index 18bcbcd037f0..ef8c18e5c161 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 18
-SUBLEVEL = 16
+SUBLEVEL = 17
 EXTRAVERSION =
 NAME = Superb Owl
 
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index 9c3d86e397bf..1fae18ba11ed 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -52,7 +52,7 @@ static void neon_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
 {
 	if (unlikely(!dctx->sset)) {
 		if (!dctx->rset) {
-			poly1305_init_arch(dctx, src);
+			poly1305_init_arm64(&dctx->h, src);
 			src += POLY1305_BLOCK_SIZE;
 			len -= POLY1305_BLOCK_SIZE;
 			dctx->rset = 1;
diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 96dc0f7da258..a971d462f531 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -103,8 +103,8 @@
 /*
  * Initial memory map attributes.
  */
-#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
-#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
+#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED | PTE_UXN)
+#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S | PMD_SECT_UXN)
 
 #if ARM64_KERNEL_USES_PMD_MAPS
 #define SWAPPER_MM_MMUFLAGS	(PMD_ATTRINDX(MT_NORMAL) | SWAPPER_PMD_FLAGS)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 6a98f1a38c29..8a93a0a7489b 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -285,7 +285,7 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
 	subs	x1, x1, #64
 	b.ne	1b
 
-	mov	x7, SWAPPER_MM_MMUFLAGS
+	mov_q	x7, SWAPPER_MM_MMUFLAGS
 
 	/*
 	 * Create the identity mapping.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4d1d87f76a74..ce1f5a876cfe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2469,7 +2469,7 @@ config RETPOLINE
 config RETHUNK
 	bool "Enable return-thunks"
 	depends on RETPOLINE && CC_HAS_RETURN_THUNK
-	default y
+	default y if X86_64
 	help
 	  Compile the kernel with the return-thunks compiler option to guard
 	  against kernel-to-user data leaks by avoiding return speculation.
@@ -2478,21 +2478,21 @@ config RETHUNK
 
 config CPU_UNRET_ENTRY
 	bool "Enable UNRET on kernel entry"
-	depends on CPU_SUP_AMD && RETHUNK
+	depends on CPU_SUP_AMD && RETHUNK && X86_64
 	default y
 	help
 	  Compile the kernel with support for the retbleed=unret mitigation.
 
 config CPU_IBPB_ENTRY
 	bool "Enable IBPB on kernel entry"
-	depends on CPU_SUP_AMD
+	depends on CPU_SUP_AMD && X86_64
 	default y
 	help
 	  Compile the kernel with support for the retbleed=ibpb mitigation.
 
 config CPU_IBRS_ENTRY
 	bool "Enable IBRS on kernel entry"
-	depends on CPU_SUP_INTEL
+	depends on CPU_SUP_INTEL && X86_64
 	default y
 	help
 	  Compile the kernel with support for the spectre_v2=ibrs mitigation.
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 49889f171e86..e82da174d28c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -302,6 +302,7 @@
 #define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
@@ -453,5 +454,6 @@
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ff36610af6a..9fdaa847d4b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -651,6 +651,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	u64 smbase;
 	u64 smi_count;
+	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
 	bool xfd_no_write_intercept;
@@ -1289,6 +1290,8 @@ struct kvm_vcpu_stat {
 	u64 nested_run;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
+	u64 preemption_reported;
+	u64 preemption_other;
 	u64 guest_mode;
 };
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ad084326f24c..f951147cc7fd 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -148,6 +148,10 @@
 						 * are restricted to targets in
 						 * kernel.
 						 */
+#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
+						 * Not susceptible to Post-Barrier
+						 * Return Stack Buffer Predictions.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 38a3e86e665e..d3a3cc6772ee 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -60,7 +60,9 @@
 774:						\
 	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
-	jnz	771b;
+	jnz	771b;				\
+	/* barrier for jnz misprediction */	\
+	lfence;
 
 #ifdef __ASSEMBLY__
 
@@ -118,13 +120,28 @@
 #endif
 .endm
 
+.macro ISSUE_UNBALANCED_RET_GUARD
+	ANNOTATE_INTRA_FUNCTION_CALL
+	call .Lunbalanced_ret_guard_\@
+	int3
+.Lunbalanced_ret_guard_\@:
+	add $(BITS_PER_LONG/8), %_ASM_SP
+	lfence
+.endm
+
  /*
   * A simpler FILL_RETURN_BUFFER macro. Don't make people use the CPP
   * monstrosity above, manually.
   */
-.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
+.macro FILL_RETURN_BUFFER reg:req nr:req ftr:req ftr2
+.ifb \ftr2
 	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
+.else
+	ALTERNATIVE_2 "jmp .Lskip_rsb_\@", "", \ftr, "jmp .Lunbalanced_\@", \ftr2
+.endif
 	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
+.Lunbalanced_\@:
+	ISSUE_UNBALANCED_RET_GUARD
 .Lskip_rsb_\@:
 .endm
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index fd986a8ba2bd..fa625b2a8a93 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1328,6 +1328,53 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 	}
 }
 
+static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
+{
+	/*
+	 * Similar to context switches, there are two types of RSB attacks
+	 * after VM exit:
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
+	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
+	 * bug is present then a LITE version of RSB protection is required,
+	 * just a single call needs to retire before a RET is executed.
+	 */
+	switch (mode) {
+	case SPECTRE_V2_NONE:
+		return;
+
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS:
+		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
+			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+		}
+		return;
+
+	case SPECTRE_V2_EIBRS_RETPOLINE:
+	case SPECTRE_V2_RETPOLINE:
+	case SPECTRE_V2_LFENCE:
+	case SPECTRE_V2_IBRS:
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		return;
+	}
+
+	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
+	dump_stack();
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1478,28 +1525,7 @@ static void __init spectre_v2_select_mitigation(void)
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-	/*
-	 * Similar to context switches, there are two types of RSB attacks
-	 * after vmexit:
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
-	 * eIBRS, on the other hand, has RSB-poisoning protections, so it
-	 * doesn't need RSB clearing after vmexit.
-	 */
-	if (boot_cpu_has(X86_FEATURE_RETPOLINE) ||
-	    boot_cpu_has(X86_FEATURE_KERNEL_IBRS))
-		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
 
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
@@ -2285,6 +2311,19 @@ static char *ibpb_state(void)
 	return "";
 }
 
+static char *pbrsb_eibrs_state(void)
+{
+	if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
+		if (boot_cpu_has(X86_FEATURE_RSB_VMEXIT_LITE) ||
+		    boot_cpu_has(X86_FEATURE_RSB_VMEXIT))
+			return ", PBRSB-eIBRS: SW sequence";
+		else
+			return ", PBRSB-eIBRS: Vulnerable";
+	} else {
+		return ", PBRSB-eIBRS: Not affected";
+	}
+}
+
 static ssize_t spectre_v2_show_state(char *buf)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
@@ -2297,12 +2336,13 @@ static ssize_t spectre_v2_show_state(char *buf)
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sprintf(buf, "%s%s%s%s%s%s\n",
+	return sprintf(buf, "%s%s%s%s%s%s%s\n",
 		       spectre_v2_strings[spectre_v2_enabled],
 		       ibpb_state(),
 		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
 		       stibp_state(),
 		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
+		       pbrsb_eibrs_state(),
 		       spectre_v2_module_string());
 }
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1f43ddf2ffc3..d47e20e305cd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1161,6 +1161,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_SPECTRE_V2		BIT(8)
+#define NO_EIBRS_PBRSB		BIT(9)
 
 #define VULNWL(vendor, family, model, whitelist)	\
 	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, whitelist)
@@ -1203,7 +1204,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1213,7 +1214,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
@@ -1391,6 +1394,11 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_RETBLEED);
 	}
 
+	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
+	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 6d3b3e5a5533..ee4802d7b36c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -145,6 +145,15 @@ static bool try_step_up(struct tdp_iter *iter)
 	return true;
 }
 
+/*
+ * Step the iterator back up a level in the paging structure. Should only be
+ * used when the iterator is below the root level.
+ */
+void tdp_iter_step_up(struct tdp_iter *iter)
+{
+	WARN_ON(!try_step_up(iter));
+}
+
 /*
  * Step to the next SPTE in a pre-order traversal of the paging structure.
  * To get to the next SPTE, the iterator either steps down towards the goal
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..adfca0cf94d3 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -114,5 +114,6 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
+void tdp_iter_step_up(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 922b06bf4b94..b61a11d462cc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1748,12 +1748,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
+	int max_mapping_level;
 	kvm_pfn_t pfn;
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
@@ -1761,15 +1761,41 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		/*
+		 * This is a leaf SPTE. Check if the PFN it maps can
+		 * be mapped at a higher level.
+		 */
 		pfn = spte_to_pfn(iter.old_spte);
-		if (kvm_is_reserved_pfn(pfn) ||
-		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
-							    pfn, PG_LEVEL_NUM))
+
+		if (kvm_is_reserved_pfn(pfn))
 			continue;
 
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
+				iter.gfn, pfn, PG_LEVEL_NUM);
+
+		WARN_ON(max_mapping_level < iter.level);
+
+		/*
+		 * If this page is already mapped at the highest
+		 * viable level, there's nothing more to do.
+		 */
+		if (max_mapping_level == iter.level)
+			continue;
+
+		/*
+		 * The page can be remapped at a higher level, so step
+		 * up to zap the parent SPTE.
+		 */
+		while (max_mapping_level > iter.level)
+			tdp_iter_step_up(&iter);
+
 		/* Note, a successful atomic zap also does a remote TLB flush. */
-		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
-			goto retry;
+		tdp_mmu_zap_spte_atomic(kvm, &iter);
+
+		/*
+		 * If the atomic zap fails, the iter will recurse back into
+		 * the same subtree to retry.
+		 */
 	}
 
 	rcu_read_unlock();
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 76e9e6eb71d6..7aa1ce34a520 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -844,7 +844,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 
 	/* If source buffer is not aligned then use an intermediate buffer */
 	if (!IS_ALIGNED((unsigned long)vaddr, 16)) {
-		src_tpage = alloc_page(GFP_KERNEL);
+		src_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!src_tpage)
 			return -ENOMEM;
 
@@ -865,7 +865,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED((unsigned long)dst_vaddr, 16) || !IS_ALIGNED(size, 16)) {
 		int dst_offset;
 
-		dst_tpage = alloc_page(GFP_KERNEL);
+		dst_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!dst_tpage) {
 			ret = -ENOMEM;
 			goto e_free;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6bfb0b0e66bd..c667214c630b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4166,6 +4166,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
+	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_INTR)
+		vcpu->arch.at_instruction_boundary = true;
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 4182c7ffc909..6de96b943804 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -227,11 +227,13 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	 * entries and (in some cases) RSB underflow.
 	 *
 	 * eIBRS has its own protection against poisoned RSB, so it doesn't
-	 * need the RSB filling sequence.  But it does need to be enabled
-	 * before the first unbalanced RET.
+	 * need the RSB filling sequence.  But it does need to be enabled, and a
+	 * single call to retire, before the first unbalanced RET.
          */
 
-	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT
+	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
+			   X86_FEATURE_RSB_VMEXIT_LITE
+
 
 	pop %_ASM_ARG2	/* @flags */
 	pop %_ASM_ARG1	/* @vmx */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4b6a0268c78e..597c3c08da50 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6630,6 +6630,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
+	vcpu->arch.at_instruction_boundary = true;
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 53b6fdf30c99..65b0ec28bd52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -291,6 +291,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
+	STATS_DESC_COUNTER(VCPU, preemption_reported),
+	STATS_DESC_COUNTER(VCPU, preemption_other),
 	STATS_DESC_ICOUNTER(VCPU, guest_mode)
 };
 
@@ -4607,6 +4609,19 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	struct kvm_memslots *slots;
 	static const u8 preempted = KVM_VCPU_PREEMPTED;
 
+	/*
+	 * The vCPU can be marked preempted if and only if the VM-Exit was on
+	 * an instruction boundary and will not trigger guest emulation of any
+	 * kind (see vcpu_run).  Vendor specific code controls (conservatively)
+	 * when this is true, for example allowing the vCPU to be marked
+	 * preempted if and only if the VM-Exit was due to a host interrupt.
+	 */
+	if (!vcpu->arch.at_instruction_boundary) {
+		vcpu->stat.preemption_other++;
+		return;
+	}
+
+	vcpu->stat.preemption_reported++;
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -4636,19 +4651,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
-		vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
+	if (vcpu->preempted) {
+		if (!vcpu->arch.guest_state_protected)
+			vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
 
-	/*
-	 * Take the srcu lock as memslots will be accessed to check the gfn
-	 * cache generation against the memslots generation.
-	 */
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (kvm_xen_msr_enabled(vcpu->kvm))
-		kvm_xen_runstate_set_preempted(vcpu);
-	else
-		kvm_steal_time_set_preempted(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		/*
+		 * Take the srcu lock as memslots will be accessed to check the gfn
+		 * cache generation against the memslots generation.
+		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		if (kvm_xen_msr_enabled(vcpu->kvm))
+			kvm_xen_runstate_set_preempted(vcpu);
+		else
+			kvm_steal_time_set_preempted(vcpu);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
@@ -9767,6 +9784,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		return;
 
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
+	preempt_disable();
 
 	activate = kvm_apicv_activated(vcpu->kvm);
 	if (vcpu->arch.apicv_active == activate)
@@ -9786,6 +9804,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 out:
+	preempt_enable();
 	up_read(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
@@ -10363,6 +10382,13 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		/*
+		 * If another guest vCPU requests a PV TLB flush in the middle
+		 * of instruction emulation, the rest of the emulation could
+		 * use a stale page translation. Assume that any code after
+		 * this point can start executing an instruction.
+		 */
+		vcpu->arch.at_instruction_boundary = false;
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index adbcc9ed59db..fda1413f8af9 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -103,8 +103,10 @@ static inline void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
 	 * behalf of the vCPU. Only if the VMM does actually block
 	 * does it need to enter RUNSTATE_blocked.
 	 */
-	if (vcpu->preempted)
-		kvm_xen_update_runstate_guest(vcpu, RUNSTATE_runnable);
+	if (WARN_ON_ONCE(!vcpu->preempted))
+		return;
+
+	kvm_xen_update_runstate_guest(vcpu, RUNSTATE_runnable);
 }
 
 /* 32-bit compatibility definitions, also used natively in 32-bit build */
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index df9cfe4ca532..63fc02042408 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -247,6 +247,8 @@ static struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
 #endif
+	ioc->ioprio = IOPRIO_DEFAULT;
+
 	return ioc;
 }
 
diff --git a/block/ioprio.c b/block/ioprio.c
index 2fe068fcaad5..2a34cbca18ae 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -157,9 +157,9 @@ static int get_task_ioprio(struct task_struct *p)
 int ioprio_best(unsigned short aprio, unsigned short bprio)
 {
 	if (!ioprio_valid(aprio))
-		aprio = IOPRIO_DEFAULT;
+		aprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NORM);
 	if (!ioprio_valid(bprio))
-		bprio = IOPRIO_DEFAULT;
+		bprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NORM);
 
 	return min(aprio, bprio);
 }
diff --git a/drivers/acpi/apei/bert.c b/drivers/acpi/apei/bert.c
index 598fd19b65fa..45973aa6e06d 100644
--- a/drivers/acpi/apei/bert.c
+++ b/drivers/acpi/apei/bert.c
@@ -29,16 +29,26 @@
 
 #undef pr_fmt
 #define pr_fmt(fmt) "BERT: " fmt
+
+#define ACPI_BERT_PRINT_MAX_RECORDS 5
 #define ACPI_BERT_PRINT_MAX_LEN 1024
 
 static int bert_disable;
 
+/*
+ * Print "all" the error records in the BERT table, but avoid huge spam to
+ * the console if the BIOS included oversize records, or too many records.
+ * Skipping some records here does not lose anything because the full
+ * data is available to user tools in:
+ *	/sys/firmware/acpi/tables/data/BERT
+ */
 static void __init bert_print_all(struct acpi_bert_region *region,
 				  unsigned int region_len)
 {
 	struct acpi_hest_generic_status *estatus =
 		(struct acpi_hest_generic_status *)region;
 	int remain = region_len;
+	int printed = 0, skipped = 0;
 	u32 estatus_len;
 
 	while (remain >= sizeof(struct acpi_bert_region)) {
@@ -46,24 +56,26 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 		if (remain < estatus_len) {
 			pr_err(FW_BUG "Truncated status block (length: %u).\n",
 			       estatus_len);
-			return;
+			break;
 		}
 
 		/* No more error records. */
 		if (!estatus->block_status)
-			return;
+			break;
 
 		if (cper_estatus_check(estatus)) {
 			pr_err(FW_BUG "Invalid error record.\n");
-			return;
+			break;
 		}
 
-		pr_info_once("Error records from previous boot:\n");
-		if (region_len < ACPI_BERT_PRINT_MAX_LEN)
+		if (estatus_len < ACPI_BERT_PRINT_MAX_LEN &&
+		    printed < ACPI_BERT_PRINT_MAX_RECORDS) {
+			pr_info_once("Error records from previous boot:\n");
 			cper_estatus_print(KERN_INFO HW_ERR, estatus);
-		else
-			pr_info_once("Max print length exceeded, table data is available at:\n"
-				     "/sys/firmware/acpi/tables/data/BERT");
+			printed++;
+		} else {
+			skipped++;
+		}
 
 		/*
 		 * Because the boot error source is "one-time polled" type,
@@ -75,6 +87,9 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 		estatus = (void *)estatus + estatus_len;
 		remain -= estatus_len;
 	}
+
+	if (skipped)
+		pr_info(HW_ERR "Skipped %d error records\n", skipped);
 }
 
 static int __init setup_bert_disable(char *str)
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index becc198e4c22..6615f59ab7fd 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -430,7 +430,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	.callback = video_detect_force_native,
 	.ident = "Clevo NL5xRU",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
 		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
 		},
 	},
@@ -438,59 +437,75 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	.callback = video_detect_force_native,
 	.ident = "Clevo NL5xRU",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "AURA1501"),
 		},
 	},
 	{
 	.callback = video_detect_force_native,
 	.ident = "Clevo NL5xRU",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "EDUBOOK1502"),
 		},
 	},
 	{
 	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xRU",
+	.ident = "Clevo NL5xNU",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
-		DMI_MATCH(DMI_BOARD_NAME, "AURA1501"),
+		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
 		},
 	},
+	/*
+	 * The TongFang PF5PU1G, PF4NU1F, PF5NU1G, and PF5LUXG/TUXEDO BA15 Gen10,
+	 * Pulse 14/15 Gen1, and Pulse 15 Gen2 have the same problem as the Clevo
+	 * NL5xRU and NL5xNU/TUXEDO Aura 15 Gen1 and Gen2. See the description
+	 * above.
+	 */
 	{
 	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xRU",
+	.ident = "TongFang PF5PU1G",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
-		DMI_MATCH(DMI_BOARD_NAME, "EDUBOOK1502"),
+		DMI_MATCH(DMI_BOARD_NAME, "PF5PU1G"),
 		},
 	},
 	{
 	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xNU",
+	.ident = "TongFang PF4NU1F",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "PF4NU1F"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF4NU1F",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		DMI_MATCH(DMI_BOARD_NAME, "PULSE1401"),
 		},
 	},
 	{
 	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xNU",
+	.ident = "TongFang PF5NU1G",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		DMI_MATCH(DMI_BOARD_NAME, "PF5NU1G"),
 		},
 	},
 	{
 	.callback = video_detect_force_native,
-	.ident = "Clevo NL5xNU",
+	.ident = "TongFang PF5NU1G",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Notebook"),
-		DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "PULSE1501"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang PF5LUXG",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
 		},
 	},
-
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index d9ceca7a7935..a18f289d7346 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -453,6 +453,8 @@ static const struct bcm_subver_table bcm_uart_subver_table[] = {
 	{ 0x6606, "BCM4345C5"	},	/* 003.006.006 */
 	{ 0x230f, "BCM4356A2"	},	/* 001.003.015 */
 	{ 0x220e, "BCM20702A1"  },	/* 001.002.014 */
+	{ 0x420d, "BCM4349B1"	},	/* 002.002.013 */
+	{ 0x420e, "BCM4349B1"	},	/* 002.002.014 */
 	{ 0x4217, "BCM4329B1"   },	/* 002.002.023 */
 	{ 0x6106, "BCM4359C0"	},	/* 003.001.006 */
 	{ 0x4106, "BCM4335A0"	},	/* 002.001.006 */
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e48c3ad069bb..d789c077d95d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -422,6 +422,18 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Realtek 8852CE Bluetooth devices */
+	{ USB_DEVICE(0x04ca, 0x4007), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x04c5, 0x1675), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0cb8, 0xc558), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3587), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3586), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_REALTEK },
@@ -469,6 +481,9 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0489, 0xe0d9), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3568), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 
 	/* Additional Realtek 8723AE Bluetooth devices */
 	{ USB_DEVICE(0x0930, 0x021d), .driver_info = BTUSB_REALTEK },
diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 785f445dd60d..49bed66b8c84 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1544,8 +1544,10 @@ static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm43430a0-bt" },
 	{ .compatible = "brcm,bcm43430a1-bt" },
 	{ .compatible = "brcm,bcm43438-bt", .data = &bcm43438_device_data },
+	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
+	{ .compatible = "infineon,cyw55572-bt" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bcm_bluetooth_of_match);
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index eab34e24d944..8df11016fd51 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1588,7 +1588,7 @@ static bool qca_wakeup(struct hci_dev *hdev)
 	wakeup = device_may_wakeup(hu->serdev->ctrl->dev.parent);
 	bt_dev_dbg(hu->hdev, "wakeup status : %d", wakeup);
 
-	return !wakeup;
+	return wakeup;
 }
 
 static int qca_regulator_init(struct hci_uart *hu)
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 73b396189039..afb0942ccc29 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -647,7 +647,7 @@ do_adb_query(struct adb_request *req)
 
 	switch(req->data[1]) {
 	case ADB_QUERY_GETDEVINFO:
-		if (req->nbytes < 3)
+		if (req->nbytes < 3 || req->data[2] >= 16)
 			break;
 		mutex_lock(&adb_handler_mutex);
 		req->reply[0] = adb_handler[req->data[2]].original_address;
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 19db5693175f..2a0ead57db71 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -104,6 +104,7 @@ struct btrfs_block_group {
 	unsigned int relocating_repair:1;
 	unsigned int chunk_item_inserted:1;
 	unsigned int zone_is_active:1;
+	unsigned int zoned_data_reloc_ongoing:1;
 
 	int disk_cache_state;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6aa92f84f465..f45ecd939a2c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3836,7 +3836,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	       block_group->start == fs_info->data_reloc_bg ||
 	       fs_info->data_reloc_bg == 0);
 
-	if (block_group->ro) {
+	if (block_group->ro || block_group->zoned_data_reloc_ongoing) {
 		ret = 1;
 		goto out;
 	}
@@ -3898,8 +3898,24 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 out:
 	if (ret && ffe_ctl->for_treelog)
 		fs_info->treelog_bg = 0;
-	if (ret && ffe_ctl->for_data_reloc)
+	if (ret && ffe_ctl->for_data_reloc &&
+	    fs_info->data_reloc_bg == block_group->start) {
+		/*
+		 * Do not allow further allocations from this block group.
+		 * Compared to increasing the ->ro, setting the
+		 * ->zoned_data_reloc_ongoing flag still allows nocow
+		 *  writers to come in. See btrfs_inc_nocow_writers().
+		 *
+		 * We need to disable an allocation to avoid an allocation of
+		 * regular (non-relocation data) extent. With mix of relocation
+		 * extents and regular extents, we can dispatch WRITE commands
+		 * (for relocation extents) and ZONE APPEND commands (for
+		 * regular extents) at the same time to the same zone, which
+		 * easily break the write pointer.
+		 */
+		block_group->zoned_data_reloc_ongoing = 1;
 		fs_info->data_reloc_bg = 0;
+	}
 	spin_unlock(&fs_info->relocation_bg_lock);
 	spin_unlock(&fs_info->treelog_bg_lock);
 	spin_unlock(&block_group->lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a23a42ba88ca..68ddd90685d9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5214,13 +5214,14 @@ int extent_writepages(struct address_space *mapping,
 	 */
 	btrfs_zoned_data_reloc_lock(BTRFS_I(inode));
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	ASSERT(ret <= 0);
 	if (ret < 0) {
+		btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 		end_write_bio(&epd, ret);
 		return ret;
 	}
 	ret = flush_write_bio(&epd);
+	btrfs_zoned_data_reloc_unlock(BTRFS_I(inode));
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9ae79342631a..5d15e374d032 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3102,6 +3102,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
 						logical_len);
+		btrfs_zoned_release_data_reloc_bg(fs_info, ordered_extent->disk_bytenr,
+						  ordered_extent->disk_num_bytes);
 	} else {
 		BUG_ON(root == fs_info->tree_root);
 		ret = insert_ordered_extent_file_extent(trans, ordered_extent);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5091d679a602..84b6d39509bd 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2005,6 +2005,7 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 	struct btrfs_device *device;
 	u64 min_alloc_bytes;
 	u64 physical;
+	int i;
 
 	if (!btrfs_is_zoned(fs_info))
 		return;
@@ -2039,13 +2040,25 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 	spin_unlock(&block_group->lock);
 
 	map = block_group->physical_map;
-	device = map->stripes[0].dev;
-	physical = map->stripes[0].physical;
+	for (i = 0; i < map->num_stripes; i++) {
+		int ret;
 
-	if (!device->zone_info->max_active_zones)
-		goto out;
+		device = map->stripes[i].dev;
+		physical = map->stripes[i].physical;
+
+		if (device->zone_info->max_active_zones == 0)
+			continue;
 
-	btrfs_dev_clear_active_zone(device, physical);
+		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+				       physical >> SECTOR_SHIFT,
+				       device->zone_info->zone_size >> SECTOR_SHIFT,
+				       GFP_NOFS);
+
+		if (ret)
+			return;
+
+		btrfs_dev_clear_active_zone(device, physical);
+	}
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
 	ASSERT(!list_empty(&block_group->active_bg_list));
@@ -2116,3 +2129,30 @@ void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 }
+
+void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
+				       u64 length)
+{
+	struct btrfs_block_group *block_group;
+
+	if (!btrfs_is_zoned(fs_info))
+		return;
+
+	block_group = btrfs_lookup_block_group(fs_info, logical);
+	/* It should be called on a previous data relocation block group. */
+	ASSERT(block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA));
+
+	spin_lock(&block_group->lock);
+	if (!block_group->zoned_data_reloc_ongoing)
+		goto out;
+
+	/* All relocation extents are written. */
+	if (block_group->start + block_group->alloc_offset == logical + length) {
+		/* Now, release this block group for further allocations. */
+		block_group->zoned_data_reloc_ongoing = 0;
+	}
+
+out:
+	spin_unlock(&block_group->lock);
+	btrfs_put_block_group(block_group);
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 2d898970aec5..cf6320feef46 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -80,6 +80,8 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
+				       u64 length);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -241,6 +243,9 @@ static inline void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
+
+static inline void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info,
+						     u64 logical, u64 length) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 3f53bc27a19b..3d088a88f832 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -11,7 +11,7 @@
 /*
  * Default IO priority.
  */
-#define IOPRIO_DEFAULT	IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NORM)
+#define IOPRIO_DEFAULT	IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0)
 
 /*
  * Check that a priority value has a valid class.
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 9d09f489b60e..2e0f75bcb7fd 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -9,12 +9,6 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 		int ret;
 
 		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
-			clear_notify_signal();
-			if (task_work_pending(current))
-				task_work_run();
-		}
-
-		if (ti_work & _TIF_SIGPENDING) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
 		}
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 5d09ded0c491..04b7e3654ff7 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -301,6 +301,7 @@
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM-Exit when EIBRS is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index ad084326f24c..f951147cc7fd 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -148,6 +148,10 @@
 						 * are restricted to targets in
 						 * kernel.
 						 */
+#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
+						 * Not susceptible to Post-Barrier
+						 * Return Stack Buffer Predictions.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 5a5bd74f55bd..9c366b3a676d 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1646,7 +1646,8 @@ Press any other key to refresh statistics immediately.
                          .format(values))
             if len(pids) > 1:
                 sys.exit('Error: Multiple processes found (pids: {}). Use "-p"'
-                         ' to specify the desired pid'.format(" ".join(pids)))
+                         ' to specify the desired pid'
+                         .format(" ".join(map(str, pids))))
             namespace.pid = pids[0]
 
     argparser = argparse.ArgumentParser(description=description_text,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index e0b0164e9af8..be1d9728c4ce 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -73,20 +73,19 @@ void ucall_uninit(struct kvm_vm *vm)
 
 void ucall(uint64_t cmd, int nargs, ...)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
+	struct ucall uc = {};
 	va_list va;
 	int i;
 
+	WRITE_ONCE(uc.cmd, cmd);
 	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
+		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
+	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
 }
 
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 722df3a28791..ddd68ba0c99f 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -110,6 +110,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
+	uint64_t region_end_gfn;
 	int i;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
@@ -144,18 +145,29 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pta->vm = vm;
 
+	/* Put the test region at the top guest physical memory. */
+	region_end_gfn = vm_get_max_gfn(vm) + 1;
+
+#ifdef __x86_64__
+	/*
+	 * When running vCPUs in L2, restrict the test region to 48 bits to
+	 * avoid needing 5-level page tables to identity map L2.
+	 */
+	if (pta->nested)
+		region_end_gfn = min(region_end_gfn, (1UL << 48) / pta->guest_page_size);
+#endif
 	/*
 	 * If there should be more memory in the guest test region than there
 	 * can be pages in the guest, it will definitely cause problems.
 	 */
-	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
+	TEST_ASSERT(guest_num_pages < region_end_gfn,
 		    "Requested more guest memory than address space allows.\n"
 		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
 		    " vcpus: %d wss: %" PRIx64 "]\n",
-		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
+		    guest_num_pages, region_end_gfn - 1, vcpus,
 		    vcpu_memory_bytes);
 
-	pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
+	pta->gpa = (region_end_gfn - guest_num_pages) * pta->guest_page_size;
 	pta->gpa = align_down(pta->gpa, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index e0b2bb1339b1..3330fb183c68 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -44,7 +44,7 @@ static inline void nop_loop(void)
 {
 	int i;
 
-	for (i = 0; i < 1000000; i++)
+	for (i = 0; i < 100000000; i++)
 		asm volatile("nop");
 }
 
@@ -56,12 +56,14 @@ static inline void check_tsc_msr_rdtsc(void)
 	tsc_freq = rdmsr(HV_X64_MSR_TSC_FREQUENCY);
 	GUEST_ASSERT(tsc_freq > 0);
 
-	/* First, check MSR-based clocksource */
+	/* For increased accuracy, take mean rdtsc() before and afrer rdmsr() */
 	r1 = rdtsc();
 	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	r1 = (r1 + rdtsc()) / 2;
 	nop_loop();
 	r2 = rdtsc();
 	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
+	r2 = (r2 + rdtsc()) / 2;
 
 	GUEST_ASSERT(r2 > r1 && t2 > t1);
 
@@ -181,12 +183,14 @@ static void host_check_tsc_msr_rdtsc(struct kvm_vm *vm)
 	tsc_freq = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TSC_FREQUENCY);
 	TEST_ASSERT(tsc_freq > 0, "TSC frequency must be nonzero");
 
-	/* First, check MSR-based clocksource */
+	/* For increased accuracy, take mean rdtsc() before and afrer ioctl */
 	r1 = rdtsc();
 	t1 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	r1 = (r1 + rdtsc()) / 2;
 	nop_loop();
 	r2 = rdtsc();
 	t2 = vcpu_get_msr(vm, VCPU_ID, HV_X64_MSR_TIME_REF_COUNT);
+	r2 = (r2 + rdtsc()) / 2;
 
 	TEST_ASSERT(t2 > t1, "Time reference MSR is not monotonic (%ld <= %ld)", t1, t2);
 
diff --git a/tools/vm/slabinfo.c b/tools/vm/slabinfo.c
index 9b68658b6bb8..5b98f3ee58a5 100644
--- a/tools/vm/slabinfo.c
+++ b/tools/vm/slabinfo.c
@@ -233,6 +233,24 @@ static unsigned long read_slab_obj(struct slabinfo *s, const char *name)
 	return l;
 }
 
+static unsigned long read_debug_slab_obj(struct slabinfo *s, const char *name)
+{
+	char x[128];
+	FILE *f;
+	size_t l;
+
+	snprintf(x, 128, "/sys/kernel/debug/slab/%s/%s", s->name, name);
+	f = fopen(x, "r");
+	if (!f) {
+		buffer[0] = 0;
+		l = 0;
+	} else {
+		l = fread(buffer, 1, sizeof(buffer), f);
+		buffer[l] = 0;
+		fclose(f);
+	}
+	return l;
+}
 
 /*
  * Put a size string together
@@ -409,14 +427,18 @@ static void show_tracking(struct slabinfo *s)
 {
 	printf("\n%s: Kernel object allocation\n", s->name);
 	printf("-----------------------------------------------------------------------\n");
-	if (read_slab_obj(s, "alloc_calls"))
+	if (read_debug_slab_obj(s, "alloc_traces"))
+		printf("%s", buffer);
+	else if (read_slab_obj(s, "alloc_calls"))
 		printf("%s", buffer);
 	else
 		printf("No Data\n");
 
 	printf("\n%s: Kernel object freeing\n", s->name);
 	printf("------------------------------------------------------------------------\n");
-	if (read_slab_obj(s, "free_calls"))
+	if (read_debug_slab_obj(s, "free_traces"))
+		printf("%s", buffer);
+	else if (read_slab_obj(s, "free_calls"))
 		printf("%s", buffer);
 	else
 		printf("No Data\n");
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 24cb37d19c63..7f1d19689701 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3327,9 +3327,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.generic.blocking = 1;
 
+	preempt_disable();
 	kvm_arch_vcpu_blocking(vcpu);
-
 	prepare_to_rcuwait(wait);
+	preempt_enable();
+
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -3339,9 +3341,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		waited = true;
 		schedule();
 	}
-	finish_rcuwait(wait);
 
+	preempt_disable();
+	finish_rcuwait(wait);
 	kvm_arch_vcpu_unblocking(vcpu);
+	preempt_enable();
 
 	vcpu->stat.generic.blocking = 0;
 

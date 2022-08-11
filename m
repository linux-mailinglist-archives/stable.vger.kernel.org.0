Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81B258FB51
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiHKLbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiHKLbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0B323BCC;
        Thu, 11 Aug 2022 04:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC78DB8205B;
        Thu, 11 Aug 2022 11:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE857C433B5;
        Thu, 11 Aug 2022 11:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660217442;
        bh=DKCr/qHrXEtvYf8Ek08HZIq+tcJo6f1f31IW56wykxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g03vPwPRhi1VDiysr/TMNItNpESdHKu7QtvS/gTaYMX8iDpIvbM62ia0jkEPzsoh0
         hrvlQTehBMLrNgd+4LyYR+GwTlUH4oBBe5S+lvvMbEYiguW4za8XcgBP49nC12Y3WX
         2BZW/Io9IYmNuCu3rcCH3mgigHtMV+IlDhj7QY4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.255
Date:   Thu, 11 Aug 2022 13:30:33 +0200
Message-Id: <166021743119696@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <1660217431160199@kroah.com>
References: <1660217431160199@kroah.com>
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
index 6bd97cd50d62..7e061ed449aa 100644
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
diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index e315e6052b9f..eb24b8137226 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -2170,7 +2170,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
 	Default: 4K
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	Currently this tunable has no effect.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimum size of send buffer that can be used by SCTP sockets.
+	It is guaranteed to each SCTP socket (but not association) even
+	under moderate memory pressure.
+
+	Default: 4K
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
diff --git a/Makefile b/Makefile
index c7a0dc943e74..b8e5b38e5352 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 254
+SUBLEVEL = 255
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
index c691b901092f..b4feebc385bc 100644
--- a/arch/arm/lib/xor-neon.c
+++ b/arch/arm/lib/xor-neon.c
@@ -29,8 +29,9 @@ MODULE_LICENSE("GPL");
  * While older versions of GCC do not generate incorrect code, they fail to
  * recognize the parallel nature of these functions, and emit plain ARM code,
  * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
+ *
+ * #warning This code requires at least version 4.6 of GCC
  */
-#warning This code requires at least version 4.6 of GCC
 #endif
 
 #pragma GCC diagnostic ignored "-Wunused-variable"
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 2c6e1c6ecbe7..4120c428dc37 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017, 2020
+ * Copyright IBM Corp. 2017, 2022
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -14,6 +14,7 @@
 #ifdef CONFIG_ARCH_RANDOM
 
 #include <linux/static_key.h>
+#include <linux/preempt.h>
 #include <linux/atomic.h>
 #include <asm/cpacf.h>
 
@@ -32,7 +33,8 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
@@ -42,7 +44,8 @@ static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8025b7da0495..89145ea183d6 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -283,6 +283,7 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+ 6) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
@@ -395,5 +396,6 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(26) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 586be095ed08..7a73799537bf 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -120,6 +120,10 @@
 						 * bit available to control VERW
 						 * behavior.
 						 */
+#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
+						 * Not susceptible to Post-Barrier
+						 * Return Stack Buffer Predictions.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index d3d68b6763d4..747549934fe3 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -52,7 +52,17 @@
 774:						\
 	dec	reg;				\
 	jnz	771b;				\
-	add	$(BITS_PER_LONG/8) * nr, sp;
+	add	$(BITS_PER_LONG/8) * nr, sp;	\
+	/* barrier for jnz misprediction */	\
+	lfence;
+
+/* Sequence to mitigate PBRSB on eIBRS CPUs */
+#define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
+	call	881f;				\
+	int3;					\
+881:						\
+	add	$(BITS_PER_LONG/8), sp;		\
+	lfence;
 
 #ifdef __ASSEMBLY__
 
@@ -269,6 +279,13 @@ static inline void vmexit_fill_RSB(void)
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
 #endif
+	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
+		      ALTERNATIVE("jmp 920f",
+				  __stringify(__ISSUE_UNBALANCED_RET_GUARD(%0)),
+				  X86_FEATURE_RSB_VMEXIT_LITE)
+		      "920:"
+		      : ASM_CALL_CONSTRAINT
+		      : : "memory" );
 }
 
 static __always_inline
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 058e92b93262..a36be6786043 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1043,6 +1043,49 @@ static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
 	return SPECTRE_V2_RETPOLINE;
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
+	/* These modes already fill RSB at vmexit */
+	case SPECTRE_V2_LFENCE:
+	case SPECTRE_V2_RETPOLINE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
+		return;
+
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS:
+		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
+			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+		}
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
@@ -1135,6 +1178,8 @@ static void __init spectre_v2_select_mitigation(void)
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
+	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
+
 	/*
 	 * Retpoline means the kernel is safe because it has no indirect
 	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
@@ -1867,6 +1912,19 @@ static char *ibpb_state(void)
 	return "";
 }
 
+static char *pbrsb_eibrs_state(void)
+{
+	if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
+		if (boot_cpu_has(X86_FEATURE_RSB_VMEXIT_LITE) ||
+		    boot_cpu_has(X86_FEATURE_RETPOLINE))
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
@@ -1879,12 +1937,13 @@ static ssize_t spectre_v2_show_state(char *buf)
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
index 389d11b2c70e..3ab35d5426b7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -954,6 +954,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define MSBDS_ONLY		BIT(5)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
+#define NO_EIBRS_PBRSB		BIT(8)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -990,7 +991,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1000,7 +1001,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
@@ -1154,6 +1157,11 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    !arch_cap_mmio_immune(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
 
+	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
+	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 44cce3e8eb18..20ce794584a3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10988,6 +10988,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 #endif
 	      );
 
+	/* Eliminate branch target predictions from guest mode */
+	vmexit_fill_RSB();
+
 	vmx_enable_fb_clear(vmx);
 
 	/*
@@ -11010,9 +11013,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
-
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 298d9c65e084..490ae990bd3c 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -371,7 +371,6 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	.callback = video_detect_force_native,
 	.ident = "Clevo NL5xRU",
 	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
 		DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
 		},
 	},
@@ -379,59 +378,75 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 76e98f0f7a3e..2f1952fd3a45 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -645,7 +645,7 @@ do_adb_query(struct adb_request *req)
 
 	switch(req->data[1]) {
 	case ADB_QUERY_GETDEVINFO:
-		if (req->nbytes < 3)
+		if (req->nbytes < 3 || req->data[2] >= 16)
 			break;
 		mutex_lock(&adb_handler_mutex);
 		req->reply[0] = adb_handler[req->data[2]].original_address;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3615c6533cf4..2f3b393e5506 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1808,11 +1808,15 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 		 * non-zero req_queue_pairs says that user requested a new
 		 * queue count via ethtool's set_channels, so use this
 		 * value for queues distribution across traffic classes
+		 * We need at least one queue pair for the interface
+		 * to be usable as we see in else statement.
 		 */
 		if (vsi->req_queue_pairs > 0)
 			vsi->num_queue_pairs = vsi->req_queue_pairs;
 		else if (pf->flags & I40E_FLAG_MSIX_ENABLED)
 			vsi->num_queue_pairs = pf->num_lan_msix;
+		else
+			vsi->num_queue_pairs = 1;
 	}
 
 	/* Number of queues per enabled TC */
diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 63a8ff816e59..e556b00dfed2 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -453,6 +453,7 @@ static int bcm5421_init(struct mii_phy* phy)
 		int can_low_power = 1;
 		if (np == NULL || of_get_property(np, "no-autolowpower", NULL))
 			can_low_power = 0;
+		of_node_put(np);
 		if (can_low_power) {
 			/* Enable automatic low-power */
 			sungem_phy_write(phy, 0x1c, 0x9002);
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index d8b7863f7926..11fef99093a7 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -34,6 +34,7 @@ static const struct usb_device_id mt7601u_device_table[] = {
 	{ USB_DEVICE(0x2717, 0x4106) },
 	{ USB_DEVICE(0x2955, 0x0001) },
 	{ USB_DEVICE(0x2955, 0x1001) },
+	{ USB_DEVICE(0x2955, 0x1003) },
 	{ USB_DEVICE(0x2a5f, 0x1000) },
 	{ USB_DEVICE(0x7392, 0x7710) },
 	{ 0, }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0191708c9dd4..ace4a7230bcf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2157,8 +2157,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
-		    scsi_device_blocked(sdev))
+		if (scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	default:
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 57985841a879..eca6d6db628a 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -124,9 +124,20 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	return ret;
 }
 
+static bool phandle_exists(const struct device_node *np,
+			   const char *phandle_name, int index)
+{
+	struct device_node *parse_np = of_parse_phandle(np, phandle_name, index);
+
+	if (parse_np)
+		of_node_put(parse_np);
+
+	return parse_np != NULL;
+}
+
 #define MAX_PROP_SIZE 32
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
-		struct ufs_vreg **out_vreg)
+				struct ufs_vreg **out_vreg)
 {
 	int ret = 0;
 	char prop_name[MAX_PROP_SIZE];
@@ -139,7 +150,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	}
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
-	if (!of_parse_phandle(np, prop_name, 0)) {
+	if (!phandle_exists(np, prop_name, 0)) {
 		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
 				__func__, prop_name);
 		goto out;
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 44a39a099b54..62b49197e5f6 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -606,8 +606,12 @@ static int ntfs_attr_find(const ATTR_TYPE type, const ntfschar *name,
 		a = (ATTR_RECORD*)((u8*)ctx->attr +
 				le32_to_cpu(ctx->attr->length));
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > (u8*)ctx->mrec +
-				le32_to_cpu(ctx->mrec->bytes_allocated))
+		u8 *mrec_end = (u8 *)ctx->mrec +
+		               le32_to_cpu(ctx->mrec->bytes_allocated);
+		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			       a->name_length * sizeof(ntfschar);
+		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
+		    name_end > mrec_end)
 			break;
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 21dbd38f724d..da0ef935c5a9 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -798,6 +798,7 @@ enum {
 };
 
 void l2cap_chan_hold(struct l2cap_chan *c);
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c);
 void l2cap_chan_put(struct l2cap_chan *c);
 
 static inline void l2cap_chan_lock(struct l2cap_chan *chan)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d28fa78dedb5..436ad4bc9d4c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1355,7 +1355,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space,
 
 static inline int tcp_win_from_space(const struct sock *sk, int space)
 {
-	int tcp_adv_win_scale = sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale;
+	int tcp_adv_win_scale = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale);
 
 	return tcp_adv_win_scale <= 0 ?
 		(space>>(-tcp_adv_win_scale)) :
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index c0d64b4144d4..709cceef6728 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -113,7 +113,8 @@ static struct l2cap_chan *__l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 }
 
 /* Find channel with given SCID.
- * Returns locked channel. */
+ * Returns a reference locked channel.
+ */
 static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 						 u16 cid)
 {
@@ -121,15 +122,19 @@ static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_scid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
 }
 
 /* Find channel with given DCID.
- * Returns locked channel.
+ * Returns a reference locked channel.
  */
 static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
 						 u16 cid)
@@ -138,8 +143,12 @@ static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_dcid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -164,8 +173,12 @@ static struct l2cap_chan *l2cap_get_chan_by_ident(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_ident(conn, ident);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -491,6 +504,16 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 	kref_get(&c->kref);
 }
 
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
+{
+	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
+
+	if (!kref_get_unless_zero(&c->kref))
+		return NULL;
+
+	return c;
+}
+
 void l2cap_chan_put(struct l2cap_chan *c)
 {
 	BT_DBG("chan %p orig refcnt %d", c, kref_read(&c->kref));
@@ -1803,7 +1826,10 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			src_match = !bacmp(&c->src, src);
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
-				l2cap_chan_hold(c);
+				c = l2cap_chan_hold_unless_zero(c);
+				if (!c)
+					continue;
+
 				read_unlock(&chan_list_lock);
 				return c;
 			}
@@ -1818,7 +1844,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 	}
 
 	if (c1)
-		l2cap_chan_hold(c1);
+		c1 = l2cap_chan_hold_unless_zero(c1);
 
 	read_unlock(&chan_list_lock);
 
@@ -4204,6 +4230,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -4316,6 +4343,7 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -5044,6 +5072,7 @@ static inline int l2cap_move_channel_req(struct l2cap_conn *conn,
 	l2cap_send_move_chan_rsp(chan, result);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5136,6 +5165,7 @@ static void l2cap_move_continue(struct l2cap_conn *conn, u16 icid, u16 result)
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
@@ -5165,6 +5195,7 @@ static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
 	l2cap_send_move_chan_cfm(chan, L2CAP_MC_UNCONFIRMED);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static int l2cap_move_channel_rsp(struct l2cap_conn *conn,
@@ -5228,6 +5259,7 @@ static int l2cap_move_channel_confirm(struct l2cap_conn *conn,
 	l2cap_send_move_chan_cfm_rsp(conn, cmd->ident, icid);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5263,6 +5295,7 @@ static inline int l2cap_move_channel_confirm_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5635,12 +5668,11 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
 	if (credits > max_credits) {
 		BT_ERR("LE credits overflow");
 		l2cap_send_disconn_req(chan, ECONNRESET);
-		l2cap_chan_unlock(chan);
 
 		/* Return 0 so that we don't trigger an unnecessary
 		 * command reject packet.
 		 */
-		return 0;
+		goto unlock;
 	}
 
 	chan->tx_credits += credits;
@@ -5651,7 +5683,9 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
 	if (chan->tx_credits)
 		chan->ops->resume(chan);
 
+unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -6949,6 +6983,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
@@ -7353,7 +7388,7 @@ static struct l2cap_chan *l2cap_global_fixed_chan(struct l2cap_chan *c,
 		if (src_type != c->src_type)
 			continue;
 
-		l2cap_chan_hold(c);
+		c = l2cap_chan_hold_unless_zero(c);
 		read_unlock(&chan_list_lock);
 		return c;
 	}
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index b831825f234f..a08acb54b6b0 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -831,7 +831,7 @@ static void igmp_ifc_event(struct in_device *in_dev)
 	struct net *net = dev_net(in_dev->dev);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev))
 		return;
-	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv);
+	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv));
 	igmp_ifc_start_timer(in_dev, 1);
 }
 
@@ -1013,7 +1013,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		 * received value was zero, use the default or statically
 		 * configured value.
 		 */
-		in_dev->mr_qrv = ih3->qrv ?: net->ipv4.sysctl_igmp_qrv;
+		in_dev->mr_qrv = ih3->qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		in_dev->mr_qi = IGMPV3_QQIC(ih3->qqic)*HZ ?: IGMP_QUERY_INTERVAL;
 
 		/* RFC3376, 8.3. Query Response Interval:
@@ -1192,7 +1192,7 @@ static void igmpv3_add_delrec(struct in_device *in_dev, struct ip_mc_list *im)
 	pmc->interface = im->interface;
 	in_dev_hold(in_dev);
 	pmc->multiaddr = im->multiaddr;
-	pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+	pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 	pmc->sfmode = im->sfmode;
 	if (pmc->sfmode == MCAST_INCLUDE) {
 		struct ip_sf_list *psf;
@@ -1243,9 +1243,11 @@ static void igmpv3_del_delrec(struct in_device *in_dev, struct ip_mc_list *im)
 			swap(im->tomb, pmc->tomb);
 			swap(im->sources, pmc->sources);
 			for (psf = im->sources; psf; psf = psf->sf_next)
-				psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+				psf->sf_crcount = in_dev->mr_qrv ?:
+					READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		} else {
-			im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+			im->crcount = in_dev->mr_qrv ?:
+				READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		}
 		in_dev_put(pmc->interface);
 		kfree_pmc(pmc);
@@ -1347,7 +1349,7 @@ static void igmp_group_added(struct ip_mc_list *im)
 	if (in_dev->dead)
 		return;
 
-	im->unsolicit_count = net->ipv4.sysctl_igmp_qrv;
+	im->unsolicit_count = READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev)) {
 		spin_lock_bh(&im->lock);
 		igmp_start_timer(im, IGMP_INITIAL_REPORT_DELAY);
@@ -1361,7 +1363,7 @@ static void igmp_group_added(struct ip_mc_list *im)
 	 * IN() to IN(A).
 	 */
 	if (im->sfmode == MCAST_EXCLUDE)
-		im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		im->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 
 	igmp_ifc_event(in_dev);
 #endif
@@ -1769,7 +1771,7 @@ static void ip_mc_reset(struct in_device *in_dev)
 
 	in_dev->mr_qi = IGMP_QUERY_INTERVAL;
 	in_dev->mr_qri = IGMP_QUERY_RESPONSE_INTERVAL;
-	in_dev->mr_qrv = net->ipv4.sysctl_igmp_qrv;
+	in_dev->mr_qrv = READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 }
 #else
 static void ip_mc_reset(struct in_device *in_dev)
@@ -1903,7 +1905,7 @@ static int ip_mc_del1_src(struct ip_mc_list *pmc, int sfmode,
 #ifdef CONFIG_IP_MULTICAST
 		if (psf->sf_oldin &&
 		    !IGMP_V1_SEEN(in_dev) && !IGMP_V2_SEEN(in_dev)) {
-			psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+			psf->sf_crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 			psf->sf_next = pmc->tomb;
 			pmc->tomb = psf;
 			rv = 1;
@@ -1967,7 +1969,7 @@ static int ip_mc_del_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 		/* filter mode change */
 		pmc->sfmode = MCAST_INCLUDE;
 #ifdef CONFIG_IP_MULTICAST
-		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
@@ -2146,7 +2148,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 #ifdef CONFIG_IP_MULTICAST
 		/* else no filters; keep old mode for reports */
 
-		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+		pmc->crcount = in_dev->mr_qrv ?: READ_ONCE(net->ipv4.sysctl_igmp_qrv);
 		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7acc0d07f148..768a7daab559 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -706,7 +706,7 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 				int size_goal)
 {
 	return skb->len < size_goal &&
-	       sock_net(sk)->ipv4.sysctl_tcp_autocorking &&
+	       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_autocorking) &&
 	       !tcp_rtx_queue_empty(sk) &&
 	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 26f0994da31b..e1d065ea5a15 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -432,7 +432,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
  */
 void tcp_init_buffer_space(struct sock *sk)
 {
-	int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
+	int tcp_app_win = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_app_win);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 
@@ -2018,7 +2018,7 @@ void tcp_enter_loss(struct sock *sk)
 	 * loss recovery is underway except recurring timeout(s) on
 	 * the same SND.UNA (sec 3.2). Disable F-RTO on path MTU probing
 	 */
-	tp->frto = net->ipv4.sysctl_tcp_frto &&
+	tp->frto = READ_ONCE(net->ipv4.sysctl_tcp_frto) &&
 		   (new_recovery || icsk->icsk_retransmits) &&
 		   !inet_csk(sk)->icsk_mtup.probe_size;
 }
@@ -2903,7 +2903,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 
 static void tcp_update_rtt_min(struct sock *sk, u32 rtt_us, const int flag)
 {
-	u32 wlen = sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen * HZ;
+	u32 wlen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen) * HZ;
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if ((flag & FLAG_ACK_MAYBE_DELAYED) && rtt_us > tcp_min_rtt(tp)) {
@@ -3420,7 +3420,8 @@ static bool __tcp_oow_rate_limited(struct net *net, int mib_idx,
 	if (*last_oow_ack_time) {
 		s32 elapsed = (s32)(tcp_jiffies32 - *last_oow_ack_time);
 
-		if (0 <= elapsed && elapsed < net->ipv4.sysctl_tcp_invalid_ratelimit) {
+		if (0 <= elapsed &&
+		    elapsed < READ_ONCE(net->ipv4.sysctl_tcp_invalid_ratelimit)) {
 			NET_INC_STATS(net, mib_idx);
 			return true;	/* rate-limited: don't send yet! */
 		}
@@ -3468,7 +3469,7 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
 	if (now != challenge_timestamp) {
-		u32 ack_limit = net->ipv4.sysctl_tcp_challenge_ack_limit;
+		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
 		challenge_timestamp = now;
@@ -4197,7 +4198,7 @@ static void tcp_dsack_set(struct sock *sk, u32 seq, u32 end_seq)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+	if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 		int mib_idx;
 
 		if (before(seq, tp->rcv_nxt))
@@ -4232,7 +4233,7 @@ static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 
-		if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+		if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 			u32 end_seq = TCP_SKB_CB(skb)->end_seq;
 
 			if (after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))
@@ -5238,7 +5239,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	}
 
 	if (!tcp_is_sack(tp) ||
-	    tp->compressed_ack >= sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr)
+	    tp->compressed_ack >= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr))
 		goto send_now;
 
 	if (tp->compressed_ack_rcv_nxt != tp->rcv_nxt) {
@@ -5261,7 +5262,8 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	if (tp->srtt_us && tp->srtt_us < rtt)
 		rtt = tp->srtt_us;
 
-	delay = min_t(unsigned long, sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns,
+	delay = min_t(unsigned long,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
 	hrtimer_start(&tp->compressed_ack_timer, ns_to_ktime(delay),
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 61843c6d7a47..4960e2b6bd7f 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -329,7 +329,7 @@ void tcp_update_metrics(struct sock *sk)
 	int m;
 
 	sk_dst_confirm(sk);
-	if (net->ipv4.sysctl_tcp_nometrics_save || !dst)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_nometrics_save) || !dst)
 		return;
 
 	rcu_read_lock();
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 13d9e8570ce5..3090b61e4edd 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1745,7 +1745,7 @@ static u32 tcp_tso_segs(struct sock *sk, unsigned int mss_now)
 
 	min_tso = ca_ops->min_tso_segs ?
 			ca_ops->min_tso_segs(sk) :
-			sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs;
+			READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs);
 
 	tso_segs = tcp_tso_autosize(sk, mss_now, min_tso);
 	return min_t(u32, tso_segs, sk->sk_gso_max_segs);
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 5c9be8594483..23ae01715e7b 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -27,6 +27,11 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
+static void ping_v6_destroy(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -170,6 +175,7 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
+	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a5aff2834bd6..cd496b074a71 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -850,11 +850,16 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 }
 
 static int
-nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
+nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
 	struct sk_buff *nskb;
 
 	if (diff < 0) {
+		unsigned int min_len = skb_transport_offset(e->skb);
+
+		if (data_len < min_len)
+			return -EINVAL;
+
 		if (pskb_trim(e->skb, data_len))
 			return -ENOMEM;
 	} else if (diff > 0) {
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index a6c04a94b08f..3a5c0d00e96c 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -178,7 +178,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 		if (!SCTP_SO(&asoc->stream, i)->ext)
 			continue;
 
-		ret = n->init_sid(&asoc->stream, i, GFP_KERNEL);
+		ret = n->init_sid(&asoc->stream, i, GFP_ATOMIC);
 		if (ret)
 			goto err;
 	}
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 166c621e0223..bd33d6613929 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -201,6 +201,33 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	return NULL;
 }
 
+static int elf_read_program_header(Elf *elf, u64 vaddr, GElf_Phdr *phdr)
+{
+	size_t i, phdrnum;
+	u64 sz;
+
+	if (elf_getphdrnum(elf, &phdrnum))
+		return -1;
+
+	for (i = 0; i < phdrnum; i++) {
+		if (gelf_getphdr(elf, i, phdr) == NULL)
+			return -1;
+
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		sz = max(phdr->p_memsz, phdr->p_filesz);
+		if (!sz)
+			continue;
+
+		if (vaddr >= phdr->p_vaddr && (vaddr < phdr->p_vaddr + sz))
+			return 0;
+	}
+
+	/* Not found any valid program header */
+	return -1;
+}
+
 static bool want_demangle(bool is_kernel_sym)
 {
 	return is_kernel_sym ? symbol_conf.demangle_kernel : symbol_conf.demangle;
@@ -1063,6 +1090,7 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 					sym.st_value);
 			used_opd = true;
 		}
+
 		/*
 		 * When loading symbols in a data mapping, ABS symbols (which
 		 * has a value of SHN_ABS in its st_shndx) failed at
@@ -1099,11 +1127,20 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 				goto out_elf_end;
 		} else if ((used_opd && runtime_ss->adjust_symbols) ||
 			   (!used_opd && syms_ss->adjust_symbols)) {
+			GElf_Phdr phdr;
+
+			if (elf_read_program_header(syms_ss->elf,
+						    (u64)sym.st_value, &phdr)) {
+				pr_warning("%s: failed to find program header for "
+					   "symbol: %s st_value: %#" PRIx64 "\n",
+					   __func__, elf_name, (u64)sym.st_value);
+				continue;
+			}
 			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
-				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
-				  (u64)sym.st_value, (u64)shdr.sh_addr,
-				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+				  "p_vaddr: %#" PRIx64 " p_offset: %#" PRIx64 "\n",
+				  __func__, (u64)sym.st_value, (u64)phdr.p_vaddr,
+				  (u64)phdr.p_offset);
+			sym.st_value -= phdr.p_vaddr - phdr.p_offset;
 		}
 
 		demangled = demangle_sym(dso, kmodule, elf_name);

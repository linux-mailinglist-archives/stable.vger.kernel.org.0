Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C015E5F539D
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJELhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiJELgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:36:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35592AE7A;
        Wed,  5 Oct 2022 04:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A06B7B81DB6;
        Wed,  5 Oct 2022 11:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B6FC433C1;
        Wed,  5 Oct 2022 11:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969649;
        bh=B4sZEX166mWT5BaNYP1vbS3IZSZpdO5+//a7udEGz5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkXnbzrHcI0ogCsb3HhjXYCbyV3bhhgA0nkbkDkB8lyHsba1h8zQsVOdGeEEHclZF
         jEfJmxbzbmGLX+T7FdEvwjpzHAMhLidZ4qv4KzCJs2ZLixsnymyyvbU3o1HAcPcwjg
         bqv8ElF3VrFHNDQg696a1Hy8c36EDXZsHb4rK1U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 37/51] x86/speculation: Add RSB VM Exit protections
Date:   Wed,  5 Oct 2022 13:32:25 +0200
Message-Id: <20221005113212.024639083@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
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

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

commit 2b1299322016731d56807aa49254a5ea3080b6b3 upstream.

tl;dr: The Enhanced IBRS mitigation for Spectre v2 does not work as
documented for RET instructions after VM exits. Mitigate it with a new
one-entry RSB stuffing mechanism and a new LFENCE.

== Background ==

Indirect Branch Restricted Speculation (IBRS) was designed to help
mitigate Branch Target Injection and Speculative Store Bypass, i.e.
Spectre, attacks. IBRS prevents software run in less privileged modes
from affecting branch prediction in more privileged modes. IBRS requires
the MSR to be written on every privilege level change.

To overcome some of the performance issues of IBRS, Enhanced IBRS was
introduced.  eIBRS is an "always on" IBRS, in other words, just turn
it on once instead of writing the MSR on every privilege level change.
When eIBRS is enabled, more privileged modes should be protected from
less privileged modes, including protecting VMMs from guests.

== Problem ==

Here's a simplification of how guests are run on Linux' KVM:

void run_kvm_guest(void)
{
	// Prepare to run guest
	VMRESUME();
	// Clean up after guest runs
}

The execution flow for that would look something like this to the
processor:

1. Host-side: call run_kvm_guest()
2. Host-side: VMRESUME
3. Guest runs, does "CALL guest_function"
4. VM exit, host runs again
5. Host might make some "cleanup" function calls
6. Host-side: RET from run_kvm_guest()

Now, when back on the host, there are a couple of possible scenarios of
post-guest activity the host needs to do before executing host code:

* on pre-eIBRS hardware (legacy IBRS, or nothing at all), the RSB is not
touched and Linux has to do a 32-entry stuffing.

* on eIBRS hardware, VM exit with IBRS enabled, or restoring the host
IBRS=1 shortly after VM exit, has a documented side effect of flushing
the RSB except in this PBRSB situation where the software needs to stuff
the last RSB entry "by hand".

IOW, with eIBRS supported, host RET instructions should no longer be
influenced by guest behavior after the host retires a single CALL
instruction.

However, if the RET instructions are "unbalanced" with CALLs after a VM
exit as is the RET in #6, it might speculatively use the address for the
instruction after the CALL in #3 as an RSB prediction. This is a problem
since the (untrusted) guest controls this address.

Balanced CALL/RET instruction pairs such as in step #5 are not affected.

== Solution ==

The PBRSB issue affects a wide variety of Intel processors which
support eIBRS. But not all of them need mitigation. Today,
X86_FEATURE_RSB_VMEXIT triggers an RSB filling sequence that mitigates
PBRSB. Systems setting RSB_VMEXIT need no further mitigation - i.e.,
eIBRS systems which enable legacy IBRS explicitly.

However, such systems (X86_FEATURE_IBRS_ENHANCED) do not set RSB_VMEXIT
and most of them need a new mitigation.

Therefore, introduce a new feature flag X86_FEATURE_RSB_VMEXIT_LITE
which triggers a lighter-weight PBRSB mitigation versus RSB_VMEXIT.

The lighter-weight mitigation performs a CALL instruction which is
immediately followed by a speculative execution barrier (INT3). This
steers speculative execution to the barrier -- just like a retpoline
-- which ensures that speculation can never reach an unbalanced RET.
Then, ensure this CALL is retired before continuing execution with an
LFENCE.

In other words, the window of exposure is opened at VM exit where RET
behavior is troublesome. While the window is open, force RSB predictions
sampling for RET targets to a dead end at the INT3. Close the window
with the LFENCE.

There is a subset of eIBRS systems which are not vulnerable to PBRSB.
Add these systems to the cpu_vuln_whitelist[] as NO_EIBRS_PBRSB.
Future systems that aren't vulnerable will set ARCH_CAP_PBRSB_NO.

  [ bp: Massage, incorporate review comments from Andy Cooper. ]

Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Co-developed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: no intra-function validation]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |    8 ++
 arch/x86/include/asm/cpufeatures.h            |    2 
 arch/x86/include/asm/msr-index.h              |    4 +
 arch/x86/include/asm/nospec-branch.h          |   16 ++++
 arch/x86/kernel/cpu/bugs.c                    |   86 +++++++++++++++++++-------
 arch/x86/kernel/cpu/common.c                  |   12 +++
 arch/x86/kvm/vmx/vmenter.S                    |    8 +-
 tools/arch/x86/include/asm/cpufeatures.h      |    1 
 8 files changed, 108 insertions(+), 29 deletions(-)

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
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -289,6 +289,7 @@
 #define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
@@ -411,6 +412,7 @@
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(28) /* CPU is too old and its MMIO Stale Data status is unknown */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -139,6 +139,10 @@
 						 * are restricted to targets in
 						 * kernel.
 						 */
+#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
+						 * Not susceptible to Post-Barrier
+						 * Return Stack Buffer Predictions.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -151,13 +151,27 @@
 #endif
 .endm
 
+.macro ISSUE_UNBALANCED_RET_GUARD
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
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1198,6 +1198,53 @@ static void __init spec_ctrl_disable_ker
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
@@ -1347,28 +1394,7 @@ static void __init spectre_v2_select_mit
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
@@ -2108,6 +2134,19 @@ static char *ibpb_state(void)
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
@@ -2120,12 +2159,13 @@ static ssize_t spectre_v2_show_state(cha
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
 
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1025,6 +1025,7 @@ static void identify_cpu_without_cpuid(s
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_SPECTRE_V2		BIT(8)
+#define NO_EIBRS_PBRSB		BIT(9)
 #define NO_MMIO			BIT(10)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
@@ -1071,7 +1072,7 @@ static const __initconst struct x86_cpu_
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1081,7 +1082,9 @@ static const __initconst struct x86_cpu_
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -1265,6 +1268,11 @@ static void __init cpu_set_bug_bits(stru
 			setup_force_cpu_bug(X86_BUG_RETBLEED);
 	}
 
+	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
+	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -185,11 +185,13 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL
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
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -284,6 +284,7 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM-Exit when EIBRS is enabled */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */



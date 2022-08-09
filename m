Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBCF58DDDE
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344863AbiHISHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344730AbiHISG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A03286C5;
        Tue,  9 Aug 2022 11:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47C3261009;
        Tue,  9 Aug 2022 18:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B032FC43140;
        Tue,  9 Aug 2022 18:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068170;
        bh=8q69jngKFZcGJS7RtYrpA7h5Zupf4kN/O/KyQXbdxdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNIyY6CrjZf17DnIXXLPhgO/TMgvAjTXNCO9W/zcqdXwAHKiGzrhnd4IRCUlngzsG
         vSnh06lEtPFQ6bOijj4KgaQpg79NbcpNVkbbVceuw+wtolQQLxV+sLIvNjVgYWiBN9
         zhnF0QW+Bq9vR8ubgiHShIpdwUkn6dxUWBVKZ0z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.19 31/32] x86/speculation: Add RSB VM Exit protections
Date:   Tue,  9 Aug 2022 20:00:22 +0200
Message-Id: <20220809175514.060533908@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
X86_FEATURE_RETPOLINE triggers an RSB filling sequence that mitigates
PBRSB. Systems setting RETPOLINE need no further mitigation - i.e.,
eIBRS systems which enable retpoline explicitly.

However, such systems (X86_FEATURE_IBRS_ENHANCED) do not set RETPOLINE
and most of them need a new mitigation.

Therefore, introduce a new feature flag X86_FEATURE_RSB_VMEXIT_LITE
which triggers a lighter-weight PBRSB mitigation versus RSB Filling at
vmexit.

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
  [ Pawan: Update commit message to replace RSB_VMEXIT with RETPOLINE ]

Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Co-developed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |    8 +++
 arch/x86/include/asm/cpufeatures.h            |    2 
 arch/x86/include/asm/msr-index.h              |    4 +
 arch/x86/include/asm/nospec-branch.h          |   15 ++++++
 arch/x86/kernel/cpu/bugs.c                    |   61 +++++++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c                  |   12 ++++-
 arch/x86/kvm/vmx.c                            |    6 +-
 7 files changed, 102 insertions(+), 6 deletions(-)

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
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -54,6 +54,14 @@
 	jnz	771b;				\
 	add	$(BITS_PER_LONG/8) * nr, sp;
 
+/* Sequence to mitigate PBRSB on eIBRS CPUs */
+#define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
+	call	881f;				\
+	int3;					\
+881:						\
+	add	$(BITS_PER_LONG/8), sp;		\
+	lfence;
+
 #ifdef __ASSEMBLY__
 
 /*
@@ -269,6 +277,13 @@ static inline void vmexit_fill_RSB(void)
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
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1043,6 +1043,49 @@ static enum spectre_v2_mitigation __init
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
@@ -1135,6 +1178,8 @@ static void __init spectre_v2_select_mit
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
@@ -1879,12 +1937,13 @@ static ssize_t spectre_v2_show_state(cha
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
@@ -954,6 +954,7 @@ static void identify_cpu_without_cpuid(s
 #define MSBDS_ONLY		BIT(5)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
+#define NO_EIBRS_PBRSB		BIT(8)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -990,7 +991,7 @@ static const __initconst struct x86_cpu_
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1000,7 +1001,9 @@ static const __initconst struct x86_cpu_
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
@@ -1154,6 +1157,11 @@ static void __init cpu_set_bug_bits(stru
 	    !arch_cap_mmio_immune(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
 
+	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
+	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10988,6 +10988,9 @@ static void __noclone vmx_vcpu_run(struc
 #endif
 	      );
 
+	/* Eliminate branch target predictions from guest mode */
+	vmexit_fill_RSB();
+
 	vmx_enable_fb_clear(vmx);
 
 	/*
@@ -11010,9 +11013,6 @@ static void __noclone vmx_vcpu_run(struc
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
-
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=



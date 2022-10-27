Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC3C6103DD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbiJ0VDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiJ0VDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:03:12 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CDB9E2E2;
        Thu, 27 Oct 2022 13:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666904177; x=1698440177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=EUyKiQIE8FmQPBJP3R3vAaz+3ZR+RCTp73pYfLbEbNs=;
  b=T3ft8AxUuYY5i0NzwWQxNi1+PpKJIVA/ZseJlEQj1K+XEIHSaZain8qj
   Zj/TXiDAUeICP22Ae4xllWzgO6nAP//nnIt2Ke6/GfHnlAtJ3PIX9fWY5
   qlOpFTbKvMJktn4RupUYVsSmq8u4Vl5BTca5O6PaWXmhZ/4umLvuMfgPQ
   s=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 20:56:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id AE7D7417EE;
        Thu, 27 Oct 2022 20:56:13 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 27 Oct 2022 20:56:13 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.223) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Thu, 27 Oct 2022 20:56:12 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <surajjs@amazon.com>, <sjitindarsingh@gmail.com>,
        <cascardo@canonical.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <jpoimboe@kernel.org>,
        <peterz@infradead.org>, <x86@kernel.org>
Subject: [PATCH 4.14 34/34] x86/speculation: Add RSB VM Exit protections
Date:   Thu, 27 Oct 2022 13:56:04 -0700
Message-ID: <20221027205604.18039-2-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221027205604.18039-1-surajjs@amazon.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
 <20221027205604.18039-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D37UWC003.ant.amazon.com (10.43.162.183) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-12.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham
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
[ bp: Adjust patch to account for kvm entry being in c ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |  8 ++
 arch/x86/include/asm/cpufeatures.h            |  2 +
 arch/x86/include/asm/msr-index.h              |  4 +
 arch/x86/include/asm/nospec-branch.h          | 15 +++-
 arch/x86/kernel/cpu/bugs.c                    | 87 ++++++++++++++-----
 arch/x86/kernel/cpu/common.c                  | 12 ++-
 arch/x86/kvm/vmx.c                            |  4 +-
 tools/arch/x86/include/asm/cpufeatures.h      |  1 +
 8 files changed, 103 insertions(+), 30 deletions(-)

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
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dcb37f07874d..840d8981567e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -291,6 +291,7 @@
 #define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
@@ -405,5 +406,6 @@
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
 #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a1a0b90293aa..92c6054f0a00 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -130,6 +130,10 @@
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
index 0c71e0b0dc6f..118441f53399 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -59,6 +59,13 @@
 	/* barrier for jnz misprediction */	\
 	lfence;
 
+#define ISSUE_UNBALANCED_RET_GUARD(sp)		\
+	call 992f;				\
+	int3;					\
+992:						\
+	add $(BITS_PER_LONG/8), sp;		\
+	lfence;
+
 #ifdef __ASSEMBLY__
 
 /*
@@ -263,9 +270,11 @@ static __always_inline void vmexit_fill_RSB(void)
 	unsigned long loops;
 
 	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
-		      ALTERNATIVE("jmp 910f",
-				  __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1)),
-				  X86_FEATURE_RSB_VMEXIT)
+		      ALTERNATIVE_2("jmp 910f", "", X86_FEATURE_RSB_VMEXIT,
+				    "jmp 911f", X86_FEATURE_RSB_VMEXIT_LITE)
+		      __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1))
+		      "911:"
+		      __stringify(ISSUE_UNBALANCED_RET_GUARD(%1))
 		      "910:"
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0af5e4d6b806..05dcdb419abd 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1196,6 +1196,54 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
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
+		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB) &&
+		    (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)) {
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
@@ -1345,28 +1393,7 @@ static void __init spectre_v2_select_mitigation(void)
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
@@ -2094,6 +2121,19 @@ static char *ibpb_state(void)
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
@@ -2106,12 +2146,13 @@ static ssize_t spectre_v2_show_state(char *buf)
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
index 4cbbe266a2b2..2ad6d3b02a38 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -906,6 +906,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_MMIO			BIT(8)
+#define NO_EIBRS_PBRSB		BIT(9)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -947,7 +948,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -957,7 +958,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -1129,6 +1132,11 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_RETBLEED);
 	}
 
+	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
+	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d6ae5237fc38..aea4c497da3f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10001,8 +10001,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * entries and (in some cases) RSB underflow.
 	 *
 	 * eIBRS has its own protection against poisoned RSB, so it doesn't
-	 * need the RSB filling sequence.  But it does need to be enabled
-	 * before the first unbalanced RET.
+	 * need the RSB filling sequence.  But it does need to be enabled, and a
+	 * single call to retire, before the first unbalanced RET.
 	 *
 	 * So no RETs before vmx_spec_ctrl_restore_host() below.
 	 */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index bb5861adb5a0..8fd46c879348 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -270,6 +270,7 @@
 
 /* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:0 (EDX), word 11 */
 #define X86_FEATURE_CQM_LLC		(11*32+ 1) /* LLC QoS if 1 */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM-Exit when EIBRS is enabled */
 
 /* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:1 (EDX), word 12 */
 #define X86_FEATURE_CQM_OCCUP_LLC	(12*32+ 0) /* LLC occupancy monitoring */
-- 
2.17.1


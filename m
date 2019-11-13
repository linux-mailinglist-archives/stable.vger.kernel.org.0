Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B09F9E7E
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKLXvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:51:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57296 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbfKLXuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:35 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvd-0008I4-5d; Tue, 12 Nov 2019 23:50:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00056o-HF; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Borislav Petkov" <bp@suse.de>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>
Date:   Tue, 12 Nov 2019 23:48:03 +0000
Message-ID: <lsq.1573602477.356392985@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 06/25] x86/speculation/taa: Add mitigation for TSX
 Async Abort
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 1b42f017415b46c317e71d41c34ec088417a1883 upstream.

TSX Async Abort (TAA) is a side channel vulnerability to the internal
buffers in some Intel processors similar to Microachitectural Data
Sampling (MDS). In this case, certain loads may speculatively pass
invalid data to dependent operations when an asynchronous abort
condition is pending in a TSX transaction.

This includes loads with no fault or assist condition. Such loads may
speculatively expose stale data from the uarch data structures as in
MDS. Scope of exposure is within the same-thread and cross-thread. This
issue affects all current processors that support TSX, but do not have
ARCH_CAP_TAA_NO (bit 8) set in MSR_IA32_ARCH_CAPABILITIES.

On CPUs which have their IA32_ARCH_CAPABILITIES MSR bit MDS_NO=0,
CPUID.MD_CLEAR=1 and the MDS mitigation is clearing the CPU buffers
using VERW or L1D_FLUSH, there is no additional mitigation needed for
TAA. On affected CPUs with MDS_NO=1 this issue can be mitigated by
disabling the Transactional Synchronization Extensions (TSX) feature.

A new MSR IA32_TSX_CTRL in future and current processors after a
microcode update can be used to control the TSX feature. There are two
bits in that MSR:

* TSX_CTRL_RTM_DISABLE disables the TSX sub-feature Restricted
Transactional Memory (RTM).

* TSX_CTRL_CPUID_CLEAR clears the RTM enumeration in CPUID. The other
TSX sub-feature, Hardware Lock Elision (HLE), is unconditionally
disabled with updated microcode but still enumerated as present by
CPUID(EAX=7).EBX{bit4}.

The second mitigation approach is similar to MDS which is clearing the
affected CPU buffers on return to user space and when entering a guest.
Relevant microcode update is required for the mitigation to work.  More
details on this approach can be found here:

  https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html

The TSX feature can be controlled by the "tsx" command line parameter.
If it is force-enabled then "Clear CPU buffers" (MDS mitigation) is
deployed. The effective mitigation state can be read from sysfs.

 [ bp:
   - massage + comments cleanup
   - s/TAA_MITIGATION_TSX_DISABLE/TAA_MITIGATION_TSX_DISABLED/g - Josh.
   - remove partial TAA mitigation in update_mds_branch_idle() - Josh.
   - s/tsx_async_abort_cmdline/tsx_async_abort_parse_cmdline/g
 ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 3.16:
 - Use next available X86_BUG bit
 - Don't use BIT() in msr-index.h because it's a UAPI header
 - Add #include "cpu.h" in bugs.c
 - Drop __ro_after_init attribute
 - Drop "nosmt" support
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeatures.h    |   1 +
 arch/x86/include/asm/nospec-branch.h  |   4 +-
 arch/x86/include/asm/processor.h      |   7 ++
 arch/x86/include/uapi/asm/msr-index.h |   4 +
 arch/x86/kernel/cpu/bugs.c            | 103 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c          |  15 ++++
 6 files changed, 132 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -279,5 +279,6 @@
 #define X86_BUG_MDS		X86_BUG(10) /* CPU is affected by Microarchitectural data sampling */
 #define X86_BUG_MSBDS_ONLY	X86_BUG(11) /* CPU is only affected by the  MSDBS variant of BUG_MDS */
 #define X86_BUG_SWAPGS		X86_BUG(12) /* CPU is affected by speculation through SWAPGS */
+#define X86_BUG_TAA		X86_BUG(13) /* CPU is affected by TSX Async Abort(TAA) */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -268,7 +268,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear)
 #include <asm/segment.h>
 
 /**
- * mds_clear_cpu_buffers - Mitigation for MDS vulnerability
+ * mds_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
  *
  * This uses the otherwise unused and obsolete VERW instruction in
  * combination with microcode which triggers a CPU buffer flush when the
@@ -291,7 +291,7 @@ static inline void mds_clear_cpu_buffers
 }
 
 /**
- * mds_user_clear_cpu_buffers - Mitigation for MDS vulnerability
+ * mds_user_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
  *
  * Clear CPU buffers if the corresponding static key is enabled
  */
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -960,4 +960,11 @@ enum mds_mitigations {
 	MDS_MITIGATION_VMWERV,
 };
 
+enum taa_mitigations {
+	TAA_MITIGATION_OFF,
+	TAA_MITIGATION_UCODE_NEEDED,
+	TAA_MITIGATION_VERW,
+	TAA_MITIGATION_TSX_DISABLED,
+};
+
 #endif /* _ASM_X86_PROCESSOR_H */
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -71,6 +71,10 @@
 						    * Sampling (MDS) vulnerabilities.
 						    */
 #define ARCH_CAP_TSX_CTRL_MSR		(1UL << 7) /* MSR for TSX control is available. */
+#define ARCH_CAP_TAA_NO			(1UL << 8) /*
+						   * Not susceptible to
+						   * TSX Async Abort (TAA) vulnerabilities.
+						   */
 
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -30,11 +30,14 @@
 #include <asm/intel-family.h>
 #include <asm/e820.h>
 
+#include "cpu.h"
+
 static void __init spectre_v1_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
+static void __init taa_select_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR that always has to be preserved. */
 u64 x86_spec_ctrl_base;
@@ -155,6 +158,7 @@ void __init check_bugs(void)
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
 	mds_select_mitigation();
+	taa_select_mitigation();
 
 	arch_smt_update();
 
@@ -313,6 +317,93 @@ static int __init mds_cmdline(char *str)
 early_param("mds", mds_cmdline);
 
 #undef pr_fmt
+#define pr_fmt(fmt)	"TAA: " fmt
+
+/* Default mitigation for TAA-affected CPUs */
+static enum taa_mitigations taa_mitigation = TAA_MITIGATION_VERW;
+
+static const char * const taa_strings[] = {
+	[TAA_MITIGATION_OFF]		= "Vulnerable",
+	[TAA_MITIGATION_UCODE_NEEDED]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
+	[TAA_MITIGATION_VERW]		= "Mitigation: Clear CPU buffers",
+	[TAA_MITIGATION_TSX_DISABLED]	= "Mitigation: TSX disabled",
+};
+
+static void __init taa_select_mitigation(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has_bug(X86_BUG_TAA)) {
+		taa_mitigation = TAA_MITIGATION_OFF;
+		return;
+	}
+
+	/* TSX previously disabled by tsx=off */
+	if (!boot_cpu_has(X86_FEATURE_RTM)) {
+		taa_mitigation = TAA_MITIGATION_TSX_DISABLED;
+		goto out;
+	}
+
+	if (cpu_mitigations_off()) {
+		taa_mitigation = TAA_MITIGATION_OFF;
+		return;
+	}
+
+	/* TAA mitigation is turned off on the cmdline (tsx_async_abort=off) */
+	if (taa_mitigation == TAA_MITIGATION_OFF)
+		goto out;
+
+	if (boot_cpu_has(X86_FEATURE_MD_CLEAR))
+		taa_mitigation = TAA_MITIGATION_VERW;
+	else
+		taa_mitigation = TAA_MITIGATION_UCODE_NEEDED;
+
+	/*
+	 * VERW doesn't clear the CPU buffers when MD_CLEAR=1 and MDS_NO=1.
+	 * A microcode update fixes this behavior to clear CPU buffers. It also
+	 * adds support for MSR_IA32_TSX_CTRL which is enumerated by the
+	 * ARCH_CAP_TSX_CTRL_MSR bit.
+	 *
+	 * On MDS_NO=1 CPUs if ARCH_CAP_TSX_CTRL_MSR is not set, microcode
+	 * update is required.
+	 */
+	ia32_cap = x86_read_arch_cap_msr();
+	if ( (ia32_cap & ARCH_CAP_MDS_NO) &&
+	    !(ia32_cap & ARCH_CAP_TSX_CTRL_MSR))
+		taa_mitigation = TAA_MITIGATION_UCODE_NEEDED;
+
+	/*
+	 * TSX is enabled, select alternate mitigation for TAA which is
+	 * the same as MDS. Enable MDS static branch to clear CPU buffers.
+	 *
+	 * For guests that can't determine whether the correct microcode is
+	 * present on host, enable the mitigation for UCODE_NEEDED as well.
+	 */
+	static_branch_enable(&mds_user_clear);
+
+out:
+	pr_info("%s\n", taa_strings[taa_mitigation]);
+}
+
+static int __init tsx_async_abort_parse_cmdline(char *str)
+{
+	if (!boot_cpu_has_bug(X86_BUG_TAA))
+		return 0;
+
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off")) {
+		taa_mitigation = TAA_MITIGATION_OFF;
+	} else if (!strcmp(str, "full")) {
+		taa_mitigation = TAA_MITIGATION_VERW;
+	}
+
+	return 0;
+}
+early_param("tsx_async_abort", tsx_async_abort_parse_cmdline);
+
+#undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V1 : " fmt
 
 enum spectre_v1_mitigation {
@@ -824,6 +915,7 @@ static void update_mds_branch_idle(void)
 }
 
 #define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.\n"
+#define TAA_MSG_SMT "TAA CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html for more details.\n"
 
 void arch_smt_update(void)
 {
@@ -856,6 +948,17 @@ void arch_smt_update(void)
 		break;
 	}
 
+	switch (taa_mitigation) {
+	case TAA_MITIGATION_VERW:
+	case TAA_MITIGATION_UCODE_NEEDED:
+		if (sched_smt_active())
+			pr_warn_once(TAA_MSG_SMT);
+		break;
+	case TAA_MITIGATION_TSX_DISABLED:
+	case TAA_MITIGATION_OFF:
+		break;
+	}
+
 	mutex_unlock(&spec_ctrl_mutex);
 }
 
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -914,6 +914,21 @@ static void __init cpu_set_bug_bits(stru
 	if (!cpu_matches(NO_SWAPGS))
 		setup_force_cpu_bug(X86_BUG_SWAPGS);
 
+	/*
+	 * When the CPU is not mitigated for TAA (TAA_NO=0) set TAA bug when:
+	 *	- TSX is supported or
+	 *	- TSX_CTRL is present
+	 *
+	 * TSX_CTRL check is needed for cases when TSX could be disabled before
+	 * the kernel boot e.g. kexec.
+	 * TSX_CTRL check alone is not sufficient for cases when the microcode
+	 * update is not present or running as guest that don't get TSX_CTRL.
+	 */
+	if (!(ia32_cap & ARCH_CAP_TAA_NO) &&
+	    (cpu_has(c, X86_FEATURE_RTM) ||
+	     (ia32_cap & ARCH_CAP_TSX_CTRL_MSR)))
+		setup_force_cpu_bug(X86_BUG_TAA);
+
 	if (cpu_matches(NO_MELTDOWN))
 		return;
 


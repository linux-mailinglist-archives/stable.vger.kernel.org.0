Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6E21F4618
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgFISXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730540AbgFIRrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3D4207F9;
        Tue,  9 Jun 2020 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724825;
        bh=vkHf7FI0b6bdGX/OWeOhR5ZGYTHqccWzpnHhhe8ZyBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZyOwvrw9ZY+Vumy2zX13H5GBoU60hoCNIQcGc2ziSX9FWt97goQQAn0GEvbxlF2Y
         gatzXAYygHnk50mvWS1PsJUCIpZx56BnHXFRVmyvmQdJuOAhek2zZpZtuc+KNRNje0
         vl1shmuFMIbTVq/EfKlKLE3LPBP22HKQLvqGsUgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Neelima Krishnan <neelima.krishnan@intel.com>
Subject: [PATCH 4.4 32/36] x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation
Date:   Tue,  9 Jun 2020 19:44:32 +0200
Message-Id: <20200609173935.543234250@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609173933.288044334@linuxfoundation.org>
References: <20200609173933.288044334@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Gross <mgross@linux.intel.com>

commit 7e5b3c267d256822407a22fdce6afdf9cd13f9fb upstream

SRBDS is an MDS-like speculative side channel that can leak bits from the
random number generator (RNG) across cores and threads. New microcode
serializes the processor access during the execution of RDRAND and
RDSEED. This ensures that the shared buffer is overwritten before it is
released for reuse.

While it is present on all affected CPU models, the microcode mitigation
is not needed on models that enumerate ARCH_CAPABILITIES[MDS_NO] in the
cases where TSX is not supported or has been disabled with TSX_CTRL.

The mitigation is activated by default on affected processors and it
increases latency for RDRAND and RDSEED instructions. Among other
effects this will reduce throughput from /dev/urandom.

* Enable administrator to configure the mitigation off when desired using
  either mitigations=off or srbds=off.

* Export vulnerability status via sysfs

* Rename file-scoped macros to apply for non-whitelist table initializations.

 [ bp: Massage,
   - s/VULNBL_INTEL_STEPPING/VULNBL_INTEL_STEPPINGS/g,
   - do not read arch cap MSR a second time in tsx_fused_off() - just pass it in,
   - flip check in cpu_set_bug_bits() to save an indentation level,
   - reflow comments.
   jpoimboe: s/Mitigated/Mitigation/ in user-visible strings
   tglx: Dropped the fused off magic for now
 ]

Signed-off-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 
 Documentation/kernel-parameters.txt                |   20 +++
 arch/x86/include/asm/cpufeatures.h                 |    2 
 arch/x86/include/asm/msr-index.h                   |    4 
 arch/x86/kernel/cpu/bugs.c                         |  106 +++++++++++++++++++++
 arch/x86/kernel/cpu/common.c                       |   31 ++++++
 arch/x86/kernel/cpu/cpu.h                          |    1 
 drivers/base/cpu.c                                 |    8 +
 8 files changed, 173 insertions(+)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -279,6 +279,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/spec_store_bypass
 		/sys/devices/system/cpu/vulnerabilities/l1tf
 		/sys/devices/system/cpu/vulnerabilities/mds
+		/sys/devices/system/cpu/vulnerabilities/srbds
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
 		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 Date:		January 2018
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3787,6 +3787,26 @@ bytes respectively. Such letter suffixes
 	spia_pedr=
 	spia_peddr=
 
+	srbds=		[X86,INTEL]
+			Control the Special Register Buffer Data Sampling
+			(SRBDS) mitigation.
+
+			Certain CPUs are vulnerable to an MDS-like
+			exploit which can leak bits from the random
+			number generator.
+
+			By default, this issue is mitigated by
+			microcode.  However, the microcode fix can cause
+			the RDRAND and RDSEED instructions to become
+			much slower.  Among other effects, this will
+			result in reduced throughput from /dev/urandom.
+
+			The microcode mitigation can be disabled with
+			the following option:
+
+			off:    Disable mitigation and remove
+				performance impact to RDRAND and RDSEED
+
 	stack_guard_gap=	[MM]
 			override the default stack gap protection. The value
 			is in page units and it defines how many pages prior
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -312,6 +312,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 18 */
 #define X86_FEATURE_AVX512_4VNNIW	(18*32+ 2) /* AVX-512 Neural Network Instructions */
 #define X86_FEATURE_AVX512_4FMAPS	(18*32+ 3) /* AVX-512 Multiply Accumulation Single precision */
+#define X86_FEATURE_SRBDS_CTRL		(18*32+ 9) /* "" SRBDS mitigation MSR available */
 #define X86_FEATURE_MD_CLEAR		(18*32+10) /* VERW clears CPU buffers */
 #define X86_FEATURE_SPEC_CTRL		(18*32+26) /* "" Speculation Control (IBRS + IBPB) */
 #define X86_FEATURE_INTEL_STIBP		(18*32+27) /* "" Single Thread Indirect Branch Predictors */
@@ -343,5 +344,6 @@
 #define X86_BUG_SWAPGS		X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
 #define X86_BUG_TAA		X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
 #define X86_BUG_ITLB_MULTIHIT	X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
+#define X86_BUG_SRBDS		X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -91,6 +91,10 @@
 #define TSX_CTRL_RTM_DISABLE		BIT(0)	/* Disable RTM feature */
 #define TSX_CTRL_CPUID_CLEAR		BIT(1)	/* Disable TSX enumeration */
 
+/* SRBDS support */
+#define MSR_IA32_MCU_OPT_CTRL		0x00000123
+#define RNGDS_MITG_DIS			BIT(0)
+
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
 #define MSR_IA32_SYSENTER_EIP		0x00000176
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -39,6 +39,7 @@ static void __init l1tf_select_mitigatio
 static void __init mds_select_mitigation(void);
 static void __init mds_print_mitigation(void);
 static void __init taa_select_mitigation(void);
+static void __init srbds_select_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR that always has to be preserved. */
 u64 x86_spec_ctrl_base;
@@ -99,6 +100,7 @@ void __init check_bugs(void)
 	l1tf_select_mitigation();
 	mds_select_mitigation();
 	taa_select_mitigation();
+	srbds_select_mitigation();
 
 	/*
 	 * As MDS and TAA mitigations are inter-related, print MDS
@@ -369,6 +371,97 @@ static int __init tsx_async_abort_parse_
 early_param("tsx_async_abort", tsx_async_abort_parse_cmdline);
 
 #undef pr_fmt
+#define pr_fmt(fmt)	"SRBDS: " fmt
+
+enum srbds_mitigations {
+	SRBDS_MITIGATION_OFF,
+	SRBDS_MITIGATION_UCODE_NEEDED,
+	SRBDS_MITIGATION_FULL,
+	SRBDS_MITIGATION_TSX_OFF,
+	SRBDS_MITIGATION_HYPERVISOR,
+};
+
+static enum srbds_mitigations srbds_mitigation = SRBDS_MITIGATION_FULL;
+
+static const char * const srbds_strings[] = {
+	[SRBDS_MITIGATION_OFF]		= "Vulnerable",
+	[SRBDS_MITIGATION_UCODE_NEEDED]	= "Vulnerable: No microcode",
+	[SRBDS_MITIGATION_FULL]		= "Mitigation: Microcode",
+	[SRBDS_MITIGATION_TSX_OFF]	= "Mitigation: TSX disabled",
+	[SRBDS_MITIGATION_HYPERVISOR]	= "Unknown: Dependent on hypervisor status",
+};
+
+static bool srbds_off;
+
+void update_srbds_msr(void)
+{
+	u64 mcu_ctrl;
+
+	if (!boot_cpu_has_bug(X86_BUG_SRBDS))
+		return;
+
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return;
+
+	if (srbds_mitigation == SRBDS_MITIGATION_UCODE_NEEDED)
+		return;
+
+	rdmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+
+	switch (srbds_mitigation) {
+	case SRBDS_MITIGATION_OFF:
+	case SRBDS_MITIGATION_TSX_OFF:
+		mcu_ctrl |= RNGDS_MITG_DIS;
+		break;
+	case SRBDS_MITIGATION_FULL:
+		mcu_ctrl &= ~RNGDS_MITG_DIS;
+		break;
+	default:
+		break;
+	}
+
+	wrmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+}
+
+static void __init srbds_select_mitigation(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has_bug(X86_BUG_SRBDS))
+		return;
+
+	/*
+	 * Check to see if this is one of the MDS_NO systems supporting
+	 * TSX that are only exposed to SRBDS when TSX is enabled.
+	 */
+	ia32_cap = x86_read_arch_cap_msr();
+	if ((ia32_cap & ARCH_CAP_MDS_NO) && !boot_cpu_has(X86_FEATURE_RTM))
+		srbds_mitigation = SRBDS_MITIGATION_TSX_OFF;
+	else if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		srbds_mitigation = SRBDS_MITIGATION_HYPERVISOR;
+	else if (!boot_cpu_has(X86_FEATURE_SRBDS_CTRL))
+		srbds_mitigation = SRBDS_MITIGATION_UCODE_NEEDED;
+	else if (cpu_mitigations_off() || srbds_off)
+		srbds_mitigation = SRBDS_MITIGATION_OFF;
+
+	update_srbds_msr();
+	pr_info("%s\n", srbds_strings[srbds_mitigation]);
+}
+
+static int __init srbds_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!boot_cpu_has_bug(X86_BUG_SRBDS))
+		return 0;
+
+	srbds_off = !strcmp(str, "off");
+	return 0;
+}
+early_param("srbds", srbds_parse_cmdline);
+
+#undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V1 : " fmt
 
 enum spectre_v1_mitigation {
@@ -1377,6 +1470,11 @@ static char *ibpb_state(void)
 	return "";
 }
 
+static ssize_t srbds_show_state(char *buf)
+{
+	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
@@ -1418,6 +1516,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_ITLB_MULTIHIT:
 		return itlb_multihit_show_state(buf);
 
+	case X86_BUG_SRBDS:
+		return srbds_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1464,4 +1565,9 @@ ssize_t cpu_show_itlb_multihit(struct de
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_ITLB_MULTIHIT);
 }
+
+ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_SRBDS);
+}
 #endif
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -912,6 +912,27 @@ static const __initconst struct x86_cpu_
 	{}
 };
 
+#define VULNBL_INTEL_STEPPINGS(model, steppings, issues)		   \
+	X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(INTEL, 6,		   \
+					    INTEL_FAM6_##model, steppings, \
+					    X86_FEATURE_ANY, issues)
+
+#define SRBDS		BIT(0)
+
+static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
+	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(HASWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(HASWELL_ULT,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(HASWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0xC),	SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0xD),	SRBDS),
+	{}
+};
+
 static bool __init cpu_matches(const struct x86_cpu_id *table, unsigned long which)
 {
 	const struct x86_cpu_id *m = x86_match_cpu(table);
@@ -977,6 +998,15 @@ static void __init cpu_set_bug_bits(stru
 	     (ia32_cap & ARCH_CAP_TSX_CTRL_MSR)))
 		setup_force_cpu_bug(X86_BUG_TAA);
 
+	/*
+	 * SRBDS affects CPUs which support RDRAND or RDSEED and are listed
+	 * in the vulnerability blacklist.
+	 */
+	if ((cpu_has(c, X86_FEATURE_RDRAND) ||
+	     cpu_has(c, X86_FEATURE_RDSEED)) &&
+	    cpu_matches(cpu_vuln_blacklist, SRBDS))
+		    setup_force_cpu_bug(X86_BUG_SRBDS);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
@@ -1330,6 +1360,7 @@ void identify_secondary_cpu(struct cpuin
 #endif
 	mtrr_ap_init();
 	x86_spec_ctrl_setup_ap();
+	update_srbds_msr();
 }
 
 struct msr_range {
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -64,6 +64,7 @@ extern void get_cpu_cap(struct cpuinfo_x
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 
 extern void x86_spec_ctrl_setup_ap(void);
+extern void update_srbds_msr(void);
 
 extern u64 x86_read_arch_cap_msr(void);
 
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -549,6 +549,12 @@ ssize_t __weak cpu_show_itlb_multihit(st
 	return sprintf(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_srbds(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -557,6 +563,7 @@ static DEVICE_ATTR(l1tf, 0444, cpu_show_
 static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
 static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
+static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -567,6 +574,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_mds.attr,
 	&dev_attr_tsx_async_abort.attr,
 	&dev_attr_itlb_multihit.attr,
+	&dev_attr_srbds.attr,
 	NULL
 };
 



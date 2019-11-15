Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7D3FD660
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKOGYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbfKOGVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:36 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805E92073C;
        Fri, 15 Nov 2019 06:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798894;
        bh=OX2S9XAMW/hm/fEQo+W4qjxGAbUDpaI0hHYaheSiY28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0SyPgjHbAKkI0Urv7rjeDhmXIiqWNCfm9ttYJmVGenhhj1pj5BqEcobdxybiprw9
         ZECC3/XjWFNwJ7AKwV4IcY9F1USzpQbye4bIIXGxzHCQ46Z6JzsUy+WMaLp7hD1RV2
         la6mjkcwsqJxLhmKBqp5fWcPtB9b9rtKR6Ja9smc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 20/20] x86/bugs: Add ITLB_MULTIHIT bug infrastructure
Date:   Fri, 15 Nov 2019 14:20:49 +0800
Message-Id: <20191115062016.618614388@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineela Tummalapalli <vineela.tummalapalli@intel.com>

commit db4d30fbb71b47e4ecb11c4efa5d8aad4b03dfae upstream.

Some processors may incur a machine check error possibly resulting in an
unrecoverable CPU lockup when an instruction fetch encounters a TLB
multi-hit in the instruction TLB. This can occur when the page size is
changed along with either the physical address or cache type. The relevant
erratum can be found here:

   https://bugzilla.kernel.org/show_bug.cgi?id=205195

There are other processors affected for which the erratum does not fully
disclose the impact.

This issue affects both bare-metal x86 page tables and EPT.

It can be mitigated by either eliminating the use of large pages or by
using careful TLB invalidations when changing the page size in the page
tables.

Just like Spectre, Meltdown, L1TF and MDS, a new bit has been allocated in
MSR_IA32_ARCH_CAPABILITIES (PSCHANGE_MC_NO) and will be set on CPUs which
are mitigated against this issue.

Signed-off-by: Vineela Tummalapalli <vineela.tummalapalli@intel.com>
Co-developed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4:
 - No support for X86_VENDOR_HYGON, ATOM_AIRMONT_NP
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 
 arch/x86/include/asm/cpufeatures.h                 |    1 
 arch/x86/include/asm/msr-index.h                   |    7 ++
 arch/x86/kernel/cpu/bugs.c                         |   13 ++++
 arch/x86/kernel/cpu/common.c                       |   61 +++++++++++----------
 drivers/base/cpu.c                                 |    8 ++
 include/linux/cpu.h                                |    2 
 7 files changed, 65 insertions(+), 28 deletions(-)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -280,6 +280,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/l1tf
 		/sys/devices/system/cpu/vulnerabilities/mds
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
+		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -341,5 +341,6 @@
 #define X86_BUG_MSBDS_ONLY	X86_BUG(20) /* CPU is only affected by the  MSDBS variant of BUG_MDS */
 #define X86_BUG_SWAPGS		X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
 #define X86_BUG_TAA		X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
+#define X86_BUG_ITLB_MULTIHIT	X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -71,6 +71,13 @@
 						  * Microarchitectural Data
 						  * Sampling (MDS) vulnerabilities.
 						  */
+#define ARCH_CAP_PSCHANGE_MC_NO		BIT(6)	 /*
+						  * The processor is not susceptible to a
+						  * machine check error due to modifying the
+						  * code page size along with either the
+						  * physical address or cache type
+						  * without TLB invalidation.
+						  */
 #define ARCH_CAP_TSX_CTRL_MSR		BIT(7)	/* MSR for TSX control is available. */
 #define ARCH_CAP_TAA_NO			BIT(8)	/*
 						 * Not susceptible to
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1277,6 +1277,11 @@ static void __init l1tf_select_mitigatio
 
 #ifdef CONFIG_SYSFS
 
+static ssize_t itlb_multihit_show_state(char *buf)
+{
+	return sprintf(buf, "Processor vulnerable\n");
+}
+
 static ssize_t mds_show_state(char *buf)
 {
 #ifdef CONFIG_HYPERVISOR_GUEST
@@ -1379,6 +1384,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_TAA:
 		return tsx_async_abort_show_state(buf);
 
+	case X86_BUG_ITLB_MULTIHIT:
+		return itlb_multihit_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1420,4 +1428,9 @@ ssize_t cpu_show_tsx_async_abort(struct
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_TAA);
 }
+
+ssize_t cpu_show_itlb_multihit(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_ITLB_MULTIHIT);
+}
 #endif
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -847,13 +847,14 @@ static void identify_cpu_without_cpuid(s
 #endif
 }
 
-#define NO_SPECULATION	BIT(0)
-#define NO_MELTDOWN	BIT(1)
-#define NO_SSB		BIT(2)
-#define NO_L1TF		BIT(3)
-#define NO_MDS		BIT(4)
-#define MSBDS_ONLY	BIT(5)
-#define NO_SWAPGS	BIT(6)
+#define NO_SPECULATION		BIT(0)
+#define NO_MELTDOWN		BIT(1)
+#define NO_SSB			BIT(2)
+#define NO_L1TF			BIT(3)
+#define NO_MDS			BIT(4)
+#define MSBDS_ONLY		BIT(5)
+#define NO_SWAPGS		BIT(6)
+#define NO_ITLB_MULTIHIT	BIT(7)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -871,26 +872,26 @@ static const __initconst struct x86_cpu_
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
 
 	/* Intel Family 6 */
-	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION),
-	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
-	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
-
-	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
-	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
+
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
 
-	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -901,13 +902,13 @@ static const __initconst struct x86_cpu_
 	 */
 
 	/* AMD Family 0xf - 0x12 */
-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	{}
 };
 
@@ -932,6 +933,10 @@ static void __init cpu_set_bug_bits(stru
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
 
+	/* Set ITLB_MULTIHIT bug if cpu is not in the whitelist and not mitigated */
+	if (!cpu_matches(NO_ITLB_MULTIHIT) && !(ia32_cap & ARCH_CAP_PSCHANGE_MC_NO))
+		setup_force_cpu_bug(X86_BUG_ITLB_MULTIHIT);
+
 	if (cpu_matches(NO_SPECULATION))
 		return;
 
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -543,6 +543,12 @@ ssize_t __weak cpu_show_tsx_async_abort(
 	return sprintf(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_itlb_multihit(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -550,6 +556,7 @@ static DEVICE_ATTR(spec_store_bypass, 04
 static DEVICE_ATTR(l1tf, 0444, cpu_show_l1tf, NULL);
 static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
 static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
+static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -559,6 +566,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_l1tf.attr,
 	&dev_attr_mds.attr,
 	&dev_attr_tsx_async_abort.attr,
+	&dev_attr_itlb_multihit.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -55,6 +55,8 @@ extern ssize_t cpu_show_mds(struct devic
 extern ssize_t cpu_show_tsx_async_abort(struct device *dev,
 					struct device_attribute *attr,
 					char *buf);
+extern ssize_t cpu_show_itlb_multihit(struct device *dev,
+				      struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,



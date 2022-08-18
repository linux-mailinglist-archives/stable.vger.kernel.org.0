Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD71598539
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245539AbiHROEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 10:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245534AbiHROEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 10:04:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AB965818;
        Thu, 18 Aug 2022 07:04:13 -0700 (PDT)
Date:   Thu, 18 Aug 2022 14:04:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660831451;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=huKV1HiKrxpeYRytT3hwqTJSmcg8WjeKNN8yQta+aBw=;
        b=j5uEBC8LnwbrTC9dEYtJFn675wVWODruUgBKIy/+kIkO9F044qRzcHQI5sQYeDsSA+UBIP
        no61jQxgyXGc4YM2mAJP3BJDxUd99c9eoT9gQ2N7LRecoEdUMja2UlIb/bGDYPb4NNIFOR
        UuAk9MgSvhpcJZVGzymlblHPEnPmQdiuI1qm00jQM3jjkDw6KGlTiXCiDBBmWFD5ibItWT
        TeaUIDMzLHKwaa6ghDyKzQWLbdxE+eHPO0ekCrV6Nb1zaorTglEg64zdAUqOpZf+xhsMZ+
        WSVFvyt3SiI01MjyUJMrDDceritJgRRdXPQjz2oTRmoXrxL0Lu8mwgQhAH7YjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660831451;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=huKV1HiKrxpeYRytT3hwqTJSmcg8WjeKNN8yQta+aBw=;
        b=1Cx7ALrLxCxNcBpoD8J/5kVspU6/qFxY28wXPNK+5u2Qtnk65Amo3X9ytWcENU927I5hPN
        gkzMxpw4VDUx2NBA==
From:   "tip-bot2 for Pawan Gupta" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/bugs: Add "unknown" reporting for MMIO Stale Data
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Tony Luck <tony.luck@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3Ca932c154772f2121794a5f2eded1a11013114711=2E16578?=
 =?utf-8?q?46269=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
References: =?utf-8?q?=3Ca932c154772f2121794a5f2eded1a11013114711=2E165784?=
 =?utf-8?q?6269=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <166083144940.401.2981933695783238161.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7df548840c496b0141fb2404b889c346380c2b22
Gitweb:        https://git.kernel.org/tip/7df548840c496b0141fb2404b889c346380c2b22
Author:        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
AuthorDate:    Wed, 03 Aug 2022 14:41:32 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 18 Aug 2022 15:35:22 +02:00

x86/bugs: Add "unknown" reporting for MMIO Stale Data

Older Intel CPUs that are not in the affected processor list for MMIO
Stale Data vulnerabilities currently report "Not affected" in sysfs,
which may not be correct. Vulnerability status for these older CPUs is
unknown.

Add known-not-affected CPUs to the whitelist. Report "unknown"
mitigation status for CPUs that are not in blacklist, whitelist and also
don't enumerate MSR ARCH_CAPABILITIES bits that reflect hardware
immunity to MMIO Stale Data vulnerabilities.

Mitigation is not deployed when the status is unknown.

  [ bp: Massage, fixup. ]

Fixes: 8d50cdf8b834 ("x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data")
Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com
---
 Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst | 14 ++++++++++++++
 arch/x86/include/asm/cpufeatures.h                              |  5 +++--
 arch/x86/kernel/cpu/bugs.c                                      | 14 ++++++++++++--
 arch/x86/kernel/cpu/common.c                                    | 42 +++++++++++++++++++++++++++---------------
 4 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
index 9393c50..c98fd11 100644
--- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
+++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
@@ -230,6 +230,20 @@ The possible values in this file are:
      * - 'Mitigation: Clear CPU buffers'
        - The processor is vulnerable and the CPU buffer clearing mitigation is
          enabled.
+     * - 'Unknown: No mitigations'
+       - The processor vulnerability status is unknown because it is
+	 out of Servicing period. Mitigation is not attempted.
+
+Definitions:
+------------
+
+Servicing period: The process of providing functional and security updates to
+Intel processors or platforms, utilizing the Intel Platform Update (IPU)
+process or other similar mechanisms.
+
+End of Servicing Updates (ESU): ESU is the date at which Intel will no
+longer provide Servicing, such as through IPU or other similar update
+processes. ESU dates will typically be aligned to end of quarter.
 
 If the processor is vulnerable then the following information is appended to
 the above information:
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 235dc85..ef4775c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -457,7 +457,8 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
-#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
-#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
+#define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 510d852..da7c361 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -433,7 +433,8 @@ static void __init mmio_select_mitigation(void)
 	u64 ia32_cap;
 
 	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
-	    cpu_mitigations_off()) {
+	     boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN) ||
+	     cpu_mitigations_off()) {
 		mmio_mitigation = MMIO_MITIGATION_OFF;
 		return;
 	}
@@ -538,6 +539,8 @@ out:
 		pr_info("TAA: %s\n", taa_strings[taa_mitigation]);
 	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
 		pr_info("MMIO Stale Data: %s\n", mmio_strings[mmio_mitigation]);
+	else if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		pr_info("MMIO Stale Data: Unknown: No mitigations\n");
 }
 
 static void __init md_clear_select_mitigation(void)
@@ -2275,6 +2278,9 @@ static ssize_t tsx_async_abort_show_state(char *buf)
 
 static ssize_t mmio_stale_data_show_state(char *buf)
 {
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return sysfs_emit(buf, "Unknown: No mitigations\n");
+
 	if (mmio_mitigation == MMIO_MITIGATION_OFF)
 		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
 
@@ -2421,6 +2427,7 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 		return srbds_show_state(buf);
 
 	case X86_BUG_MMIO_STALE_DATA:
+	case X86_BUG_MMIO_UNKNOWN:
 		return mmio_stale_data_show_state(buf);
 
 	case X86_BUG_RETBLEED:
@@ -2480,7 +2487,10 @@ ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *
 
 ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_UNKNOWN);
+	else
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
 
 ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 64a73f4..3e508f2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1135,7 +1135,8 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_SPECTRE_V2		BIT(8)
-#define NO_EIBRS_PBRSB		BIT(9)
+#define NO_MMIO			BIT(9)
+#define NO_EIBRS_PBRSB		BIT(10)
 
 #define VULNWL(vendor, family, model, whitelist)	\
 	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, whitelist)
@@ -1158,6 +1159,11 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL(VORTEX,	6, X86_MODEL_ANY,	NO_SPECULATION),
 
 	/* Intel Family 6 */
+	VULNWL_INTEL(TIGERLAKE,			NO_MMIO),
+	VULNWL_INTEL(TIGERLAKE_L,		NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE,			NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE_L,		NO_MMIO),
+
 	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
@@ -1176,9 +1182,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_AIRMONT_NP,		NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
 
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_D,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1193,18 +1199,18 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL_INTEL(ATOM_TREMONT_D,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
-	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/* Zhaoxin Family 7 */
-	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS),
-	VULNWL(ZHAOXIN,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS),
+	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS | NO_MMIO),
+	VULNWL(ZHAOXIN,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS | NO_MMIO),
 	{}
 };
 
@@ -1358,10 +1364,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	 * Affected CPU list is generally enough to enumerate the vulnerability,
 	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
 	 * not want the guest to enumerate the bug.
+	 *
+	 * Set X86_BUG_MMIO_UNKNOWN for CPUs that are neither in the blacklist,
+	 * nor in the whitelist and also don't enumerate MSR ARCH_CAP MMIO bits.
 	 */
-	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
-	    !arch_cap_mmio_immune(ia32_cap))
-		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+	if (!arch_cap_mmio_immune(ia32_cap)) {
+		if (cpu_matches(cpu_vuln_blacklist, MMIO))
+			setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+		else if (!cpu_matches(cpu_vuln_whitelist, NO_MMIO))
+			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
+	}
 
 	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
 		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))

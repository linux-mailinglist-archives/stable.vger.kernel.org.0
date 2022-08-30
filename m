Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB365A6E5B
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 22:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiH3UUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 16:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiH3UUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 16:20:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FB270E71;
        Tue, 30 Aug 2022 13:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661890851; x=1693426851;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XEkVIM1o3cJzP9j3i+ERnRentCzHr7lx3eZ5zg1Khjo=;
  b=WQ2IcfBBeMq8VNpJU3QZOG1XkGJz6I82eVAkQlEpsXDwaGHNcSju4pbz
   3RIujwHrfbln6PX9LYLgqPTdk4gfQwFfWsRYQn9/Kw78Ch+WUORG5Ndda
   597AiLTxuqptcyXpMzGCQvdWy5/sv+8JlXXV9PtRayD503hs6fGwvzGoW
   OhkBY+V66vQRavVDhOrhz6r9HZXXwEuSkq+cft5jjz3XneRXKC1qPpRib
   ZsNHJeqRFhBR5ZpBoqwzw1nqu1tl/PEHpDmCGoV/vbDb4VgrGP33liEjv
   bHCKOCPTHpNZ8vJvtvvVkO+LoU1qbmiAYm/rHhuTsrM7xHqISI83XQphZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="296571298"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="296571298"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 13:20:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="673036847"
Received: from skanpuri-mobl1.amr.corp.intel.com (HELO desk) ([10.212.18.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 13:20:50 -0700
Date:   Tue, 30 Aug 2022 13:20:49 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrew.cooper3@citrix.com, bp@suse.de,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.4] x86/bugs: Add "unknown" reporting for MMIO Stale Data
Message-ID: <34cb2f634020a3425a754f76b092df699e7e34a5.1661890721.git.pawan.kumar.gupta@linux.intel.com>
References: <166175790177143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166175790177143@kroah.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7df548840c496b0141fb2404b889c346380c2b22 ]

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
 .../hw-vuln/processor_mmio_stale_data.rst     | 14 +++++++
 arch/x86/include/asm/cpufeatures.h            |  3 +-
 arch/x86/kernel/cpu/bugs.c                    | 14 ++++++-
 arch/x86/kernel/cpu/common.c                  | 40 ++++++++++++-------
 4 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
index 9393c50b5afc..c98fd11907cc 100644
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
index a3e32bc93856..736b0e412344 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -407,6 +407,7 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
-#define X86_BUG_EIBRS_PBRSB		X86_BUG(26) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 57efa90f3fbd..c90d91cb1434 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -396,7 +396,8 @@ static void __init mmio_select_mitigation(void)
 	u64 ia32_cap;
 
 	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
-	    cpu_mitigations_off()) {
+	     boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN) ||
+	     cpu_mitigations_off()) {
 		mmio_mitigation = MMIO_MITIGATION_OFF;
 		return;
 	}
@@ -501,6 +502,8 @@ static void __init md_clear_update_mitigation(void)
 		pr_info("TAA: %s\n", taa_strings[taa_mitigation]);
 	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
 		pr_info("MMIO Stale Data: %s\n", mmio_strings[mmio_mitigation]);
+	else if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		pr_info("MMIO Stale Data: Unknown: No mitigations\n");
 }
 
 static void __init md_clear_select_mitigation(void)
@@ -1880,6 +1883,9 @@ static ssize_t tsx_async_abort_show_state(char *buf)
 
 static ssize_t mmio_stale_data_show_state(char *buf)
 {
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return sysfs_emit(buf, "Unknown: No mitigations\n");
+
 	if (mmio_mitigation == MMIO_MITIGATION_OFF)
 		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
 
@@ -2007,6 +2013,7 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 		return srbds_show_state(buf);
 
 	case X86_BUG_MMIO_STALE_DATA:
+	case X86_BUG_MMIO_UNKNOWN:
 		return mmio_stale_data_show_state(buf);
 
 	default:
@@ -2063,6 +2070,9 @@ ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *
 
 ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
+	if (boot_cpu_has_bug(X86_BUG_MMIO_UNKNOWN))
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_UNKNOWN);
+	else
+		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b926b7244d42..59413e741ecf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1026,6 +1026,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_SPECTRE_V2		BIT(8)
 #define NO_EIBRS_PBRSB		BIT(9)
+#define NO_MMIO			BIT(10)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -1046,6 +1047,11 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
 
 	/* Intel Family 6 */
+	VULNWL_INTEL(TIGERLAKE,			NO_MMIO),
+	VULNWL_INTEL(TIGERLAKE_L,		NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE,			NO_MMIO),
+	VULNWL_INTEL(ALDERLAKE_L,		NO_MMIO),
+
 	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION | NO_ITLB_MULTIHIT),
 	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION | NO_ITLB_MULTIHIT),
@@ -1064,9 +1070,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
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
@@ -1081,18 +1087,18 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
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
-	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2),
-	VULNWL(ZHAOXIN,	7, X86_MODEL_ANY,	NO_SPECTRE_V2),
+	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_MMIO),
+	VULNWL(ZHAOXIN,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_MMIO),
 	{}
 };
 
@@ -1234,10 +1240,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
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
 
 	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
 	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&

base-commit: 684cc17be897de3b0fd2e5a021a702f68046d9fe
-- 
2.37.2



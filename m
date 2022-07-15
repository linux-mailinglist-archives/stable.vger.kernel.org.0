Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D251457591B
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 03:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiGOBaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 21:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiGOBaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 21:30:21 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67503ED46;
        Thu, 14 Jul 2022 18:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657848620; x=1689384620;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VULQdfb9uIcToxA48uBh48V4LsuTxsYYsa97hl98D9s=;
  b=CMoRLk/yhbV/65hticH0qkVBTvgZH+TBf+z2ZWFlQ5iUDCbcPajpXtgf
   2f0+AZ/to5G9wxMoxkFRjFkphX+O8418Ex+3zWMrocGHunMytrgPq1I1v
   08pgA5DzyLFY0mkmRrSThHpoIdIGS+Oh2t5iBeq4aIz6FDnV0Xl/KbK6y
   JnC4NeuoKPSEEne4KpD6hHHw76VryAQoJUGY0Da3hj6DQhTYTIzSQ3pDa
   c/HWpU/k01KcJXucdlP5KbV07R6ThKTwJzRtw2YUqlHR8/JZ/f+Pz3aVy
   u3abaU1BQjt1rz0QEAnNXRaVScaI6vEj7xo80lSDmsQA/mjCuPrhndAIQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268700723"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="268700723"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 18:30:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="600329519"
Received: from pravinpa-mobl.amr.corp.intel.com (HELO desk) ([10.212.243.89])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 18:30:19 -0700
Date:   Thu, 14 Jul 2022 18:30:18 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, tony.luck@intel.com,
        antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        andrew.cooper3@citrix.com, Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO Stale
 Data
Message-ID: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=0.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Older CPUs beyond its Servicing period are not listed in the affected
processor list for MMIO Stale Data vulnerabilities. These CPUs currently
report "Not affected" in sysfs, which may not be correct.

Add support for "Unknown" reporting for such CPUs. Mitigation is not
deployed when the status is "Unknown".

"CPU is beyond its Servicing period" means these CPUs are beyond their
Servicing [1] period and have reached End of Servicing Updates (ESU) [2].

  [1] Servicing: The process of providing functional and security
  updates to Intel processors or platforms, utilizing the Intel Platform
  Update (IPU) process or other similar mechanisms.

  [2] End of Servicing Updates (ESU): ESU is the date at which Intel
  will no longer provide Servicing, such as through IPU or other similar
  update processes. ESU dates will typically be aligned to end of
  quarter.

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Suggested-by: Tony Luck <tony.luck@intel.com>
Fixes: 8d50cdf8b834 ("x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data")
Cc: stable@vger.kernel.org
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
CPU vulnerability is unknown if, hardware doesn't set the immunity bits
and CPU is not in the known-affected-list.

In order to report the unknown status, this patch sets the MMIO bug
for all Intel CPUs that don't have the hardware immunity bits set.
Based on the known-affected-list of CPUs, mitigation selection then
deploys the mitigation or sets the "Unknown" status; which is ugly.

I will appreciate suggestions to improve this.

Thanks,
Pawan

 .../hw-vuln/processor_mmio_stale_data.rst     |  3 +++
 arch/x86/kernel/cpu/bugs.c                    | 11 +++++++-
 arch/x86/kernel/cpu/common.c                  | 26 +++++++++++++------
 arch/x86/kernel/cpu/cpu.h                     |  1 +
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
index 9393c50b5afc..55524e0798da 100644
--- a/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
+++ b/Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst
@@ -230,6 +230,9 @@ The possible values in this file are:
      * - 'Mitigation: Clear CPU buffers'
        - The processor is vulnerable and the CPU buffer clearing mitigation is
          enabled.
+     * - 'Unknown: CPU is beyond its Servicing period'
+       - The processor vulnerability status is unknown because it is
+	 out of Servicing period. Mitigation is not attempted.
 
 If the processor is vulnerable then the following information is appended to
 the above information:
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0dd04713434b..dd6e78d370bc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -416,6 +416,7 @@ enum mmio_mitigations {
 	MMIO_MITIGATION_OFF,
 	MMIO_MITIGATION_UCODE_NEEDED,
 	MMIO_MITIGATION_VERW,
+	MMIO_MITIGATION_UNKNOWN,
 };
 
 /* Default mitigation for Processor MMIO Stale Data vulnerabilities */
@@ -426,12 +427,18 @@ static const char * const mmio_strings[] = {
 	[MMIO_MITIGATION_OFF]		= "Vulnerable",
 	[MMIO_MITIGATION_UCODE_NEEDED]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
 	[MMIO_MITIGATION_VERW]		= "Mitigation: Clear CPU buffers",
+	[MMIO_MITIGATION_UNKNOWN]	= "Unknown: CPU is beyond its servicing period",
 };
 
 static void __init mmio_select_mitigation(void)
 {
 	u64 ia32_cap;
 
+	if (mmio_stale_data_unknown()) {
+		mmio_mitigation = MMIO_MITIGATION_UNKNOWN;
+		return;
+	}
+
 	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA) ||
 	    cpu_mitigations_off()) {
 		mmio_mitigation = MMIO_MITIGATION_OFF;
@@ -1638,6 +1645,7 @@ void cpu_bugs_smt_update(void)
 			pr_warn_once(MMIO_MSG_SMT);
 		break;
 	case MMIO_MITIGATION_OFF:
+	case MMIO_MITIGATION_UNKNOWN:
 		break;
 	}
 
@@ -2235,7 +2243,8 @@ static ssize_t tsx_async_abort_show_state(char *buf)
 
 static ssize_t mmio_stale_data_show_state(char *buf)
 {
-	if (mmio_mitigation == MMIO_MITIGATION_OFF)
+	if (mmio_mitigation == MMIO_MITIGATION_OFF ||
+	    mmio_mitigation == MMIO_MITIGATION_UNKNOWN)
 		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
 
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 736262a76a12..82088410870e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1286,6 +1286,22 @@ static bool arch_cap_mmio_immune(u64 ia32_cap)
 		ia32_cap & ARCH_CAP_SBDR_SSDP_NO);
 }
 
+bool __init mmio_stale_data_unknown(void)
+{
+	u64 ia32_cap = x86_read_arch_cap_msr();
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return false;
+	/*
+	 * CPU vulnerability is unknown when, hardware doesn't set the
+	 * immunity bits and CPU is not in the known affected list.
+	 */
+	if (!cpu_matches(cpu_vuln_blacklist, MMIO) &&
+	    !arch_cap_mmio_immune(ia32_cap))
+		return true;
+	return false;
+}
+
 static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
@@ -1349,14 +1365,8 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    cpu_matches(cpu_vuln_blacklist, SRBDS | MMIO_SBDS))
 		    setup_force_cpu_bug(X86_BUG_SRBDS);
 
-	/*
-	 * Processor MMIO Stale Data bug enumeration
-	 *
-	 * Affected CPU list is generally enough to enumerate the vulnerability,
-	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
-	 * not want the guest to enumerate the bug.
-	 */
-	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
+	 /* Processor MMIO Stale Data bug enumeration */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 	    !arch_cap_mmio_immune(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 7c9b5893c30a..a2dbfc1bbc49 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -82,6 +82,7 @@ unsigned int aperfmperf_get_khz(int cpu);
 
 extern void x86_spec_ctrl_setup_ap(void);
 extern void update_srbds_msr(void);
+extern bool mmio_stale_data_unknown(void);
 
 extern u64 x86_read_arch_cap_msr(void);
 

base-commit: 4a57a8400075bc5287c5c877702c68aeae2a033d
-- 
2.35.3



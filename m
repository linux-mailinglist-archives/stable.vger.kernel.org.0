Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D424D5419
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiCJWDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbiCJWDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:03:18 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC96D195323;
        Thu, 10 Mar 2022 14:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646949736; x=1678485736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y8q0ybKAkysnwhGHgJ+OG6o1DMS+xAEvEE3u0LB/V4k=;
  b=j57xBD9vOb9d/5BOtoLFJQLXqdVLg+yj9gtIP2dHcHGhkd2nO4ewN2d1
   PjSFAQKQG7XYuDl7gQHNpPI+gDC15CPv9R/BLqr8DewwXHhwrPhW/UeSm
   QLHSjWRpOGXF1v5sIjhUJWEQjem2sB+VUPh3nQWL6S+rWpezQX85jSpro
   a09EkCMLoQEnuhsML/z0nUE85vVj6Rv563neq3yHzKnDRkxyG5QMbPf8/
   kMDjTpShMt/Gp2+YCSzdlYRFLg2ORQeBhe7z0nTtUXkzRlw2KamCtYEtF
   xD0c4TUCyfzlbsK1v2x0fxhg6u5Vf9VkLwU9HgqjIJTX0C/TWV0souudl
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="242838935"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="242838935"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 14:02:15 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="578975159"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.209.31.141])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 14:02:10 -0800
Date:   Thu, 10 Mar 2022 14:02:09 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 2/2] x86/tsx: Disable TSX development mode at boot
Message-ID: <347bd844da3a333a9793c6687d4e4eb3b2419a3e.1646943780.git.pawan.kumar.gupta@linux.intel.com>
References: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A microcode update on some Intel processors causes all TSX transactions
to always abort by default [*]. Microcode also added functionality to
re-enable TSX for development purpose. With this microcode loaded, if
tsx=on was passed on the cmdline, and TSX development mode was already
enabled before the kernel boot, it may make the system vulnerable to TSX
Asynchronous Abort (TAA).

To be on safer side, unconditionally disable TSX development mode at
boot. If needed, a user can enable it using msr-tools.

[*] Intel Transactional Synchronization Extension (Intel TSX) Disable Update for Selected Processors
    https://cdrdv2.intel.com/v1/dl/getContent/643557

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/include/asm/msr-index.h       |  4 +--
 arch/x86/kernel/cpu/cpu.h              |  1 +
 arch/x86/kernel/cpu/intel.c            |  4 +++
 arch/x86/kernel/cpu/tsx.c              | 34 ++++++++++++++++++++++++++
 tools/arch/x86/include/asm/msr-index.h |  4 +--
 5 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a4a39c3e0f19..0c2610cde6ea 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -128,9 +128,9 @@
 #define TSX_CTRL_RTM_DISABLE		BIT(0)	/* Disable RTM feature */
 #define TSX_CTRL_CPUID_CLEAR		BIT(1)	/* Disable TSX enumeration */
 
-/* SRBDS support */
 #define MSR_IA32_MCU_OPT_CTRL		0x00000123
-#define RNGDS_MITG_DIS			BIT(0)
+#define RNGDS_MITG_DIS			BIT(0)	/* SRBDS support */
+#define RTM_ALLOW			BIT(1)	/* TSX development mode */
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index ee6f23f7587d..628d18062372 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -58,6 +58,7 @@ extern void __init tsx_init(void);
 extern void tsx_enable(void);
 extern void tsx_disable(void);
 extern void tsx_clear_cpuid(void);
+extern bool tsx_dev_mode_disable(void);
 #else
 static inline void tsx_init(void) { }
 #endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8abf995677a4..46cb5a18bd97 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -717,6 +717,10 @@ static void init_intel(struct cpuinfo_x86 *c)
 
 	init_intel_misc_features(c);
 
+	/* Boot CPU is handled in tsx_init() */
+	if (c->cpu_index != boot_cpu_data.cpu_index)
+		tsx_dev_mode_disable();
+
 	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
 		tsx_enable();
 	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 2835fa89fc6f..513e479bca2e 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -142,11 +142,45 @@ void tsx_clear_cpuid(void)
 	}
 }
 
+/*
+ * Disable TSX development mode
+ *
+ * When the microcode released in Feb 2022 is applied, TSX will be disabled by
+ * default on some processors. MSR 0x122 (TSX_CTRL) and MSR 0x123
+ * (IA32_MCU_OPT_CTRL) can be used to re-enable TSX for development, doing so is
+ * not recommended for production deployments. In particular, applying MD_CLEAR
+ * flows for mitigation of the Intel TSX Asynchronous Abort (TAA) transient
+ * execution attack may not be effective on these processors when Intel TSX is
+ * enabled with updated microcode.
+ */
+bool tsx_dev_mode_disable(void)
+{
+	u64 mcu_opt_ctrl;
+
+	/* Check if RTM_ALLOW exists */
+	if (!boot_cpu_has_bug(X86_BUG_TAA) || !tsx_ctrl_is_supported() ||
+	    !boot_cpu_has(X86_FEATURE_SRBDS_CTRL))
+		return false;
+
+	rdmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+
+	if (mcu_opt_ctrl & RTM_ALLOW) {
+		mcu_opt_ctrl &= ~RTM_ALLOW;
+		wrmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+		return true;
+	}
+
+	return false;
+}
+
 void __init tsx_init(void)
 {
 	char arg[5] = {};
 	int ret;
 
+	if (tsx_dev_mode_disable())
+		setup_force_cpu_cap(X86_FEATURE_RTM_ALWAYS_ABORT);
+
 	/*
 	 * Hardware will always abort a TSX transaction when CPUID
 	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index a4a39c3e0f19..0c2610cde6ea 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -128,9 +128,9 @@
 #define TSX_CTRL_RTM_DISABLE		BIT(0)	/* Disable RTM feature */
 #define TSX_CTRL_CPUID_CLEAR		BIT(1)	/* Disable TSX enumeration */
 
-/* SRBDS support */
 #define MSR_IA32_MCU_OPT_CTRL		0x00000123
-#define RNGDS_MITG_DIS			BIT(0)
+#define RNGDS_MITG_DIS			BIT(0)	/* SRBDS support */
+#define RTM_ALLOW			BIT(1)	/* TSX development mode */
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
-- 
2.25.1


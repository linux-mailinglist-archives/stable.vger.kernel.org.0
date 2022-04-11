Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931104FC00F
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347682AbiDKPQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbiDKPQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:16:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6455C31537;
        Mon, 11 Apr 2022 08:13:54 -0700 (PDT)
Date:   Mon, 11 Apr 2022 15:13:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649690032;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lA0LlidcWJL7C5Og8jZF4ju2oJG//hmMEVLV9sjzSQA=;
        b=FFN5HsUjo/3EC/Hn/iI3jAbXv/j7qEGMp1mQdt4ZhDU6vwKcGJ7ThEJvymn6DcPtYVwDuL
        rdYl7pISKj8ijHHDQ9yvQo8i1Xmm3dNhyjAnwE/YRdtjI70bTfbq+nWNuBEY4lm+6H4/5M
        REDuz7lHkY+1Pg5xBsf4cQcvXhKf+sFlJwBGSejegcofDQwpH1DAH8FaZZpaaPtdWGIUK4
        VGnBGmUXPtyfqSFiM2lCxMsr1OA9maLhRqoQUE7rypKFz39knSjk44hM1MvoGu1y7w1WSu
        hz+1JAYmZ2gezFlml/6ePbumfOti6XguzHEUV4ZTgumlSU29dGaQnx+H5xsNLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649690032;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lA0LlidcWJL7C5Og8jZF4ju2oJG//hmMEVLV9sjzSQA=;
        b=4NG97VaOnj8NSkQ8yQLCdKAMunZvLugZzC+hK8TMsH4VcQNllZWH9M92OwlZvRiT4tjKG1
        nZgAfXGbZ3d/TkAA==
From:   "tip-bot2 for Pawan Gupta" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/tsx: Disable TSX development mode at boot
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C347bd844da3a333a9793c6687d4e4eb3b2419a3e=2E16469?=
 =?utf-8?q?43780=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
References: =?utf-8?q?=3C347bd844da3a333a9793c6687d4e4eb3b2419a3e=2E164694?=
 =?utf-8?q?3780=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <164969003119.4207.9766798513967669907.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     400331f8ffa3bec5c561417e5eec6848464e9160
Gitweb:        https://git.kernel.org/tip/400331f8ffa3bec5c561417e5eec6848464e9160
Author:        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
AuthorDate:    Thu, 10 Mar 2022 14:02:09 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 11 Apr 2022 09:58:40 +02:00

x86/tsx: Disable TSX development mode at boot

A microcode update on some Intel processors causes all TSX transactions
to always abort by default[*]. Microcode also added functionality to
re-enable TSX for development purposes. With this microcode loaded, if
tsx=on was passed on the cmdline, and TSX development mode was already
enabled before the kernel boot, it may make the system vulnerable to TSX
Asynchronous Abort (TAA).

To be on safer side, unconditionally disable TSX development mode during
boot. If a viable use case appears, this can be revisited later.

  [*]: Intel TSX Disable Update for Selected Processors, doc ID: 643557

  [ bp: Drop unstable web link, massage heavily. ]

Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/347bd844da3a333a9793c6687d4e4eb3b2419a3e.1646943780.git.pawan.kumar.gupta@linux.intel.com
---
 arch/x86/include/asm/msr-index.h       |  4 +-
 arch/x86/kernel/cpu/common.c           |  2 +-
 arch/x86/kernel/cpu/cpu.h              |  5 +--
 arch/x86/kernel/cpu/intel.c            |  8 +----
 arch/x86/kernel/cpu/tsx.c              | 50 +++++++++++++++++++++++--
 tools/arch/x86/include/asm/msr-index.h |  4 +-
 6 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 0eb90d2..ee15311 100644
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ed44175..e342ae4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1855,6 +1855,8 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 	validate_apic_and_package_id(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
+
+	tsx_ap_init();
 }
 
 static __init int setup_noclflush(char *arg)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index ee6f23f..2a8e584 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -55,11 +55,10 @@ enum tsx_ctrl_states {
 extern __ro_after_init enum tsx_ctrl_states tsx_ctrl_state;
 
 extern void __init tsx_init(void);
-extern void tsx_enable(void);
-extern void tsx_disable(void);
-extern void tsx_clear_cpuid(void);
+void tsx_ap_init(void);
 #else
 static inline void tsx_init(void) { }
+static inline void tsx_ap_init(void) { }
 #endif /* CONFIG_CPU_SUP_INTEL */
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8abf995..f7a5370 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -717,14 +717,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 
 	init_intel_misc_features(c);
 
-	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
-		tsx_enable();
-	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
-		tsx_disable();
-	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
-		/* See comment over that function for more details. */
-		tsx_clear_cpuid();
-
 	split_lock_init();
 	bus_lock_init();
 
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index ec6ff80..ec7bbac 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -19,7 +19,7 @@
 
 enum tsx_ctrl_states tsx_ctrl_state __ro_after_init = TSX_CTRL_NOT_SUPPORTED;
 
-void tsx_disable(void)
+static void tsx_disable(void)
 {
 	u64 tsx;
 
@@ -39,7 +39,7 @@ void tsx_disable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-void tsx_enable(void)
+static void tsx_enable(void)
 {
 	u64 tsx;
 
@@ -122,7 +122,7 @@ static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
  * That's why, this function's call in init_intel() doesn't clear the
  * feature flags.
  */
-void tsx_clear_cpuid(void)
+static void tsx_clear_cpuid(void)
 {
 	u64 msr;
 
@@ -142,11 +142,42 @@ void tsx_clear_cpuid(void)
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
+static void tsx_dev_mode_disable(void)
+{
+	u64 mcu_opt_ctrl;
+
+	/* Check if RTM_ALLOW exists */
+	if (!boot_cpu_has_bug(X86_BUG_TAA) || !tsx_ctrl_is_supported() ||
+	    !cpu_feature_enabled(X86_FEATURE_SRBDS_CTRL))
+		return;
+
+	rdmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+
+	if (mcu_opt_ctrl & RTM_ALLOW) {
+		mcu_opt_ctrl &= ~RTM_ALLOW;
+		wrmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+		setup_force_cpu_cap(X86_FEATURE_RTM_ALWAYS_ABORT);
+	}
+}
+
 void __init tsx_init(void)
 {
 	char arg[5] = {};
 	int ret;
 
+	tsx_dev_mode_disable();
+
 	/*
 	 * Hardware will always abort a TSX transaction when the CPUID bit
 	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
@@ -215,3 +246,16 @@ void __init tsx_init(void)
 		setup_force_cpu_cap(X86_FEATURE_HLE);
 	}
 }
+
+void tsx_ap_init(void)
+{
+	tsx_dev_mode_disable();
+
+	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
+		tsx_enable();
+	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
+		tsx_disable();
+	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
+		/* See comment over that function for more details. */
+		tsx_clear_cpuid();
+}
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 0eb90d2..ee15311 100644
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

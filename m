Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0F64EB1C2
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 18:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbiC2QZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 12:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbiC2QZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 12:25:58 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD84205947;
        Tue, 29 Mar 2022 09:24:14 -0700 (PDT)
Received: from zn.tnic (p200300ea971561dd329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:61dd:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C7A231EC0304;
        Tue, 29 Mar 2022 18:24:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1648571047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3HLtCJ0Z7kf58HNoB/tnLG8oBS1ml4FoT2pxn9HxQ9A=;
        b=GI9sXykmSFS4do75pZm+FuWiSV3DooLB6KfZkN8NCa6LKo1xv7RAqNJkNATYoi4H8IpqxX
        NdL7fhuPIOI3WNmls4tTLS/7r7pgJ9b11x4WItsRCKHhetbFH5rMXq1w+I/vQU/X8fSQHw
        c4n83KOioCJdXYs3fAZfUh/fbIgVNTc=
Date:   Tue, 29 Mar 2022 18:24:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 2/2] x86/tsx: Disable TSX development mode at boot
Message-ID: <YkMyo2Jw8iYx9wAU@zn.tnic>
References: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
 <347bd844da3a333a9793c6687d4e4eb3b2419a3e.1646943780.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <347bd844da3a333a9793c6687d4e4eb3b2419a3e.1646943780.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 02:02:09PM -0800, Pawan Gupta wrote:
> A microcode update on some Intel processors causes all TSX transactions
> to always abort by default [*]. Microcode also added functionality to
> re-enable TSX for development purpose. With this microcode loaded, if
> tsx=on was passed on the cmdline, and TSX development mode was already
> enabled before the kernel boot, it may make the system vulnerable to TSX
> Asynchronous Abort (TAA).
> 
> To be on safer side, unconditionally disable TSX development mode at
> boot. If needed, a user can enable it using msr-tools.
> 
> [*] Intel Transactional Synchronization Extension (Intel TSX) Disable Update for Selected Processors
>     https://cdrdv2.intel.com/v1/dl/getContent/643557
> 
> Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/include/asm/msr-index.h       |  4 +--
>  arch/x86/kernel/cpu/cpu.h              |  1 +
>  arch/x86/kernel/cpu/intel.c            |  4 +++
>  arch/x86/kernel/cpu/tsx.c              | 34 ++++++++++++++++++++++++++
>  tools/arch/x86/include/asm/msr-index.h |  4 +--
>  5 files changed, 43 insertions(+), 4 deletions(-)

Does this a lot more encapsulated version work too?

---
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date: Thu, 10 Mar 2022 14:02:09 -0800
Subject: [PATCH] x86/tsx: Disable TSX development mode at boot

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
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/347bd844da3a333a9793c6687d4e4eb3b2419a3e.1646943780.git.pawan.kumar.gupta@linux.intel.com
---
 arch/x86/include/asm/msr-index.h       |  4 +--
 arch/x86/kernel/cpu/common.c           |  2 ++
 arch/x86/kernel/cpu/cpu.h              |  5 ++-
 arch/x86/kernel/cpu/intel.c            |  8 -----
 arch/x86/kernel/cpu/tsx.c              | 50 ++++++++++++++++++++++++--
 tools/arch/x86/include/asm/msr-index.h |  4 +--
 6 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9f1741ac4769..adce6a17770b 100644
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
index 64deb7727d00..4616753d1510 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1798,6 +1798,8 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 	validate_apic_and_package_id(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
+
+	tsx_ap_init();
 }
 
 static __init int setup_noclflush(char *arg)
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index ee6f23f7587d..2a8e584fc991 100644
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
index 8abf995677a4..f7a5370a9b3b 100644
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
index ec6ff8000920..ec7bbac3a9f2 100644
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
2.35.1

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DB14B72E4
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241546AbiBOQcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 11:32:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiBOQcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 11:32:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8A28879C;
        Tue, 15 Feb 2022 08:31:49 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 54D881EC0518;
        Tue, 15 Feb 2022 17:31:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1644942703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=cvlxRJuZ2ajCAnvFcq7AjH7roJyqu6nBgWYCPE7BuV8=;
        b=p8RxN6gZHLFL3JMgdGVlrjZ2Q8S6h9K+LYQd+yUSC886YxDjCyTvIyj/BN7FreqiJnLeu8
        6JGfX0Ei3XhqNkhC575yfdVQ0ysP50N1qoOOsYZGYWC+K4oyssyGoEn+OOP+l4Bu+QJT8h
        f4M840uqRUjFDYdRSZAXqKQvo+j6k0s=
Date:   Tue, 15 Feb 2022 17:31:45 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <YgvVcdpmFCCn20A7@zn.tnic>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
 <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
 <Ygt/QSTSMlUJnzFS@zn.tnic>
 <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220215121103.vhb2lpoygxn3xywy@guptapa-mobl1.amr.corp.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 04:11:03AM -0800, Pawan Gupta wrote:
> That is exactly what this patch is fixing. Please let me know if you
> have any questions.

Just one: does the explanation I've written for this mess, sound about
right?

I'd like for this to be documented so that I don't scratch my head again
when looking at this again later.

Btw, lemme add Cooper to Cc to doublecheck me - he usually knows those
things.

Thx.

---
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date: Wed, 9 Feb 2022 13:04:36 -0800
Subject: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits

tsx_clear_cpuid() uses MSR_TSX_FORCE_ABORT to clear CPUID.RTM and
CPUID.HLE. Not all CPUs support MSR_TSX_FORCE_ABORT, alternatively use
MSR_IA32_TSX_CTRL when supported.

  [ bp: Document how and why TSX gets disabled. ]

Fixes: 293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com
---
 arch/x86/kernel/cpu/intel.c |  1 +
 arch/x86/kernel/cpu/tsx.c   | 54 ++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8321c43554a1..8abf995677a4 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -722,6 +722,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
 		tsx_disable();
 	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
+		/* See comment over that function for more details. */
 		tsx_clear_cpuid();
 
 	split_lock_init();
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 9c7a5f049292..2835fa89fc6f 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -58,7 +58,7 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
+static bool tsx_ctrl_is_supported(void)
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
 
@@ -84,6 +84,44 @@ static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 	return TSX_CTRL_ENABLE;
 }
 
+/*
+ * Disabling TSX is not a trivial business.
+ *
+ * First of all, there's a CPUID bit: X86_FEATURE_RTM_ALWAYS_ABORT
+ * which says that TSX is practically disabled (all transactions are
+ * aborted by default). When that bit is set, the kernel unconditionally
+ * disables TSX.
+ *
+ * In order to do that, however, it needs to dance a bit:
+ *
+ * 1. The first method to disable it is through MSR_TSX_FORCE_ABORT and
+ * the MSR is present only when *two* CPUID bits are set:
+ *
+ * - X86_FEATURE_RTM_ALWAYS_ABORT
+ * - X86_FEATURE_TSX_FORCE_ABORT
+ *
+ * 2. The second method is for CPUs which do not have the above-mentioned
+ * MSR: those use a different MSR - MSR_IA32_TSX_CTRL and disable TSX
+ * through that one. Those CPUs can also have the initially mentioned
+ * CPUID bit X86_FEATURE_RTM_ALWAYS_ABORT set and for those the same strategy
+ * applies: TSX gets disabled unconditionally.
+ *
+ * When either of the two methods are present, the kernel disables TSX and
+ * clears the respective RTM and HLE feature flags.
+ *
+ * An additional twist in the whole thing presents late microcode loading
+ * which, when done, may cause for the X86_FEATURE_RTM_ALWAYS_ABORT CPUID
+ * bit to be set after the update.
+ *
+ * A subsequent hotplug operation on any logical CPU except the BSP will
+ * cause for the supported CPUID feature bits to get re-detected and, if
+ * RTM and HLE get cleared all of a sudden, but, userspace did consult
+ * them before the update, then funny explosions will happen. Long story
+ * short: the kernel doesn't modify CPUID feature bits after booting.
+ *
+ * That's why, this function's call in init_intel() doesn't clear the
+ * feature flags.
+ */
 void tsx_clear_cpuid(void)
 {
 	u64 msr;
@@ -97,6 +135,10 @@ void tsx_clear_cpuid(void)
 		rdmsrl(MSR_TSX_FORCE_ABORT, msr);
 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
 		wrmsrl(MSR_TSX_FORCE_ABORT, msr);
+	} else if (tsx_ctrl_is_supported()) {
+		rdmsrl(MSR_IA32_TSX_CTRL, msr);
+		msr |= TSX_CTRL_CPUID_CLEAR;
+		wrmsrl(MSR_IA32_TSX_CTRL, msr);
 	}
 }
 
@@ -106,13 +148,11 @@ void __init tsx_init(void)
 	int ret;
 
 	/*
-	 * Hardware will always abort a TSX transaction if both CPUID bits
-	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
-	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
-	 * here.
+	 * Hardware will always abort a TSX transaction when CPUID
+	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
+	 * CPUID.RTM and CPUID.HLE bits. Clear them here.
 	 */
-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
-	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
+	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT)) {
 		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
 		tsx_clear_cpuid();
 		setup_clear_cpu_cap(X86_FEATURE_RTM);
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

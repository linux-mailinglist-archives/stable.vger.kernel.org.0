Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19634B5E40
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 00:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiBNX3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 18:29:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiBNX3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 18:29:05 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7A413CA0E;
        Mon, 14 Feb 2022 15:28:56 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1A6F31EC0545;
        Tue, 15 Feb 2022 00:28:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1644881331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=bw0Cg0Vb0ckQBMrs6FQYYmT/dLrW2QZDQ9x37mTqLAI=;
        b=IGCcz0PtuqfdIcFq70dUFsEUqYK0NFMjrfPystBUacOo7vzN87O4UMt32RqwGL+gUP1xVG
        GxCZBJ9ssoQ55HhLZSHaw55OfCfK5oKaIbJ2nQ7LTUzvddcDvFIXJHlMpLjAGsNFS3/ykm
        NdcPAZDhyrmcsf/2lr8UMv7ZIe+u+YQ=
Date:   Tue, 15 Feb 2022 00:28:53 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <YgrltbToK8+tG2qK@zn.tnic>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 02:41:21PM -0800, Pawan Gupta wrote:
> Yes, this needs to be backported to a few kernels that have the commit
> 293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts").
> Once this is reviewed, I will send a separate email to stable@ with the
> list of stable kernels.

You don't have to send a separate email - CC: stable and the Fixes tag
is enough for a patch to be picked up by the stable folks.

> X86_FEATURE_RTM_ALWAYS_ABORT is the precondition for
> MSR_TFA_TSX_CPUID_CLEAR bit to exist. For current callers of
> tsx_clear_cpuid() this condition is met, and test for
> X86_FEATURE_RTM_ALWAYS_ABORT can be removed. But, all the future callers
> must also have this check, otherwise the MSR write will fault.

I meant something like this (completely untested):

diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index c2343ea911e8..9d08a6b1726a 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -84,7 +84,7 @@ static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 	return TSX_CTRL_ENABLE;
 }
 
-void tsx_clear_cpuid(void)
+bool tsx_clear_cpuid(void)
 {
 	u64 msr;
 
@@ -97,11 +97,14 @@ void tsx_clear_cpuid(void)
 		rdmsrl(MSR_TSX_FORCE_ABORT, msr);
 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
 		wrmsrl(MSR_TSX_FORCE_ABORT, msr);
+		return true;
 	} else if (tsx_ctrl_is_supported()) {
 		rdmsrl(MSR_IA32_TSX_CTRL, msr);
 		msr |= TSX_CTRL_CPUID_CLEAR;
 		wrmsrl(MSR_IA32_TSX_CTRL, msr);
+		return true;
 	}
+	return false;
 }
 
 void __init tsx_init(void)
@@ -114,9 +117,8 @@ void __init tsx_init(void)
 	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
 	 * CPUID.RTM and CPUID.HLE bits. Clear them here.
 	 */
-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT)) {
+	if (tsx_clear_cpuid()) {
 		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
-		tsx_clear_cpuid();
 		setup_clear_cpu_cap(X86_FEATURE_RTM);
 		setup_clear_cpu_cap(X86_FEATURE_HLE);
 		return;

---

but I'm guessing TSX should be disabled by default during boot only when
X86_FEATURE_RTM_ALWAYS_ABORT is set.

If those CPUs which support only disabling TSX through MSR_IA32_TSX_CTRL
but don't have MSR_TSX_FORCE_ABORT - if those CPUs set
X86_FEATURE_RTM_ALWAYS_ABORT too, then this should work.

> There are certain cases where this will leave the system in an
> inconsistent state, for example smt toggle after a late microcode update

What is a "smt toggle"?

You mean late microcode update and then offlining and onlining all
logical CPUs except the BSP which would re-detect CPUID features?

> that adds CPUID.RTM_ALWAYS_ABORT=1. During an smt toggle, if we
> unconditionally clear CPUID.RTM and CPUID.HLE in init_intel(), half of
> the CPUs will report TSX feature and other half will not.

That is important and should be documented. Something like this perhaps:

---

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8321c43554a1..6c7bca9d6f2e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -722,6 +722,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
 		tsx_disable();
 	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
+		/*
+		 * This call doesn't clear RTM and HLE X86_FEATURE bits because
+		 * a late microcode reload adding MSR_TSX_FORCE_ABORT can cause
+		 * for those bits to get cleared - something which the kernel
+		 * cannot do due to userspace potentially already using said
+		 * features.
+		 */
 		tsx_clear_cpuid();
 
 	split_lock_init();

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB1D4B5EF5
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 01:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiBOAU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 19:20:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiBOAU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 19:20:26 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5795212D211;
        Mon, 14 Feb 2022 16:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644884417; x=1676420417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/KbEyiRn/Aaf8BrULpR7QEC8uKrRfLRRrv92U0AAhQQ=;
  b=Mi+rZCUtPqVd1wpC4ajwH3hIAkqH8vpkDKo3me02wqcaMcctGY1Ur/9m
   iiIZS6NXrxdi7vWPVZZorUFQCa5bVnIM0NrdCGto/9RAyaYfLlKzQzRjK
   jySeus5mZCb8FPb40H7j5Vt5TJ2OvqOg6IR2gsboir3wKa0oXbwVBbc8T
   AXKRvdytkIm2mGW7JzR/rG7+FHTmuln4Is7l7EMkdxk3HQJJ3IZA38KwN
   vowikLE/U6iNxQlDjyx8aoiq/DwPEeD0pXvqpa/TSfvcqmZhUcAZCch6s
   ZWS1b+oWEyr0gqT/m1eG/WCpdQtiNxA+MfCv5VnE3EPos+/IA77N0RLs7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="310952320"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="310952320"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 16:20:17 -0800
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="496435214"
Received: from guptapa-mobl1.amr.corp.intel.com ([10.212.244.212])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 16:20:16 -0800
Date:   Mon, 14 Feb 2022 16:20:14 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@linux.intel.com, neelima.krishnan@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Message-ID: <20220215002014.mb7g4y3hfefmyozx@guptapa-mobl1.amr.corp.intel.com>
References: <5bd785a1d6ea0b572250add0c6617b4504bc24d1.1644440311.git.pawan.kumar.gupta@linux.intel.com>
 <YgqToxbGQluNHABF@zn.tnic>
 <20220214224121.ilhu23cfjdyhvahk@guptapa-mobl1.amr.corp.intel.com>
 <YgrltbToK8+tG2qK@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <YgrltbToK8+tG2qK@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.02.2022 00:28, Borislav Petkov wrote:
>On Mon, Feb 14, 2022 at 02:41:21PM -0800, Pawan Gupta wrote:
>> X86_FEATURE_RTM_ALWAYS_ABORT is the precondition for
>> MSR_TFA_TSX_CPUID_CLEAR bit to exist. For current callers of
>> tsx_clear_cpuid() this condition is met, and test for
>> X86_FEATURE_RTM_ALWAYS_ABORT can be removed. But, all the future callers
>> must also have this check, otherwise the MSR write will fault.
>
>I meant something like this (completely untested):
>
>diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
>index c2343ea911e8..9d08a6b1726a 100644
>--- a/arch/x86/kernel/cpu/tsx.c
>+++ b/arch/x86/kernel/cpu/tsx.c
>@@ -84,7 +84,7 @@ static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
> 	return TSX_CTRL_ENABLE;
> }
>
>-void tsx_clear_cpuid(void)
>+bool tsx_clear_cpuid(void)
> {
> 	u64 msr;
>
>@@ -97,11 +97,14 @@ void tsx_clear_cpuid(void)
> 		rdmsrl(MSR_TSX_FORCE_ABORT, msr);
> 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
> 		wrmsrl(MSR_TSX_FORCE_ABORT, msr);
>+		return true;
> 	} else if (tsx_ctrl_is_supported()) {
> 		rdmsrl(MSR_IA32_TSX_CTRL, msr);
> 		msr |= TSX_CTRL_CPUID_CLEAR;
> 		wrmsrl(MSR_IA32_TSX_CTRL, msr);

This will clear TSX CPUID when X86_FEATURE_RTM_ALWAYS_ABORT=0 also, because ...

>+		return true;
> 	}
>+	return false;
> }
>
> void __init tsx_init(void)
>@@ -114,9 +117,8 @@ void __init tsx_init(void)
> 	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
> 	 * CPUID.RTM and CPUID.HLE bits. Clear them here.
> 	 */
>-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT)) {
>+	if (tsx_clear_cpuid()) {

... we are calling tsx_clear_cpuid() unconditionally.

> 		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
>-		tsx_clear_cpuid();
> 		setup_clear_cpu_cap(X86_FEATURE_RTM);
> 		setup_clear_cpu_cap(X86_FEATURE_HLE);
> 		return;
>
>---
>
>but I'm guessing TSX should be disabled by default during boot only when
>X86_FEATURE_RTM_ALWAYS_ABORT is set.

That is correct.

>If those CPUs which support only disabling TSX through MSR_IA32_TSX_CTRL
>but don't have MSR_TSX_FORCE_ABORT - if those CPUs set
>X86_FEATURE_RTM_ALWAYS_ABORT too, then this should work.
>
>> There are certain cases where this will leave the system in an
>> inconsistent state, for example smt toggle after a late microcode update
>
>What is a "smt toggle"?

Sorry, I should have been more clear. I meant:

	# echo off > /sys/devices/system/cpu/smt/control
	# echo on  > /sys/devices/system/cpu/smt/control

>You mean late microcode update and then offlining and onlining all
>logical CPUs except the BSP which would re-detect CPUID features?

That could also be the problematic case.

>> that adds CPUID.RTM_ALWAYS_ABORT=1. During an smt toggle, if we
>> unconditionally clear CPUID.RTM and CPUID.HLE in init_intel(), half of
>> the CPUs will report TSX feature and other half will not.
>
>That is important and should be documented. Something like this perhaps:
>
>---
>
>diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>index 8321c43554a1..6c7bca9d6f2e 100644
>--- a/arch/x86/kernel/cpu/intel.c
>+++ b/arch/x86/kernel/cpu/intel.c
>@@ -722,6 +722,13 @@ static void init_intel(struct cpuinfo_x86 *c)
> 	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
> 		tsx_disable();
> 	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
>+		/*
>+		 * This call doesn't clear RTM and HLE X86_FEATURE bits because
>+		 * a late microcode reload adding MSR_TSX_FORCE_ABORT can cause
>+		 * for those bits to get cleared - something which the kernel
>+		 * cannot do due to userspace potentially already using said
>+		 * features.
>+		 */
> 		tsx_clear_cpuid();

Thanks, I will add this comment in the next revision.

Pawan

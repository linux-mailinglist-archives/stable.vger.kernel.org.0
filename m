Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2867641EF4E
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 16:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354442AbhJAOVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 10:21:47 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50992 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354434AbhJAOVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 10:21:46 -0400
Received: from zn.tnic (p200300ec2f0e8e001f2e791e6d4c2984.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:1f2e:791e:6d4c:2984])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D67531EC05BF;
        Fri,  1 Oct 2021 16:19:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633097999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Zal9+szdk4o8OsVxkTlc7oZ9vkyimfo+1p/FVTC7tTI=;
        b=ccTZo99+oep4NozO2dEFbGzDeOc4/L/UmUp67ITtJGJNPwDQdOi6oqo/VV79n77wnv8zSn
        GfPH14ug+rakHR3WHp3zaJymATBOcHX/Cv3FdyCReLIL4eRMXIw0pr/3zhvPjdbLZ8IwAs
        mRQF1lWeE+nr6g0HCrk6WtoNqgmPcNk=
Date:   Fri, 1 Oct 2021 16:19:54 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jane Malalane <jane.malalane@citrix.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YVcZCgOVkCPz1kwO@zn.tnic>
References: <20211001133349.9825-1-jane.malalane@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211001133349.9825-1-jane.malalane@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 01, 2021 at 02:33:49PM +0100, Jane Malalane wrote:
> Subject: Re: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
> ...
> Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
> makes it unsafe to migrate in a virtualised environment as the
> properties across the migration pool might differ.

Sorry but you need to explain "migration safety" in greater detail -
we're not all virtualizers.

> Zen3 adds the NullSelectorClearsBase bit to indicate that loading
> a NULL segment selector zeroes the base and limit fields, as well as
> just attributes. Zen2 also has this behaviour but doesn't have the
> NSCB bit.

I'm guessing you can detect Zen2 too, without the CPUID bit?

> When virtualised, NSCB might be cleared for migration safety,
> therefore we must not probe. Always honour the NSCB bit in this case,

Who is "we"?

> as the hypervisor is expected to synthesize it in the Zen2 case.
> 
> Signed-off-by: Jane Malalane <jane.malalane@citrix.com>
> ---
> CC: <x86@kernel.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Pu Wen <puwen@hygon.cn>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <seanjc@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Andrew Cooper <andrew.cooper3@citrix.com>
> CC: Yazen Ghannam <Yazen.Ghannam@amd.com>
> CC: Brijesh Singh <brijesh.singh@amd.com>
> CC: Huang Rui <ray.huang@amd.com>
> CC: Andy Lutomirski <luto@kernel.org>
> CC: Kim Phillips <kim.phillips@amd.com>
> CC: <stable@vger.kernel.org>
> ---
>  arch/x86/include/asm/cpufeatures.h |  2 +-
>  arch/x86/kernel/cpu/amd.c          | 23 +++++++++++++++++++++++
>  arch/x86/kernel/cpu/common.c       |  6 ++----
>  arch/x86/kernel/cpu/cpu.h          |  1 +
>  arch/x86/kernel/cpu/hygon.c        | 23 +++++++++++++++++++++++
>  5 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index d0ce5cfd3ac1..f571e4f6fe83 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -96,7 +96,7 @@
>  #define X86_FEATURE_SYSCALL32		( 3*32+14) /* "" syscall in IA32 userspace */
>  #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
>  #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
> -/* FREE!                                ( 3*32+17) */
> +#define X86_FEATURE_NSCB		( 3*32+17) /* Null Selector Clears Base */

You don't really need that bit definition - you check CPUID in the
early_init_amd/hygon() functions and that is enough. IOW, based on that
CPUID bit, you can call detect_null_seg_behavior() and set (or not)
X86_BUG_NULL_SEG.

...

> diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
> index 6d50136f7ab9..765f1556d964 100644
> --- a/arch/x86/kernel/cpu/hygon.c
> +++ b/arch/x86/kernel/cpu/hygon.c
> @@ -264,6 +264,29 @@ static void early_init_hygon(struct cpuinfo_x86 *c)
>  	if (c->x86_power & BIT(14))
>  		set_cpu_cap(c, X86_FEATURE_RAPL);
>  
> +	/*
> +	 * Zen1 and earlier CPUs don't clear segment base/limits when
> +	 * loading a NULL selector.  This has been designated
> +	 * X86_BUG_NULL_SEG.
> +	 *
> +	 * Zen3 CPUs advertise Null Selector Clears Base in CPUID.
> +	 * Zen2 CPUs also have this behaviour, but no CPUID bit.
> +	 *
> +	 * A hypervisor may sythesize the bit, but may also hide it
> +	 * for migration safety, so we must not probe for model
> +	 * specific behaviour when virtualised.
> +	 */
> +	if (c->extended_cpuid_level >= 0x80000021 &&
> +	    cpuid_eax(0x80000021) & BIT(6))
> +	        set_cpu_cap(c, X86_FEATURE_NSCB);
> +
> +	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !cpu_has(c, X86_FEATURE_NSCB) &&
> +	    c->x86 == 0x18)
> +                detect_null_seg_behavior(c);
> +
> +	if (!cpu_has(c, X86_FEATURE_NSCB))
> +		set_cpu_bug(c, X86_BUG_NULL_SEG);

Please integrate scripts/checkpatch.pl into your patch creation
workflow. Some of the warnings/errors *actually* make sense.

I'll show you that there's whitespace damage here:

ERROR: code indent should use tabs where possible
#238: FILE: arch/x86/kernel/cpu/hygon.c:281:
+^I        set_cpu_cap(c, X86_FEATURE_NSCB);$

ERROR: code indent should use tabs where possible
#242: FILE: arch/x86/kernel/cpu/hygon.c:285:
+                detect_null_seg_behavior(c);$

WARNING: please, no spaces at the start of a line
#242: FILE: arch/x86/kernel/cpu/hygon.c:285:
+                detect_null_seg_behavior(c);$

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

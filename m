Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E42432632
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhJRSTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 14:19:43 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55762 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhJRSTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 14:19:43 -0400
Received: from zn.tnic (p200300ec2f085700af6a7a3215758573.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5700:af6a:7a32:1575:8573])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A27881EC04A9;
        Mon, 18 Oct 2021 20:17:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634581050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uFKMgdVJFuAMxHN1IAGm/xRW2JT89EOF3TPA/iPD/r8=;
        b=UBh+Z8F0bkePuoPFqIcoUJ6KW5uHh7CLk6xjRzKnW6VnRmMxUGvUXbyxmBaDV/mGbWuzv2
        7dDm774ZELg8Ws6lhkQJGwr1KrX2t8nFkyt4+a6lD4fQa4mHQtUWf18hVMXFSpZCHcS/+4
        hWm8Za7ekoa4sR9nwA2jG7goM93tbrU=
Date:   Mon, 18 Oct 2021 20:17:30 +0200
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
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YW25x7AYiM1f1HQA@zn.tnic>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211013142230.10129-1-jane.malalane@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 03:22:30PM +0100, Jane Malalane wrote:
> @@ -650,6 +651,27 @@ static void early_init_amd(struct cpuinfo_x86 *c)
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
> +	if (c->extended_cpuid_level >= 0x80000021 && cpuid_eax(0x80000021) & BIT(6))
> +		nscb = true;
> +
> +	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !nscb && c->x86 == 0x17)
> +		nscb = check_null_seg_clears_base(c);
> +
> +	if (!nscb)
> +		set_cpu_bug(c, X86_BUG_NULL_SEG);
> +
>  #ifdef CONFIG_X86_64
>  	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
>  #else

Can we do something like this?

It is carved out into a separate function which you can simply call from
early_init_amd() and early_init_hygon().

I guess you can put that function in arch/x86/kernel/cpu/common.c or so.

Then, you should put the comments right over the code like I've done
below so that one can follow what's going on with each particular check.

I've also flipped the logic a bit and it is simpler this way.

Totally untested of course.

static void early_probe_null_seg_clearing_base(struct cpuinfo_x86 *c)
{
	/*
	 * A hypervisor may sythesize the bit, but may also hide it
	 * for migration safety, so do not probe for model-specific
	 * behaviour when virtualised.
	 */
	if (cpu_has(c, X86_FEATURE_HYPERVISOR))
		return;

	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
	if (c->extended_cpuid_level >= 0x80000021 && cpuid_eax(0x80000021) & BIT(6))
		return;

	/* Zen2 CPUs also have this behaviour, but no CPUID bit. */
	if (c->x86 == 0x17 && check_null_seg_clears_base(c))
		return;

	/* All the remaining ones are affected */
	set_cpu_bug(c, X86_BUG_NULL_SEG);
}

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 0f8885949e8c..2ca4afb97247 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1395,7 +1395,7 @@ void __init early_cpu_init(void)
>  	early_identify_cpu(&boot_cpu_data);
>  }
>  
> -static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
> +bool check_null_seg_clears_base(struct cpuinfo_x86 *c)
>  {
>  #ifdef CONFIG_X86_64
>  	/*
> @@ -1418,10 +1418,10 @@ static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
>  	wrmsrl(MSR_FS_BASE, 1);
>  	loadsegment(fs, 0);
>  	rdmsrl(MSR_FS_BASE, tmp);
> -	if (tmp != 0)
> -		set_cpu_bug(c, X86_BUG_NULL_SEG);
>  	wrmsrl(MSR_FS_BASE, old_base);
> +	return tmp == 0;
>  #endif
> +	return true;
>  }
>  
>  static void generic_identify(struct cpuinfo_x86 *c)
> @@ -1457,8 +1457,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
>  
>  	get_model_name(c); /* Default name */
>  
> -	detect_null_seg_behavior(c);
> -
>  	/*
>  	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
>  	 * systems that run Linux at CPL > 0 may or may not have the

So this function is called on all x86 CPUs. Are you sure others besides
AMD and Hygon do not have the same issue?

IOW, I wouldn't remove that call here.

But then this is the identify() phase in the boot process and you've
moved it to early_identify() by putting it in the ->c_early_init()
function pointer on AMD and Hygon.

Is there any particular reasoning for this or can that detection remain
in ->c_identify()?

Because if this null seg behavior detection should happen on all
CPUs - and I think it should, because, well, it has been that way
until now - then the vendor specific identification minus what
detect_null_seg_behavior() does should run first and then after
->c_identify() is done, you should do something like:

	if (!cpu_has_bug(c, X86_BUG_NULL_SEG)) {
		if (!check_null_seg_clears_base(c))
			set_cpu_bug(c, X86_BUG_NULL_SEG);
	}

so that it still takes place on all CPUs.

I.e., you should split the detection.

I hope I'm making sense ...

Ah, btw, that @c parameter to detect_null_seg_behavior() is unused - you
should remove it in a pre-patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

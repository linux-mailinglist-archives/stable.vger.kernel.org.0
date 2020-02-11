Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEE9159026
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 14:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgBKNmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 08:42:15 -0500
Received: from mail.skyhub.de ([5.9.137.197]:59864 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgBKNmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 08:42:15 -0500
Received: from zn.tnic (p200300EC2F095500BD9EB4A201E18C86.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5500:bd9e:b4a2:1e1:8c86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 633C31EC0C8A;
        Tue, 11 Feb 2020 14:42:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1581428532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dosw9ntDX7QDINjNhfhbT5aAzrLjfsYCUC0faBP+Wz0=;
        b=kq0tQxmwUYy42AMdJOVWEyLhI5TVx/84YmySoB2IXJGHvR9gUOmxPHGocYMI9rn0v8OZrd
        mNswhLPkd034/yv27q3bJsZ25w71dy58PeHoUwICP5hvvC1HUInjCFK7vKNVxusYPF7I9l
        YItw/xOiWKc5SaQIpd5QeFq5WtfbBiU=
Date:   Tue, 11 Feb 2020 14:42:05 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Frank van der Linden <fllinden@amazon.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Huang Rui <ray.huang@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jan Beulich <jbeulich@suse.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luwei Kang <luwei.kang@intel.com>,
        Martin =?utf-8?B?TGnFoWth?= <mliska@suse.cz>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2 v2 RESEND] x86/cpu/amd: Enable the fixed intructions
 retired free counter IRPERF
Message-ID: <20200211134205.GB32279@zn.tnic>
References: <20200207230427.26515-1-kim.phillips@amd.com>
 <20200207230427.26515-2-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200207230427.26515-2-kim.phillips@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 07, 2020 at 05:04:27PM -0600, Kim Phillips wrote:
> commit aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions
> Retired) performance counter") added support for 'perf -e msr/irperf/',
> but when exercised, we always get a 0 count:
> 
> BEFORE:
> 
> $ sudo perf stat -e instructions,msr/irperf/ true
> 
>  Performance counter stats for 'true':
> 
>            624,833      instructions
>                                                   #    0.00  stalled cycles per insn
>                  0      msr/irperf/
> 
> It turns out it simply needs its enable bit - HWCR bit 30 - set.  This patch

Avoid having "This patch" or "This commit" in the commit message. It is
tautologically useless.

Also, do

$ git grep 'This patch' Documentation/process

for more details.

> does just that.
> 
> Enablement is restricted to all machines advertising IRPERF capability,
> except those susceptible to an erratum that makes the IRPERF return
> bad values.
> 
> That erratum occurs in Family 17h models 00-1fh [1], but not in F17h
> models 20h and above [2].
> 
> AFTER (on a family 17h model 31h machine):
> 
> $ sudo perf stat -e instructions,msr/irperf/ true
> 
>  Performance counter stats for 'true':
> 
>            621,690      instructions
>                                                   #    0.00  stalled cycles per insn
>            622,490      msr/irperf/
> 
> [1] "Revision Guide for AMD Family 17h Models 00h-0Fh Processors",
>     currently available here:
> 
>     https://www.amd.com/system/files/TechDocs/55449_Fam_17h_M_00h-0Fh_Rev_Guide.pdf
> 
> [2] "Revision Guide for AMD Family 17h Models 30h-3Fh Processors",
>     currently available here:
> 
>     https://developer.amd.com/wp-content/resources/56323-PUB_0.74.pdf

How stable are those links? Past experience shows not very.

Please upload those to a bugzilla.kernel.org entry and add that URL here
with a Link: tag.

> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Babu Moger <babu.moger@amd.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Frank van der Linden <fllinden@amazon.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
> Cc: Jan Beulich <jbeulich@suse.com>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Luwei Kang <luwei.kang@intel.com>
> Cc: Martin Liška <mliska@suse.cz>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Michael Petlan <mpetlan@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Fixes: aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions Retired) performance counter")
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
> RESEND, adding Michael Petlan to cc. Original v2:
> 
> https://lore.kernel.org/lkml/20200121171232.28839-2-kim.phillips@amd.com/
> 
> v2: Based on Andi Kleen's review:
> 
>     https://lore.kernel.org/lkml/20200116040324.GI302770@tassilo.jf.intel.com/
> 
>     Add an amd_erratum_1054 and use cpu_has_bug infrastructure instead of
>     open-coding the {family,model} check.
> 
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/include/asm/msr-index.h   |  2 ++
>  arch/x86/kernel/cpu/amd.c          | 17 +++++++++++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index f3327cb56edf..1c1600e7476b 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -404,5 +404,6 @@
>  #define X86_BUG_SWAPGS			X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
>  #define X86_BUG_TAA			X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
>  #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
> +#define X86_BUG_AMD_E1054		X86_BUG(24) /* CPU is among the affected by Erratum 1054 */

That is visible in /proc/cpuinfo and the string "amd_e1054" means
nothing. Call that

X86_BUG_IRPERF

or so to at least give some hint as to what the bug is.

>  
>  #endif /* _ASM_X86_CPUFEATURES_H */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index ebe1685e92dd..d5e517d1c3dd 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -512,6 +512,8 @@
>  #define MSR_K7_HWCR			0xc0010015
>  #define MSR_K7_HWCR_SMMLOCK_BIT		0
>  #define MSR_K7_HWCR_SMMLOCK		BIT_ULL(MSR_K7_HWCR_SMMLOCK_BIT)
> +#define MSR_K7_HWCR_IRPERF_EN_BIT	30
> +#define MSR_K7_HWCR_IRPERF_EN		BIT_ULL(MSR_K7_HWCR_IRPERF_EN_BIT)
>  #define MSR_K7_FID_VID_CTL		0xc0010041
>  #define MSR_K7_FID_VID_STATUS		0xc0010042
>  
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 62c30279be77..c067234a271f 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -28,6 +28,7 @@
>  
>  static const int amd_erratum_383[];
>  static const int amd_erratum_400[];
> +static const int amd_erratum_1054[];
>  static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
>  
>  /*
> @@ -701,6 +702,9 @@ static void early_init_amd(struct cpuinfo_x86 *c)
>  	if (cpu_has_amd_erratum(c, amd_erratum_400))
>  		set_cpu_bug(c, X86_BUG_AMD_E400);
>  
> +	if (cpu_has_amd_erratum(c, amd_erratum_1054))
> +		set_cpu_bug(c, X86_BUG_AMD_E1054);
> +
>  	early_detect_mem_encrypt(c);
>  
>  	/* Re-enable TopologyExtensions if switched off by BIOS */
> @@ -978,6 +982,15 @@ static void init_amd(struct cpuinfo_x86 *c)
>  	/* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
>  	if (!cpu_has(c, X86_FEATURE_XENPV))
>  		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
> +
> +	/*
> +	 * Turn on the Instructions Retired free counter on machines not
> +	 * susceptible to erratum #1054 "Instructions Retired Performance
> +	 * Counter May Be Inaccurate"
				     .
				     ^
				     |--- fullstop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

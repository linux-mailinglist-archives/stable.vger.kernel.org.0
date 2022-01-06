Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B927486432
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 13:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbiAFMQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 07:16:48 -0500
Received: from mail.skyhub.de ([5.9.137.197]:60202 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238347AbiAFMQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 07:16:47 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EA2F31EC04D6;
        Thu,  6 Jan 2022 13:16:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1641471402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JU6A5NnG87Cq628iJmiPoWU/7eVHNQ1UKSgzIKICHiU=;
        b=q4AvY3CHdXSm1h8qLy3FuJ+VaS0mtr4OcwPKH+RF9BBRQCVxHHtlnxY9bu2NNL4MWOlhfW
        rjz7F5fY9jC01l0UZAUPtdGwBm/Uq81KYH4e6HpiBYENsKmTFdbh1l31i5OIVNWEAVfZUF
        UY9saboKOHEqcrB6pXDDTwyeLRqk+6o=
Date:   Thu, 6 Jan 2022 13:16:43 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Huang Rui <ray.huang@amd.com>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Perry Yuan <Perry.Yuan@amd.com>,
        Jinzhou Su <Jinzhou.Su@amd.com>,
        Xiaojian Du <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
Message-ID: <Ydbdq6lXPKFG98MY@zn.tnic>
References: <20220106074306.2712090-1-ray.huang@amd.com>
 <20220106074306.2712090-2-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220106074306.2712090-2-ray.huang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 03:43:06PM +0800, Huang Rui wrote:
> The init_freq_invariance_cppc function is implemented in smpboot and depends on
> CONFIG_SMP.
> 
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.kallsyms1
> ld: drivers/acpi/cppc_acpi.o: in function `acpi_cppc_processor_probe':
> /home/ray/brahma3/linux/drivers/acpi/cppc_acpi.c:819: undefined reference to `init_freq_invariance_cppc'
> make: *** [Makefile:1161: vmlinux] Error 1
> 
> See https://lore.kernel.org/lkml/484af487-7511-647e-5c5b-33d4429acdec@infradead.org/.
> 
> Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/include/asm/topology.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index cc164777e661..2f0b6be8eaab 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -221,7 +221,7 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled)
>  }
>  #endif
>  
> -#ifdef CONFIG_ACPI_CPPC_LIB
> +#if defined(CONFIG_ACPI_CPPC_LIB) && defined(CONFIG_SMP)
>  void init_freq_invariance_cppc(void);
>  #define init_freq_invariance_cppc init_freq_invariance_cppc
>  #endif
> -- 

Well, since that function is in smpboot.c then the logic should be that
CPPC depends on functionality in smpboot.c for proper operation.

IOW, ACPI_CPPC_LIB should have "depends on CONFIG_SMP" in Kconfig, no?

Instead of adding more ifdeffery around...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

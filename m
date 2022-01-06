Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504B348682B
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 18:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbiAFRMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 12:12:34 -0500
Received: from mail-qv1-f54.google.com ([209.85.219.54]:34621 "EHLO
        mail-qv1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiAFRMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 12:12:33 -0500
Received: by mail-qv1-f54.google.com with SMTP id ke6so2984025qvb.1;
        Thu, 06 Jan 2022 09:12:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IA1ahLCNPOQhCIpb5/ahAQS2dP6cjsn0rV/hKbv++w=;
        b=Q5R6sgmIvdMW03IYTjg6nicgSOC9D8Pc7GKnevvJoVvLU3h/+uecRI3/QqKe/IlDbe
         s7SQ5LnyBzAUzfIvUhFF3ND5iZSq8OgGLNCY1JZKE7fBuuOPNTPfpHeXRaDRs/mkp0Nf
         pw3mKrtcJc3bDiu29m7YuVMVL+11k8TtCKUPrIjEwG8jKiEpAbk1+DLvGYFHpFS6FS6k
         gyEVNJx8Qbykjnn1+mSmAvy6oYHLVR7tKApW5+wssn0IKm4UIKfPS+qXDkONA/rAxm7Y
         KzZWVWaErg4kAkME6VwHixedz7T0RceCLujY76wI5ejjDuBwaoYPv733bS1dhq6EJW5v
         AS0g==
X-Gm-Message-State: AOAM533y46K+6DiRpg41WwSEpPMjPOlw10Z7ArS7PsEZC43dy8F1Aqvk
        1nTcMR6nN5oXttr89PL2TQW9iYd4HLdw4Go3ddcO/CQ+EeI=
X-Google-Smtp-Source: ABdhPJwZA/vDfCXlX+KKPHZBLv8gRqJUFE1cS5uj/DSk0o0ftCh64qrZ1Bp6ACSQTRl83lXiVMPDRJHHaQiYubBa8nw=
X-Received: by 2002:ad4:5c8b:: with SMTP id o11mr53640125qvh.130.1641489152767;
 Thu, 06 Jan 2022 09:12:32 -0800 (PST)
MIME-Version: 1.0
References: <20220106074306.2712090-1-ray.huang@amd.com> <20220106074306.2712090-2-ray.huang@amd.com>
In-Reply-To: <20220106074306.2712090-2-ray.huang@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 6 Jan 2022 18:12:22 +0100
Message-ID: <CAJZ5v0htW=twuLY88XJmLGnDtmmjoav=Z8WLZZcjG29-YKQMog@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
To:     Huang Rui <ray.huang@amd.com>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Perry Yuan <Perry.Yuan@amd.com>,
        Jinzhou Su <Jinzhou.Su@amd.com>,
        Xiaojian Du <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 6, 2022 at 8:43 AM Huang Rui <ray.huang@amd.com> wrote:
>
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

Why don't you check CONFIG_SMP instead of this symbol in cppc_acpi.c?
That file depends on CONFIG_ACPI_CPPC_LIB anyway.

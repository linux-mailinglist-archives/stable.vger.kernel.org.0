Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8333695F6
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239383AbhDWPUi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 23 Apr 2021 11:20:38 -0400
Received: from mail-oi1-f170.google.com ([209.85.167.170]:41905 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhDWPUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 11:20:34 -0400
Received: by mail-oi1-f170.google.com with SMTP id r186so21713683oif.8;
        Fri, 23 Apr 2021 08:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PXVE4hrN8Ra4BE5pdNeYwDJC3vSSB5hMKHCcSU9/f4Q=;
        b=SUjt4lZDxzJN/DWjwv8ZqTuFnHwVB9b/pF/ANX1yVgU8u67OONmFsr0VJHlKvdAgGf
         /nc+eiN1o+O0D9WsLDA7EjQ3uxGfEwnK3aoIZO6c7adMcHxNxMX4EUwNjd61V6lB0ORN
         o4PAjt3rw2deQke78hAMbhoTRHQoyc2KUiMgHnTUDG6LguQPqFCv8XrJuvuefKXQZt1K
         JtzRc4YXSs1yEZfHL4TFEMd+MLaO2Qe3wlP6LS3DJQVJjpr97WOXZOAl2vrgv9XQR5lP
         sw0yt5gZhE+eUGwFdTcARYIQnVJV0YzjyNoGKWDP9FJcLlT9KFzrFJE+hN8TfTqAWNWY
         94lg==
X-Gm-Message-State: AOAM5318Lmfoq9OxbhjgnnhpCo7t8sqKUCSzRWv70JWz/ZNErRI41GO4
        962/t/bNXJ9/lYILUN5vp5haknOJjX6n81uWcI4=
X-Google-Smtp-Source: ABdhPJz7Yen33/DFEFFZRPowMOP+9GbKueYCf7KG1NmlDzHz1MwU1H44aW0EVNazUbfJQyjN3rEnPpyHp7WGsc3ahOU=
X-Received: by 2002:aca:bc89:: with SMTP id m131mr3223966oif.71.1619191197698;
 Fri, 23 Apr 2021 08:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210421023807.1540290-1-ray.huang@amd.com>
In-Reply-To: <20210421023807.1540290-1-ray.huang@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 23 Apr 2021 17:19:46 +0200
Message-ID: <CAJZ5v0iXzpD_DNWOroncHL+XkSznv+meQf74OiHcbQMqbAC4ug@mail.gmail.com>
Subject: Re: [PATCH v2] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
To:     Huang Rui <ray.huang@amd.com>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 4:38 AM Huang Rui <ray.huang@amd.com> wrote:
>
> Some AMD Ryzen generations has different calculation method on maximum
> perf. 255 is not for all asics, some specific generations should use 166
> as the maximum perf. Otherwise, it will report incorrect frequency value
> like below:
>
> ~ → lscpu | grep MHz
> CPU MHz:                         3400.000
> CPU max MHz:                     7228.3198
> CPU min MHz:                     2200.0000
>
> Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
>
> Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211791
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Nathan Fontenot <nathan.fontenot@amd.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> ---
>
> Changes from V1 -> V2:
> - Enhance the commit message.
> - Move amd_get_highest_perf() into amd.c.
> - Refine the implementation of switch-case.
> - Cc stable mail list.
>
> ---
>  arch/x86/include/asm/processor.h |  2 ++
>  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
>  arch/x86/kernel/smpboot.c        |  2 +-
>  drivers/cpufreq/acpi-cpufreq.c   | 19 +++++++++++++++++++
>  4 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index f1b9ed5efaa9..908bcaea1361 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
>
>  #ifdef CONFIG_CPU_SUP_AMD
>  extern u32 amd_get_nodes_per_socket(void);
> +extern u32 amd_get_highest_perf(void);
>  #else
>  static inline u32 amd_get_nodes_per_socket(void)       { return 0; }
> +static inline u32 amd_get_highest_perf(void)           { return 0; }
>  #endif
>
>  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 347a956f71ca..aadb691d9357 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
>                 break;
>         }
>  }
> +
> +u32 amd_get_highest_perf(void)
> +{
> +       struct cpuinfo_x86 *c = &boot_cpu_data;
> +       u32 cppc_max_perf = 225;

The extra local variable is redundant.

> +
> +       switch (c->x86) {
> +       case 0x17:
> +               if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> +                   (c->x86_model >= 0x70 && c->x86_model < 0x80))
> +                       cppc_max_perf = 166;
> +               break;

Also it would be cleaner to write this as

if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
    (c->x86_model >= 0x70 && c->x86_model < 0x80))
        return 166;

And analogously below.

> +       case 0x19:
> +               if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> +                   (c->x86_model >= 0x40 && c->x86_model < 0x70))
> +                       cppc_max_perf = 166;
> +               break;
> +       }
> +
> +       return cppc_max_perf;

And here

return 225;

> +}
> +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 02813a7f3a7c..7bec57d04a87 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -2046,7 +2046,7 @@ static bool amd_set_max_freq_ratio(void)
>                 return false;
>         }
>
> -       highest_perf = perf_caps.highest_perf;
> +       highest_perf = amd_get_highest_perf();
>         nominal_perf = perf_caps.nominal_perf;
>
>         if (!highest_perf || !nominal_perf) {
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index d1bbc16fba4b..3f0a19dd658c 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -630,6 +630,22 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x86 *c)
>  #endif
>
>  #ifdef CONFIG_ACPI_CPPC_LIB
> +
> +static u64 get_amd_max_boost_ratio(unsigned int cpu, u64 nominal_perf)
> +{
> +       u64 boost_ratio, cppc_max_perf;
> +
> +       if (!nominal_perf)
> +               return 0;
> +
> +       cppc_max_perf = amd_get_highest_perf();
> +
> +       boost_ratio = div_u64(cppc_max_perf << SCHED_CAPACITY_SHIFT,
> +                             nominal_perf);
> +
> +       return boost_ratio;
> +}

The function above is not necessary if I'm not mistaken.

> +
>  static u64 get_max_boost_ratio(unsigned int cpu)
>  {
>         struct cppc_perf_caps perf_caps;
> @@ -646,6 +662,9 @@ static u64 get_max_boost_ratio(unsigned int cpu)
>                 return 0;
>         }
>
> +       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
> +               return get_amd_max_boost_ratio(cpu, perf_caps.nominal_perf);
> +
>         highest_perf = perf_caps.highest_perf;

The above can be written as

if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
        highest_perf = amd_get_highest_perf();
else
        highest_perf = perf_caps.highest_perf;

>         nominal_perf = perf_caps.nominal_perf;
>
> --

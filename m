Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500DB36DDE1
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 19:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241469AbhD1RJU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 28 Apr 2021 13:09:20 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:46880 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbhD1RJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 13:09:17 -0400
Received: by mail-ot1-f41.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso57111414otb.13;
        Wed, 28 Apr 2021 10:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XRDBCByww0vL9MgCGGo6Hdw4kgbPrxOtEdQ74IIaHH8=;
        b=iLCs/WTr/G01D2BsEK4NM1CfH8DJbZZDUPWvidXa7opZlx99LkhhpQwQszK3wN7Eqe
         W7hPqrOF7/ggrkEoxEhyHFPK7c++tGHNuhKLhmG4/6DbXhvIuS4myrcwXiOcr+5E+zEW
         q4CPsh2+Gry0A0Ly9V1/BDtTu0lU+zndtYanbFkYOZ18eui/99bMtedctaurX8do7a6o
         uv+VRjSEIL2OomTxP/c+Hll53mZGUyUTjBv2ceH5PY9ZDabpGyfUeAXcciJwc2Pf/ECm
         D9xYWBy9ouRhnJzzVoreaSMiFiMLNTq65kmSxaqaC5B8reqJ67saz3zrTXah0MkGUH6j
         GhCw==
X-Gm-Message-State: AOAM533aZUfL+mP5Xnk8FD6xKiBs/NVka9FpYkKx4KL9GDRg4M5j0VhU
        svuE5CtOmmHdPoYDdo4DP0UJPr3fK7Jb8ytmeIg=
X-Google-Smtp-Source: ABdhPJxkpe8aspOAWAyRe4i/C7nB4bTKA765mdqggQVleH1NcvnBD8ol9cUcb+B6N/GYYMYob/gf6zQ7CJXyuIX7UVs=
X-Received: by 2002:a05:6830:55b:: with SMTP id l27mr24621043otb.260.1619629712268;
 Wed, 28 Apr 2021 10:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210425073451.2557394-1-ray.huang@amd.com>
In-Reply-To: <20210425073451.2557394-1-ray.huang@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 28 Apr 2021 19:08:20 +0200
Message-ID: <CAJZ5v0ixmRzC4W0q5U+B+uHTYNNB2Wen=nzdGMOO+_Dpc3EujQ@mail.gmail.com>
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
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

On Sun, Apr 25, 2021 at 9:35 AM Huang Rui <ray.huang@amd.com> wrote:
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
> Changes from V2 -> V3:
> - Move the update into cppc_get_perf_caps() to correct the highest perf value in
>   the API.
>
> Changes from V3 -> V4:
> - Rollback to V2 implementation because acpi_cppc.c will be used by ARM as well.
>   It's not good to add x86-specific calling there.
> - Simplify the implementation of the functions.

All of my comments have been addressed, so:

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

and I'm expecting the x86 maintainers to take care of this patch.

> ---
>  arch/x86/include/asm/processor.h |  2 ++
>  arch/x86/kernel/cpu/amd.c        | 16 ++++++++++++++++
>  arch/x86/kernel/smpboot.c        |  2 +-
>  drivers/cpufreq/acpi-cpufreq.c   |  6 +++++-
>  4 files changed, 24 insertions(+), 2 deletions(-)
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
> index 347a956f71ca..bc3496669def 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
>                 break;
>         }
>  }
> +
> +u32 amd_get_highest_perf(void)
> +{
> +       struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +       if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> +                              (c->x86_model >= 0x70 && c->x86_model < 0x80)))
> +           return 166;
> +
> +       if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> +                              (c->x86_model >= 0x40 && c->x86_model < 0x70)))
> +           return 166;
> +
> +       return 225;
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
> index d1bbc16fba4b..7e7450453714 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -646,7 +646,11 @@ static u64 get_max_boost_ratio(unsigned int cpu)
>                 return 0;
>         }
>
> -       highest_perf = perf_caps.highest_perf;
> +       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
> +               highest_perf = amd_get_highest_perf();
> +       else
> +               highest_perf = perf_caps.highest_perf;
> +
>         nominal_perf = perf_caps.nominal_perf;
>
>         if (!highest_perf || !nominal_perf) {
> --
> 2.25.1
>

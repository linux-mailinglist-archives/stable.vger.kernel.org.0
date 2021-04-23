Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C9B3691C0
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 14:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhDWMKk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 23 Apr 2021 08:10:40 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:37500 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhDWMKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 08:10:40 -0400
Received: by mail-wr1-f50.google.com with SMTP id j5so47198125wrn.4;
        Fri, 23 Apr 2021 05:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xDdTkEz3jYFi8dUXVTGarIUd1p+hB/XaUF8ZoHdzxKE=;
        b=MEQ3EOr9cRHCbLPkOUIRAw7tg76gJEBgk1+qxqtkIxSpjRR5LoQfrKMnMLwZUrMSq0
         14x/73SdFEFsPfUzeLX9BLMNnMvVVuEFP0SoLvigXADK478dHt9tUT4oI557Pc6p1kNj
         ts5rsjpgwpYYkwvQhGLOjfS0QvtWqkZSSsKJZZT648XKK6+x89RBYmiM5OoqQPDpxXIV
         WYewnY7hDOxffW0AB17EEsfZ5PdkFMEFXgihi6K8OLHNEXZY2zvirpR9yMd2ymhL/n/t
         N3+q/+30PeoH2evI4sPU28psF2UhxlrKbLvawxjWwy7rBQ09kuhUcW4cUFzIAhLkjDcJ
         ejdQ==
X-Gm-Message-State: AOAM5338xnNMqSjG4cR2pl9tvEpouE1LtZNAsPQ4TXya5pBYnodmxO8Q
        C7r3qqarmakHmS2wanjzaprPjEdIFEkKCtt4IMA=
X-Google-Smtp-Source: ABdhPJz6Dsd6AmT5Ml2AN3hXNIf0bBPeLJMJ8jJ+HZwLeHyuVBpj92jgtzaurmQeTY9WijsB2pnBut47CZXK3N22T0k=
X-Received: by 2002:adf:9d81:: with SMTP id p1mr4477670wre.247.1619179801674;
 Fri, 23 Apr 2021 05:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210423023928.688767-1-ray.huang@amd.com>
In-Reply-To: <20210423023928.688767-1-ray.huang@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 23 Apr 2021 14:09:49 +0200
Message-ID: <CAJZ5v0iH0-YL-yVPSA2oJF7PGfQs5Tcv5ktH43xMLPAKysDXPw@mail.gmail.com>
Subject: Re: [PATCH v3] x86, sched: Fix the AMD CPPC maximum perf on some
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

On Fri, Apr 23, 2021 at 4:40 AM Huang Rui <ray.huang@amd.com> wrote:
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
> ---
>  arch/x86/include/asm/processor.h |  2 ++
>  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
>  drivers/acpi/cppc_acpi.c         |  8 ++++++--
>  3 files changed, 30 insertions(+), 2 deletions(-)
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
> +
> +       switch (c->x86) {
> +       case 0x17:
> +               if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> +                   (c->x86_model >= 0x70 && c->x86_model < 0x80))
> +                       cppc_max_perf = 166;
> +               break;
> +       case 0x19:
> +               if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> +                   (c->x86_model >= 0x40 && c->x86_model < 0x70))
> +                       cppc_max_perf = 166;
> +               break;
> +       }
> +
> +       return cppc_max_perf;
> +}
> +EXPORT_SYMBOL_GPL(amd_get_highest_perf);
> diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
> index 69057fcd2c04..58e72b6e222f 100644
> --- a/drivers/acpi/cppc_acpi.c
> +++ b/drivers/acpi/cppc_acpi.c
> @@ -1107,8 +1107,12 @@ int cppc_get_perf_caps(int cpunum, struct cppc_perf_caps *perf_caps)
>                 }
>         }
>
> -       cpc_read(cpunum, highest_reg, &high);
> -       perf_caps->highest_perf = high;
> +       if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {

This is a generic arch-independent file.

Can we avoid adding the x86-specific check here?

> +               perf_caps->highest_perf = amd_get_highest_perf();
> +       } else {
> +               cpc_read(cpunum, highest_reg, &high);
> +               perf_caps->highest_perf = high;
> +       }
>
>         cpc_read(cpunum, lowest_reg, &low);
>         perf_caps->lowest_perf = low;
> --
> 2.25.1
>

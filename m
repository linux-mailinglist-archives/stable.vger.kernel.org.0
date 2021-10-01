Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA1841EB67
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 13:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352328AbhJALKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 07:10:01 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:44984 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhJALKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 07:10:00 -0400
Received: by mail-ot1-f45.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso10994656otb.11;
        Fri, 01 Oct 2021 04:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EtAHmQZw91u7lVU62l1P8pNTURuYrm0FshqcUyypknw=;
        b=RoSIKz2rg9h5aEA1hlf4lODjxJfRbfteOtdMZ8YRwmTYjTHmLcFIhENpXXuprCBTck
         PgoFVYPSvPfS1ugsFYT2Wq/F1ZvUbhtDhf/QC7hvazba0vudBFfAkjeFRRwb4nVOLSwQ
         I+G/U3BOUG9p2N9Ypyll7msf+3mKdeF3/F8FaZ2sBwu7cxMdA0ZZktO96EkD8dJI4+qB
         uTba0/ZyNaG4nGWt+1nuqlax4EoNGVnpRQ7OLKW8NVvOSoiISmG4Q66AxV+kqssFGpuF
         yk4obqn76KEzQFi60xWrFz6+jyrh2suKPLDZoZHYgDJoCYhEiqb86OS6Khlagx6DgH+s
         o5xQ==
X-Gm-Message-State: AOAM533grl42c5LmgVv8ZbOUvBxZwG9YxuLnd4/eWDNLvAApe1vdi0Hf
        DfrCZ2b7dIDApNfGrNIYVJjOdXvAVm6cdV+3blI=
X-Google-Smtp-Source: ABdhPJzo+0Q0KOxUoYQMmvMSP1UskRUfApAoeDtwjOT0KkLdiqigAI4XNGs0kPuGRX/q+zt3TgqAbNwDMkcP/x4w83Q=
X-Received: by 2002:a05:6830:165a:: with SMTP id h26mr9902807otr.301.1633086496224;
 Fri, 01 Oct 2021 04:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210929160550.GA773748@bhelgaas> <87mtnu77mr.ffs@tglx>
 <87k0iy71rw.ffs@tglx> <CAJZ5v0hH_h9V0dACEMomqZbwpQUf6GB_8UK9+S1AGEdFQqvPLQ@mail.gmail.com>
 <87h7e26lh9.ffs@tglx> <87czoq6kt8.ffs@tglx>
In-Reply-To: <87czoq6kt8.ffs@tglx>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 1 Oct 2021 13:08:04 +0200
Message-ID: <CAJZ5v0gCmRUF4PRoQzdQqf1sDieAgH-MY_=74HB+c_=VqW3qww@mail.gmail.com>
Subject: Re: [PATCH RFT v2] x86/hpet: Use another crystalball to evaluate HPET usability
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, jose.souza@intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Harry Pan <harry.pan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 7:21 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On recent Intel systems the HPET stops working when the system reaches PC10
> idle state.
>
> The approach of adding PCI ids to the early quirks to disable HPET on
> these systems is a whack a mole game which makes no sense.
>
> Check for PC10 instead and force disable HPET if supported. The check is
> overbroad as it does not take ACPI, intel_idle enablement and command
> line parameters into account. That's fine as long as there is at least
> PMTIMER available to calibrate the TSC frequency. The decision can be
> overruled by adding "hpet=force" on the kernel command line.
>
> Remove the related early PCI quirks for affected Ice Cake and Coffin Lake
> systems as they are not longer required. That should also cover all
> other systems, i.e. Tiger Rag and newer generations, which are most
> likely affected by this as well.
>
> Fixes: Yet another hardware trainwreck
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Not-yet-signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
> Notes: Completely untested. Use at your own peril.
>
> V2: Move the substate check into the helper function. Adjust function
>     name accordingly.
> ---
>  arch/x86/kernel/early-quirks.c |    6 ---
>  arch/x86/kernel/hpet.c         |   81 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 81 insertions(+), 6 deletions(-)
>
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -714,12 +714,6 @@ static struct chipset early_qrk[] __init
>          */
>         { PCI_VENDOR_ID_INTEL, 0x0f00,
>                 PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> -       { PCI_VENDOR_ID_INTEL, 0x3e20,
> -               PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> -       { PCI_VENDOR_ID_INTEL, 0x3ec4,
> -               PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> -       { PCI_VENDOR_ID_INTEL, 0x8a12,
> -               PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>         { PCI_VENDOR_ID_BROADCOM, 0x4331,
>           PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
>         {}
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -10,6 +10,7 @@
>  #include <asm/irq_remapping.h>
>  #include <asm/hpet.h>
>  #include <asm/time.h>
> +#include <asm/mwait.h>
>
>  #undef  pr_fmt
>  #define pr_fmt(fmt) "hpet: " fmt
> @@ -916,6 +917,83 @@ static bool __init hpet_counting(void)
>         return false;
>  }
>
> +static bool __init mwait_pc10_supported(void)
> +{
> +       unsigned int eax, ebx, ecx, mwait_substates;
> +
> +       if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +               return false;
> +
> +       if (!cpu_feature_enabled(X86_FEATURE_MWAIT))
> +               return false;
> +
> +       if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
> +               return false;
> +
> +       cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &mwait_substates);
> +
> +       return (ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) &&
> +              (ecx & CPUID5_ECX_INTERRUPT_BREAK) &&
> +              (mwait_substates & (0xF << 28));
> +}
> +
> +/*
> + * Check whether the system supports PC10. If so force disable HPET as that
> + * stops counting in PC10. This check is overbroad as it does not take any
> + * of the following into account:
> + *
> + *     - ACPI tables
> + *     - Enablement of intel_idle
> + *     - Command line arguments which limit intel_idle C-state support
> + *
> + * That's perfectly fine. HPET is a piece of hardware designed by committee
> + * and the only reasons why it is still in use on modern systems is the
> + * fact that it is impossible to reliably query TSC and CPU frequency via
> + * CPUID or firmware.
> + *
> + * If HPET is functional it is useful for calibrating TSC, but this can be
> + * done via PMTIMER as well which seems to be the last remaining timer on
> + * X86/INTEL platforms that has not been completely wreckaged by feature
> + * creep.
> + *
> + * In theory HPET support should be removed altogether, but there are older
> + * systems out there which depend on it because TSC and APIC timer are
> + * dysfunctional in deeper C-states.
> + *
> + * It's only 20 years now that hardware people have been asked to provide
> + * reliable and discoverable facilities which can be used for timekeeping
> + * and per CPU timer interrupts.
> + *
> + * The probability that this problem is going to be solved in the
> + * forseeable future is close to zero, so the kernel has to be cluttered
> + * with heuristics to keep up with the ever growing amount of hardware and
> + * firmware trainwrecks. Hopefully some day hardware people will understand
> + * that the approach of "This can be fixed in software" is not sustainable.
> + * Hope dies last...
> + */
> +static bool __init hpet_is_pc10_damaged(void)
> +{
> +       unsigned long long pcfg;
> +
> +       /* Check whether PC10 substates are supported */
> +       if (!mwait_pc10_supported())
> +               return false;
> +
> +       /* Check whether PC10 is enabled in PKG C-state limit */
> +       rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
> +       if ((pcfg & 0xF) < 8)
> +               return false;
> +
> +       if (hpet_force_user) {
> +               pr_warn("HPET force enabled via command line, but dysfunctional in PC10.\n");
> +               return false;
> +       }
> +
> +       pr_info("HPET dysfunctional in PC10. Force disabled.\n");
> +       boot_hpet_disable = true;
> +       return true;
> +}
> +
>  /**
>   * hpet_enable - Try to setup the HPET timer. Returns 1 on success.
>   */
> @@ -929,6 +1007,9 @@ int __init hpet_enable(void)
>         if (!is_hpet_capable())
>                 return 0;
>
> +       if (hpet_is_pc10_damaged())
> +               return 0;
> +
>         hpet_set_mapping();
>         if (!hpet_virt_address)
>                 return 0;
>

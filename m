Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F258541D8EE
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 13:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350459AbhI3Lkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 07:40:47 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:34632 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350447AbhI3Lkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 07:40:47 -0400
Received: by mail-oi1-f175.google.com with SMTP id z11so6866243oih.1;
        Thu, 30 Sep 2021 04:39:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OF8WgjDkn5DMrrHiDXmQjdfJ2oSSBgWc5DiKpL2YaMc=;
        b=ccKhff9/26d4gtXXFHzugv350PDDeqp3jyqlEDxkiG70MtFWMS7YXiEJj6khd4MYHg
         qphbC9ep1kjMvBIALPBI+pAeOqnJ69kKDTC12mxg9rkgsd+bhz9aL5azRwady/KcK7XX
         Qg6ZZ5nMCGkShqBMyIepdIKD+BzQ4euTZXZ7CubIc5+HPfudju2SYeDKUqS4Bk9uDpxj
         /RZTNk/+rprytZA+wfaiUM/ug3SwPrRpTYLe/5Za5ys/CBEwoRnbwBAicp6LYkDZR8Gt
         w1pw/sPqC/mGpdmoxjkj3CT9EPIvnYx7WrIqnubtMNKITI87eSO+Jux2rzacMXp4A/Nx
         k7LQ==
X-Gm-Message-State: AOAM532igI1Zj4abV4WQhAIIIt1uZgWzQg81gLfQZGP3FfSvrZuIl6sm
        i4Z1vt7qvshe2yNjslorpb6+8vd9Yi2L9/miYNs=
X-Google-Smtp-Source: ABdhPJzGv2yjHMUSCfYalGdVV97Bt0xmzL7z4pf0nELgDeJCp1+FiFJ6rh9QJM0381SamZrxoskT60XV1su7QJat9Aw=
X-Received: by 2002:a54:4f15:: with SMTP id e21mr2356796oiy.71.1633001944252;
 Thu, 30 Sep 2021 04:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210929160550.GA773748@bhelgaas> <87mtnu77mr.ffs@tglx> <87k0iy71rw.ffs@tglx>
In-Reply-To: <87k0iy71rw.ffs@tglx>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 30 Sep 2021 13:38:53 +0200
Message-ID: <CAJZ5v0hH_h9V0dACEMomqZbwpQUf6GB_8UK9+S1AGEdFQqvPLQ@mail.gmail.com>
Subject: Re: [PATCH RFT] x86/hpet: Use another crystalball to evaluate HPET usability
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
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
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Harry Pan <harry.pan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 1:15 PM Thomas Gleixner <tglx@linutronix.de> wrote:
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
> Remove the related early PCI quirks for affected Ice and Coffin Lake
> systems as they are not longer required.
>
> Fixes: Yet another hardware trainwreck
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Not-yet-signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> Notes: Completely untested. Use at your own peril.
> ---
>  arch/x86/kernel/early-quirks.c |    6 --
>  arch/x86/kernel/hpet.c         |   88 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 6 deletions(-)
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
> @@ -916,6 +917,90 @@ static bool __init hpet_counting(void)
>         return false;
>  }
>
> +static bool __init get_mwait_substates(unsigned int *mwait_substates)
> +{
> +       unsigned int eax, ebx, ecx;
> +
> +       if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +               return false;
> +
> +       if (!boot_cpu_has(X86_FEATURE_MWAIT))
> +               return false;
> +
> +       if (boot_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
> +               return false;
> +
> +       cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, mwait_substates);
> +
> +       if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
> +           !(ecx & CPUID5_ECX_INTERRUPT_BREAK) ||
> +           !*mwait_substates)
> +               return false;

I would do

return (ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) && (ecx &
CPUID5_ECX_INTERRUPT_BREAK) && *mwait_substates;

And this function could just return the mwait_substates value proper,
because returning 0 then would be equivalent to returning 'false' from
it as is.

LGTM otherwise.

> +
> +       return true;
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
> + * fact that it is impossible to reliably query the TSC frequency via
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
> +       unsigned int mwait_substates;
> +       unsigned long long pcfg;
> +
> +       if (!get_mwait_substates(&mwait_substates))
> +               return false;
> +
> +       /* Check whether PC10 substates are supported */
> +       if (!(mwait_substates & (0xF << 28)))
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
> @@ -929,6 +1014,9 @@ int __init hpet_enable(void)
>         if (!is_hpet_capable())
>                 return 0;
>
> +       if (hpet_is_pc10_damaged())
> +               return 0;
> +
>         hpet_set_mapping();
>         if (!hpet_virt_address)
>                 return 0;

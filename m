Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D733554E5
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242625AbhDFNWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:22:30 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:45816 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbhDFNW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 09:22:28 -0400
Received: by mail-ot1-f46.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so14550882oty.12;
        Tue, 06 Apr 2021 06:22:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VoWY/s77zLLDu+Op6P265Vg8YKwWqy+Vh24Ks0b7ijw=;
        b=JADnTbGDklp8ckWALguRNFBcgQocVHCWE164QOxNX7EBpl42mZRJeuJpPYneo3SX9K
         UacS8GdAMwFFAfTSMsFIoWEiKMEGXCRTkUyN7q8TpHGiFnSh/geKphzvgaD9BrmDQ7Ol
         len1TtUdy011uq3TYBbFbZ3wCsYuZezsiIv1g2SEMBWr2u6hlE8jeoOVRZqlp7p5+nZ7
         sTo5KVVKt9FVhA/FhkfIMusxrdconYYEwUbfeoPoyoNUEUUvGZq6lhsEnDujUEuY9w8w
         I4ta7VRYUgS7b4P1sal/nfvkdfO0/U6HSFvJpZQCeUcaqyHwC+83eEyrerdQoea9xedf
         2S7g==
X-Gm-Message-State: AOAM531vOlqqpO+wYmbU+0iD1G+lq3ObBp7Y1YbiS6s5Izqwwlx3ZzyM
        sT6f2PNqtSmwwvvupYZOxUFO58UMbHcaVBzdTNA=
X-Google-Smtp-Source: ABdhPJz2fyrytIoslGUKKUA2m10f98uEsyHqThzFXBrDG5t8ALIUf7K0wQGA9GduVuuduEo53PSsC6TXquOwEXFIy3k=
X-Received: by 2002:a05:6830:55b:: with SMTP id l27mr25959514otb.260.1617715338923;
 Tue, 06 Apr 2021 06:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210406125047.547501-1-vkuznets@redhat.com>
In-Reply-To: <20210406125047.547501-1-vkuznets@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 6 Apr 2021 15:22:00 +0200
Message-ID: <CAJZ5v0hpkF-acQAomZZKN=r00gNy831R7J-ZWZgWnoCJe5xSkg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 6, 2021 at 2:50 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Commit 8cdddd182bd7 ("ACPI: processor: Fix CPU0 wakeup in
> acpi_idle_play_dead()") tried to fix CPU0 hotplug breakage by copying
> wakeup_cpu0() + start_cpu0() logic from hlt_play_dead()//mwait_play_dead()
> into acpi_idle_play_dead(). The problem is that these functions are not
> exported to modules so when CONFIG_ACPI_PROCESSOR=m build fails.
>
> The issue could've been fixed by exporting both wakeup_cpu0()/start_cpu0()
> (the later from assembly) but it seems putting the whole pattern into a
> new function and exporting it instead is better.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 8cdddd182bd7 ("CPI: processor: Fix CPU0 wakeup in acpi_idle_play_dead()")
> Cc: <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/smp.h    |  2 +-
>  arch/x86/kernel/smpboot.c     | 15 ++++++++++-----
>  drivers/acpi/processor_idle.c |  3 +--
>  3 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 57ef2094af93..6f79deb1f970 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -132,7 +132,7 @@ void native_play_dead(void);
>  void play_dead_common(void);
>  void wbinvd_on_cpu(int cpu);
>  int wbinvd_on_all_cpus(void);
> -bool wakeup_cpu0(void);
> +void wakeup_cpu0_if_needed(void);
>
>  void native_smp_send_reschedule(int cpu);
>  void native_send_call_func_ipi(const struct cpumask *mask);
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index f877150a91da..9547d870ee27 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1659,7 +1659,7 @@ void play_dead_common(void)
>         local_irq_disable();
>  }
>
> -bool wakeup_cpu0(void)
> +static bool wakeup_cpu0(void)
>  {
>         if (smp_processor_id() == 0 && enable_start_cpu0)
>                 return true;
> @@ -1667,6 +1667,13 @@ bool wakeup_cpu0(void)
>         return false;
>  }
>
> +void wakeup_cpu0_if_needed(void)
> +{
> +       if (wakeup_cpu0())
> +               start_cpu0();

Note that all of the callers of wakeup_cpu0 do the above, so maybe
make them all use the new function?

In which case it can be rewritten in the following way

void cond_wakeup_cpu0(void)
{
        if (smp_processor_id() == 0 && enable_start_cpu0)
                start_cpu0();
}
EXPORT_SYMBOL_GPL(cond_wakeup_cpu0);

Also please add a proper kerneldoc comment to it and maybe drop the
comments at the call sites?


> +}
> +EXPORT_SYMBOL_GPL(wakeup_cpu0_if_needed);
> +
>  /*
>   * We need to flush the caches before going to sleep, lest we have
>   * dirty data in our caches when we come back up.
> @@ -1737,8 +1744,7 @@ static inline void mwait_play_dead(void)
>                 /*
>                  * If NMI wants to wake up CPU0, start CPU0.
>                  */
> -               if (wakeup_cpu0())
> -                       start_cpu0();
> +               wakeup_cpu0_if_needed();
>         }
>  }
>
> @@ -1752,8 +1758,7 @@ void hlt_play_dead(void)
>                 /*
>                  * If NMI wants to wake up CPU0, start CPU0.
>                  */
> -               if (wakeup_cpu0())
> -                       start_cpu0();
> +               wakeup_cpu0_if_needed();
>         }
>  }
>
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 768a6b4d2368..de15116b754a 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -545,8 +545,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
>
>  #if defined(CONFIG_X86) && defined(CONFIG_HOTPLUG_CPU)
>                 /* If NMI wants to wake up CPU0, start CPU0. */
> -               if (wakeup_cpu0())
> -                       start_cpu0();
> +               wakeup_cpu0_if_needed();
>  #endif
>         }
>
> --
> 2.30.2
>

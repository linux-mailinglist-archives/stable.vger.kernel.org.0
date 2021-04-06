Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F823557A0
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345602AbhDFPWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 11:22:50 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:44624 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhDFPWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 11:22:48 -0400
Received: by mail-ot1-f53.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso14961660oti.11;
        Tue, 06 Apr 2021 08:22:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sXwcRig3tvZ+Z4uaFJyjbcZ77bloTOBAk/tXd58gGqg=;
        b=oIERtfMfxiL/6WFEA9yX1IT8myMf4xQFDwD0x5xknZZoRGFHhqxodHhdD8nKosmf6p
         jEgmseIVLDYxhlrAG0FxzviUxV9FA3oex/TB45xTMsSbV4fiSEUko9QvTwR0r+5GIqA9
         Ng6WCEv12yvj4+XV4j+S6cQLyYdqWwg4TFzEU+b9flvNDi56GSxjn5d3d4coJi9QMXoH
         /wY9/kCjM/z+wAxaIAZfjf8u7eE1hawezFJcw30TE0Wdecs8Y2unGGAukV76D8LdCtOV
         /LGBrlaSmKSf1YyC9MVk+YVfQIfkaWQYJ+NilYiVH1H8QG2ZarlC9M53BYE0be43d5B8
         Yx3w==
X-Gm-Message-State: AOAM531xz4e2GzAyL9c6NPTimuzHT/L6GFFOT6k0rlG7fzD6xGfzI5d4
        Dv1dgfoygukS/MFi7gkgZf1OnBWfEIfu1sVL3YY=
X-Google-Smtp-Source: ABdhPJyAU3OaY8gRQ4/LiKT6/iD+IByZRCak85VRzGCbbqiiAqXMP3el70R2FFCVi3ltTRoozbuzNWYOl2YsOwnMYc4=
X-Received: by 2002:a05:6830:55b:: with SMTP id l27mr26387265otb.260.1617722558727;
 Tue, 06 Apr 2021 08:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210406140005.554402-1-vkuznets@redhat.com>
In-Reply-To: <20210406140005.554402-1-vkuznets@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 6 Apr 2021 17:22:27 +0200
Message-ID: <CAJZ5v0ixuM0HfVrrn47+vmTaBq8RS9b3nyKbbTr9qKQps_buYg@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
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

On Tue, Apr 6, 2021 at 4:01 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
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
> Changes since v1:
> - Rename wakeup_cpu0() to cond_wakeup_cpu0() and fold wakeup_cpu0() in
>  as it has no other users [Rafael J. Wysocki]
> ---
>  arch/x86/include/asm/smp.h    |  2 +-
>  arch/x86/kernel/smpboot.c     | 24 ++++++++++--------------
>  drivers/acpi/processor_idle.c |  4 +---
>  3 files changed, 12 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 57ef2094af93..630ff08532be 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -132,7 +132,7 @@ void native_play_dead(void);
>  void play_dead_common(void);
>  void wbinvd_on_cpu(int cpu);
>  int wbinvd_on_all_cpus(void);
> -bool wakeup_cpu0(void);
> +void cond_wakeup_cpu0(void);
>
>  void native_smp_send_reschedule(int cpu);
>  void native_send_call_func_ipi(const struct cpumask *mask);
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index f877150a91da..147f1bba9736 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1659,13 +1659,15 @@ void play_dead_common(void)
>         local_irq_disable();
>  }
>
> -bool wakeup_cpu0(void)
> +/*
> + * If NMI wants to wake up CPU0, start CPU0.
> + */

Hasn't checkpatch.pl complained about this?

A proper kerneldoc would be something like:

/**
 * cond_wakeup_cpu0 - Wake up CPU0 if needed.
 *
 * If NMI wants to wake up CPU0, start CPU0.
 */

> +void cond_wakeup_cpu0(void)
>  {
>         if (smp_processor_id() == 0 && enable_start_cpu0)
> -               return true;
> -
> -       return false;
> +               start_cpu0();
>  }
> +EXPORT_SYMBOL_GPL(cond_wakeup_cpu0);
>
>  /*
>   * We need to flush the caches before going to sleep, lest we have
> @@ -1734,11 +1736,8 @@ static inline void mwait_play_dead(void)
>                 __monitor(mwait_ptr, 0, 0);
>                 mb();
>                 __mwait(eax, 0);
> -               /*
> -                * If NMI wants to wake up CPU0, start CPU0.
> -                */
> -               if (wakeup_cpu0())
> -                       start_cpu0();
> +
> +               cond_wakeup_cpu0();
>         }
>  }
>
> @@ -1749,11 +1748,8 @@ void hlt_play_dead(void)
>
>         while (1) {
>                 native_halt();
> -               /*
> -                * If NMI wants to wake up CPU0, start CPU0.
> -                */
> -               if (wakeup_cpu0())
> -                       start_cpu0();
> +
> +               cond_wakeup_cpu0();
>         }
>  }
>
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 768a6b4d2368..4e2d76b8b697 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -544,9 +544,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
>                         return -ENODEV;
>
>  #if defined(CONFIG_X86) && defined(CONFIG_HOTPLUG_CPU)
> -               /* If NMI wants to wake up CPU0, start CPU0. */
> -               if (wakeup_cpu0())
> -                       start_cpu0();
> +               cond_wakeup_cpu0();
>  #endif
>         }
>
> --
> 2.30.2
>

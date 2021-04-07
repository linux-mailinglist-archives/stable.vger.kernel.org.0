Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687A23572B6
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 19:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354620AbhDGRGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 13:06:33 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:46048 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354588AbhDGRG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 13:06:27 -0400
Received: by mail-ot1-f41.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so18730766oty.12;
        Wed, 07 Apr 2021 10:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=abnQRkdJvp2BPIa2wpxV2nwwLsa1/aF4RGi27RRL+2M=;
        b=kSu6+mb1EnRqHaiQyIfq6p+xPeurnN/oYfIQ5wyLJX2kJNHzGui1w4936WBjrNSqJJ
         NsaDHxpo2lTpITa+6AOY4jiQLNOB5sOjYaxq+wLVT0vXUQQ2AkdoeLZayMT+sxWcGcIc
         x5b/XXMyWwVp6FQuC0orW4BfK21SMqv67l9nB2kWhv66G43x9h+qkjL3j0ZblthcGKcb
         xB2XZVgUh8oBXMRrAfkqc/4HHomZhYcR1q8tQs19izoCJ0NewbLUErWayc+SSm+SG/IW
         ttTk7NZ5ONJ4AtAiIpq5ZTLogFJQuH0hIXT352McRmL5DeWHPkkf2mfnJUBPksgnxqO1
         xX5Q==
X-Gm-Message-State: AOAM532+ZP2LUWJGhMjhfvQ2ShiRQjBtWjLBwML78SS0CK4YwzWe02T8
        wUnCsXHuvnBUgEf1QRcNWW1CkK2IZmKLN78paVg=
X-Google-Smtp-Source: ABdhPJzCYFheOkHMIqBHjQXvEhsxnEDPLw9Y4mxOzFMKycSTj9M7XrhE/ivVZC6UEsO9Nyggo/LRjbivWc0B0LkQaBI=
X-Received: by 2002:a9d:4811:: with SMTP id c17mr3947200otf.206.1617815176928;
 Wed, 07 Apr 2021 10:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210406155640.564341-1-vkuznets@redhat.com>
In-Reply-To: <20210406155640.564341-1-vkuznets@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 7 Apr 2021 19:06:05 +0200
Message-ID: <CAJZ5v0gqSEzkja-eAOvWEFs=HLv=046sj=g03ukVFhDF0xUdTg@mail.gmail.com>
Subject: Re: [PATCH v3] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
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

On Tue, Apr 6, 2021 at 5:56 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
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

Applied as 5.12-rc material, thanks!

> ---
> Changes since v2:
> - Use proper kerneldoc format [Rafael J. Wysocki]
> ---
>  arch/x86/include/asm/smp.h    |  2 +-
>  arch/x86/kernel/smpboot.c     | 26 ++++++++++++--------------
>  drivers/acpi/processor_idle.c |  4 +---
>  3 files changed, 14 insertions(+), 18 deletions(-)
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
> index f877150a91da..16703c35a944 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1659,13 +1659,17 @@ void play_dead_common(void)
>         local_irq_disable();
>  }
>
> -bool wakeup_cpu0(void)
> +/**
> + * cond_wakeup_cpu0 - Wake up CPU0 if needed.
> + *
> + * If NMI wants to wake up CPU0, start CPU0.
> + */
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
> @@ -1734,11 +1738,8 @@ static inline void mwait_play_dead(void)
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
> @@ -1749,11 +1750,8 @@ void hlt_play_dead(void)
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC229355860
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 17:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244265AbhDFPpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 11:45:46 -0400
Received: from mail-ot1-f44.google.com ([209.85.210.44]:42547 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345925AbhDFPpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 11:45:45 -0400
Received: by mail-ot1-f44.google.com with SMTP id c24-20020a9d6c980000b02902662e210895so14556025otr.9;
        Tue, 06 Apr 2021 08:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yTsbcZ5ueDOcHEuYy1IjjBCedLT5t0EnLzbrpYTknTo=;
        b=cJEitDBNe7dDonEiaFuWuE0+Pr1ZAXClGEVx2bz/f1rSJ+2Lv2/fHI9QEPSzVdwzAT
         jOzW1fGf2iczXFhlLjYxm5kJVI/y9Aeu9Rzn8N119Soyn3obHTG/4QKbz7NymKq5H82z
         q7XCWgsNLWkmLXChOKp49ueh5roR47u2SezhfWRzzHhKYJkfOoQ14wea92Jz8QoPSsyi
         pMUWaTb2CwmL/2u040JIcXKBOX7sgvUcljNOjWX7aLEuJmzcMG9juUGQNoYdnhpEJ/f0
         3xNml9ujS4BD243Jw0lQ+j7N2S/82CWk2omiatrZ3HyoSlItdYKOlKDm7+HLwxYKi/am
         LucQ==
X-Gm-Message-State: AOAM533bLYZKj6lFNguuOrXgRVI8t2YTxNcRr3+8nOlJM+9YhcIlS9Hu
        INr8adCnfE8jSM91dho4WeTorvYJ6BzjGF4SUfY=
X-Google-Smtp-Source: ABdhPJyOD0R91kTbxndb6i8+oJKcHpftfnUdFFv0VDrJAfn8qsEsrrwQXFwO1QsexJDSvDRrKWG5GKrmR1FiTb1Sxxo=
X-Received: by 2002:a9d:4811:: with SMTP id c17mr28075800otf.206.1617723936165;
 Tue, 06 Apr 2021 08:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210406140005.554402-1-vkuznets@redhat.com> <CAJZ5v0ixuM0HfVrrn47+vmTaBq8RS9b3nyKbbTr9qKQps_buYg@mail.gmail.com>
 <87h7kjcti6.fsf@vitty.brq.redhat.com>
In-Reply-To: <87h7kjcti6.fsf@vitty.brq.redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 6 Apr 2021 17:45:25 +0200
Message-ID: <CAJZ5v0iQDNhvhWYvafZsOS+-Hjkbruu3SU2CetjhxPfrbpRa3w@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
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

On Tue, Apr 6, 2021 at 5:39 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> "Rafael J. Wysocki" <rafael@kernel.org> writes:
>
> > On Tue, Apr 6, 2021 at 4:01 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> Commit 8cdddd182bd7 ("ACPI: processor: Fix CPU0 wakeup in
> >> acpi_idle_play_dead()") tried to fix CPU0 hotplug breakage by copying
> >> wakeup_cpu0() + start_cpu0() logic from hlt_play_dead()//mwait_play_dead()
> >> into acpi_idle_play_dead(). The problem is that these functions are not
> >> exported to modules so when CONFIG_ACPI_PROCESSOR=m build fails.
> >>
> >> The issue could've been fixed by exporting both wakeup_cpu0()/start_cpu0()
> >> (the later from assembly) but it seems putting the whole pattern into a
> >> new function and exporting it instead is better.
> >>
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Fixes: 8cdddd182bd7 ("CPI: processor: Fix CPU0 wakeup in acpi_idle_play_dead()")
> >> Cc: <stable@vger.kernel.org> # 5.10+
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >> Changes since v1:
> >> - Rename wakeup_cpu0() to cond_wakeup_cpu0() and fold wakeup_cpu0() in
> >>  as it has no other users [Rafael J. Wysocki]
> >> ---
> >>  arch/x86/include/asm/smp.h    |  2 +-
> >>  arch/x86/kernel/smpboot.c     | 24 ++++++++++--------------
> >>  drivers/acpi/processor_idle.c |  4 +---
> >>  3 files changed, 12 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> >> index 57ef2094af93..630ff08532be 100644
> >> --- a/arch/x86/include/asm/smp.h
> >> +++ b/arch/x86/include/asm/smp.h
> >> @@ -132,7 +132,7 @@ void native_play_dead(void);
> >>  void play_dead_common(void);
> >>  void wbinvd_on_cpu(int cpu);
> >>  int wbinvd_on_all_cpus(void);
> >> -bool wakeup_cpu0(void);
> >> +void cond_wakeup_cpu0(void);
> >>
> >>  void native_smp_send_reschedule(int cpu);
> >>  void native_send_call_func_ipi(const struct cpumask *mask);
> >> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> >> index f877150a91da..147f1bba9736 100644
> >> --- a/arch/x86/kernel/smpboot.c
> >> +++ b/arch/x86/kernel/smpboot.c
> >> @@ -1659,13 +1659,15 @@ void play_dead_common(void)
> >>         local_irq_disable();
> >>  }
> >>
> >> -bool wakeup_cpu0(void)
> >> +/*
> >> + * If NMI wants to wake up CPU0, start CPU0.
> >> + */
> >
> > Hasn't checkpatch.pl complained about this?
> >
>
> No, it didn't.
>
> > A proper kerneldoc would be something like:
> >
> > /**
> >  * cond_wakeup_cpu0 - Wake up CPU0 if needed.
> >  *
> >  * If NMI wants to wake up CPU0, start CPU0.
> >  */
>
> Yea, I didn't do that partly because of my laziness but partly because
> I don't see much usage of this format in arch/x86/kernel/[smpboot.c]. I
> can certainly do v3 if it's prefered.

Yes, please.

Exported functions generally need proper kerneldoc comments.

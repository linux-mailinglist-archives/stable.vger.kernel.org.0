Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E142470A6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbgHQSNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390541AbgHQSM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 14:12:57 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6110AC061342
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 11:12:57 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x24so8829192lfe.11
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 11:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7yoDJoEA7vgq3GWujkt1bvWEISuJc569oCDBRXcp0LQ=;
        b=oAGoWeFyEp4ErQovLfIwgMmnPbn1pu/GKGb5fxo9wsdh6qi3jOnvmY7V7dCP/mg9iE
         moTJN0CTldA0hDCarFbJ/df/D7OvJwcbx82pBySGh4bZNxWQY9cQ9HB8EzFfDa3dl2Gg
         nNLfgkjKkmoYH/ircXshAHufiIAffsPkshYfU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7yoDJoEA7vgq3GWujkt1bvWEISuJc569oCDBRXcp0LQ=;
        b=CT/bOyo9hJMg5rryMqTy/RHsz6dav2Mq9TWA073vbTt5DsUjrGeKNEE4UFJN7nMKpp
         UaQw6AdF3LaEYWYVv3YtzojYGeG0x2Z+xzA6LUnysIobvOc1eMFQTdxXGQ8+NqaNDx2E
         BEV4k3fZ/PyHMgiVdBQPHamFqsyLqxLZTZvejbDrIN6eeO8kVnWsTa2WpZ/sPmjvqjsU
         nyQHehxa45/l4Lvj5N6UdAl4SoY9+LrcIzp0iqqpsTm1ewR/A7RtqMqzwgcybpWU5OYP
         DzdjRir3TCz10uvhqqOH/YeFBVTYLgvYnrK/i8gEVfT3ajzjlr00BjKZN/DA3kv5vanc
         Z5vQ==
X-Gm-Message-State: AOAM530245LbVb2RVj9xxOfuhDl6RMYd4maz22hOSTNKTPA8CDepR7yP
        PxyKl3hSAwh3+3kRvusWp86zWZYn7QB2oA==
X-Google-Smtp-Source: ABdhPJw8gtsVjCJO1xMY6MhyL7yupmwsz8ONELQK//RFE4oaVB/IKq/eDrruTcEY4AcB2pg13nkyMw==
X-Received: by 2002:a19:c7d0:: with SMTP id x199mr7952729lff.205.1597687975284;
        Mon, 17 Aug 2020 11:12:55 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id x26sm5212728ljm.53.2020.08.17.11.12.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 11:12:54 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id t6so18503188ljk.9
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 11:12:54 -0700 (PDT)
X-Received: by 2002:a05:651c:1b4:: with SMTP id c20mr7906945ljn.432.1597687973528;
 Mon, 17 Aug 2020 11:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200814213842.31151-1-ashok.raj@intel.com>
In-Reply-To: <20200814213842.31151-1-ashok.raj@intel.com>
From:   Evan Green <evgreen@chromium.org>
Date:   Mon, 17 Aug 2020 11:12:17 -0700
X-Gmail-Original-Message-ID: <CAE=gft6fQ7cLQO025TDYNF-d6xxMeGkOHVieMZDq6wAZ84NsGQ@mail.gmail.com>
Message-ID: <CAE=gft6fQ7cLQO025TDYNF-d6xxMeGkOHVieMZDq6wAZ84NsGQ@mail.gmail.com>
Subject: Re: [PATCH] x86/hotplug: Silence APIC only after all irq's are migrated
To:     Ashok Raj <ashok.raj@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ashok,
Thank you, Srikanth, and Sukumar for some very impressive debugging here.

On Fri, Aug 14, 2020 at 2:38 PM Ashok Raj <ashok.raj@intel.com> wrote:
>
> When offlining CPU's, fixup_irqs() migrates all interrupts away from the
> outgoing CPU to an online CPU. Its always possible the device sent an
> interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> lapic identifies such interrupts. apic_soft_disable() will not capture any
> new interrupts in IRR. This causes interrupts from device to be lost during
> cpu offline. The issue was found when explicitly setting MSI affinity to a
> CPU and immediately offlining it. It was simple to recreate with a USB
> ethernet device and doing I/O to it while the CPU is offlined. Lost
> interrupts happen even when Interrupt Remapping is enabled.
>
> Current code does apic_soft_disable() before migrating interrupts.
>
> native_cpu_disable()
> {
>         ...
>         apic_soft_disable();
>         cpu_disable_common();
>           --> fixup_irqs(); // Too late to capture anything in IRR.
> }
>
> Just fliping the above call sequence seems to hit the IRR checks
> and the lost interrupt is fixed for both legacy MSI and when
> interrupt remapping is enabled.
>
>
> Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
> Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>
> To: linux-kernel@vger.kernel.org
> To: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sukumar Ghorai <sukumar.ghorai@intel.com>
> Cc: Srikanth Nandamuri <srikanth.nandamuri@intel.com>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/smpboot.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index ffbd9a3d78d8..278cc9f92f2f 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1603,13 +1603,20 @@ int native_cpu_disable(void)
>         if (ret)
>                 return ret;
>
> +       cpu_disable_common();
>         /*
>          * Disable the local APIC. Otherwise IPI broadcasts will reach
>          * it. It still responds normally to INIT, NMI, SMI, and SIPI
> -        * messages.

I'm slightly unclear about whether interrupts are disabled at the core
by this point or not. I followed native_cpu_disable() up to
__cpu_disable(), up to take_cpu_down(). This is passed into a call to
stop_machine_cpuslocked(), where interrupts get disabled at the core.
So unless there's another path, it seems like interrupts are always
disabled at the core by this point.

If interrupts are always disabled, then the comment above is a little
obsolete, since we're not expecting to receive broadcast IPIs from
here on out anyway. We could clean up that comment in this change.

If there is a path to here where interrupts are still enabled at the
core, then we'd need to watch out, because this change now allows
broadcast IPIs to come in during cpu_disable_common(). That could be
bad. But I think that's not this case, so this should be ok.

> +        * messages. Its important to do apic_soft_disable() after
> +        * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
> +        * depends on IRR being set. After apic_soft_disable() CPU preserves
> +        * currently set IRR/ISR but new interrupts will not set IRR.
> +        * This causes interrupts sent to outgoing cpu before completion
> +        * of irq migration to be lost. Check SDM Vol 3 "10.4.7.2 Local
> +        * APIC State after It Has been Software Disabled" section for more
> +        * details.
>          */
>         apic_soft_disable();
> -       cpu_disable_common();
>
>         return 0;
>  }
> --
> 2.13.6
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299412524C7
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 02:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHZAks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 20:40:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53680 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgHZAks (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 20:40:48 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598402446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HaO5x8/tx8/TEeeBdOIpPppICl91lELHJsr2/I9eQcY=;
        b=AC8EL9XKyi6CLE1Xbltikg0JVYhPusspSySFRJ/n1/rTROjJe+xoci2RSwdjc5dA1ieKij
        NkIXwIGltidHm3JqidLy12dfo6vFG490kM2KXIiANr5SQSCM8cU619VDbsoVkNFWSoIGve
        mT8PndcyS/UMVcfhloz6tf3DFBY2XwHC+fYav0+pAWnTrixFb0jiD+xM7jyPWOd3IIbZ08
        IyKhe0EMOkNEUhh+DkpBj21hrqPTaXF4RhTFBoVBCiaI9aXUqbFGOqLUMMptklMBrpWqI6
        kRGG9M2Ow7pBjDADiTr6pnv8o7oNA1f/dRt65xmRdGo1/YJr3w3pt5AMbgbs9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598402446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HaO5x8/tx8/TEeeBdOIpPppICl91lELHJsr2/I9eQcY=;
        b=HcP8s3gaJehpKU/8ojIwFwBR9YDG31Rb8SAhDver5CXJwj9FH/O/ddbvXEX7NxgP6/xeRM
        8UDtfi6/dv01JiAA==
To:     Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org
Cc:     Ashok Raj <ashok.raj@intel.com>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/hotplug: Silence APIC only after all irq's are migrated
In-Reply-To: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
References: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
Date:   Wed, 26 Aug 2020 02:40:45 +0200
Message-ID: <87mu2iw86q.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ashok,

On Thu, Aug 20 2020 at 17:42, Ashok Raj wrote:
> When offlining CPUs, fixup_irqs() migrates all interrupts away from the
> outgoing CPU to an online CPU. It's always possible the device sent an
> interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> LAPIC identifies such interrupts. apic_soft_disable() will not capture any
> new interrupts in IRR. This causes interrupts from device to be lost during
> CPU offline. The issue was found when explicitly setting MSI affinity to a
> CPU and immediately offlining it. It was simple to recreate with a USB
> ethernet device and doing I/O to it while the CPU is offlined. Lost
> interrupts happen even when Interrupt Remapping is enabled.

New lines exist for a reason. They help to structure information. For
the content, please see below.

> Current code does apic_soft_disable() before migrating interrupts.
>
> native_cpu_disable()
> {
> 	...
> 	apic_soft_disable();
> 	cpu_disable_common();
> 	  --> fixup_irqs(); // Too late to capture anything in IRR.
> }
>
> Just flipping the above call sequence seems to hit the IRR checks
> and the lost interrupt is fixed for both legacy MSI and when
> interrupt remapping is enabled.

Seems to hit? Come on, we really want changelogs which are based on
facts and not on assumptions.

Aside of that, yes that's a really subtle one and thanks for tracking it
down! For some reason I never looked at that ordering, but now that you
stick it in front of me, it's pretty clear that this is the root cause.

>  	/*
>  	 * Disable the local APIC. Otherwise IPI broadcasts will reach
>  	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
> -	 * messages.
> +	 * messages. It's important to do apic_soft_disable() after
> +	 * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
> +	 * depends on IRR being set.

That sentence does not make sense to me.

> +       .... After apic_soft_disable() CPU preserves
> +	 * currently set IRR/ISR but new interrupts will not set IRR.

I agree with the IRR part, but ISR is simply impossible to be set in
this situation.

> +	 * This causes interrupts sent to outgoing CPU before completion
> +	 * of IRQ migration to be lost. Check SDM Vol 3 "10.4.7.2 Local
> +	 * APIC State after It Has been Software Disabled" section for more
> +	 * details.

Please do not use the SDM chapter number of today. It's going to be a
different one with the next version.

Something like this perhaps?

  	/*
  	 * Disable the local APIC. Otherwise IPI broadcasts will reach
  	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
 	 * messages.
         *
         * Disabling the APIC must happen after cpu_disable_common()
  	 * which invokes fixup_irqs().
         *
         * Disabling the APIC preserves already set bits in IRR, but
         * an interrupt arriving after disabling the local APIC does not
         * set the corresponding IRR bit.
         *
         * fixup_irqs() scans IRR for set bits so it can raise a not
  	 * yet handled interrupt on the new destination CPU via an IPI
         * but obviously it can't do so for IRR bits which are not set.
         * IOW, interrupts arriving after disabling the local APIC will
         * be lost.
         */

Hmm?

The changelog wants to have a corresponding update.

Thanks,

        tglx

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30C82525A0
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 04:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHZCuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 22:50:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:43488 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgHZCuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 22:50:25 -0400
IronPort-SDR: AD3rC23vJSXTCTdY/qmhmzqSj6y31LaVsL+uRoLWBWF3+TdENYaP8XdabuNjXjZYicbccjwXU/
 4rlWSKE4YE9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9724"; a="241042416"
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="241042416"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 19:50:24 -0700
IronPort-SDR: FaxD9fawf0eT3/3ggGueIVqhNP/8d9Yz0iZS5Nb5dppbghNmvSF2YVOiYKS/G5zxn1hjjU3vpD
 NNbf45X9y1Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,354,1592895600"; 
   d="scan'208";a="373243623"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga001.jf.intel.com with ESMTP; 25 Aug 2020 19:50:24 -0700
Date:   Tue, 25 Aug 2020 19:50:24 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v2] x86/hotplug: Silence APIC only after all irq's are
 migrated
Message-ID: <20200826025024.GB40407@otc-nc-03>
References: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
 <87mu2iw86q.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu2iw86q.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

On Wed, Aug 26, 2020 at 02:40:45AM +0200, Thomas Gleixner wrote:
> Ashok,
> 
> On Thu, Aug 20 2020 at 17:42, Ashok Raj wrote:
> > When offlining CPUs, fixup_irqs() migrates all interrupts away from the
> > outgoing CPU to an online CPU. It's always possible the device sent an
> > interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> > LAPIC identifies such interrupts. apic_soft_disable() will not capture any
> > new interrupts in IRR. This causes interrupts from device to be lost during
> > CPU offline. The issue was found when explicitly setting MSI affinity to a
> > CPU and immediately offlining it. It was simple to recreate with a USB
> > ethernet device and doing I/O to it while the CPU is offlined. Lost
> > interrupts happen even when Interrupt Remapping is enabled.
> 
> New lines exist for a reason. They help to structure information. For
> the content, please see below.

Will work on that :-)

> 
> > Current code does apic_soft_disable() before migrating interrupts.
> >
> > native_cpu_disable()
> > {
> > 	...
> > 	apic_soft_disable();
> > 	cpu_disable_common();
> > 	  --> fixup_irqs(); // Too late to capture anything in IRR.
> > }
> >
> > Just flipping the above call sequence seems to hit the IRR checks
> > and the lost interrupt is fixed for both legacy MSI and when
> > interrupt remapping is enabled.
> 
> Seems to hit? Come on, we really want changelogs which are based on
> facts and not on assumptions.

What I intended to convay was by placing a debug trace_printk() at
fixup_irqs(), it was *indeed* observed. Before the change I never noticed
that path being covered.

Just my Inglish (Indian English) tricking you :-).
Will make them sensible in the next update.

> 
> Aside of that, yes that's a really subtle one and thanks for tracking it
> down! For some reason I never looked at that ordering, but now that you
> stick it in front of me, it's pretty clear that this is the root cause.
> 
> >  	/*
> >  	 * Disable the local APIC. Otherwise IPI broadcasts will reach
> >  	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
> > -	 * messages.
> > +	 * messages. It's important to do apic_soft_disable() after
> > +	 * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
> > +	 * depends on IRR being set.
> 
> That sentence does not make sense to me.

Right, I was just stating the obvious. Since fixup_irqs() isn't called
right in that function, it was suggested to make that connection explicit.

Your writeup below is crystal.. so will replace with what you have below.


> 
> > +       .... After apic_soft_disable() CPU preserves
> > +	 * currently set IRR/ISR but new interrupts will not set IRR.
> 
> I agree with the IRR part, but ISR is simply impossible to be set in
> this situation. 

You are correct. I was trying to convey what the SDM said, but its probably
irrelavant for this discussion. 

> 
> > +	 * This causes interrupts sent to outgoing CPU before completion
> > +	 * of IRQ migration to be lost. Check SDM Vol 3 "10.4.7.2 Local
> > +	 * APIC State after It Has been Software Disabled" section for more
> > +	 * details.
> 
> Please do not use the SDM chapter number of today. It's going to be a
> different one with the next version.
> 
> Something like this perhaps?
> 
>   	/*
>   	 * Disable the local APIC. Otherwise IPI broadcasts will reach
>   	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
>  	 * messages.
>          *
>          * Disabling the APIC must happen after cpu_disable_common()
>   	 * which invokes fixup_irqs().
>          *
>          * Disabling the APIC preserves already set bits in IRR, but
>          * an interrupt arriving after disabling the local APIC does not
>          * set the corresponding IRR bit.
>          *
>          * fixup_irqs() scans IRR for set bits so it can raise a not
>   	 * yet handled interrupt on the new destination CPU via an IPI
>          * but obviously it can't do so for IRR bits which are not set.
>          * IOW, interrupts arriving after disabling the local APIC will
>          * be lost.
>          */
> 
> Hmm?
> 
> The changelog wants to have a corresponding update.

Will do ...

Cheers,
Ashok

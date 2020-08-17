Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C992471C4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbgHQSd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:33:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:20115 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391194AbgHQSdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 14:33:25 -0400
IronPort-SDR: UdlPOJnxxm+O/ZUYwfBL/z/tNYCRexoN2soL15b0jhfI8FYYQvTYrX4EZu0En96s4Nc/AI4iPb
 iRsWjReSWp7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="155861181"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="155861181"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 11:33:23 -0700
IronPort-SDR: nbGYDkBru5jWL+2XrTJFOCkkUau6lpQkhmK8HLE10iRovyCehiQV4xs8wtUebHn5lBZ+ToWdbL
 kSFs2d1qEeog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="440958545"
Received: from araj-mobl1.jf.intel.com ([10.254.122.10])
  by orsmga004.jf.intel.com with ESMTP; 17 Aug 2020 11:33:23 -0700
Date:   Mon, 17 Aug 2020 11:33:22 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Evan Green <evgreen@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH] x86/hotplug: Silence APIC only after all irq's are
 migrated
Message-ID: <20200817183322.GA11486@araj-mobl1.jf.intel.com>
References: <20200814213842.31151-1-ashok.raj@intel.com>
 <CAE=gft6fQ7cLQO025TDYNF-d6xxMeGkOHVieMZDq6wAZ84NsGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE=gft6fQ7cLQO025TDYNF-d6xxMeGkOHVieMZDq6wAZ84NsGQ@mail.gmail.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Evan

Some details below, 

On Mon, Aug 17, 2020 at 11:12:17AM -0700, Evan Green wrote:
> Hi Ashok,
> Thank you, Srikanth, and Sukumar for some very impressive debugging here.
> 
> On Fri, Aug 14, 2020 at 2:38 PM Ashok Raj <ashok.raj@intel.com> wrote:
> >
> > When offlining CPU's, fixup_irqs() migrates all interrupts away from the
> > outgoing CPU to an online CPU. Its always possible the device sent an
> > interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> > lapic identifies such interrupts. apic_soft_disable() will not capture any
> > new interrupts in IRR. This causes interrupts from device to be lost during
> > cpu offline. The issue was found when explicitly setting MSI affinity to a
> > CPU and immediately offlining it. It was simple to recreate with a USB
> > ethernet device and doing I/O to it while the CPU is offlined. Lost
> > interrupts happen even when Interrupt Remapping is enabled.
> >
> > Current code does apic_soft_disable() before migrating interrupts.
> >
> > native_cpu_disable()
> > {
> >         ...
> >         apic_soft_disable();
> >         cpu_disable_common();
> >           --> fixup_irqs(); // Too late to capture anything in IRR.
> > }
> >
> > Just fliping the above call sequence seems to hit the IRR checks
> > and the lost interrupt is fixed for both legacy MSI and when
> > interrupt remapping is enabled.
> >
> >
> > Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
> > Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
> > Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> >
> > To: linux-kernel@vger.kernel.org
> > To: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Sukumar Ghorai <sukumar.ghorai@intel.com>
> > Cc: Srikanth Nandamuri <srikanth.nandamuri@intel.com>
> > Cc: Evan Green <evgreen@chromium.org>
> > Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/x86/kernel/smpboot.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index ffbd9a3d78d8..278cc9f92f2f 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -1603,13 +1603,20 @@ int native_cpu_disable(void)
> >         if (ret)
> >                 return ret;
> >
> > +       cpu_disable_common();
> >         /*
> >          * Disable the local APIC. Otherwise IPI broadcasts will reach
> >          * it. It still responds normally to INIT, NMI, SMI, and SIPI
> > -        * messages.
> 
> I'm slightly unclear about whether interrupts are disabled at the core
> by this point or not. I followed native_cpu_disable() up to
> __cpu_disable(), up to take_cpu_down(). This is passed into a call to
> stop_machine_cpuslocked(), where interrupts get disabled at the core.
> So unless there's another path, it seems like interrupts are always
> disabled at the core by this point.

local_irq_disable() just does cli() which allows interrupts to trickle
in to the IRR bits, and once you do sti() things would flow back for
normal interrupt processing. 


> 
> If interrupts are always disabled, then the comment above is a little

Disable interrupts is different from disabling LAPIC. Once you do the
apic_soft_disable(), there is nothing flowing into the LAPIC except
for INIT, NMI, SMI and SIPI messages. 

This turns off the pipe for all other interrupts to enter LAPIC. Which
is different from doing a cli().


> obsolete, since we're not expecting to receive broadcast IPIs from
> here on out anyway. We could clean up that comment in this change.
> 
> If there is a path to here where interrupts are still enabled at the
> core, then we'd need to watch out, because this change now allows
> broadcast IPIs to come in during cpu_disable_common(). That could be
> bad. But I think that's not this case, so this should be ok.

Section SDM Vol3.b 10.4.7.2 says.

* The reception of any interrupt or transmission of any IPIs that are in 
  progress when the local APIC is disabled are completed before the local 
  APIC enters the software-disabled state.

It doesn't actually say much about broadcast IPI's, except broadcast 
NMI for instance, which is still permitted when cli() is set.

Hope this helps.

Cheers,
Ashok

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA9245316
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgHOV6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:58:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:63150 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgHOV6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Aug 2020 17:58:15 -0400
IronPort-SDR: chfJsoWD21AZCo8XmipsY48Gr8Xp3fPVJU5kSbNv3X3S4iNFbIXkyB8U6JWbDTnuVx9ArIdlsP
 crfC4UdWv/cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="153763269"
X-IronPort-AV: E=Sophos;i="5.76,315,1592895600"; 
   d="scan'208";a="153763269"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 22:58:07 -0700
IronPort-SDR: su0+2Bc+sf5a5AkUhAnKl1SwBt4M44H8rpqtoq3dBXweKweSiz9JoJjzqHl15/gQODauiDVSZq
 3jjjhZb3JdGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,315,1592895600"; 
   d="scan'208";a="291931077"
Received: from araj-mobl1.jf.intel.com ([10.254.83.48])
  by orsmga003.jf.intel.com with ESMTP; 14 Aug 2020 22:58:06 -0700
Date:   Fri, 14 Aug 2020 22:58:06 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH] x86/hotplug: Silence APIC only after all irq's are
 migrated
Message-ID: <20200815055806.GA3828@araj-mobl1.jf.intel.com>
References: <20200814213842.31151-1-ashok.raj@intel.com>
 <bb47f196-90e5-3f78-305b-122fc9192867@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb47f196-90e5-3f78-305b-122fc9192867@infradead.org>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Randy,


On Fri, Aug 14, 2020 at 04:25:32PM -0700, Randy Dunlap wrote:
> On 8/14/20 2:38 PM, Ashok Raj wrote:
> > When offlining CPU's, fixup_irqs() migrates all interrupts away from the
> 
>                  CPUs,

Thanks for catching these. I'll fix all these suggested changes in my next rev
Once i get additional feedback from Thomas.


> 
> > outgoing CPU to an online CPU. Its always possible the device sent an
> 
>                                  It's
> 
> > interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> > lapic identifies such interrupts. apic_soft_disable() will not capture any
> 
>   LAPIC
> 
> > new interrupts in IRR. This causes interrupts from device to be lost during
> > cpu offline. The issue was found when explicitly setting MSI affinity to a
> 
>   CPU
> 
> > CPU and immediately offlining it. It was simple to recreate with a USB
> > ethernet device and doing I/O to it while the CPU is offlined. Lost
> > interrupts happen even when Interrupt Remapping is enabled.
> > 
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
> > Just fliping the above call sequence seems to hit the IRR checks
> 
>        flipping
> 
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
> >  	if (ret)
> >  		return ret;
> >  
> > +	cpu_disable_common();
> >  	/*
> >  	 * Disable the local APIC. Otherwise IPI broadcasts will reach
> >  	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
> > -	 * messages.
> > +	 * messages. Its important to do apic_soft_disable() after
> 
> 	             It's
> 
> > +	 * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
> > +	 * depends on IRR being set. After apic_soft_disable() CPU preserves
> > +	 * currently set IRR/ISR but new interrupts will not set IRR.
> > +	 * This causes interrupts sent to outgoing cpu before completion
> 
> 	                                           CPU
> 
> > +	 * of irq migration to be lost. Check SDM Vol 3 "10.4.7.2 Local
> 
> 	      IRQ
> 
> > +	 * APIC State after It Has been Software Disabled" section for more
> > +	 * details.
> >  	 */
> >  	apic_soft_disable();
> > -	cpu_disable_common();
> >  
> >  	return 0;
> >  }
> > 
> 
> thanks.
> -- 
> ~Randy
> 

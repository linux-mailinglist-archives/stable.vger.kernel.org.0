Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FA824EED6
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgHWQsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 12:48:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:36920 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgHWQsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Aug 2020 12:48:51 -0400
IronPort-SDR: gYaEtC4C09WN3eSdGPnej3YUbl2S2k6lhKdUifcVsspTIutIu5umFI9ee6LVQWuUaQGlSQ+Qln
 0SnPt++mG3xA==
X-IronPort-AV: E=McAfee;i="6000,8403,9722"; a="217337468"
X-IronPort-AV: E=Sophos;i="5.76,345,1592895600"; 
   d="scan'208";a="217337468"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2020 09:48:50 -0700
IronPort-SDR: 0ht87XvZ53q/3W2CoVydxUjAnlEpxuU+TAcCwqoqni40dcjfonSCDKdy7wWC+ddzFuUDbBTaL1
 PIsc2/OfE0yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,345,1592895600"; 
   d="scan'208";a="321858908"
Received: from araj-mobl1.jf.intel.com ([10.254.85.84])
  by fmsmga004.fm.intel.com with ESMTP; 23 Aug 2020 09:48:49 -0700
Date:   Sun, 23 Aug 2020 09:48:49 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc:     Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        x86@kernel.org, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v2] x86/hotplug: Silence APIC only after all irq's are
 migrated
Message-ID: <20200823164848.GA29858@araj-mobl1.jf.intel.com>
References: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

I was wondering if you got a chance to take a look at this fix?

I had some mail issues recently and they showed up at lore after 2
days. I wasn't sure if you got the original mail, or maybe it didn't
make it. 

If you had a different way to fix it, we can try those out. 


On Thu, Aug 20, 2020 at 05:42:03PM -0700, Ashok Raj wrote:
> When offlining CPUs, fixup_irqs() migrates all interrupts away from the
> outgoing CPU to an online CPU. It's always possible the device sent an
> interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> LAPIC identifies such interrupts. apic_soft_disable() will not capture any
> new interrupts in IRR. This causes interrupts from device to be lost during
> CPU offline. The issue was found when explicitly setting MSI affinity to a
> CPU and immediately offlining it. It was simple to recreate with a USB
> ethernet device and doing I/O to it while the CPU is offlined. Lost
> interrupts happen even when Interrupt Remapping is enabled.
> 
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

On another note, we have tested both with and without the read
after write when programming MSI addr/data on the device. It didn't
seem to change the results. But I think its a useful one to add
for correctness.

https://lore.kernel.org/lkml/878si6rx7f.fsf@nanos.tec.linutronix.de/

This bug been eluding for a while. Looking for your feedback.

> 
> Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
> Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
> Reported-by: Evan Green <evgreen@chromium.org>
> Tested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Tested-by: Evan Green <evgreen@chromium.org>
> Reviewed-by: Evan Green <evgreen@chromium.org>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> ---
> v2:
> - Typos and fixes suggested by Randy Dunlap
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
> index 27aa04a95702..3016c3b627ce 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1594,13 +1594,20 @@ int native_cpu_disable(void)
>  	if (ret)
>  		return ret;
>  
> +	cpu_disable_common();
>  	/*
>  	 * Disable the local APIC. Otherwise IPI broadcasts will reach
>  	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
> -	 * messages.
> +	 * messages. It's important to do apic_soft_disable() after
> +	 * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
> +	 * depends on IRR being set. After apic_soft_disable() CPU preserves
> +	 * currently set IRR/ISR but new interrupts will not set IRR.
> +	 * This causes interrupts sent to outgoing CPU before completion
> +	 * of IRQ migration to be lost. Check SDM Vol 3 "10.4.7.2 Local
> +	 * APIC State after It Has been Software Disabled" section for more
> +	 * details.
>  	 */
>  	apic_soft_disable();
> -	cpu_disable_common();
>  
>  	return 0;
>  }
> -- 
> 2.7.4
> 

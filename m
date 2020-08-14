Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67C2245021
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 01:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgHNXZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 19:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgHNXZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 19:25:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA9DC061385;
        Fri, 14 Aug 2020 16:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Y0E0LZUHG1vNnpFUrQvEenCL5ANWUqlMtRfd74+R+f4=; b=ZMi+b2V2BDJLYdZu4LmYyLf93Y
        LbEZs4mp5zRmDlBM6rUd1xxVkoETDadYCD1tNb4NR1eEnLjlHBmJikkaxQHGKfiYd6gu0QD6k02IW
        pQtGg2/R9g33xhRbBmD9tEc+56RVqyONxwU2SfIULbdnHuXTXZqv7t1++M9gJIA0YO6QhITj2MXU1
        6o7LvvXW+a9O619rFSRW6yQ1UuicmRbsdcVnT56Afe8VRCFN1EIzqq6u5iXEeadBdPe+lvlOClcxP
        XguDnOrVDKZHfhxYAaX0lppoeLvnxXdA82xRSPw8VFNjNYF+fR9zMAh1yH/EX+XgP5/QxVclmiqTG
        h9k5CJ0Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6j4q-0003s4-1D; Fri, 14 Aug 2020 23:25:37 +0000
Subject: Re: [PATCH] x86/hotplug: Silence APIC only after all irq's are
 migrated
To:     Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Cc:     Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
References: <20200814213842.31151-1-ashok.raj@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bb47f196-90e5-3f78-305b-122fc9192867@infradead.org>
Date:   Fri, 14 Aug 2020 16:25:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200814213842.31151-1-ashok.raj@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/14/20 2:38 PM, Ashok Raj wrote:
> When offlining CPU's, fixup_irqs() migrates all interrupts away from the

                 CPUs,

> outgoing CPU to an online CPU. Its always possible the device sent an

                                 It's

> interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> lapic identifies such interrupts. apic_soft_disable() will not capture any

  LAPIC

> new interrupts in IRR. This causes interrupts from device to be lost during
> cpu offline. The issue was found when explicitly setting MSI affinity to a

  CPU

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
> Just fliping the above call sequence seems to hit the IRR checks

       flipping

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
>  	if (ret)
>  		return ret;
>  
> +	cpu_disable_common();
>  	/*
>  	 * Disable the local APIC. Otherwise IPI broadcasts will reach
>  	 * it. It still responds normally to INIT, NMI, SMI, and SIPI
> -	 * messages.
> +	 * messages. Its important to do apic_soft_disable() after

	             It's

> +	 * fixup_irqs(), because fixup_irqs() called from cpu_disable_common()
> +	 * depends on IRR being set. After apic_soft_disable() CPU preserves
> +	 * currently set IRR/ISR but new interrupts will not set IRR.
> +	 * This causes interrupts sent to outgoing cpu before completion

	                                           CPU

> +	 * of irq migration to be lost. Check SDM Vol 3 "10.4.7.2 Local

	      IRQ

> +	 * APIC State after It Has been Software Disabled" section for more
> +	 * details.
>  	 */
>  	apic_soft_disable();
> -	cpu_disable_common();
>  
>  	return 0;
>  }
> 

thanks.
-- 
~Randy


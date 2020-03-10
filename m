Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F7E180B4E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 23:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJWR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 18:17:28 -0400
Received: from 20.mo7.mail-out.ovh.net ([46.105.49.208]:53460 "EHLO
        20.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJWR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 18:17:28 -0400
X-Greylist: delayed 21596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 18:17:27 EDT
Received: from player762.ha.ovh.net (unknown [10.110.115.3])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 7E87E15207F
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 17:07:32 +0100 (CET)
Received: from kaod.org (unknown [129.41.47.1])
        (Authenticated sender: clg@kaod.org)
        by player762.ha.ovh.net (Postfix) with ESMTPSA id 2A00810445AEB;
        Tue, 10 Mar 2020 16:07:27 +0000 (UTC)
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Subject: Re: [PATCH 1/4] powerpc/xive: Use XIVE_BAD_IRQ instead of zero to
 catch non configured IPIs
To:     Greg Kurz <groug@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        stable@vger.kernel.org
References: <20200306150143.5551-1-clg@kaod.org>
 <20200306150143.5551-2-clg@kaod.org> <20200310160916.37de59c2@bahia.home>
Message-ID: <77a77566-7b5d-158c-a775-de30375ec553@kaod.org>
Date:   Tue, 10 Mar 2020 17:07:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310160916.37de59c2@bahia.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13493910384322906996
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffuvfhfkffffgggjggtgfesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpuddvledrgedurdegjedrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejiedvrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 4:09 PM, Greg Kurz wrote:
> On Fri,  6 Mar 2020 16:01:40 +0100
> Cédric Le Goater <clg@kaod.org> wrote:
> 
>> When a CPU is brought up, an IPI number is allocated and recorded
>> under the XIVE CPU structure. Invalid IPI numbers are tracked with
>> interrupt number 0x0.
>>
>> On the PowerNV platform, the interrupt number space starts at 0x10 and
>> this works fine. However, on the sPAPR platform, it is possible to
>> allocate the interrupt number 0x0 and this raises an issue when CPU 0
>> is unplugged. The XIVE spapr driver tracks allocated interrupt numbers
>> in a bitmask and it is not correctly updated when interrupt number 0x0
>> is freed. It stays allocated and it is then impossible to reallocate.
>>
>> Fix by using the XIVE_BAD_IRQ value instead of zero on both platforms.
>>
>> Reported-by: David Gibson <david@gibson.dropbear.id.au>
>> Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
>> Cc: stable@vger.kernel.org # v4.14+
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
>> ---
> 
> This looks mostly good. I'm juste wondering about potential overlooks:

Yes. Thanks for doing so. There are some non-obvious use of interrupt
numbers under the hood. 

One thing we should be adding is a comment on the different interrupt 
number spaces. The HW interrupt numbers, the EISN numbers found on the 
XIVE even queue and the Linux interrupt numbers are different spaces 
and have different limits. XIVE_BAD_IRQ was introduced for the EISN 
numbers and the patch is using this value for HW numbers. This is ok 
because it's more a tag than a limit.

> $ git grep 'if.*hw_i' arch/powerpc/ | egrep -v 'xics|XIVE_BAD_IRQ'
>
>
> arch/powerpc/kvm/book3s_xive.h:         if (out_hw_irq)
> arch/powerpc/kvm/book3s_xive.h:         if (out_hw_irq)
> arch/powerpc/kvm/book3s_xive_template.c:        else if (hw_irq && xd->flags & XIVE_IRQ_FLAG_EOI_FW)
> arch/powerpc/sysdev/xive/common.c:      else if (hw_irq && xd->flags & XIVE_IRQ_FLAG_EOI_FW) {
>
> This hw_irq check in xive_do_source_eoi() for example is related to:
> 
> 	/*
> 	 * Note: We pass "0" to the hw_irq argument in order to
> 	 * avoid calling into the backend EOI code which we don't
> 	 * want to do in the case of a re-trigger. Backends typically
> 	 * only do EOI for LSIs anyway.
> 	 */
> 	xive_do_source_eoi(0, xd);

that's a hack to skip the following part of the code in case of EOI 
being done through FW:

	else if (hw_irq && xd->flags & XIVE_IRQ_FLAG_EOI_FW) {
		/*
		 * The FW told us to call it. This happens for some
		 * interrupt sources that need additional HW whacking
		 * beyond the ESB manipulation. For example LPC interrupts
		 * on P9 DD1.0 needed a latch to be clared in the LPC bridge
		 * itself. The Firmware will take care of it.
		 */
		if (WARN_ON_ONCE(!xive_ops->eoi))
			return;
		xive_ops->eoi(hw_irq);

That was the case for PHB4 LSIs on P9 DD1 only. We could probably drop
the code in Linux unless similar bugs show up on new platforms.

> but it can get hw_irq from:
> 
> 	xive_do_source_eoi(xc->hw_ipi, &xc->ipi_data);

That part is fine. It's an IPI EOI.

> 
> It seems that these should use XIVE_BAD_IRQ as well or I'm missing
> something ?
> 
> arch/powerpc/sysdev/xive/common.c:      if (hw_irq)

This tests the XIVE IPI number which is mapped to 0 for all CPUs.
See xive_request_ipi() and xive_irq_domain_map()

C.

> arch/powerpc/sysdev/xive/common.c:              if (d->domain != xive_irq_domain || hw_irq == 0)
> 
> 
> 
>>  arch/powerpc/sysdev/xive/xive-internal.h |  7 +++++++
>>  arch/powerpc/sysdev/xive/common.c        | 12 +++---------
>>  arch/powerpc/sysdev/xive/native.c        |  4 ++--
>>  arch/powerpc/sysdev/xive/spapr.c         |  4 ++--
>>  4 files changed, 14 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/powerpc/sysdev/xive/xive-internal.h b/arch/powerpc/sysdev/xive/xive-internal.h
>> index 59cd366e7933..382980f4de2d 100644
>> --- a/arch/powerpc/sysdev/xive/xive-internal.h
>> +++ b/arch/powerpc/sysdev/xive/xive-internal.h
>> @@ -5,6 +5,13 @@
>>  #ifndef __XIVE_INTERNAL_H
>>  #define __XIVE_INTERNAL_H
>>  
>> +/*
>> + * A "disabled" interrupt should never fire, to catch problems
>> + * we set its logical number to this
>> + */
>> +#define XIVE_BAD_IRQ		0x7fffffff
>> +#define XIVE_MAX_IRQ		(XIVE_BAD_IRQ - 1)
>> +
>>  /* Each CPU carry one of these with various per-CPU state */
>>  struct xive_cpu {
>>  #ifdef CONFIG_SMP
>> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
>> index fa49193206b6..550baba98ec9 100644
>> --- a/arch/powerpc/sysdev/xive/common.c
>> +++ b/arch/powerpc/sysdev/xive/common.c
>> @@ -68,13 +68,6 @@ static u32 xive_ipi_irq;
>>  /* Xive state for each CPU */
>>  static DEFINE_PER_CPU(struct xive_cpu *, xive_cpu);
>>  
>> -/*
>> - * A "disabled" interrupt should never fire, to catch problems
>> - * we set its logical number to this
>> - */
>> -#define XIVE_BAD_IRQ		0x7fffffff
>> -#define XIVE_MAX_IRQ		(XIVE_BAD_IRQ - 1)
>> -
>>  /* An invalid CPU target */
>>  #define XIVE_INVALID_TARGET	(-1)
>>  
>> @@ -1153,7 +1146,7 @@ static int xive_setup_cpu_ipi(unsigned int cpu)
>>  	xc = per_cpu(xive_cpu, cpu);
>>  
>>  	/* Check if we are already setup */
>> -	if (xc->hw_ipi != 0)
>> +	if (xc->hw_ipi != XIVE_BAD_IRQ)
>>  		return 0;
>>  
>>  	/* Grab an IPI from the backend, this will populate xc->hw_ipi */
>> @@ -1190,7 +1183,7 @@ static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
>>  	/* Disable the IPI and free the IRQ data */
>>  
>>  	/* Already cleaned up ? */
>> -	if (xc->hw_ipi == 0)
>> +	if (xc->hw_ipi == XIVE_BAD_IRQ)
>>  		return;
>>  
>>  	/* Mask the IPI */
>> @@ -1346,6 +1339,7 @@ static int xive_prepare_cpu(unsigned int cpu)
>>  		if (np)
>>  			xc->chip_id = of_get_ibm_chip_id(np);
>>  		of_node_put(np);
>> +		xc->hw_ipi = XIVE_BAD_IRQ;
>>  
>>  		per_cpu(xive_cpu, cpu) = xc;
>>  	}
>> diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
>> index 0ff6b739052c..50e1a8e02497 100644
>> --- a/arch/powerpc/sysdev/xive/native.c
>> +++ b/arch/powerpc/sysdev/xive/native.c
>> @@ -312,7 +312,7 @@ static void xive_native_put_ipi(unsigned int cpu, struct xive_cpu *xc)
>>  	s64 rc;
>>  
>>  	/* Free the IPI */
>> -	if (!xc->hw_ipi)
>> +	if (xc->hw_ipi == XIVE_BAD_IRQ)
>>  		return;
>>  	for (;;) {
>>  		rc = opal_xive_free_irq(xc->hw_ipi);
>> @@ -320,7 +320,7 @@ static void xive_native_put_ipi(unsigned int cpu, struct xive_cpu *xc)
>>  			msleep(OPAL_BUSY_DELAY_MS);
>>  			continue;
>>  		}
>> -		xc->hw_ipi = 0;
>> +		xc->hw_ipi = XIVE_BAD_IRQ;
>>  		break;
>>  	}
>>  }
>> diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
>> index 55dc61cb4867..3f15615712b5 100644
>> --- a/arch/powerpc/sysdev/xive/spapr.c
>> +++ b/arch/powerpc/sysdev/xive/spapr.c
>> @@ -560,11 +560,11 @@ static int xive_spapr_get_ipi(unsigned int cpu, struct xive_cpu *xc)
>>  
>>  static void xive_spapr_put_ipi(unsigned int cpu, struct xive_cpu *xc)
>>  {
>> -	if (!xc->hw_ipi)
>> +	if (xc->hw_ipi == XIVE_BAD_IRQ)
>>  		return;
>>  
>>  	xive_irq_bitmap_free(xc->hw_ipi);
>> -	xc->hw_ipi = 0;
>> +	xc->hw_ipi = XIVE_BAD_IRQ;
>>  }
>>  #endif /* CONFIG_SMP */
>>  
> 


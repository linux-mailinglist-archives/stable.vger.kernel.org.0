Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB0B947C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 17:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404461AbfITPwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 11:52:44 -0400
Received: from foss.arm.com ([217.140.110.172]:46664 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404366AbfITPwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 11:52:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27AB1337;
        Fri, 20 Sep 2019 08:52:43 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02D853F575;
        Fri, 20 Sep 2019 08:52:41 -0700 (PDT)
Subject: Re: [PATCH 2/3] genirq/irqdomain: Re-check mapping after associate in
 irq_create_mapping()
To:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc:     Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Glavinic-Pecotic, Matija (EXT - DE/Ulm)" 
        <matija.glavinic-pecotic.ext@nokia.com>,
        "Adamski, Krzysztof (Nokia - PL/Wroclaw)" 
        <krzysztof.adamski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
 <20190912094343.5480-3-alexander.sverdlin@nokia.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <2c02b9d5-2394-7dcb-ee89-9950c6071dd1@kernel.org>
Date:   Fri, 20 Sep 2019 16:52:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912094343.5480-3-alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/09/2019 10:44, Sverdlin, Alexander (Nokia - DE/Ulm) wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> If two irq_create_mapping() calls perform a mapping of the same hwirq on
> two CPU cores in parallel they both will get 0 from irq_find_mapping(),
> both will allocate unique virq using irq_domain_alloc_descs() and both
> will finally irq_domain_associate() it. Giving different virq numbers
> to their callers.
> 
> In practice the first caller is usually an interrupt controller driver and
> the seconds is some device requesting the interrupt providede by the above
> interrupt controller.

I disagree with this "In practice". An irqchip controller should *very
rarely* call irq_create_mapping on its own. It usually indicates some
level of brokenness, unless the mapped interrupt is exposed by the
irqchip itself (the GIC maintenance interrupt, for example).

> In this case either the interrupt controller driver configures virq which
> is not the one being "associated" with hwirq, or the "slave" device
> requests the virq which is never being triggered.

Why should the interrupt controller configure that interrupt? On any
sane platform, the mapping should be created by the user of the
interrupt, and not by the provider.

This doesn't mean we shouldn't fix the irqdomain races, but I tend to
disagree with the analysis here.

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
>  kernel/irq/irqdomain.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 7bc07b6..176f2cc 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -675,13 +675,6 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  
>  	of_node = irq_domain_get_of_node(domain);
>  
> -	/* Check if mapping already exists */
> -	virq = irq_find_mapping(domain, hwirq);
> -	if (virq) {
> -		pr_debug("-> existing mapping on virq %d\n", virq);
> -		return virq;
> -	}
> -
>  	/* Allocate a virtual interrupt number */
>  	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node), NULL);
>  	if (virq <= 0) {
> @@ -691,7 +684,11 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  
>  	if (irq_domain_associate(domain, virq, hwirq)) {
>  		irq_free_desc(virq);
> -		return 0;
> +
> +		virq = irq_find_mapping(domain, hwirq);
> +		if (virq)
> +			pr_debug("-> existing mapping on virq %d\n", virq);

I'd rather you limit this second irq_find_mapping() to cases where we're
sure we've found a duplicate:

	ret = irq_domain_associate(domain, virq, hwirq);
	if (ret) {
		irq_free_desc(virq);
		if (ret == -EEXIST)
			return irq_find_mapping(domain, hwirq);

		return 0;
	}

> +		return virq;
>  	}
>  
>  	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
> 

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6217B9421
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404129AbfITPhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 11:37:48 -0400
Received: from foss.arm.com ([217.140.110.172]:46486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404128AbfITPhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 11:37:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDA7C337;
        Fri, 20 Sep 2019 08:37:47 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDB743F575;
        Fri, 20 Sep 2019 08:37:46 -0700 (PDT)
Subject: Re: [PATCH 1/3] genirq/irqdomain: Check for existing mapping in
 irq_domain_associate()
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
 <20190912094343.5480-2-alexander.sverdlin@nokia.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <3f12b315-b7bf-e0c3-7105-4c9c9536f52f@kernel.org>
Date:   Fri, 20 Sep 2019 16:37:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912094343.5480-2-alexander.sverdlin@nokia.com>
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
> irq_domain_associate() is the only place where irq_find_mapping() can be
> used reliably (under irq_domain_mutex) to make a decision if the mapping
> shall be created or not. Other calls to irq_find_mapping() (not under
> any lock) cannot be used for this purpose and lead to race conditions in
> particular inside irq_create_mapping().
> 
> Give the callers of irq_domain_associate() an ability to detect existing
> domain reliably by examining the return value.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
>  kernel/irq/irqdomain.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 3078d0e..7bc07b6 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -532,6 +532,7 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
>  			 irq_hw_number_t hwirq)
>  {
>  	struct irq_data *irq_data = irq_get_irq_data(virq);
> +	unsigned int eirq;
>  	int ret;
>  
>  	if (WARN(hwirq >= domain->hwirq_max,
> @@ -543,6 +544,16 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
>  		return -EINVAL;
>  
>  	mutex_lock(&irq_domain_mutex);
> +
> +	/* Check if mapping already exists */
> +	eirq = irq_find_mapping(domain, hwirq);
> +	if (eirq) {

nit: Just have

	if (irq_find_mapping(...)) {

and get rid the extra variable, given that it's not used for anything.

> +		mutex_unlock(&irq_domain_mutex);
> +		pr_debug("%s: conflicting mapping for hwirq 0x%x\n",
> +			 domain->name, (int)hwirq);
> +		return -EBUSY;

I'm overall OK with this, although I'd rather we return -EEXIST rather
than -EBUSY.

> +	}
> +
>  	irq_data->hwirq = hwirq;
>  	irq_data->domain = domain;
>  	if (domain->ops->map) {
> 

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...

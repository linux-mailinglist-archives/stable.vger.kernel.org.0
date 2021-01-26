Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE083043A0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 17:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392793AbhAZQTt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 26 Jan 2021 11:19:49 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2428 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391024AbhAZJ24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 04:28:56 -0500
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DQ1XZ0jQmz67gMH;
        Tue, 26 Jan 2021 17:24:46 +0800 (CST)
Received: from lhreml719-chm.china.huawei.com (10.201.108.70) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 10:28:03 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml719-chm.china.huawei.com (10.201.108.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 09:28:02 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.006; Tue, 26 Jan 2021 09:28:02 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] genirq/msi: Activate Multi-MSI early when
 MSI_FLAG_ACTIVATE_EARLY is set
Thread-Topic: [PATCH] genirq/msi: Activate Multi-MSI early when
 MSI_FLAG_ACTIVATE_EARLY is set
Thread-Index: AQHW8YM/ALz6HSUk/kKcnCo0G2LmYqo4alSggAAE+QCAATfw8A==
Date:   Tue, 26 Jan 2021 09:28:02 +0000
Message-ID: <d5ed824a4233402fab8a9900f7c55c9f@huawei.com>
References: <20210123122759.1781359-1-maz@kernel.org>
 <19ddad1517f0495d92c2248d04cf0d5c@huawei.com>
 <4e7ea548f1667410dd6197509ab15ef4@kernel.org>
In-Reply-To: <4e7ea548f1667410dd6197509ab15ef4@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.82.74]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 25 January 2021 14:49
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-kernel@vger.kernel.org; Thomas Gleixner <tglx@linutronix.de>; Bjorn
> Helgaas <bhelgaas@google.com>; stable@vger.kernel.org
> Subject: Re: [PATCH] genirq/msi: Activate Multi-MSI early when
> MSI_FLAG_ACTIVATE_EARLY is set
> 
> On 2021-01-25 14:39, Shameerali Kolothum Thodi wrote:
> >> -----Original Message-----
> >> From: Marc Zyngier [mailto:maz@kernel.org]
> >> Sent: 23 January 2021 12:28
> >> To: linux-kernel@vger.kernel.org
> >> Cc: Thomas Gleixner <tglx@linutronix.de>; Bjorn Helgaas
> >> <bhelgaas@google.com>; Shameerali Kolothum Thodi
> >> <shameerali.kolothum.thodi@huawei.com>; stable@vger.kernel.org
> >> Subject: [PATCH] genirq/msi: Activate Multi-MSI early when
> >> MSI_FLAG_ACTIVATE_EARLY is set
> >>
> >> When MSI_FLAG_ACTIVATE_EARLY is set (which is the case for PCI),
> >> we perform the activation of the interrupt (which in the case of
> >> PCI results in the endpoint being programmed) as soon as the
> >> interrupt is allocated.
> >>
> >> But it appears that this is only done for the first vector,
> >> introducing an inconsistent behaviour for PCI Multi-MSI.
> >>
> >> Fix it by iterating over the number of vectors allocated to
> >> each MSI descriptor. This is easily achieved by introducing
> >> a new "for_each_msi_vector" iterator, together with a tiny
> >> bit of refactoring.
> >>
> >> Fixes: f3b0946d629c ("genirq/msi: Make sure PCI MSIs are activated
> >> early")
> >> Reported-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> >> Signed-off-by: Marc Zyngier <maz@kernel.org>
> >> Cc: stable@vger.kernel.org
> >> ---
> >>  include/linux/msi.h |  6 ++++++
> >>  kernel/irq/msi.c    | 44 ++++++++++++++++++++------------------------
> >>  2 files changed, 26 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/include/linux/msi.h b/include/linux/msi.h
> >> index 360a0a7e7341..aef35fd1cf11 100644
> >> --- a/include/linux/msi.h
> >> +++ b/include/linux/msi.h
> >> @@ -178,6 +178,12 @@ struct msi_desc {
> >>  	list_for_each_entry((desc), dev_to_msi_list((dev)), list)
> >>  #define for_each_msi_entry_safe(desc, tmp, dev)	\
> >>  	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)),
> >> list)
> >> +#define for_each_msi_vector(desc, __irq, dev)				\
> >> +	for_each_msi_entry((desc), (dev))				\
> >> +		if ((desc)->irq)					\
> >> +			for (__irq = (desc)->irq;			\
> >> +			     __irq < ((desc)->irq + (desc)->nvec_used);	\
> >> +			     __irq++)
> >>
> >>  #ifdef CONFIG_IRQ_MSI_IOMMU
> >>  static inline const void *msi_desc_get_iommu_cookie(struct msi_desc
> >> *desc)
> >> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
> >> index 2c0c4d6d0f83..d924676c8781 100644
> >> --- a/kernel/irq/msi.c
> >> +++ b/kernel/irq/msi.c
> >> @@ -436,22 +436,22 @@ int __msi_domain_alloc_irqs(struct irq_domain
> >> *domain, struct device *dev,
> >>
> >>  	can_reserve = msi_check_reservation_mode(domain, info, dev);
> >>
> >> -	for_each_msi_entry(desc, dev) {
> >> -		virq = desc->irq;
> >> -		if (desc->nvec_used == 1)
> >> -			dev_dbg(dev, "irq %d for MSI\n", virq);
> >> -		else
> >> +	/*
> >> +	 * This flag is set by the PCI layer as we need to activate
> >> +	 * the MSI entries before the PCI layer enables MSI in the
> >> +	 * card. Otherwise the card latches a random msi message.
> >> +	 */
> >> +	if (!(info->flags & MSI_FLAG_ACTIVATE_EARLY))
> >> +		goto skip_activate;
> >
> > This will change the dbg print behavior. From the commit f3b0946d629c,
> > it looks like the below dev_dbg() code was there for
> > !MSI_FLAG_ACTIVATE_EARLY
> > case as well. Not sure how much this matters though.
> 
> I'm not sure this matters either. We may have relied on these statements
> some 6/7 years ago, as the whole hierarchy stuff was brand new, but we
> now have a much better debug infrastructure thanks to Thomas. I'd be
> totally in favour of dropping it.
> 
Ok.

Tested on D06 with gicv4 enabled and Guest MSI dev works fine.

FWIW,
   Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer



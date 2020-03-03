Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89779177D50
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCCRXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:23:21 -0500
Received: from foss.arm.com ([217.140.110.172]:50200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbgCCRXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:23:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC5852F;
        Tue,  3 Mar 2020 09:23:20 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2C7F3F534;
        Tue,  3 Mar 2020 09:23:19 -0800 (PST)
Subject: Re: [PATCH] iommu/dma: Fix MSI reservation allocation
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Eric Auger <eric.auger@redhat.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
References: <20200303115154.32263-1-maz@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <f0fc18a5-17a9-4c53-052b-00272bbd2691@arm.com>
Date:   Tue, 3 Mar 2020 17:23:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200303115154.32263-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/03/2020 11:51 am, Marc Zyngier wrote:
> The way cookie_init_hw_msi_region() allocates the iommu_dma_msi_page
> structures doesn't match the way iommu_put_dma_cookie() frees them.
> 
> The former performs a single allocation of all the required structures,
> while the latter tries to free them one at a time. It doesn't quite
> work for the main use case (the GICv3 ITS where the range is 64kB)
> when the base ganule size is 4kB.
> 
> This leads to a nice slab corruption on teardown, which is easily
> observable by simply creating a VF on a SRIOV-capable device, and
> tearing it down immediately (no need to even make use of it).
> 
> Fix it by allocating iommu_dma_msi_page structures one at a time.

Bleh, you know you're supposed to be using 64K pages on those things, 
right? :P

> Fixes: 7c1b058c8b5a3 ("iommu/dma: Handle IOMMU API reserved regions")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>   drivers/iommu/dma-iommu.c | 36 ++++++++++++++++++++++++------------
>   1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index a2e96a5fd9a7..01fa64856c12 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -171,25 +171,37 @@ static int cookie_init_hw_msi_region(struct iommu_dma_cookie *cookie,
>   		phys_addr_t start, phys_addr_t end)
>   {
>   	struct iova_domain *iovad = &cookie->iovad;
> -	struct iommu_dma_msi_page *msi_page;
> -	int i, num_pages;
> +	struct iommu_dma_msi_page *msi_page, *tmp;
> +	int i, num_pages, ret = 0;
> +	phys_addr_t base;
>   
> -	start -= iova_offset(iovad, start);
> +	base = start -= iova_offset(iovad, start);
>   	num_pages = iova_align(iovad, end - start) >> iova_shift(iovad);
>   
> -	msi_page = kcalloc(num_pages, sizeof(*msi_page), GFP_KERNEL);
> -	if (!msi_page)
> -		return -ENOMEM;
> -
>   	for (i = 0; i < num_pages; i++) {
> -		msi_page[i].phys = start;
> -		msi_page[i].iova = start;
> -		INIT_LIST_HEAD(&msi_page[i].list);
> -		list_add(&msi_page[i].list, &cookie->msi_page_list);
> +		msi_page = kmalloc(sizeof(*msi_page), GFP_KERNEL);
> +		if (!msi_page) {
> +			ret = -ENOMEM;

I think we can just return here and skip the cleanup below - by the time 
we get here the cookie itself has already been allocated and 
initialised, so even if iommu_dma_init_domain() fails someone else has 
already accepted the responsibility of calling iommu_put_dma_cookie() at 
some point later, which will clean up properly.

Cheers,
Robin.

> +			break;
> +		}
> +		msi_page->phys = start;
> +		msi_page->iova = start;
> +		INIT_LIST_HEAD(&msi_page->list);
> +		list_add(&msi_page->list, &cookie->msi_page_list);
>   		start += iovad->granule;
>   	}
>   
> -	return 0;
> +	if (ret) {
> +		list_for_each_entry_safe(msi_page, tmp,
> +					 &cookie->msi_page_list, list) {
> +			if (msi_page->phys >= base && msi_page->phys < start) {
> +				list_del(&msi_page->list);
> +				kfree(msi_page);
> +			}
> +		}
> +	}
> +
> +	return ret;
>   }
>   
>   static int iova_reserve_pci_windows(struct pci_dev *dev,
> 

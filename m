Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB5C179080
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 13:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbgCDMg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 07:36:59 -0500
Received: from foss.arm.com ([217.140.110.172]:33774 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388005AbgCDMg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 07:36:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E353731B;
        Wed,  4 Mar 2020 04:36:57 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0CDB3F6C4;
        Wed,  4 Mar 2020 04:36:56 -0800 (PST)
Subject: Re: [PATCH v2] iommu/dma: Fix MSI reservation allocation
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
References: <20200304111117.3540-1-maz@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <35a91284-619e-398a-decc-2e3879702335@arm.com>
Date:   Wed, 4 Mar 2020 12:36:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200304111117.3540-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/03/2020 11:11 am, Marc Zyngier wrote:
> The way cookie_init_hw_msi_region() allocates the iommu_dma_msi_page
> structures doesn't match the way iommu_put_dma_cookie() frees them.
> 
> The former performs a single allocation of all the required structures,
> while the latter tries to free them one at a time. It doesn't quite
> work for the main use case (the GICv3 ITS where the range is 64kB)
> when the base granule size is 4kB.
> 
> This leads to a nice slab corruption on teardown, which is easily
> observable by simply creating a VF on a SRIOV-capable device, and
> tearing it down immediately (no need to even make use of it).
> Fortunately, this only affects systems where the ITS isn't translated
> by the SMMU, which are both rare and non-standard.
> 
> Fix it by allocating iommu_dma_msi_page structures one at a time.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Fixes: 7c1b058c8b5a3 ("iommu/dma: Handle IOMMU API reserved regions")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> ---
> * From v1:
>    - Got rid of the superfluous error handling (Robin)
>    - Clarified that it only affects a very small set of systems
>    - Added Eric's RB (which I assume still stands)
> 
>   drivers/iommu/dma-iommu.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index a2e96a5fd9a7..ba128d1cdaee 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -177,15 +177,15 @@ static int cookie_init_hw_msi_region(struct iommu_dma_cookie *cookie,
>   	start -= iova_offset(iovad, start);
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
> +		if (!msi_page)
> +			return -ENOMEM;
> +
> +		msi_page->phys = start;
> +		msi_page->iova = start;
> +		INIT_LIST_HEAD(&msi_page->list);
> +		list_add(&msi_page->list, &cookie->msi_page_list);
>   		start += iovad->granule;
>   	}
>   
> 

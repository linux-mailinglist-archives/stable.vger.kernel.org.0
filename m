Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44B1177678
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 13:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgCCM4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 07:56:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43159 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728414AbgCCM4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 07:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583240171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StD01upWfLys6j/mJDiSTbKkVFO2v53vgbK9NTukAX0=;
        b=W6PJrARdrd4EiLTHvBK3Sot/q7iaBKI7V8HsGqaqgKgm9ULVrv6X7dgoVY8mv0s58KmcWZ
        Y4LmIy5NS1Kb+SiKzXzMbFI8yFX6zjkeU1wIeYVTlmfN63flUrVBJfYigckYdENYsIQ936
        5DI0OKTxk5EecvOWC8VM9A2LGVceTCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-RtCwRq53P9-lBmzYFQHFyQ-1; Tue, 03 Mar 2020 07:56:08 -0500
X-MC-Unique: RtCwRq53P9-lBmzYFQHFyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8BBDDB60;
        Tue,  3 Mar 2020 12:56:06 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F2885C1D6;
        Tue,  3 Mar 2020 12:56:04 +0000 (UTC)
Subject: Re: [PATCH] iommu/dma: Fix MSI reservation allocation
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>
References: <20200303115154.32263-1-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b340f887-5960-390c-948d-c1b8fa14adec@redhat.com>
Date:   Tue, 3 Mar 2020 13:56:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200303115154.32263-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,
On 3/3/20 12:51 PM, Marc Zyngier wrote:
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
> 
> Fixes: 7c1b058c8b5a3 ("iommu/dma: Handle IOMMU API reserved regions")
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/iommu/dma-iommu.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index a2e96a5fd9a7..01fa64856c12 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -171,25 +171,37 @@ static int cookie_init_hw_msi_region(struct iommu_dma_cookie *cookie,
>  		phys_addr_t start, phys_addr_t end)
>  {
>  	struct iova_domain *iovad = &cookie->iovad;
> -	struct iommu_dma_msi_page *msi_page;
> -	int i, num_pages;
> +	struct iommu_dma_msi_page *msi_page, *tmp;
> +	int i, num_pages, ret = 0;
> +	phys_addr_t base;
>  
> -	start -= iova_offset(iovad, start);
> +	base = start -= iova_offset(iovad, start);
>  	num_pages = iova_align(iovad, end - start) >> iova_shift(iovad);
>  
> -	msi_page = kcalloc(num_pages, sizeof(*msi_page), GFP_KERNEL);
> -	if (!msi_page)
> -		return -ENOMEM;
> -
>  	for (i = 0; i < num_pages; i++) {
> -		msi_page[i].phys = start;
> -		msi_page[i].iova = start;
> -		INIT_LIST_HEAD(&msi_page[i].list);
> -		list_add(&msi_page[i].list, &cookie->msi_page_list);
> +		msi_page = kmalloc(sizeof(*msi_page), GFP_KERNEL);
> +		if (!msi_page) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +		msi_page->phys = start;
> +		msi_page->iova = start;
> +		INIT_LIST_HEAD(&msi_page->list);
> +		list_add(&msi_page->list, &cookie->msi_page_list);
>  		start += iovad->granule;
>  	}
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
>  }
>  
>  static int iova_reserve_pci_windows(struct pci_dev *dev,
> 


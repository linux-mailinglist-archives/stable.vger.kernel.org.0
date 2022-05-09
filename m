Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F85C51F8BB
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiEIJvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiEIJ0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 05:26:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44A4918C063;
        Mon,  9 May 2022 02:22:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00EA71480;
        Mon,  9 May 2022 02:22:48 -0700 (PDT)
Received: from [10.57.80.111] (unknown [10.57.80.111])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B0153F66F;
        Mon,  9 May 2022 02:22:44 -0700 (PDT)
Message-ID: <de0befa1-8376-6891-abe8-12cd898fa5ab@arm.com>
Date:   Mon, 9 May 2022 10:22:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] iommu/dma: Fix iova map result check bug
Content-Language: en-GB
To:     yf.wang@mediatek.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Cc:     wsd_upstream@mediatek.com, Libo Kang <Libo.Kang@mediatek.com>,
        Yong Wu <yong.wu@mediatek.com>, Ning Li <Ning.Li@mediatek.com>,
        stable@vger.kernel.org
References: <20220507085204.16914-1-yf.wang@mediatek.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220507085204.16914-1-yf.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-05-07 09:52, yf.wang@mediatek.com wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> The data type of the return value of the iommu_map_sg_atomic
> is ssize_t, but the data type of iova size is size_t,
> e.g. one is int while the other is unsigned int.
> 
> When iommu_map_sg_atomic return value is compared with iova size,
> it will force the signed int to be converted to unsigned int, if
> iova map fails and iommu_map_sg_atomic return error code is less
> than 0, then (ret < iova_len) is false, which will to cause not
> do free iova, and the master can still successfully get the iova
> of map fail, which is not expected.
> 
> Therefore, we need to check the return value of iommu_map_sg_atomic
> in two cases according to whether it is less than 0.

Heh, it's always a fun day when I have to go back to the C standard to 
remind myself of the usual arithmetic conversions. But indeed this seems 
correct, and even though the double comparisons look a little 
non-obvious on their own I can't think of an objectively better 
alternative, so:

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
> Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.15.*
> ---
>   drivers/iommu/dma-iommu.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 09f6e1c0f9c0..2932281e93fc 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -776,6 +776,7 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
>   	unsigned int count, min_size, alloc_sizes = domain->pgsize_bitmap;
>   	struct page **pages;
>   	dma_addr_t iova;
> +	ssize_t ret;
>   
>   	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
>   	    iommu_deferred_attach(dev, domain))
> @@ -813,8 +814,8 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
>   			arch_dma_prep_coherent(sg_page(sg), sg->length);
>   	}
>   
> -	if (iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot)
> -			< size)
> +	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot);
> +	if (ret < 0 || ret < size)
>   		goto out_free_sg;
>   
>   	sgt->sgl->dma_address = iova;
> @@ -1209,7 +1210,7 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
>   	 * implementation - it knows better than we do.
>   	 */
>   	ret = iommu_map_sg_atomic(domain, iova, sg, nents, prot);
> -	if (ret < iova_len)
> +	if (ret < 0 || ret < iova_len)
>   		goto out_free_iova;
>   
>   	return __finalise_sg(dev, sg, nents, iova);

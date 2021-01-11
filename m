Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7279E2F1A88
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 17:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388952AbhAKQJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 11:09:23 -0500
Received: from foss.arm.com ([217.140.110.172]:60602 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387962AbhAKQJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 11:09:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50DDB31B;
        Mon, 11 Jan 2021 08:08:33 -0800 (PST)
Received: from [10.57.56.43] (unknown [10.57.56.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12FE93F70D;
        Mon, 11 Jan 2021 08:08:31 -0800 (PST)
Subject: Re: [PATCH] dma: mark unmapped DMA scatter/gather invalid
To:     Marc Orr <marcorr@google.com>, hch@lst.de,
        m.szyprowski@samsung.com, jxgao@google.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210111154335.23388-1-marcorr@google.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <dc6db6b4-88f1-4762-bd3b-edf3dd410366@arm.com>
Date:   Mon, 11 Jan 2021 16:08:25 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111154335.23388-1-marcorr@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-11 15:43, Marc Orr wrote:
> This patch updates dma_direct_unmap_sg() to mark each scatter/gather
> entry invalid, after it's unmapped. This fixes two issues:

s/fixes/bodges around (badly)/

> 1. It makes the unmapping code able to tolerate a double unmap.
> 2. It prevents the NVMe driver from erroneously treating an unmapped DMA
> address as mapped.
> 
> The bug that motivated this patch was the following sequence, which
> occurred within the NVMe driver, with the kernel flag `swiotlb=force`.
> 
> * NVMe driver calls dma_direct_map_sg()
> * dma_direct_map_sg() fails part way through the scatter gather/list
> * dma_direct_map_sg() calls dma_direct_unmap_sg() to unmap any entries
>    succeeded.
> * NVMe driver calls dma_direct_unmap_sg(), redundantly, leading to a
>    double unmap, which is a bug.

So why not just fix that actual bug?

> With this patch, a hadoop workload running on a cluster of three AMD
> SEV VMs, is able to succeed. Without the patch, the hadoop workload
> suffers application-level and even VM-level failures.
> 
> Tested-by: Jianxiong Gao <jxgao@google.com>
> Tested-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Jianxiong Gao <jxgao@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>   kernel/dma/direct.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index 0a4881e59aa7..3d9b17fe5771 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -374,9 +374,11 @@ void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sgl,
>   	struct scatterlist *sg;
>   	int i;
>   
> -	for_each_sg(sgl, sg, nents, i)
> +	for_each_sg(sgl, sg, nents, i) {
>   		dma_direct_unmap_page(dev, sg->dma_address, sg_dma_len(sg), dir,
>   			     attrs);
> +		sg->dma_address = DMA_MAPPING_ERROR;

There are more DMA API backends than just dma-direct, so while this 
might help paper over bugs when SWIOTLB is in use, it's not going to 
have any effect when those same bugs are hit under other circumstances. 
Once again, the moral of the story is that effort is better spent just 
fixing the bugs ;)

Robin.

> +	}
>   }
>   EXPORT_SYMBOL(dma_direct_unmap_sg);
>   #endif
> 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F65546BA44
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhLGLqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:46:09 -0500
Received: from foss.arm.com ([217.140.110.172]:57812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231338AbhLGLqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 06:46:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B96A611FB;
        Tue,  7 Dec 2021 03:42:38 -0800 (PST)
Received: from [10.57.34.58] (unknown [10.57.34.58])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A46E3F73B;
        Tue,  7 Dec 2021 03:42:36 -0800 (PST)
Message-ID: <c81305b0-c419-362a-073b-65150497d1d7@arm.com>
Date:   Tue, 7 Dec 2021 11:42:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v3] iommu/io-pgtable-arm-v7s: Add error handle for page
 table allocation failure
Content-Language: en-GB
To:     yf.wang@mediatek.com, will@kernel.org
Cc:     Guangming.Cao@mediatek.com, Libo.Kang@mediatek.com,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com,
        wsd_upstream@mediatek.com, stable@vger.kernel.org
References: <20211207094817.GA31382@willie-the-truck>
 <20211207113315.29109-1-yf.wang@mediatek.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20211207113315.29109-1-yf.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-12-07 11:33, yf.wang@mediatek.com wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> In __arm_v7s_alloc_table function:
> iommu call kmem_cache_alloc to allocate page table, this function
> allocate memory may fail, when kmem_cache_alloc fails to allocate
> table, call virt_to_phys will be abnomal and return unexpected phys
> and goto out_free, then call kmem_cache_free to release table will
> trigger KE, __get_free_pages and free_pages have similar problem,
> so add error handle for page table allocation failure.
> 
> Fixes: 29859aeb8a6ea ("iommu/io-pgtable-arm-v7s: Abort allocation when table address overflows the PTE")
> Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.10.*

Is this genuinely a realistic issue which distro users can hit? In 
practice, a system that can't allocate 2KB is already dead and almost 
certainly isn't coming back either way.

Still, v3 has managed to address my other review comments before I'd 
even finished writing them, so for the change itself,

Acked-by: Robin Murphy <robin.murphy@arm.com>

Thanks,
Robin.

> ---
> v3: Update patch
>      1. Remove unnecessary log print as suggested by Will.
>      2. Remove unnecessary condition check.
> v2: Cc stable@vger.kernel.org
>      1. This patch needs to be merged stable branch, add stable@vger.kernel.org
>         in mail list.
>      2. There is No new code change in v2.
> 
> ---
>   drivers/iommu/io-pgtable-arm-v7s.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
> index bfb6acb651e5..be066c1503d3 100644
> --- a/drivers/iommu/io-pgtable-arm-v7s.c
> +++ b/drivers/iommu/io-pgtable-arm-v7s.c
> @@ -246,13 +246,17 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
>   			__GFP_ZERO | ARM_V7S_TABLE_GFP_DMA, get_order(size));
>   	else if (lvl == 2)
>   		table = kmem_cache_zalloc(data->l2_tables, gfp);
> +
> +	if (!table)
> +		return NULL;
> +
>   	phys = virt_to_phys(table);
>   	if (phys != (arm_v7s_iopte)phys) {
>   		/* Doesn't fit in PTE */
>   		dev_err(dev, "Page table does not fit in PTE: %pa", &phys);
>   		goto out_free;
>   	}
> -	if (table && !cfg->coherent_walk) {
> +	if (!cfg->coherent_walk) {
>   		dma = dma_map_single(dev, table, size, DMA_TO_DEVICE);
>   		if (dma_mapping_error(dev, dma))
>   			goto out_free;
> 

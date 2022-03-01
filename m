Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0869F4C8D15
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiCAN5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 08:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiCAN5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 08:57:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CCE49F6EA;
        Tue,  1 Mar 2022 05:56:36 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66ABA1042;
        Tue,  1 Mar 2022 05:56:36 -0800 (PST)
Received: from [10.57.39.47] (unknown [10.57.39.47])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA0353F70D;
        Tue,  1 Mar 2022 05:56:34 -0800 (PST)
Message-ID: <b10031aa-8e49-70b3-b498-8aa6b7021fbb@arm.com>
Date:   Tue, 1 Mar 2022 13:56:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] iommu/iova: Reset max32_alloc_size after cleaning
 rcache in the fail path
Content-Language: en-GB
To:     yf.wang@mediatek.com
Cc:     wsd_upstream@mediatek.com, linux-kernel@vger.kernel.org,
        Libo.Kang@mediatek.com, iommu@lists.linux-foundation.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Ning.Li@mediatek.com,
        matthias.bgg@gmail.com, stable@vger.kernel.org, will@kernel.org
References: <20220301014246.5011-1-yf.wang@mediatek.com>
 <20220301015919.5116-1-yf.wang@mediatek.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220301015919.5116-1-yf.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-01 01:59, yf.wang--- via iommu wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> In alloc_iova_fast function, if __alloc_and_insert_iova_range fail,
> alloc_iova_fast will try flushing rcache and retry alloc iova, but
> this has an issue:
> 
> Since __alloc_and_insert_iova_range fail will set the current alloc
> iova size to max32_alloc_size (iovad->max32_alloc_size = size),
> when the retry is executed into the __alloc_and_insert_iova_range
> function, the retry action will be blocked by the check condition
> (size >= iovad->max32_alloc_size) and goto iova32_full directly,
> causes the action of retry regular alloc iova in
> __alloc_and_insert_iova_range to not actually be executed.
> 
> Based on the above, so need reset max32_alloc_size before retry alloc
> iova when alloc iova fail, that is set the initial dma_32bit_pfn value
> of iovad to max32_alloc_size, so that the action of retry alloc iova
> in __alloc_and_insert_iova_range can be executed.

Have you observed this making any difference in practice?

Given that both free_cpu_cached_iovas() and free_global_cached_iovas() 
call iova_magazine_free_pfns(), which calls remove_iova(), which calls 
__cached_rbnode_delete_update(), I'm thinking no...

Robin.

> Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.10.*
> ---
> v2: Cc stable@vger.kernel.org
>      1. This patch needs to be merged stable branch, add stable@vger.kernel.org
>         in mail list.
> 
> ---
>   drivers/iommu/iova.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b28c9435b898..0c085ae8293f 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -453,6 +453,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   retry:
>   	new_iova = alloc_iova(iovad, size, limit_pfn, true);
>   	if (!new_iova) {
> +		unsigned long flags;
>   		unsigned int cpu;
>   
>   		if (!flush_rcache)
> @@ -463,6 +464,12 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   		for_each_online_cpu(cpu)
>   			free_cpu_cached_iovas(cpu, iovad);
>   		free_global_cached_iovas(iovad);
> +
> +		/* Reset max32_alloc_size after flushing rcache for retry */
> +		spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> +		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
> +		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +
>   		goto retry;
>   	}
>   
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9B2665B11
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 13:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjAKML0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 07:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbjAKMLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 07:11:14 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2ED97262A;
        Wed, 11 Jan 2023 04:11:12 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1F2BFEC;
        Wed, 11 Jan 2023 04:11:53 -0800 (PST)
Received: from [10.57.68.138] (unknown [10.57.68.138])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7D313F71A;
        Wed, 11 Jan 2023 04:11:09 -0800 (PST)
Message-ID: <02f259fe-1c6f-834b-c29d-aaf2a0595adb@arm.com>
Date:   Wed, 11 Jan 2023 12:11:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] iommu/iova: Fix alloc iova overflows issue
Content-Language: en-GB
To:     yf.wang@mediatek.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:IOMMU DMA-API LAYER" <iommu@lists.linux.dev>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Cc:     wsd_upstream@mediatek.com, stable@vger.kernel.org,
        Libo Kang <Libo.Kang@mediatek.com>,
        Yong Wu <yong.wu@mediatek.com>, Ning Li <Ning.Li@mediatek.com>,
        jianjiao zeng <jianjiao.zeng@mediatek.com>
References: <20230111063801.25107-1-yf.wang@mediatek.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20230111063801.25107-1-yf.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-11 06:38, yf.wang@mediatek.com wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> In __alloc_and_insert_iova_range, there is an issue that retry_pfn
> overflows. The value of iovad->anchor.pfn_hi is ~0UL, then when
> iovad->cached_node is iovad->anchor, curr_iova->pfn_hi + 1 will
> overflow. As a result, if the retry logic is executed, low_pfn is
> updated to 0, and then new_pfn < low_pfn returns false to make the
> allocation successful.
> 
> This issue occurs in the following two situations:
> 1. The first iova size exceeds the domain size. When initializing
> iova domain, iovad->cached_node is assigned as iovad->anchor. For
> example, the iova domain size is 10M, start_pfn is 0x1_F000_0000,
> and the iova size allocated for the first time is 11M. The
> following is the log information, new->pfn_lo is smaller than
> iovad->cached_node.
> 
> Example log as follows:
> [  223.798112][T1705487] sh: [name:iova&]__alloc_and_insert_iova_range
> start_pfn:0x1f0000,retry_pfn:0x0,size:0xb00,limit_pfn:0x1f0a00
> [  223.799590][T1705487] sh: [name:iova&]__alloc_and_insert_iova_range
> success start_pfn:0x1f0000,new->pfn_lo:0x1efe00,new->pfn_hi:0x1f08ff
> 
> 2. The node with the largest iova->pfn_lo value in the iova domain
> is deleted, iovad->cached_node will be updated to iovad->anchor,
> and then the alloc iova size exceeds the maximum iova size that can
> be allocated in the domain.
> 
> After judging that retry_pfn is less than limit_pfn, call retry_pfn+1
> to fix the overflow issue.
> 
> Signed-off-by: jianjiao zeng <jianjiao.zeng@mediatek.com>
> Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.15.*

Fixes: 4e89dce72521 ("iommu/iova: Retry from last rb tree node if iova search fails")

Acked-by: Robin Murphy <robin.murphy@arm.com>

> ---
> v2: Update patch
>      1. Cc stable@vger.kernel.org
>         This patch needs to be merged stable branch,
>         add stable@vger.kernel.org in mail list.
>      2. Refer robin's suggestion to update patch.
> 
> ---
>   drivers/iommu/iova.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index a44ad92fc5eb..fe452ce46642 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -197,7 +197,7 @@ static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
>   
>   	curr = __get_cached_rbnode(iovad, limit_pfn);
>   	curr_iova = to_iova(curr);
> -	retry_pfn = curr_iova->pfn_hi + 1;
> +	retry_pfn = curr_iova->pfn_hi;
>   
>   retry:
>   	do {
> @@ -211,7 +211,7 @@ static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
>   	if (high_pfn < size || new_pfn < low_pfn) {
>   		if (low_pfn == iovad->start_pfn && retry_pfn < limit_pfn) {
>   			high_pfn = limit_pfn;
> -			low_pfn = retry_pfn;
> +			low_pfn = retry_pfn + 1;
>   			curr = iova_find_limit(iovad, limit_pfn);
>   			curr_iova = to_iova(curr);
>   			goto retry;

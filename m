Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CACD4CD5D1
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 15:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiCDOEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 09:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239756AbiCDOEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 09:04:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF6A8532D8;
        Fri,  4 Mar 2022 06:03:25 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7893E1424;
        Fri,  4 Mar 2022 06:03:25 -0800 (PST)
Received: from [10.57.39.47] (unknown [10.57.39.47])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7E423F70D;
        Fri,  4 Mar 2022 06:03:23 -0800 (PST)
Message-ID: <906a446e-3e25-5813-d380-de699a84b6f4@arm.com>
Date:   Fri, 4 Mar 2022 14:03:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] iommu/iova: Free all CPU rcache for retry when iova alloc
 failure
Content-Language: en-GB
To:     yf.wang@mediatek.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Cc:     wsd_upstream@mediatek.com, Libo Kang <Libo.Kang@mediatek.com>,
        stable@vger.kernel.org, Ning Li <Ning.Li@mediatek.com>
References: <20220304044635.4273-1-yf.wang@mediatek.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220304044635.4273-1-yf.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-04 04:46, yf.wang--- via iommu wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> In alloc_iova_fast function, if an iova alloc request fail,
> it will free the iova ranges present in the percpu iova
> rcaches and free global iova rcache and then retry, but
> flushing CPU iova rcaches only for each online CPU, which
> will cause incomplete rcache cleaning, and iova rcaches of
> not online CPU cannot be flushed, because iova rcaches may
> also lead to fragmentation of iova space, so the next retry
> action may still be fail.
> 
> Based on the above, so need to flushing all iova rcaches
> for each possible CPU, use for_each_possible_cpu instead of
> for_each_online_cpu like in free_iova_rcaches function,
> so that all rcaches can be completely released to try
> replenishing IOVAs.

OK, so either there's a mystery bug where IOVAs somehow get freed on 
offline CPUs, or the hotplug notifier isn't working correctly, or you've 
contrived a situation where alloc_iova_fast() is actually racing against 
iova_cpuhp_dead(). In the latter case, the solution is "don't do that".

This change should not be necessary.

Thanks,
Robin.

> Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.4.*
> ---
>   drivers/iommu/iova.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b28c9435b898..5a0637cd7bc2 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -460,7 +460,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   
>   		/* Try replenishing IOVAs by flushing rcache. */
>   		flush_rcache = false;
> -		for_each_online_cpu(cpu)
> +		for_each_possible_cpu(cpu)
>   			free_cpu_cached_iovas(cpu, iovad);
>   		free_global_cached_iovas(iovad);
>   		goto retry;
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

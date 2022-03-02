Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B1D4CA395
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 12:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbiCBL1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 06:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238986AbiCBL1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 06:27:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7CA9606E0;
        Wed,  2 Mar 2022 03:26:30 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 925091424;
        Wed,  2 Mar 2022 03:26:30 -0800 (PST)
Received: from [10.57.39.47] (unknown [10.57.39.47])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC3ED3F70D;
        Wed,  2 Mar 2022 03:26:28 -0800 (PST)
Message-ID: <ca208635-449b-2c94-7317-09ed8eb86a2c@arm.com>
Date:   Wed, 2 Mar 2022 11:26:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] iommu/iova: Reset max32_alloc_size after cleaning
Content-Language: en-GB
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     wsd_upstream@mediatek.com, linux-kernel@vger.kernel.org,
        Libo.Kang@mediatek.com, yf.wang@mediatek.com,
        iommu@lists.linux-foundation.org,
        linux-mediatek@lists.infradead.org, Ning.Li@mediatek.com,
        matthias.bgg@gmail.com, stable@vger.kernel.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <b10031aa-8e49-70b3-b498-8aa6b7021fbb@arm.com>
 <20220301232953.17331-1-miles.chen@mediatek.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220301232953.17331-1-miles.chen@mediatek.com>
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

On 2022-03-01 23:29, Miles Chen via iommu wrote:
> Hi Yunfei,
> 
>>> Since __alloc_and_insert_iova_range fail will set the current alloc
>>> iova size to max32_alloc_size (iovad->max32_alloc_size = size),
>>> when the retry is executed into the __alloc_and_insert_iova_range
>>> function, the retry action will be blocked by the check condition
>>> (size >= iovad->max32_alloc_size) and goto iova32_full directly,
>>> causes the action of retry regular alloc iova in
>>> __alloc_and_insert_iova_range to not actually be executed.
>>>
>>> Based on the above, so need reset max32_alloc_size before retry alloc
>>> iova when alloc iova fail, that is set the initial dma_32bit_pfn value
>>> of iovad to max32_alloc_size, so that the action of retry alloc iova
>>> in __alloc_and_insert_iova_range can be executed.
>>
>> Have you observed this making any difference in practice?
>>
>> Given that both free_cpu_cached_iovas() and free_global_cached_iovas()
>> call iova_magazine_free_pfns(), which calls remove_iova(), which calls
>> __cached_rbnode_delete_update(), I'm thinking no...
>>
>> Robin.
>>
> 
> Like Robin pointed out, if some cached iovas are freed by
> free_global_cached_iovas()/free_cpu_cached_iovas(),
> the max32_alloc_size should be reset to iovad->dma_32bit_pfn.
> 
> If no cached iova is freed, resetting max32_alloc_size before
> the retry allocation only give us a retry. Is it possible that
> other users free their iovas during the additional retry?

No, it's not possible, since everyone's serialised by iova_rbtree_lock. 
If the caches were already empty and the retry gets the lock first, it 
will still fail again - forcing a reset of max32_alloc_size only means 
it has to take the slow path to that failure. If another caller *did* 
manage to get in and free something between free_global_cached_iovas() 
dropping the lock and alloc_iova() re-taking it, then that would have 
legitimately reset max32_alloc_size anyway.

Thanks,
Robin.

> alloc_iova_fast()
>    retry:
>      alloc_iova() // failed, iovad->max32_alloc_size = size
>      free_cpu_cached_iovas()
>        iova_magazine_free_pfns()
>          remove_iova()
> 	  __cached_rbnode_delete_update()
> 	    iovad->max32_alloc_size = iovad->dma_32bit_pfn // reset
>      free_global_cached_iovas()
>        iova_magazine_free_pfns()
>          remove_iova()
> 	  __cached_rbnode_delete_update()
> 	    iovad->max32_alloc_size = iovad->dma_32bit_pfn // reset
>      goto retry;
> 
> thanks,
> Miles
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

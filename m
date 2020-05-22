Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB1B1DE2F5
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 11:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgEVJYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 05:24:43 -0400
Received: from foss.arm.com ([217.140.110.172]:60006 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgEVJYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 05:24:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A94A1042;
        Fri, 22 May 2020 02:24:42 -0700 (PDT)
Received: from [10.57.2.168] (unknown [10.57.2.168])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFA263F305;
        Fri, 22 May 2020 02:24:40 -0700 (PDT)
Subject: Re: [PATCH] iommu/dma: limit iova free size to unmmaped iova
To:     guptap@codeaurora.org, Andrew Morton <akpm@linux-foundation.org>
Cc:     mhocko@suse.com, joro@8bytes.org, linux-mm@kvack.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        owner-linux-mm@kvack.org, stable@vger.kernel.org
References: <20200521113004.12438-1-guptap@codeaurora.org>
 <7aaa8dcc-6a47-f256-431d-2a1b034b4076@arm.com>
 <90662ef3123dbf2e93f9718ee5cc14a7@codeaurora.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <2d873ab9-ebb9-3c2d-f129-55a036ab47d0@arm.com>
Date:   Fri, 22 May 2020 10:24:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <90662ef3123dbf2e93f9718ee5cc14a7@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-22 07:25, guptap@codeaurora.org wrote:
> On 2020-05-22 01:46, Robin Murphy wrote:
>> On 2020-05-21 12:30, Prakash Gupta wrote:
>>> Limit the iova size while freeing based on unmapped size. In absence of
>>> this even with unmap failure, invalid iova is pushed to iova rcache and
>>> subsequently can cause panic while rcache magazine is freed.
>>
>> Can you elaborate on that panic?
>>
> We have seen couple of stability issues around this.
> Below is one such example:
> 
> kernel BUG at kernel/msm-4.19/drivers/iommu/iova.c:904!
> iova_magazine_free_pfns
> iova_rcache_insert
> free_iova_fast
> __iommu_unmap_page
> iommu_dma_unmap_page

OK, so it's not some NULL dereference or anything completely unexpected, 
that's good.

> It turned out an iova pfn 0 got into iova_rcache. One possibility I see is
> where client unmap with invalid dma_addr. The unmap call will fail and 
> warn on
> and still try to free iova. This will cause invalid pfn to be inserted into
> rcache. As and when the magazine with invalid pfn will be freed
> private_find_iova() will return NULL for invalid iova and meet bug 
> condition.

That would indeed be a bug in whatever driver made the offending 
dma_unmap call.

>>> Signed-off-by: Prakash Gupta <guptap@codeaurora.org>
>>>
>>> :100644 100644 4959f5df21bd 098f7d377e04 M    drivers/iommu/dma-iommu.c
>>>
>>> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
>>> index 4959f5df21bd..098f7d377e04 100644
>>> --- a/drivers/iommu/dma-iommu.c
>>> +++ b/drivers/iommu/dma-iommu.c
>>> @@ -472,7 +472,8 @@ static void __iommu_dma_unmap(struct device *dev, 
>>> dma_addr_t dma_addr,
>>>         if (!cookie->fq_domain)
>>>           iommu_tlb_sync(domain, &iotlb_gather);
>>> -    iommu_dma_free_iova(cookie, dma_addr, size);
>>> +    if (unmapped)
>>> +        iommu_dma_free_iova(cookie, dma_addr, unmapped);
>>
>> Frankly, if any part of the unmap fails then things have gone
>> catastrophically wrong already, but either way this isn't right. The
>> IOVA API doesn't support partial freeing - an IOVA *must* be freed
>> with its original size, or not freed at all, otherwise it will corrupt
>> the state of the rcaches and risk a cascade of further misbehaviour
>> for future callers.
>>
> I agree, we shouldn't be freeing the partial iova. Instead just making
> sure if unmap was successful should be sufficient before freeing iova. 
> So change
> can instead be something like this:
> 
> -    iommu_dma_free_iova(cookie, dma_addr, size);
> +    if (unmapped)
> +        iommu_dma_free_iova(cookie, dma_addr, size);
> 
>> TBH my gut feeling here is that you're really just trying to treat a
>> symptom of another bug elsewhere, namely some driver calling
>> dma_unmap_* or dma_free_* with the wrong address or size in the first
>> place.
>>
> This condition would arise only if driver calling dma_unmap/free_* with 0
> iova_pfn. This will be flagged with a warning during unmap but will trigger
> panic later on while doing unrelated dma_map/unmap_*. If unmapped has 
> already
> failed for invalid iova, there is no reason we should consider this as 
> valid
> iova and free. This part should be fixed.

I disagree. In general, if drivers call the DMA API incorrectly it is 
liable to lead to data loss, memory corruption, and various other 
unpleasant misbehaviour - it is not the DMA layer's job to attempt to 
paper over driver bugs.

There *is* an argument for downgrading the BUG_ON() in 
iova_magazine_free_pfns() to a WARN_ON(), since frankly it isn't a 
sufficiently serious condition to justify killing the whole machine 
immediately, but NAK to bodging the iommu-dma mid-layer to "fix" that. A 
serious bug already happened elsewhere, so trying to hide the fallout 
really doesn't help anyone.

Robin.

> On 2020-05-22 00:19, Andrew Morton wrote:
>> I think we need a cc:stable here?
>>
> Added now.
> 
> Thanks,
> Prakash

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5E81EBC99
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 15:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgFBNHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 09:07:21 -0400
Received: from foss.arm.com ([217.140.110.172]:50674 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbgFBNHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 09:07:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7A811FB;
        Tue,  2 Jun 2020 06:07:15 -0700 (PDT)
Received: from [10.57.10.95] (unknown [10.57.10.95])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BE473F305;
        Tue,  2 Jun 2020 06:07:13 -0700 (PDT)
Subject: Re: [PATCH] iommu/dma: limit iova free size to unmmaped iova
To:     guptap@codeaurora.org
Cc:     mhocko@suse.com, owner-linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200521113004.12438-1-guptap@codeaurora.org>
 <7aaa8dcc-6a47-f256-431d-2a1b034b4076@arm.com>
 <90662ef3123dbf2e93f9718ee5cc14a7@codeaurora.org>
 <2d873ab9-ebb9-3c2d-f129-55a036ab47d0@arm.com>
 <4ba082d3bb965524157704ea1ffb1ff4@codeaurora.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <9b5f8501-6e6e-0cd2-7f98-7cfea13051d7@arm.com>
Date:   Tue, 2 Jun 2020 14:07:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <4ba082d3bb965524157704ea1ffb1ff4@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-26 08:19, guptap@codeaurora.org wrote:
> On 2020-05-22 14:54, Robin Murphy wrote:
>> On 2020-05-22 07:25, guptap@codeaurora.org wrote:
>>> On 2020-05-22 01:46, Robin Murphy wrote:
>>>> On 2020-05-21 12:30, Prakash Gupta wrote:
>>> I agree, we shouldn't be freeing the partial iova. Instead just making
>>> sure if unmap was successful should be sufficient before freeing 
>>> iova. So change
>>> can instead be something like this:
>>>
>>> -    iommu_dma_free_iova(cookie, dma_addr, size);
>>> +    if (unmapped)
>>> +        iommu_dma_free_iova(cookie, dma_addr, size);
>>>
>>>> TBH my gut feeling here is that you're really just trying to treat a
>>>> symptom of another bug elsewhere, namely some driver calling
>>>> dma_unmap_* or dma_free_* with the wrong address or size in the first
>>>> place.
>>>>
>>> This condition would arise only if driver calling dma_unmap/free_* 
>>> with 0
>>> iova_pfn. This will be flagged with a warning during unmap but will 
>>> trigger
>>> panic later on while doing unrelated dma_map/unmap_*. If unmapped has 
>>> already
>>> failed for invalid iova, there is no reason we should consider this 
>>> as valid
>>> iova and free. This part should be fixed.
>>
>> I disagree. In general, if drivers call the DMA API incorrectly it is
>> liable to lead to data loss, memory corruption, and various other
>> unpleasant misbehaviour - it is not the DMA layer's job to attempt to
>> paper over driver bugs.
>>
>> There *is* an argument for downgrading the BUG_ON() in
>> iova_magazine_free_pfns() to a WARN_ON(), since frankly it isn't a
>> sufficiently serious condition to justify killing the whole machine
>> immediately, but NAK to bodging the iommu-dma mid-layer to "fix" that.
>> A serious bug already happened elsewhere, so trying to hide the
>> fallout really doesn't help anyone.
>>
> Sorry for delayed response, it was a long weekend.
> I agree that invalid DMA API call can result in unexpected issues and 
> client
> should fix it, but then the present behavior makes it difficult to catch 
> cases
> when driver is making wrong DMA API calls. When invalid iova pfn is 
> passed it
> doesn't fail then and there, though DMA layer is aware of iova being 
> invalid. It
> fails much after that in the context of an valid map/unmap, with BUG_ON().
> 
> Downgrading BUG_ON() to WARN_ON() in iova_magazine_free_pfns() will not 
> help
> much as invalid iova will cause NULL pointer dereference.

Obviously I didn't mean a literal s/BUG/WARN/ substitution - some 
additional control flow to actually handle the error case was implied.

I'll write up the patch myself, since it's easier than further debating.

> I see no reason why DMA layer wants to free an iova for which unmapped 
> failed.
> IMHO queuing an invalid iova (which already failed unmap) to rcache which
> eventually going to crash the system looks like iommu-dma layer issue.

What if the unmap fails because the address range is already entirely 
unmapped? Freeing the IOVA (or at least attempting to) would be 
logically appropriate in that case. In fact some IOMMU drivers might not 
even consider that a failure, so the DMA layer may not even be aware 
that it's been handed a bogus unallocated address.

The point is that unmapping *doesn't* fail under normal and correct 
operation, so the DMA layer should not expect to have to handle it. Even 
if it does happen, that's a highly exceptional case that the DMA layer 
cannot recover from by itself; at best it can just push the problem 
elsewhere. It's pretty hard to justify doing extra work to simply move 
an exceptional problem around without really addressing it.

And in this particular case, personally I would *much* rather see 
warnings spewing from both the pagetable and IOVA code as early as 
possible to clearly indicate that the DMA layer itself has been thrown 
out of sync, than just have warnings that might represent some other 
source of pagetable corruption (or at worst, depending on the pagetable 
code, no warnings at all and only have dma_map_*() calls quietly start 
failing much, much later due to all the IOVA space having been leaked by 
bad unmaps).

Robin.

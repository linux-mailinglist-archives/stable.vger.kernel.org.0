Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E91D1ECAA8
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 09:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgFCHhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 03:37:19 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:45006 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgFCHhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 03:37:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591169834; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=aJvFtRy1el1NP+Z5+87GQ+m2nk+T28gjost9JU7AaP0=;
 b=PU/U0R6QBn/US+5EVe/RcK5Q/1+pQSj7pcd7MajkxRtDyD/Cbta7zM8O02/SmuDnHFpI3MlA
 jBSxB3+qP9BxzeCETvMgfeh5K7sshTefxY632HblZFn/l8YjK3wxVzZRkTQ8BxUgBbP03iYM
 zwLzzOkEMrm1jTfF056E4PEBbF8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5ed75326cb04586933e89807 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Jun 2020 07:37:10
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 94CBFC43395; Wed,  3 Jun 2020 07:37:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: guptap)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D600BC433CA;
        Wed,  3 Jun 2020 07:37:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Jun 2020 13:07:08 +0530
From:   guptap@codeaurora.org
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     mhocko@suse.com, owner-linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] iommu/dma: limit iova free size to unmmaped iova
In-Reply-To: <9b5f8501-6e6e-0cd2-7f98-7cfea13051d7@arm.com>
References: <20200521113004.12438-1-guptap@codeaurora.org>
 <7aaa8dcc-6a47-f256-431d-2a1b034b4076@arm.com>
 <90662ef3123dbf2e93f9718ee5cc14a7@codeaurora.org>
 <2d873ab9-ebb9-3c2d-f129-55a036ab47d0@arm.com>
 <4ba082d3bb965524157704ea1ffb1ff4@codeaurora.org>
 <9b5f8501-6e6e-0cd2-7f98-7cfea13051d7@arm.com>
Message-ID: <4b6a864674a9231b3ac35e5ce0c7292f@codeaurora.org>
X-Sender: guptap@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-02 18:37, Robin Murphy wrote:
> On 2020-05-26 08:19, guptap@codeaurora.org wrote:
>> On 2020-05-22 14:54, Robin Murphy wrote:
>>> On 2020-05-22 07:25, guptap@codeaurora.org wrote:
>>>> On 2020-05-22 01:46, Robin Murphy wrote:
>>>>> On 2020-05-21 12:30, Prakash Gupta wrote:
>> Sorry for delayed response, it was a long weekend.
>> I agree that invalid DMA API call can result in unexpected issues and 
>> client
>> should fix it, but then the present behavior makes it difficult to 
>> catch cases
>> when driver is making wrong DMA API calls. When invalid iova pfn is 
>> passed it
>> doesn't fail then and there, though DMA layer is aware of iova being 
>> invalid. It
>> fails much after that in the context of an valid map/unmap, with 
>> BUG_ON().
>> 
>> Downgrading BUG_ON() to WARN_ON() in iova_magazine_free_pfns() will 
>> not help
>> much as invalid iova will cause NULL pointer dereference.
> 
> Obviously I didn't mean a literal s/BUG/WARN/ substitution - some
> additional control flow to actually handle the error case was implied.
> 
> I'll write up the patch myself, since it's easier than further 
> debating.
> 

I think it will address the issue I am facing as well. I will wait for 
your patch.

>> I see no reason why DMA layer wants to free an iova for which unmapped 
>> failed.
>> IMHO queuing an invalid iova (which already failed unmap) to rcache 
>> which
>> eventually going to crash the system looks like iommu-dma layer issue.
> 
> What if the unmap fails because the address range is already entirely
> unmapped? Freeing the IOVA (or at least attempting to) would be
> logically appropriate in that case. In fact some IOMMU drivers might
> not even consider that a failure, so the DMA layer may not even be
> aware that it's been handed a bogus unallocated address.
> 
> The point is that unmapping *doesn't* fail under normal and correct
> operation, so the DMA layer should not expect to have to handle it.
> Even if it does happen, that's a highly exceptional case that the DMA
> layer cannot recover from by itself; at best it can just push the
> problem elsewhere. It's pretty hard to justify doing extra work to
> simply move an exceptional problem around without really addressing
> it.
> 

iommu_unmap() expects that all areas within unmap size are mapped. 
infact It
abandons further unmap if it find any chunk not mapped.  So if an IOMMU
implementation is not returning failure for already unmapped area,
then it's prone to issue where DMA API reuse the IOVA, which is already 
mapped.

In this case where iommu implementation returns error for already 
unmapped area,
currently there is no way to distinguish an unmap failure due to range 
already
unmapped or say while partially unmapping a section map, memory 
allocation fails
and thus unmap returns failure.
In second case, we will free the iova even with mapping present. And 
subsequent
dma mapping will keep on failing if it uses this freed iova. For managed 
iova
both unmap/map should be done with dma APIs, it should be safe to expect 
if a
range is unmapped with DMA APIs corresponding iova is also freed, so 
there
shouldn't be a real need to free iova where unmap fails due to range 
already
entirely unmapped.

> And in this particular case, personally I would *much* rather see
> warnings spewing from both the pagetable and IOVA code as early as
> possible to clearly indicate that the DMA layer itself has been thrown
> out of sync, than just have warnings that might represent some other
> source of pagetable corruption (or at worst, depending on the
> pagetable code, no warnings at all and only have dma_map_*() calls
> quietly start failing much, much later due to all the IOVA space
> having been leaked by bad unmaps).
> 

I am not sure how useful is this freed iova if corresponding mappings 
are not
unmapped. We won't be able to use those iova. The subsequent iommu_map 
will fail
if using this freed iova. So it's important to ensure we only free iova 
which is
unmapped successfully.

Thanks,
Prakash

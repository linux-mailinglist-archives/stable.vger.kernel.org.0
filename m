Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C8C1DDFC2
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 08:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgEVGZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 02:25:56 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:48077 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbgEVGZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 02:25:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590128755; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=H359ESmKnUtSY7Q0hAO68B/54fVOQ0qzAvK2WHo9oz8=;
 b=nSlqKGOPTSt7Mxkmyc57AI+3wrGgD4yFjTaiNtsMTZ33a2dQEeI0iAugTmiePTEk1lHQuvcu
 zmTzcmMUjlDSVf5PqVkkLBRyH9ky1+xyFF5FTxfp4AsvTJz3mzSrBm428QYbOwRw6Co9OdsG
 s1pzRCLZVDYhNo53xw22d8oDa9E=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec77069.7fe5ffd92650-smtp-out-n05;
 Fri, 22 May 2020 06:25:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CB1F3C433C6; Fri, 22 May 2020 06:25:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: guptap)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB428C433C6;
        Fri, 22 May 2020 06:25:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 22 May 2020 11:55:44 +0530
From:   guptap@codeaurora.org
To:     Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mhocko@suse.com, joro@8bytes.org, linux-mm@kvack.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        owner-linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/dma: limit iova free size to unmmaped iova
In-Reply-To: <7aaa8dcc-6a47-f256-431d-2a1b034b4076@arm.com>
References: <20200521113004.12438-1-guptap@codeaurora.org>
 <7aaa8dcc-6a47-f256-431d-2a1b034b4076@arm.com>
Message-ID: <90662ef3123dbf2e93f9718ee5cc14a7@codeaurora.org>
X-Sender: guptap@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-22 01:46, Robin Murphy wrote:
> On 2020-05-21 12:30, Prakash Gupta wrote:
>> Limit the iova size while freeing based on unmapped size. In absence 
>> of
>> this even with unmap failure, invalid iova is pushed to iova rcache 
>> and
>> subsequently can cause panic while rcache magazine is freed.
> 
> Can you elaborate on that panic?
> 
We have seen couple of stability issues around this.
Below is one such example:

kernel BUG at kernel/msm-4.19/drivers/iommu/iova.c:904!
iova_magazine_free_pfns
iova_rcache_insert
free_iova_fast
__iommu_unmap_page
iommu_dma_unmap_page


It turned out an iova pfn 0 got into iova_rcache. One possibility I see 
is
where client unmap with invalid dma_addr. The unmap call will fail and 
warn on
and still try to free iova. This will cause invalid pfn to be inserted 
into
rcache. As and when the magazine with invalid pfn will be freed
private_find_iova() will return NULL for invalid iova and meet bug 
condition.

>> Signed-off-by: Prakash Gupta <guptap@codeaurora.org>
>> 
>> :100644 100644 4959f5df21bd 098f7d377e04 M	drivers/iommu/dma-iommu.c
>> 
>> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
>> index 4959f5df21bd..098f7d377e04 100644
>> --- a/drivers/iommu/dma-iommu.c
>> +++ b/drivers/iommu/dma-iommu.c
>> @@ -472,7 +472,8 @@ static void __iommu_dma_unmap(struct device *dev, 
>> dma_addr_t dma_addr,
>>     	if (!cookie->fq_domain)
>>   		iommu_tlb_sync(domain, &iotlb_gather);
>> -	iommu_dma_free_iova(cookie, dma_addr, size);
>> +	if (unmapped)
>> +		iommu_dma_free_iova(cookie, dma_addr, unmapped);
> 
> Frankly, if any part of the unmap fails then things have gone
> catastrophically wrong already, but either way this isn't right. The
> IOVA API doesn't support partial freeing - an IOVA *must* be freed
> with its original size, or not freed at all, otherwise it will corrupt
> the state of the rcaches and risk a cascade of further misbehaviour
> for future callers.
> 
I agree, we shouldn't be freeing the partial iova. Instead just making
sure if unmap was successful should be sufficient before freeing iova. 
So change
can instead be something like this:

-	iommu_dma_free_iova(cookie, dma_addr, size);
+	if (unmapped)
+		iommu_dma_free_iova(cookie, dma_addr, size);

> TBH my gut feeling here is that you're really just trying to treat a
> symptom of another bug elsewhere, namely some driver calling
> dma_unmap_* or dma_free_* with the wrong address or size in the first
> place.
> 
This condition would arise only if driver calling dma_unmap/free_* with 
0
iova_pfn. This will be flagged with a warning during unmap but will 
trigger
panic later on while doing unrelated dma_map/unmap_*. If unmapped has 
already
failed for invalid iova, there is no reason we should consider this as 
valid
iova and free. This part should be fixed.

On 2020-05-22 00:19, Andrew Morton wrote:
> I think we need a cc:stable here?
> 
Added now.

Thanks,
Prakash

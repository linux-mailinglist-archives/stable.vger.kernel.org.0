Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CAA1F51F5
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 12:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgFJKMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 06:12:50 -0400
Received: from foss.arm.com ([217.140.110.172]:56316 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbgFJKMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 06:12:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C8511FB;
        Wed, 10 Jun 2020 03:12:49 -0700 (PDT)
Received: from [10.57.9.128] (unknown [10.57.9.128])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7F7A3F7BB;
        Wed, 10 Jun 2020 03:12:47 -0700 (PDT)
Subject: Re: [PATCH] iommu/iova: Don't BUG on invalid PFNs
To:     guptap@codeaurora.org
Cc:     joro@8bytes.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <acbd2d092b42738a03a21b417ce64e27f8c91c86.1591103298.git.robin.murphy@arm.com>
 <79df62c92cf61f2b5f717c28d620a283@codeaurora.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <ae261494-4d38-11b1-37c2-0ab6a671a7d8@arm.com>
Date:   Wed, 10 Jun 2020 11:12:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <79df62c92cf61f2b5f717c28d620a283@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-10 10:27, guptap@codeaurora.org wrote:
> On 2020-06-02 18:38, Robin Murphy wrote:
>> Unlike the other instances which represent a complete loss of
>> consistency within the rcache mechanism itself, or a fundamental
>> and obvious misconfiguration by an IOMMU driver, the BUG_ON() in
>> iova_magazine_free_pfns() can be provoked at more or less any time
>> in a "spooky action-at-a-distance" manner by any old device driver
>> passing nonsense to dma_unmap_*() which then propagates through to
>> queue_iova().
>>
>> Not only is this well outside the IOVA layer's control, it's also
>> nowhere near fatal enough to justify panicking anyway - all that
>> really achieves is to make debugging the offending driver more
>> difficult. Let's simply WARN and otherwise ignore bogus PFNs.
>>
>> Reported-by: Prakash Gupta <guptap@codeaurora.org>
>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
>> ---
>>  drivers/iommu/iova.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
> 
> Copying stable@vger.kernel.org

Per Documentation/process/stable-kernel-rules.rst, I'm not convinced 
this meets the criteria for stable, which is why I deliberately left 
that out. This change isn't fixing any bug in itself, it is merely 
relaxing a behaviour that only comes into play if a serious and 
effectively unrecoverable bug has already occurred elsewhere.

If Joerg feels like sending it to stable anyway then fair enough, but 
FYI there is no relevant "Fixes" tag.

> You can add
> Reviewed-by: Prakash Gupta <guptap@codeaurora.org>

Thanks,
Robin.

>> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
>> index 0e6a9536eca6..612cbf668adf 100644
>> --- a/drivers/iommu/iova.c
>> +++ b/drivers/iommu/iova.c
>> @@ -811,7 +811,9 @@ iova_magazine_free_pfns(struct iova_magazine *mag,
>> struct iova_domain *iovad)
>>      for (i = 0 ; i < mag->size; ++i) {
>>          struct iova *iova = private_find_iova(iovad, mag->pfns[i]);
>>
>> -        BUG_ON(!iova);
>> +        if (WARN_ON(!iova))
>> +            continue;
>> +
>>          private_free_iova(iovad, iova);
>>      }

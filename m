Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4540B1EB8AB
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 11:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFBJje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 05:39:34 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:17643 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbgFBJjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 05:39:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591090771; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=IekPtOjoRZDjZaNDXgKSitUXOmu6PIOrWvgVXoQjNic=;
 b=cfvpd22XQIWhXj+m1JAN/8oRqUckduoHsGT1da1sxjO7ppoaYRTEPtcX3e2D9dRkkMnt4yM+
 cZfu3vx0hhx2gWIQkTJ6Wf5ZH3eTnACo5I0RoGhEk+qOVWua/Gw3jUddBWP7D1ysfBg6aGc8
 GEWH25WheB1p4NNheKa5LXRrW5c=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5ed61e5246d39fc0a2cc1a82 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 02 Jun 2020 09:39:30
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB705C433A0; Tue,  2 Jun 2020 09:39:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: guptap)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22DF2C433CA;
        Tue,  2 Jun 2020 09:39:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 02 Jun 2020 15:09:29 +0530
From:   guptap@codeaurora.org
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.com,
        joro@8bytes.org, linux-mm@kvack.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        owner-linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/dma: limit iova free size to unmmaped iova
In-Reply-To: <4ba082d3bb965524157704ea1ffb1ff4@codeaurora.org>
References: <20200521113004.12438-1-guptap@codeaurora.org>
 <7aaa8dcc-6a47-f256-431d-2a1b034b4076@arm.com>
 <90662ef3123dbf2e93f9718ee5cc14a7@codeaurora.org>
 <2d873ab9-ebb9-3c2d-f129-55a036ab47d0@arm.com>
 <4ba082d3bb965524157704ea1ffb1ff4@codeaurora.org>
Message-ID: <2bfb4ce3a2dfeb2d585f0308a9002feb@codeaurora.org>
X-Sender: guptap@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-26 12:49, guptap@codeaurora.org wrote:
> On 2020-05-22 14:54, Robin Murphy wrote:
>> On 2020-05-22 07:25, guptap@codeaurora.org wrote:
>>> On 2020-05-22 01:46, Robin Murphy wrote:
>>>> On 2020-05-21 12:30, Prakash Gupta wrote:
>>> I agree, we shouldn't be freeing the partial iova. Instead just 
>>> making
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
>>>> dma_unmap_* or dma_free_* with the wrong address or size in the 
>>>> first
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
> should fix it, but then the present behavior makes it difficult to 
> catch cases
> when driver is making wrong DMA API calls. When invalid iova pfn is 
> passed it
> doesn't fail then and there, though DMA layer is aware of iova being 
> invalid. It
> fails much after that in the context of an valid map/unmap, with 
> BUG_ON().
> 
> Downgrading BUG_ON() to WARN_ON() in iova_magazine_free_pfns() will not 
> help
> much as invalid iova will cause NULL pointer dereference.
> 
> I see no reason why DMA layer wants to free an iova for which unmapped 
> failed.
> IMHO queuing an invalid iova (which already failed unmap) to rcache 
> which
> eventually going to crash the system looks like iommu-dma layer issue.
> 
> Thanks,
> Prakash

ping?

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B424CD384
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 12:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiCDLdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 06:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiCDLdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 06:33:39 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC4FA14866F;
        Fri,  4 Mar 2022 03:32:51 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8797143D;
        Fri,  4 Mar 2022 03:32:51 -0800 (PST)
Received: from [10.57.39.47] (unknown [10.57.39.47])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7723B3F70D;
        Fri,  4 Mar 2022 03:32:50 -0800 (PST)
Message-ID: <77b0c978-7caa-c333-6015-1d784b5daf3f@arm.com>
Date:   Fri, 4 Mar 2022 11:32:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] iommu/iova: Improve 32-bit free space estimate
Content-Language: en-GB
To:     Joerg Roedel <joro@8bytes.org>,
        Miles Chen <miles.chen@mediatek.com>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        will@kernel.org, wsd_upstream@mediatek.com, yf.wang@mediatek.com,
        stable@vger.kernel.org
References: <033815732d83ca73b13c11485ac39336f15c3b40.1646318408.git.robin.murphy@arm.com>
 <20220303233646.13773-1-miles.chen@mediatek.com>
 <YiHey3lGHAMUp+oC@8bytes.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YiHey3lGHAMUp+oC@8bytes.org>
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

On 2022-03-04 09:41, Joerg Roedel wrote:
> On Fri, Mar 04, 2022 at 07:36:46AM +0800, Miles Chen wrote:
>> Hi Robin,
>>
>>> For various reasons based on the allocator behaviour and typical
>>> use-cases at the time, when the max32_alloc_size optimisation was
>>> introduced it seemed reasonable to couple the reset of the tracked
>>> size to the update of cached32_node upon freeing a relevant IOVA.
>>> However, since subsequent optimisations focused on helping genuine
>>> 32-bit devices make best use of even more limited address spaces, it
>>> is now a lot more likely for cached32_node to be anywhere in a "full"
>>> 32-bit address space, and as such more likely for space to become
>>> available from IOVAs below that node being freed.
>>>
>>> At this point, the short-cut in __cached_rbnode_delete_update() really
>>> doesn't hold up any more, and we need to fix the logic to reliably
>>> provide the expected behaviour. We still want cached32_node to only move
>>> upwards, but we should reset the allocation size if *any* 32-bit space
>>> has become available.
>>>
>>> Reported-by: Yunfei Wang <yf.wang@mediatek.com>
>>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
>>
>> Would you mind adding:
>>
>> Cc: <stable@vger.kernel.org>
> 
> Applied without stable tag for now. If needed, please consider
> re-sending it for stable when this patch is merged upstream.

Yeah, having figured out the history, I ended up with the opinion that 
it was a missed corner-case optimisation opportunity, rather than an 
actual error with respect to intent or implementation, so I 
intentionally left that out. Plus figuring out an exact Fixes tag might 
be tricky - as above I reckon it probably only started to become 
significant somwehere around 5.11 or so.

All of these various levels of retry mechanisms are only a best-effort 
thing, and ultimately if you're making large allocations from a small 
space there are always going to be *some* circumstances that still 
manage to defeat them. Over time, we've made them try harder, but that 
fact that we haven't yet made them try hard enough to work well for a 
particular use-case does not constitute a bug. However as Joerg says, 
anyone's welcome to make a case to Greg to backport a mainline commit if 
it's a low-risk change with significant benefit to real-world stable 
kernel users.

Thanks all!

Robin.

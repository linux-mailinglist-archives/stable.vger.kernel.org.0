Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBA0831FA
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 14:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbfHFM57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 08:57:59 -0400
Received: from foss.arm.com ([217.140.110.172]:33032 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730896AbfHFM56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 08:57:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DBCB28;
        Tue,  6 Aug 2019 05:57:58 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 395DF3F694;
        Tue,  6 Aug 2019 05:57:57 -0700 (PDT)
Subject: Re: [PATCH 5.2 073/131] dma-direct: correct the physical addr in
 dma_direct_sync_sg_for_cpu/device
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        Christoph Hellwig <hch@lst.de>
References: <20190805124951.453337465@linuxfoundation.org>
 <20190805124956.543654128@linuxfoundation.org>
 <20190806124143.GF17747@sasha-vm>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <9dd82745-1673-afc3-5eb4-8b79ddb5824b@arm.com>
Date:   Tue, 6 Aug 2019 13:57:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190806124143.GF17747@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/08/2019 13:41, Sasha Levin wrote:
> On Mon, Aug 05, 2019 at 03:02:40PM +0200, Greg Kroah-Hartman wrote:
>> [ Upstream commit 449fa54d6815be8c2c1f68fa9dbbae9384a7c03e ]
>>
>> dma_map_sg() may use swiotlb buffer when the kernel command line includes
>> "swiotlb=force" or the dma_addr is out of dev->dma_mask range.  After
>> DMA complete the memory moving from device to memory, then user call
>> dma_sync_sg_for_cpu() to sync with DMA buffer, and copy the original
>> virtual buffer to other space.
>>
>> So dma_direct_sync_sg_for_cpu() should use swiotlb physical addr, not
>> the original physical addr from sg_phys(sg).
>>
>> dma_direct_sync_sg_for_device() also has the same issue, correct it as
>> well.
>>
>> Fixes: 55897af63091("dma-direct: merge swiotlb_dma_ops into the 
>> dma_direct code")
>> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>> Reviewed-by: Robin Murphy <robin.murphy@arm.com>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I'm going to drop this one. There's a fix to it upstream, but the fix
> also seems to want 0036bc73ccbe ("drm/msm: stop abusing dma_map/unmap for
> cache") which we're not taking, so I'm just going to drop this one as
> well.

Given that the two commits touch entirely separate files I'm not sure 
what the imagined dependency could be :/

0036bc73ccbe is indeed not a fix (frankly I'm not convinced it's even a 
valid change at all) but even conceptually it bears no relation 
whatsoever to the genuine bug fixed by 449fa54d6815.

Robin.

> 
> If someone wants it in the stable trees, please send a tested backport.
> 
> -- 
> Thanks,
> Sasha

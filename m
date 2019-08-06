Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED9183D24
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfHFWEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbfHFWEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 18:04:50 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7657121880;
        Tue,  6 Aug 2019 22:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565129089;
        bh=AuqdTVytYqGwq/gm5yHhPwjwfhHe1pLTnzeuDh1BmAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kUuYVb6xuyzs4OnPtaiKRTKPuzMpF5WG8+SnMfOoePE+aHCgTx55/ym/eXIQA3b9O
         K9a5bvTZL1N9WU0Qm2HjEiV5SCCqiYirLBV4H3S0jvF5rohkl9F6dq7MFMnY/8hl+j
         5PSu+wp/SJNVAA5v8ca3g746OP2auWkvQ39K2mIo=
Date:   Tue, 6 Aug 2019 18:04:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.2 073/131] dma-direct: correct the physical addr in
 dma_direct_sync_sg_for_cpu/device
Message-ID: <20190806220448.GN17747@sasha-vm>
References: <20190805124951.453337465@linuxfoundation.org>
 <20190805124956.543654128@linuxfoundation.org>
 <20190806124143.GF17747@sasha-vm>
 <9dd82745-1673-afc3-5eb4-8b79ddb5824b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9dd82745-1673-afc3-5eb4-8b79ddb5824b@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 01:57:56PM +0100, Robin Murphy wrote:
>On 06/08/2019 13:41, Sasha Levin wrote:
>>On Mon, Aug 05, 2019 at 03:02:40PM +0200, Greg Kroah-Hartman wrote:
>>>[ Upstream commit 449fa54d6815be8c2c1f68fa9dbbae9384a7c03e ]
>>>
>>>dma_map_sg() may use swiotlb buffer when the kernel command line includes
>>>"swiotlb=force" or the dma_addr is out of dev->dma_mask range.  After
>>>DMA complete the memory moving from device to memory, then user call
>>>dma_sync_sg_for_cpu() to sync with DMA buffer, and copy the original
>>>virtual buffer to other space.
>>>
>>>So dma_direct_sync_sg_for_cpu() should use swiotlb physical addr, not
>>>the original physical addr from sg_phys(sg).
>>>
>>>dma_direct_sync_sg_for_device() also has the same issue, correct it as
>>>well.
>>>
>>>Fixes: 55897af63091("dma-direct: merge swiotlb_dma_ops into the 
>>>dma_direct code")
>>>Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>>>Reviewed-by: Robin Murphy <robin.murphy@arm.com>
>>>Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>>I'm going to drop this one. There's a fix to it upstream, but the fix
>>also seems to want 0036bc73ccbe ("drm/msm: stop abusing dma_map/unmap for
>>cache") which we're not taking, so I'm just going to drop this one as
>>well.
>
>Given that the two commits touch entirely separate files I'm not sure 
>what the imagined dependency could be :/

From the commit message of 3de433c5b38a ("drm/msm: Use the correct
dma_sync calls in msm_gem"):

    Fixes the combination of two patches:

    Fixes: 0036bc73ccbe (drm/msm: stop abusing dma_map/unmap for cache)
    Fixes: 449fa54d6815 (dma-direct: correct the physical addr in dma_direct_sync_sg_for_cpu/device)

>0036bc73ccbe is indeed not a fix (frankly I'm not convinced it's even 
>a valid change at all) but even conceptually it bears no relation 
>whatsoever to the genuine bug fixed by 449fa54d6815.

Given that Rob Clark asked me to drop 0036bc73ccbe not because it's
irrelevant but because it's potentially dangerous, I did not feel
confident enough ignoring the statement in the commit message and
dropped this patch instead.

If I'm  wrong here, I'd be happy to take these two patches if someone
acks it.

--
Thanks,
Sasha

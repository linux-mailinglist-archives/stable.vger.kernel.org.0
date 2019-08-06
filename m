Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6121383193
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfHFMlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 08:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfHFMlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 08:41:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A9120818;
        Tue,  6 Aug 2019 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565095304;
        bh=xNSlvXtmO8YI+JCDc0+g/z1qw41BP+LTgmlaJunBWPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pb4DE6Yk5/x+GwL6UoJAwpE0fPujt/dU0EmepiQHPs8z8yjoKN9XeTDFVTvuUnaVj
         94JfSTjz2ShLdTkptQEOLgXD8qopcptbejyWH8J62oE39KdnEW/tsOpvSLIg52EAGW
         m2KWNBvJYHuR3ZexgA6cXgjTEOxWPOi69oKUU184=
Date:   Tue, 6 Aug 2019 08:41:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.2 073/131] dma-direct: correct the physical addr in
 dma_direct_sync_sg_for_cpu/device
Message-ID: <20190806124143.GF17747@sasha-vm>
References: <20190805124951.453337465@linuxfoundation.org>
 <20190805124956.543654128@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190805124956.543654128@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 03:02:40PM +0200, Greg Kroah-Hartman wrote:
>[ Upstream commit 449fa54d6815be8c2c1f68fa9dbbae9384a7c03e ]
>
>dma_map_sg() may use swiotlb buffer when the kernel command line includes
>"swiotlb=force" or the dma_addr is out of dev->dma_mask range.  After
>DMA complete the memory moving from device to memory, then user call
>dma_sync_sg_for_cpu() to sync with DMA buffer, and copy the original
>virtual buffer to other space.
>
>So dma_direct_sync_sg_for_cpu() should use swiotlb physical addr, not
>the original physical addr from sg_phys(sg).
>
>dma_direct_sync_sg_for_device() also has the same issue, correct it as
>well.
>
>Fixes: 55897af63091("dma-direct: merge swiotlb_dma_ops into the dma_direct code")
>Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>Reviewed-by: Robin Murphy <robin.murphy@arm.com>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>Signed-off-by: Sasha Levin <sashal@kernel.org>

I'm going to drop this one. There's a fix to it upstream, but the fix
also seems to want 0036bc73ccbe ("drm/msm: stop abusing dma_map/unmap for
cache") which we're not taking, so I'm just going to drop this one as
well.

If someone wants it in the stable trees, please send a tested backport.

--
Thanks,
Sasha

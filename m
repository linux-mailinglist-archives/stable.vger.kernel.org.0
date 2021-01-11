Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68402F1AB3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 17:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbhAKQP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 11:15:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730621AbhAKQP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 11:15:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8DFE2247F;
        Mon, 11 Jan 2021 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610381688;
        bh=vU6H120stfuOQ5pc95UICs91NrCA+KFQFAToskWyZpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hoSh/oB7ljXzyLCi+dfAntUXnizW2+IZJheAzTKPcGNh23wFUFYgQUhq27SIW4LDx
         OY+DaAU2Jf/Ag6O/o111G7gj+To6ZlXDCHNfiy9FXxnQIwrlhfXWQJ/7M6PxWi8m98
         BNG+d/x4LtbzR9WHiAzpZNbY9j+SgRuaJV4Xaf3c=
Date:   Mon, 11 Jan 2021 17:15:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Orr <marcorr@google.com>
Cc:     hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        jxgao@google.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dma: mark unmapped DMA scatter/gather invalid
Message-ID: <X/x5v4Gjretp4lii@kroah.com>
References: <20210111154335.23388-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111154335.23388-1-marcorr@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 07:43:35AM -0800, Marc Orr wrote:
> This patch updates dma_direct_unmap_sg() to mark each scatter/gather
> entry invalid, after it's unmapped. This fixes two issues:
> 
> 1. It makes the unmapping code able to tolerate a double unmap.
> 2. It prevents the NVMe driver from erroneously treating an unmapped DMA
> address as mapped.
> 
> The bug that motivated this patch was the following sequence, which
> occurred within the NVMe driver, with the kernel flag `swiotlb=force`.
> 
> * NVMe driver calls dma_direct_map_sg()
> * dma_direct_map_sg() fails part way through the scatter gather/list
> * dma_direct_map_sg() calls dma_direct_unmap_sg() to unmap any entries
>   succeeded.
> * NVMe driver calls dma_direct_unmap_sg(), redundantly, leading to a
>   double unmap, which is a bug.
> 
> With this patch, a hadoop workload running on a cluster of three AMD
> SEV VMs, is able to succeed. Without the patch, the hadoop workload
> suffers application-level and even VM-level failures.
> 
> Tested-by: Jianxiong Gao <jxgao@google.com>
> Tested-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Jianxiong Gao <jxgao@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>  kernel/dma/direct.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

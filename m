Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827E233B363
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCONMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229780AbhCONLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D2264E99;
        Mon, 15 Mar 2021 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615813914;
        bh=1T+/fJ1FsMm/MkM3lmB4/GDgzFjJ6zppqyvNaR531dQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X1AqCD7wHkD7pgL6vv2MfQMdbtuezVXQW+eVqRhDtODQzx06jfy3L8duU9Z6Cb0s/
         OFxOXqymXv7QlNAB3RU1sGf4SdBXbHc7jEkO6rO2ydA34R5WpkJM10qW5lr4UDq0ZO
         PdW9pm+hDRc2lCJzoTQkO2rq8mQqCcNltJzr1Si4=
Date:   Mon, 15 Mar 2021 14:11:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: rdmavt panic in long term stable linux-5.10.y
Message-ID: <YE9dF5nVp9WhSEDI@kroah.com>
References: <BYAPR01MB3816509E2A5824045B110099F26C9@BYAPR01MB3816.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR01MB3816509E2A5824045B110099F26C9@BYAPR01MB3816.prod.exchangelabs.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 01:05:43PM +0000, Marciniszyn, Mike wrote:
> The following panic happens on the 5.10.20 long term stable running qperf with rdmavt/hfi1:
> 
> [ 1467.730495] BUG: kernel NULL pointer dereference, address: 0000000000000268
> [ 1467.738940] #PF: supervisor read access in kernel mode
> [ 1467.745052] #PF: error_code(0x0000) - not-present page
> [ 1467.751159] PGD 0 P4D 0 
> [ 1467.754350] Oops: 0000 [#1] SMP PTI
> [ 1467.758621] CPU: 43 PID: 42843 Comm: qperf Tainted: G S                5.10.17 #1
> [ 1467.767370] HISS-219ardware name: Intel Corporation S2600CWR/S2600CW, BIOS SE5C610.86B.01.01.0014.121820151719 12/18/2015
> [ 1467.779357] RIP: 0010:ib_umem_get+0x233/0x3d0 [ib_uverbs]
> [ 1467.785811] Code: 02 00 00 48 0f 46 f5 e8 9b 67 27 ca 85 c0 0f 88 40 01 00 00 4c 63 f0 4c 89 f2 4c 29 f5 48 c1 e2 0c 89 e9 48 01 d3 49 8b 14 24 <48> 8b 92 68 02 00 00 48 85 d2 0f 85 5a ff ff ff 41 b9 00 00 01 00
> [ 1467.807715] RSP: 0018:ffffb7ba87303aa8 EFLAGS: 00010206
> [ 1467.814026] RAX: 0000000000000010 RBX: 000055ad89f11000 RCX: 0000000000000000
> [ 1467.822457] RDX: 0000000000000000 RSI: 000000000000000f RDI: ffff8954bffd6000
> [ 1467.830888] RBP: 0000000000000000 R08: 0000000000031443 R09: 0000000000000000
> [ 1467.839322] R10: 0000000000031420 R11: 0000000000000022 R12: ffff894d50930000
> [ 1467.847751] R13: 0000000000000000 R14: 0000000000000010 R15: ffff894d4a2fe880
> [ 1467.856193] FS:  00007fb12f44c740(0000) GS:ffff89549fa40000(0000) knlGS:0000000000000000
> [ 1467.865721] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1467.872657] CR2: 0000000000000268 CR3: 00000001c0534001 CR4: 00000000001706e0
> [ 1467.881136] Call Trace:
> [ 1467.884398]  rvt_reg_user_mr+0x70/0x200 [rdmavt]
> 
> The panic happens in the call to dma_get_max_seg_size() because the dma_device is NULL.
> 
> Here is the stable patch that causes the issue:
> 
> commit 404fa093741e15e16fd522cc76cd9f86e9ef81d2
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Fri Nov 6 19:19:38 2020 +0100
> 
>     RDMA/core: remove use of dma_virt_ops
>     
>     [ Upstream commit 5a7a9e038b032137ae9c45d5429f18a2ffdf7d42 ]
>     
>     Use the ib_dma_* helpers to skip the DMA translation instead.  This
>     removes the last user if dma_virt_ops and keeps the weird layering
>     violation inside the RDMA core instead of burderning the DMA mapping
>     subsystems with it.  This also means the software RDMA drivers now don't
>     have to mess with DMA parameters that are not relevant to them at all, and
>     that in the future we can use PCI P2P transfers even for software RDMA, as
>     there is no first fake layer of DMA mapping that the P2P DMA support.
>     
>     Link: https://lore.kernel.org/r/20201106181941.1878556-8-hch@lst.de
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Tested-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
>     Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> The stable backport missed a prereq patch:
> 
> commit b116c702791a9834e6485f67ca6267d9fdf59b87
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Fri Nov 6 19:19:33 2020 +0100
> 
>     RDMA/umem: Use ib_dma_max_seg_size instead of dma_get_max_seg_size
>     
>     RDMA ULPs must not call DMA mapping APIs directly but instead use the
>     ib_dma_* wrappers.
>     
>     Fixes: 0c16d9635e3a ("RDMA/umem: Move to allocate SG table from pages")
>     Link: https://lore.kernel.org/r/20201106181941.1878556-3-hch@lst.de
>     Reported-by: Jason Gunthorpe <jgg@nvidia.com>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> The missing patch adds the necessary RDMA wrappers to handle the ib_device dma_device member being NULL.
> 
> The missing patch picks clean and fixes the issue.
> 
> Do you want me to send the stable request?

You just did, now queued up :)

greg k-h

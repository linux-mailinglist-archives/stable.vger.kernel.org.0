Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC46410657
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhIRMTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhIRMTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Sep 2021 08:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA64D61108;
        Sat, 18 Sep 2021 12:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631967464;
        bh=ir7SWkLoquJvVAEwsobzj7Q35ddTz/V+pnZ+lVu5Qb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KrE7Ylz/WVensEcEqCVYUI0LF4JLzi5BbaQxsnVVTIMd9pJ5UHxdC3jI52Bnhhr71
         WSdg742Iy/8FY9Hsy+5Xt5BYTK4vwcvDPWEUST0QTwYvMleLGIRsisuWmtT4eBiO9Q
         fZB90qA0gkw79NzyTHtzpLo8MiWeBtnbMK0/SPqE=
Date:   Sat, 18 Sep 2021 14:17:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     snitzer@redhat.com, yebin10@huawei.com, stable@vger.kernel.org,
        xiejingfeng@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH] dm thin metadata: Fix use-after-free in
 dm_bm_set_read_only
Message-ID: <YUXY5bIxC+Fdjyeb@kroah.com>
References: <20210918023105.89503-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210918023105.89503-1-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 18, 2021 at 10:31:05AM +0800, Jeffle Xu wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> Hi Greg,
> 
> Ye Bin had ever fixed a use-after-free of dm-thin in v5.9, and the
> complete patchset contains three patches:
> 
> [1/3] d16ff19e69ab  dm cache metadata: Avoid returning cmd->bm wild pointer on error
> [2/3] 219403d7e56f dm thin metadata:  Avoid returning cmd->bm wild pointer on error
> [3/3] 3a653b205f29 dm thin metadata: Fix use-after-free in dm_bm_set_read_only
> 
> However, 4.19.y stable only picks the former two patches [1]:
> [1/3] 67f03c3d6829 dm cache metadata: Avoid returning cmd->bm wild pointer on error
> [2/3] 2c00ee626ed4 dm thin metadata: Avoid returning cmd->bm wild pointer on error
> 
> We encountered a NULL crash and xiejingfeng found that the omitted patch 3 can
> fix that. I'm not sure why patch 3 is not picked then, and we need this patch
> to fix this issue.
> 
> [32402.449200] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [32402.459553] Oops: 0002 [#1] SMP NOPTI
> [32402.483982] RIP: 0010:dm_bm_set_read_only+0x5/0x10 [dm_persistent_data]
> [32402.588073] Call Trace:
> [32402.590522] dm_pool_metadata_read_only+0x22/0x30 [dm_thin_pool]
> [32402.596526] set_pool_mode+0x209/0x2e0 [dm_thin_pool]
> [32402.601579] metadata_operation_failed+0xd5/0xf0 [dm_thin_pool]
> [32402.607499] commit+0x91/0xf0 [dm_thin_pool]
> [32402.611771] pool_status+0x28a/0x700 [dm_thin_pool]
> [32402.616652] retrieve_status+0xa1/0x1c0 [dm_mod]
> [32402.627794] table_status+0x61/0xa0 [dm_mod]
> [32402.632068] ctl_ioctl+0x1b3/0x480 [dm_mod]
> [32402.636253] dm_ctl_ioctl+0xa/0x10 [dm_mod]
> [32402.640440] do_vfs_ioctl+0x9f/0x610
> [32402.653081] ksys_ioctl+0x70/0x80
> [32402.656393] __x64_sys_ioctl+0x16/0x20
> [32402.660145] do_syscall_64+0x7b/0x200
> [32402.663813] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [1] https://lore.kernel.org/lkml/20200908152225.086536876@linuxfoundation.org/
> 
> ---
> commit 3a653b205f29b3f9827a01a0c88bfbcb0d169494 upstream.
> 
> The following error ocurred when testing disk online/offline:

Now queued up, thanks.

greg k-h

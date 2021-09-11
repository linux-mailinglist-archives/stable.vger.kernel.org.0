Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836C2407651
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 13:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhIKLzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 07:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230249AbhIKLzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 07:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457D86108B;
        Sat, 11 Sep 2021 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631361259;
        bh=0PyyY5XyWadYSWBgfq6Ct159vY/Gcv1URpHd7P9SiwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G4QmRNV4Y7pYdCEABSmKhou4oo9Tna/Bx4yCRyRuQvCpL5vCQ78offVHM5nOYh6FI
         QgsvaiharPWW5R9YmsMIoSY75JMenTaYxSgffXgADwaPmSUDWiJXu41xWiFgmiYxEF
         E5ltuUBlFfZvwHEYjBXxZuP76Ltybg19+4xyj9w8=
Date:   Sat, 11 Sep 2021 13:54:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cheng Chao <cs.os.kernel@gmail.com>
Cc:     labbott@redhat.com, sumit.semwal@linaro.org, arve@android.com,
        riandrews@android.com, devel@driverdev.osuosl.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [PATCH 4.9] staging: android: ion: fix page is NULL
Message-ID: <YTyY6ZALBhCm47T6@kroah.com>
References: <20210911112115.47202-1-cs.os.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210911112115.47202-1-cs.os.kernel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 11, 2021 at 07:21:15PM +0800, Cheng Chao wrote:
> kernel panic is here:
> 
> Unable to handle kernel paging request at virtual address b0380000
> pgd = d9d94000
> [b0380000] *pgd=00000000
> Internal error: Oops: 2805 [#1] PREEMPT SMP ARM
> ...
> task: daa2dd00 task.stack: da194000
> PC is at v7_dma_clean_range+0x1c/0x34
> LR is at arm_dma_sync_single_for_device+0x44/0x58
> pc : [<c011aa0c>]    lr : [<c011645c>]    psr: 200f0013
> sp : da195da0  ip : dc1f9000  fp : c1043dc4
> r10: 00000000  r9 : c16f1f58  r8 : 00000001
> r7 : c1621f94  r6 : c0116418  r5 : 00000000  r4 : c011aa58
> r3 : 0000003f  r2 : 00000040  r1 : b0480000  r0 : b0380000
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c5383d  Table: 19d9406a  DAC: 00000051
> ...
> [<c011aa0c>] (v7_dma_clean_range) from [<c011645c>] (arm_dma_sync_single_for_device+0x44/0x58)
> [<c011645c>] (arm_dma_sync_single_for_device) from [<c0117088>] (arm_dma_sync_sg_for_device+0x50/0x7c)
> [<c0117088>] (arm_dma_sync_sg_for_device) from [<c0c033c4>] (ion_pages_sync_for_device+0xb0/0xec)
> [<c0c033c4>] (ion_pages_sync_for_device) from [<c0c054ac>] (ion_system_heap_allocate+0x2a0/0x2e0)
> [<c0c054ac>] (ion_system_heap_allocate) from [<c0c02c78>] (ion_alloc+0x12c/0x494)
> [<c0c02c78>] (ion_alloc) from [<c0c03eac>] (ion_ioctl+0x510/0x63c)
> [<c0c03eac>] (ion_ioctl) from [<c027c4b0>] (do_vfs_ioctl+0xa8/0x9b4)
> [<c027c4b0>] (do_vfs_ioctl) from [<c027ce28>] (SyS_ioctl+0x6c/0x7c)
> [<c027ce28>] (SyS_ioctl) from [<c0108a40>] (ret_fast_syscall+0x0/0x48)
> Code: e3a02004 e1a02312 e2423001 e1c00003 (ee070f3a)
> ---[ end trace 89278304932c0e87 ]---
> Kernel panic - not syncing: Fatal exception
> 
> Signed-off-by: Cheng Chao <cs.os.kernel@gmail.com>
> ---
>  drivers/staging/android/ion/ion_system_heap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index 22c481f2ae4f..2a35b99cf628 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -75,7 +75,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
>  
>  	page = ion_page_pool_alloc(pool);
>  
> -	if (cached)
> +	if (page && cached)
>  		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
>  					  DMA_BIDIRECTIONAL);
>  	return page;
> -- 
> 2.26.3
> 

Why is this just a 4.9 patch?  Ion didn't get removed until 5.11, so
wouldn't this be an issue for anything 5.10 and older?

thanks,

greg k-h

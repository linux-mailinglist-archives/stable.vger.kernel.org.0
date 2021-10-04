Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D092E42097C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 12:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhJDKtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 06:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhJDKtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 06:49:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B477061222;
        Mon,  4 Oct 2021 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633344444;
        bh=A4suHIh2XBV/GkKaYZqU2ZSTKYGq9Qku6HZ3MxtDI14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4VyDOvnR2TRNJR3oz4YqBLro5CwXkXc6vZW8sL6LPCF7LWRspUpUm5QV7tyihxBP
         +Xr+vm/WDSAhBPfiLXE0FGFLZvio4j8HwUzeug2C3RlE4cek1KQIn6gB9Q9Pp1RRbc
         OxYeXhx/xtBI07vsR55k1peKhRDqFu4I0Dwzxc4g=
Date:   Mon, 4 Oct 2021 12:47:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     stable@vger.kernel.org, dan.j.williams@intel.com,
        sumiyawang@tencent.com, yongduan@tencent.com
Subject: Re: [PATCH 5.4] libnvdimm/pmem: Fix crash triggered when I/O
 in-flight during unbind
Message-ID: <YVrbucZs5h7/VcLv@kroah.com>
References: <1631797319109199@kroah.com>
 <20211004055134.677854-1-tyhicks@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004055134.677854-1-tyhicks@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 12:51:34AM -0500, Tyler Hicks wrote:
> From: sumiyawang <sumiyawang@tencent.com>
> 
> commit 32b2397c1e56f33b0b1881def965bb89bd12f448 upstream.
> 
> There is a use after free crash when the pmem driver tears down its
> mapping while I/O is still inbound.
> 
> This is triggered by driver unbind, "ndctl destroy-namespace", while I/O
> is in flight.
> 
> Fix the sequence of blk_cleanup_queue() vs memunmap().
> 
> The crash signature is of the form:
> 
>  BUG: unable to handle page fault for address: ffffc90080200000
>  CPU: 36 PID: 9606 Comm: systemd-udevd
>  Call Trace:
>   ? pmem_do_bvec+0xf9/0x3a0
>   ? xas_alloc+0x55/0xd0
>   pmem_rw_page+0x4b/0x80
>   bdev_read_page+0x86/0xb0
>   do_mpage_readpage+0x5d4/0x7a0
>   ? lru_cache_add+0xe/0x10
>   mpage_readpages+0xf9/0x1c0
>   ? bd_link_disk_holder+0x1a0/0x1a0
>   blkdev_readpages+0x1d/0x20
>   read_pages+0x67/0x1a0
> 
>   ndctl Call Trace in vmcore:
>   PID: 23473  TASK: ffff88c4fbbe8000  CPU: 1   COMMAND: "ndctl"
>   __schedule
>   schedule
>   blk_mq_freeze_queue_wait
>   blk_freeze_queue
>   blk_cleanup_queue
>   pmem_release_queue
>   devm_action_release
>   release_nodes
>   devres_release_all
>   device_release_driver_internal
>   device_driver_detach
>   unbind_store
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: sumiyawang <sumiyawang@tencent.com>
> Reviewed-by: yongduan <yongduan@tencent.com>
> Link: https://lore.kernel.org/r/1629632949-14749-1-git-send-email-sumiyawang@tencent.com
> Fixes: 50f44ee7248a ("mm/devm_memremap_pages: fix final page put race")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> [tyhicks: Minor contextual change in pmem_attach_disk() due to the
>  transition to 'struct range' not yet taking place. Preserve the
>  memcpy() call rather than initializing the range struct. That change
>  was introduced in v5.10 with commit a4574f63edc6 ("mm/memremap_pages:
>  convert to 'struct range'")]
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
> 
> We're seeing memory corruption issues in production and, AFAICT, we
> exercise this bit of code around the time that the corruption takes
> place. Therefore, I'm submitting this manually tested backport for
> inclusion in linux-5.4.y since it wasn't automatically applied due to
> the need for a manual backport.

Now queued up, thanks.

greg k-h

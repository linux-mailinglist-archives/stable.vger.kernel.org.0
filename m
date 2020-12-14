Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785832D9B61
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 16:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgLNPrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 10:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438820AbgLNPq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 10:46:59 -0500
Date:   Mon, 14 Dec 2020 16:47:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607960779;
        bh=6ZOo9A67E4JZmzABETwbIcJRq8CASETATkKwUJW62es=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ikxg8ogUMYLW4aJHno+U7JBhFgvsfqIk+KbSbYZZKL880G4Ke1aDvbMo1JxgDXl4o
         B35RoiQaZscf5YGnxb5UqmJ/VHgHzyQsl8khhvmakf/vnbbjfE0aB7iWmZPJXw6+B2
         FL3HvBjRwZmQ5l+OQ+zzRNy62qjO610v7px47F2g=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     akpm@linux-foundation.org, harish@linux.ibm.com, hch@infradead.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: drop
 ZSMALLOC_PGTABLE_MAPPING" failed to apply to 5.4-stable tree
Message-ID: <X9eJDMoE0NHfqljc@kroah.com>
References: <160750482424034@kroah.com>
 <X9JgpjCx9CDIt8ye@google.com>
 <X9OFwvyRVQMTG2lI@kroah.com>
 <X9P4yZH8RQc2FGxM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9P4yZH8RQc2FGxM@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 02:55:05PM -0800, Minchan Kim wrote:
> On Fri, Dec 11, 2020 at 03:44:18PM +0100, Greg KH wrote:
> > On Thu, Dec 10, 2020 at 09:53:42AM -0800, Minchan Kim wrote:
> > > On Wed, Dec 09, 2020 at 10:07:04AM +0100, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > The patch below does not apply to the 5.4-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > ------------------ original commit in Linus's tree ------------------
> > > > 
> > > > From e91d8d78237de8d7120c320b3645b7100848f24d Mon Sep 17 00:00:00 2001
> > > > From: Minchan Kim <minchan@kernel.org>
> > > > Date: Sat, 5 Dec 2020 22:14:51 -0800
> > > > Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING
> > > > 
> > > > While I was doing zram testing, I found sometimes decompression failed
> > > > since the compression buffer was corrupted.  With investigation, I found
> > > > below commit calls cond_resched unconditionally so it could make a
> > > > problem in atomic context if the task is reschedule.
> > > > 
> > > >   BUG: sleeping function called from invalid context at mm/vmalloc.c:108
> > > >   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
> > > >   3 locks held by memhog/946:
> > > >    #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
> > > >    #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
> > > >    #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
> > > >   CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
> > > >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
> > > >   Call Trace:
> > > >     unmap_kernel_range_noflush+0x2eb/0x350
> > > >     unmap_kernel_range+0x14/0x30
> > > >     zs_unmap_object+0xd5/0xe0
> > > >     zram_bvec_rw.isra.0+0x38c/0x8e0
> > > >     zram_rw_page+0x90/0x101
> > > >     bdev_write_page+0x92/0xe0
> > > >     __swap_writepage+0x94/0x4a0
> > > >     pageout+0xe3/0x3a0
> > > >     shrink_page_list+0xb94/0xd60
> > > >     shrink_inactive_list+0x158/0x460
> > > > 
> > > > We can fix this by removing the ZSMALLOC_PGTABLE_MAPPING feature (which
> > > > contains the offending calling code) from zsmalloc.
> > > > 
> > > > Even though this option showed some amount improvement(e.g., 30%) in
> > > > some arm32 platforms, it has been headache to maintain since it have
> > > > abused APIs[1](e.g., unmap_kernel_range in atomic context).
> > > > 
> > > > Since we are approaching to deprecate 32bit machines and already made
> > > > the config option available for only builtin build since v5.8, lastly it
> > > > has been not default option in zsmalloc, it's time to drop the option
> > > > for better maintenance.
> > > > 
> > > > [1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org
> > > > 
> > > > Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")
> > > 
> > > This patch fixex e47110e90584 which merged at v5.9 so we could drop it
> > > for v5.4.
> > 
> > It was backported to 5.4.62, so are you _sure_?
> 
> Oops, the patch went into 5.4 as stable but missed it.
> This is backport patch for 5.4.
> original commit id is e91d8d78237de8d7120c320b3645b7100848f24d
> 
> Let me know unless it applies clean

That worked, thanks!

greg k-h

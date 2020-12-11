Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA72D789B
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436923AbgLKPA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436896AbgLKPAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:00:22 -0500
Date:   Fri, 11 Dec 2020 15:44:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607697791;
        bh=PjL18FYeBU2nHyRddpcQgIYrZzxZns+vXdMSSK+HrGA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRuSFO3Q/mz31nZbjIH1S4SHEIgw0es+ldS75r0aoqIei9nS4CvdMKd9aeb4lt3GQ
         eUSQzzCf/fcG1Y8vSVYWNim/3yW3k9z7Vy2Opzjm+jXFmNmw56CkOm7NIB6tAWVvDL
         B5AQVhXtOcZ3QDhz4RO0a1c7lWbk4gBC3G0CVleE=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     akpm@linux-foundation.org, harish@linux.ibm.com, hch@infradead.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: drop
 ZSMALLOC_PGTABLE_MAPPING" failed to apply to 5.4-stable tree
Message-ID: <X9OFwvyRVQMTG2lI@kroah.com>
References: <160750482424034@kroah.com>
 <X9JgpjCx9CDIt8ye@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9JgpjCx9CDIt8ye@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 09:53:42AM -0800, Minchan Kim wrote:
> On Wed, Dec 09, 2020 at 10:07:04AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From e91d8d78237de8d7120c320b3645b7100848f24d Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan@kernel.org>
> > Date: Sat, 5 Dec 2020 22:14:51 -0800
> > Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING
> > 
> > While I was doing zram testing, I found sometimes decompression failed
> > since the compression buffer was corrupted.  With investigation, I found
> > below commit calls cond_resched unconditionally so it could make a
> > problem in atomic context if the task is reschedule.
> > 
> >   BUG: sleeping function called from invalid context at mm/vmalloc.c:108
> >   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
> >   3 locks held by memhog/946:
> >    #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
> >    #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
> >    #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
> >   CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
> >   Call Trace:
> >     unmap_kernel_range_noflush+0x2eb/0x350
> >     unmap_kernel_range+0x14/0x30
> >     zs_unmap_object+0xd5/0xe0
> >     zram_bvec_rw.isra.0+0x38c/0x8e0
> >     zram_rw_page+0x90/0x101
> >     bdev_write_page+0x92/0xe0
> >     __swap_writepage+0x94/0x4a0
> >     pageout+0xe3/0x3a0
> >     shrink_page_list+0xb94/0xd60
> >     shrink_inactive_list+0x158/0x460
> > 
> > We can fix this by removing the ZSMALLOC_PGTABLE_MAPPING feature (which
> > contains the offending calling code) from zsmalloc.
> > 
> > Even though this option showed some amount improvement(e.g., 30%) in
> > some arm32 platforms, it has been headache to maintain since it have
> > abused APIs[1](e.g., unmap_kernel_range in atomic context).
> > 
> > Since we are approaching to deprecate 32bit machines and already made
> > the config option available for only builtin build since v5.8, lastly it
> > has been not default option in zsmalloc, it's time to drop the option
> > for better maintenance.
> > 
> > [1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org
> > 
> > Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")
> 
> This patch fixex e47110e90584 which merged at v5.9 so we could drop it
> for v5.4.

It was backported to 5.4.62, so are you _sure_?

thanks,

greg k-h

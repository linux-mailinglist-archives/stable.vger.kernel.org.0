Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6E20BDF3
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 05:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgF0Ddc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 23:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0Ddc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACEB92089D;
        Sat, 27 Jun 2020 03:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593228811;
        bh=sNYPfHofN/DqivqZhVYR/JYE0ODvChCcUEpdNurrAqE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lhYnnFJxT0Mj67w/mYZfnnkwK6+dr00fbSQEygirN2YfQKeV+hVrHqnwJGjWMR37e
         b/Q447mS52AtTBK1Sw0D06iyMEEclRgoeTOxDesj4F9gh+nPVJksUjbTja9DfxNGYw
         BKU5MKo1jzWeyq+3TE3xU9wbtFf27NLNpTbP2GZ8=
Date:   Fri, 26 Jun 2020 20:33:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hughd@google.com, lists@colorremedies.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged] mm-fix-swap-cache-node-allocation-mask.patch
 removed from -mm tree
Message-ID: <20200627033331.tzz9HkVuF%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix swap cache node allocation mask
has been removed from the -mm tree.  Its filename was
     mm-fix-swap-cache-node-allocation-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix swap cache node allocation mask

https://bugzilla.kernel.org/show_bug.cgi?id=208085 reports that a slightly
overcommitted load, testing swap and zram along with i915, splats and
keeps on splatting, when it had better fail less noisily:

gnome-shell: page allocation failure: order:0,
mode:0x400d0(__GFP_IO|__GFP_FS|__GFP_COMP|__GFP_RECLAIMABLE),
nodemask=(null),cpuset=/,mems_allowed=0
CPU: 2 PID: 1155 Comm: gnome-shell Not tainted 5.7.0-1.fc33.x86_64 #1
Call Trace:
dump_stack+0x64/0x88
warn_alloc.cold+0x75/0xd9
__alloc_pages_slowpath.constprop.0+0xcfa/0xd30
__alloc_pages_nodemask+0x2df/0x320
alloc_slab_page+0x195/0x310
allocate_slab+0x3c5/0x440
___slab_alloc+0x40c/0x5f0
__slab_alloc+0x1c/0x30
kmem_cache_alloc+0x20e/0x220
xas_nomem+0x28/0x70
add_to_swap_cache+0x321/0x400
__read_swap_cache_async+0x105/0x240
swap_cluster_readahead+0x22c/0x2e0
shmem_swapin+0x8e/0xc0
shmem_swapin_page+0x196/0x740
shmem_getpage_gfp+0x3a2/0xa60
shmem_read_mapping_page_gfp+0x32/0x60
shmem_get_pages+0x155/0x5e0 [i915]
__i915_gem_object_get_pages+0x68/0xa0 [i915]
i915_vma_pin+0x3fe/0x6c0 [i915]
eb_add_vma+0x10b/0x2c0 [i915]
i915_gem_do_execbuffer+0x704/0x3430 [i915]
i915_gem_execbuffer2_ioctl+0x1ea/0x3e0 [i915]
drm_ioctl_kernel+0x86/0xd0 [drm]
drm_ioctl+0x206/0x390 [drm]
ksys_ioctl+0x82/0xc0
__x64_sys_ioctl+0x16/0x20
do_syscall_64+0x5b/0xf0
entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported on 5.7, but it goes back really to 3.1: when
shmem_read_mapping_page_gfp() was implemented for use by i915, and
allowed for __GFP_NORETRY and __GFP_NOWARN flags in most places, but
missed swapin's "& GFP_KERNEL" mask for page tree node allocation in
__read_swap_cache_async() - that was to mask off HIGHUSER_MOVABLE bits
from what page cache uses, but GFP_RECLAIM_MASK is now what's needed.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2006151330070.11064@eggly.anvils
Fixes: 68da9f055755 ("tmpfs: pass gfp to shmem_getpage_gfp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Chris Murphy <lists@colorremedies.com>
Analyzed-by: Vlastimil Babka <vbabka@suse.cz>
Analyzed-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Chris Murphy <lists@colorremedies.com>
Cc: <stable@vger.kernel.org>	[3.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-fix-swap-cache-node-allocation-mask
+++ a/mm/swap_state.c
@@ -21,7 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
 #include <linux/huge_mm.h>
-
+#include "internal.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -429,7 +429,7 @@ struct page *__read_swap_cache_async(swp
 	__SetPageSwapBacked(page);
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL)) {
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK)) {
 		put_swap_page(page, entry);
 		goto fail_unlock;
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch


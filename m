Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC27847F990
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 01:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhL0AcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Dec 2021 19:32:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57264 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbhL0AcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Dec 2021 19:32:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 265D660F22;
        Mon, 27 Dec 2021 00:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045E5C36AE8;
        Mon, 27 Dec 2021 00:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640565140;
        bh=RQbsofjZR6yDmWsk2bBY9xNCUBevUhYc38UgqhuCkZE=;
        h=Date:From:To:Subject:From;
        b=geOumw+FRd/vuLw+UrH/M8kL+GGSfWxM5JyhL7EF9Yxn2ShW779wFKvD40iCMu94M
         sz9Ns5DYJ7SxoOheIIM+BzSvH9ve/DTNsghqWhrJLuUveqt37220qfRstJ69o7GnnO
         DIdvVPAltn+KoZeF1/reNQghppOQ9ddy3qjtY0hQ=
Date:   Sun, 26 Dec 2021 16:32:19 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        robin.murphy@arm.com, rientjes@google.com, penberg@kernel.org,
        m.szyprowski@samsung.com, john.p.donnelly@oracle.com,
        iamjoonsoo.kim@lge.com, hch@lst.de, david@redhat.com,
        David.Laight@ACULAB.COM, cl@linux.com, bp@alien8.de,
        42.hyeyoo@gmail.com, bhe@redhat.com
Subject:  +
 dma-pool-create-dma-atomic-pool-only-if-dma-zone-has-managed-pages.patch
 added to -mm tree
Message-ID: <20211227003219.smGaI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: dma/pool: create dma atomic pool only if dma zone has managed pages
has been added to the -mm tree.  Its filename is
     dma-pool-create-dma-atomic-pool-only-if-dma-zone-has-managed-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dma-pool-create-dma-atomic-pool-only-if-dma-zone-has-managed-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dma-pool-create-dma-atomic-pool-only-if-dma-zone-has-managed-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: dma/pool: create dma atomic pool only if dma zone has managed pages

Currently three dma atomic pools are initialized as long as the relevant
kernel codes are built in.  While in kdump kernel of x86_64, this is not
right when trying to create atomic_pool_dma, because there's no managed
pages in DMA zone.  In the case, DMA zone only has low 1M memory presented
and locked down by memblock allocator.  So no pages are added into buddy
of DMA zone.  Please check commit f1d4d47c5851 ("x86/setup: Always reserve
the first 1M of RAM").

Then in kdump kernel of x86_64, it always prints below failure message:

 DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
 swapper/0: page allocation failure: order:5, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-0.rc5.20210611git929d931f2b40.42.fc35.x86_64 #1
 Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS 2.12.0 06/04/2018
 Call Trace:
  dump_stack+0x7f/0xa1
  warn_alloc.cold+0x72/0xd6
  ? _raw_spin_unlock_irq+0x24/0x40
  ? __alloc_pages_direct_compact+0x90/0x1b0
  __alloc_pages_slowpath.constprop.0+0xf29/0xf50
  ? __cond_resched+0x16/0x50
  ? prepare_alloc_pages.constprop.0+0x19d/0x1b0
  __alloc_pages+0x24d/0x2c0
  ? __dma_atomic_pool_init+0x93/0x93
  alloc_page_interleave+0x13/0xb0
  atomic_pool_expand+0x118/0x210
  ? __dma_atomic_pool_init+0x93/0x93
  __dma_atomic_pool_init+0x45/0x93
  dma_atomic_pool_init+0xdb/0x176
  do_one_initcall+0x67/0x320
  ? rcu_read_lock_sched_held+0x3f/0x80
  kernel_init_freeable+0x290/0x2dc
  ? rest_init+0x24f/0x24f
  kernel_init+0xa/0x111
  ret_from_fork+0x22/0x30
 Mem-Info:
 ......
 DMA: failed to allocate 128 KiB GFP_KERNEL|GFP_DMA pool for atomic allocation
 DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations

Here, let's check if DMA zone has managed pages, then create
atomic_pool_dma if yes.  Otherwise just skip it.

Link: https://lkml.kernel.org/r/20211223094435.248523-3-bhe@redhat.com
Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: John Donnelly  <john.p.donnelly@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/pool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/dma/pool.c~dma-pool-create-dma-atomic-pool-only-if-dma-zone-has-managed-pages
+++ a/kernel/dma/pool.c
@@ -203,7 +203,7 @@ static int __init dma_atomic_pool_init(v
 						    GFP_KERNEL);
 	if (!atomic_pool_kernel)
 		ret = -ENOMEM;
-	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
+	if (has_managed_dma()) {
 		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
 						GFP_KERNEL | GFP_DMA);
 		if (!atomic_pool_dma)
@@ -226,7 +226,7 @@ static inline struct gen_pool *dma_guess
 	if (prev == NULL) {
 		if (IS_ENABLED(CONFIG_ZONE_DMA32) && (gfp & GFP_DMA32))
 			return atomic_pool_dma32;
-		if (IS_ENABLED(CONFIG_ZONE_DMA) && (gfp & GFP_DMA))
+		if (atomic_pool_dma && (gfp & GFP_DMA))
 			return atomic_pool_dma;
 		return atomic_pool_kernel;
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are

mm_zone-add-function-to-check-if-managed-dma-zone-exists.patch
dma-pool-create-dma-atomic-pool-only-if-dma-zone-has-managed-pages.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages.patch


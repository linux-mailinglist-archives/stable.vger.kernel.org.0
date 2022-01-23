Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FBD497221
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiAWOaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiAWOaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:30:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8D2C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:30:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2307A60CA3
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65D8C340E2;
        Sun, 23 Jan 2022 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642948199;
        bh=wvA5MEk1sqZak7nk8ajGbwrv88Ar/9kh/oKc1Ldbb+8=;
        h=Subject:To:Cc:From:Date:From;
        b=ekrXhpIpzqc4WsFng9BKZ2/VJAmJIghSp4K7+YbDtHm+sFFAivYMIpuiF1GiGj3Rk
         nUJ/CBL1WCwfUOL9ZUEZPBdI8mGMlbVipMkIVMafR94cGy9OS98yI76NdIz0ZYFHW7
         3KpEhZFpUoELu0vgt5NAj9lU5CDhpAUuOKFKhlDA=
Subject: FAILED: patch "[PATCH] dma/pool: create dma atomic pool only if dma zone has managed" failed to apply to 5.4-stable tree
To:     bhe@redhat.com, 42.hyeyoo@gmail.com, David.Laight@ACULAB.COM,
        akpm@linux-foundation.org, bp@alien8.de, cl@linux.com,
        david@redhat.com, hch@lst.de, iamjoonsoo.kim@lge.com,
        john.p.donnelly@oracle.com, m.szyprowski@samsung.com,
        penberg@kernel.org, rientjes@google.com, robin.murphy@arm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:29:56 +0100
Message-ID: <164294819620733@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a674e48c5443d12a8a43c3ac42367aa39505d506 Mon Sep 17 00:00:00 2001
From: Baoquan He <bhe@redhat.com>
Date: Fri, 14 Jan 2022 14:07:41 -0800
Subject: [PATCH] dma/pool: create dma atomic pool only if dma zone has managed
 pages

Currently three dma atomic pools are initialized as long as the relevant
kernel codes are built in.  While in kdump kernel of x86_64, this is not
right when trying to create atomic_pool_dma, because there's no managed
pages in DMA zone.  In the case, DMA zone only has low 1M memory
presented and locked down by memblock allocator.  So no pages are added
into buddy of DMA zone.  Please check commit f1d4d47c5851 ("x86/setup:
Always reserve the first 1M of RAM").

Then in kdump kernel of x86_64, it always prints below failure message:

 DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
 swapper/0: page allocation failure: order:5, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-0.rc5.20210611git929d931f2b40.42.fc35.x86_64 #1
 Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS 2.12.0 06/04/2018
 Call Trace:
  dump_stack+0x7f/0xa1
  warn_alloc.cold+0x72/0xd6
  __alloc_pages_slowpath.constprop.0+0xf29/0xf50
  __alloc_pages+0x24d/0x2c0
  alloc_page_interleave+0x13/0xb0
  atomic_pool_expand+0x118/0x210
  __dma_atomic_pool_init+0x45/0x93
  dma_atomic_pool_init+0xdb/0x176
  do_one_initcall+0x67/0x320
  kernel_init_freeable+0x290/0x2dc
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
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 5f84e6cdb78e..4d40dcce7604 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -203,7 +203,7 @@ static int __init dma_atomic_pool_init(void)
 						    GFP_KERNEL);
 	if (!atomic_pool_kernel)
 		ret = -ENOMEM;
-	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
+	if (has_managed_dma()) {
 		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
 						GFP_KERNEL | GFP_DMA);
 		if (!atomic_pool_dma)
@@ -226,7 +226,7 @@ static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
 	if (prev == NULL) {
 		if (IS_ENABLED(CONFIG_ZONE_DMA32) && (gfp & GFP_DMA32))
 			return atomic_pool_dma32;
-		if (IS_ENABLED(CONFIG_ZONE_DMA) && (gfp & GFP_DMA))
+		if (atomic_pool_dma && (gfp & GFP_DMA))
 			return atomic_pool_dma;
 		return atomic_pool_kernel;
 	}


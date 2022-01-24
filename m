Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233E14998C4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453289AbiAXV3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447370AbiAXVTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:19:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540FDC0610C8;
        Mon, 24 Jan 2022 12:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1CACB8119E;
        Mon, 24 Jan 2022 20:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B331C340E7;
        Mon, 24 Jan 2022 20:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055196;
        bh=LuecBG6exdVyr57uhsw42o+FTE4KyTz6RrJJmYThb+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrclxnQsolJ927gGgNHkldFz1Lr4C9lOKzbDbnMcGOHppZ6R+vZLrZ3HyXeBLo3+1
         cPcRl2QQ1Izu+AteYEkQH8LhkaE/XplSg6p7/DBmUP7lmZNl/7qUxTF55xi07bfB9g
         onr4BRI4aJ8PmJ5RjXgyvl+0nf3VqPEI+0Le3sVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        John Donnelly <john.p.donnelly@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Lameter <cl@linux.com>,
        David Laight <David.Laight@ACULAB.COM>,
        David Rientjes <rientjes@google.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 071/846] dma/pool: create dma atomic pool only if dma zone has managed pages
Date:   Mon, 24 Jan 2022 19:33:08 +0100
Message-Id: <20220124184103.423633377@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit a674e48c5443d12a8a43c3ac42367aa39505d506 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/pool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
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



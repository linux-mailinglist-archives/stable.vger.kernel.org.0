Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665134955ED
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 22:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377854AbiATV0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 16:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347710AbiATV0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 16:26:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CF0C061574;
        Thu, 20 Jan 2022 13:26:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFA1BB81E54;
        Thu, 20 Jan 2022 21:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13538C340E0;
        Thu, 20 Jan 2022 21:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713995;
        bh=fPTeTnThatHODr1WMuOtA1qDRVqmBPqMVFnidFVKO1Y=;
        h=Date:From:To:Subject:From;
        b=o2UxCmYbDCfTPV+awRC5tC4nm+8puYlumEgbHc94HuAW9EaugxPn1EdlwtOpQghOu
         yGp2o27y3LfhlFNCqLFQ2cfBjqIjYEg/QI3Zdur0vjPTuPMrbR8TlD3j9teiuaaqPX
         qjUcMBvoh8j7/F/jWzdkfGuI0DitU5kcPdl6axkQ=
Date:   Thu, 20 Jan 2022 13:26:34 -0800
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, bhe@redhat.com, bp@alien8.de, cl@linux.com,
        David.Laight@ACULAB.COM, david@redhat.com, hch@lst.de,
        iamjoonsoo.kim@lge.com, john.p.donnelly@oracle.com,
        m.szyprowski@samsung.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, robin.murphy@arm.com,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm_zone-add-function-to-check-if-managed-dma-zone-exists.patch removed from
 -mm tree
Message-ID: <20220120212634.4DBtjjTX9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm_zone: add function to check if managed dma zone exists
has been removed from the -mm tree.  Its filename was
     mm_zone-add-function-to-check-if-managed-dma-zone-exists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm_zone: add function to check if managed dma zone exists

Patch series "Handle warning of allocation failure on DMA zone w/o managed pages", v4.

**Problem observed:
On x86_64, when crash is triggered and entering into kdump kernel, page
allocation failure can always be seen.

 ---------------------------------
 DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
 swapper/0: page allocation failure: order:5, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0
 CPU: 0 PID: 1 Comm: swapper/0
 Call Trace:
  dump_stack+0x7f/0xa1
  warn_alloc.cold+0x72/0xd6
  ......
  __alloc_pages+0x24d/0x2c0
  ......
  dma_atomic_pool_init+0xdb/0x176
  do_one_initcall+0x67/0x320
  ? rcu_read_lock_sched_held+0x3f/0x80
  kernel_init_freeable+0x290/0x2dc
  ? rest_init+0x24f/0x24f
  kernel_init+0xa/0x111
  ret_from_fork+0x22/0x30
 Mem-Info:
 ------------------------------------

***Root cause:
In the current kernel, it assumes that DMA zone must have managed pages
and try to request pages if CONFIG_ZONE_DMA is enabled. While this is not
always true. E.g in kdump kernel of x86_64, only low 1M is presented and
locked down at very early stage of boot, so that this low 1M won't be
added into buddy allocator to become managed pages of DMA zone. This
exception will always cause page allocation failure if page is requested
from DMA zone.

***Investigation:
This failure happens since below commit merged into linus's tree.
  1a6a9044b967 x86/setup: Remove CONFIG_X86_RESERVE_LOW and reservelow= options
  23721c8e92f7 x86/crash: Remove crash_reserve_low_1M()
  f1d4d47c5851 x86/setup: Always reserve the first 1M of RAM
  7c321eb2b843 x86/kdump: Remove the backup region handling
  6f599d84231f x86/kdump: Always reserve the low 1M when the crashkernel option is specified

Before them, on x86_64, the low 640K area will be reused by kdump kernel.
So in kdump kernel, the content of low 640K area is copied into a backup
region for dumping before jumping into kdump. Then except of those firmware
reserved region in [0, 640K], the left area will be added into buddy
allocator to become available managed pages of DMA zone.

However, after above commits applied, in kdump kernel of x86_64, the low
1M is reserved by memblock, but not released to buddy allocator. So any
later page allocation requested from DMA zone will fail.

At the beginning, if crashkernel is reserved, the low 1M need be locked
down because AMD SME encrypts memory making the old backup region
mechanims impossible when switching into kdump kernel.

Later, it was also observed that there are BIOSes corrupting memory
under 1M. To solve this, in commit f1d4d47c5851, the entire region of
low 1M is always reserved after the real mode trampoline is allocated.

Besides, recently, Intel engineer mentioned their TDX (Trusted domain
extensions) which is under development in kernel also needs to lock down
the low 1M. So we can't simply revert above commits to fix the page allocation
failure from DMA zone as someone suggested.

***Solution:
Currently, only DMA atomic pool and dma-kmalloc will initialize and
request page allocation with GFP_DMA during bootup.

So only initializ DMA atomic pool when DMA zone has available managed
pages, otherwise just skip the initialization.

For dma-kmalloc(), for the time being, let's mute the warning of
allocation failure if requesting pages from DMA zone while no manged
pages.  Meanwhile, change code to use dma_alloc_xx/dma_map_xx API to
replace kmalloc(GFP_DMA), or do not use GFP_DMA when calling kmalloc() if
not necessary.  Christoph is posting patches to fix those under
drivers/scsi/.  Finally, we can remove the need of dma-kmalloc() as people
suggested.


This patch (of 3):

In some places of the current kernel, it assumes that dma zone must have
managed pages if CONFIG_ZONE_DMA is enabled.  While this is not always
true.  E.g in kdump kernel of x86_64, only low 1M is presented and locked
down at very early stage of boot, so that there's no managed pages at all
in DMA zone.  This exception will always cause page allocation failure if
page is requested from DMA zone.

Here add function has_managed_dma() and the relevant helper functions to
check if there's DMA zone with managed pages.  It will be used in later
patches.

Link: https://lkml.kernel.org/r/20211223094435.248523-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20211223094435.248523-2-bhe@redhat.com
Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: John Donnelly  <john.p.donnelly@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 +++++++++
 mm/page_alloc.c        |   15 +++++++++++++++
 2 files changed, 24 insertions(+)

--- a/include/linux/mmzone.h~mm_zone-add-function-to-check-if-managed-dma-zone-exists
+++ a/include/linux/mmzone.h
@@ -1047,6 +1047,15 @@ static inline int is_highmem_idx(enum zo
 #endif
 }
 
+#ifdef CONFIG_ZONE_DMA
+bool has_managed_dma(void);
+#else
+static inline bool has_managed_dma(void)
+{
+	return false;
+}
+#endif
+
 /**
  * is_highmem - helper function to quickly check if a struct zone is a
  *              highmem zone or not.  This is an attempt to keep references
--- a/mm/page_alloc.c~mm_zone-add-function-to-check-if-managed-dma-zone-exists
+++ a/mm/page_alloc.c
@@ -9518,3 +9518,18 @@ bool take_page_off_buddy(struct page *pa
 	return ret;
 }
 #endif
+
+#ifdef CONFIG_ZONE_DMA
+bool has_managed_dma(void)
+{
+	struct pglist_data *pgdat;
+
+	for_each_online_pgdat(pgdat) {
+		struct zone *zone = &pgdat->node_zones[ZONE_DMA];
+
+		if (managed_zone(zone))
+			return true;
+	}
+	return false;
+}
+#endif /* CONFIG_ZONE_DMA */
_

Patches currently in -mm which might be from bhe@redhat.com are



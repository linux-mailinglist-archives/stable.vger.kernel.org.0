Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3660A499224
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344565AbiAXURf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40224 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346750AbiAXUNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6846661383;
        Mon, 24 Jan 2022 20:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4C2C340E5;
        Mon, 24 Jan 2022 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055193;
        bh=exrSuk96vwoFR+RVQ0VK5/RxwJOrM/jll69Pm0oELdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4Z/HFXcG5lS4STJDPCUpW1iUwQpJ3G5m+CY14NgTSwv12fXDbxBq8La+DgUaxmTi
         bvHRPbS9D1kKVkd0KgDGrKzXztAKrumNH/5yeumKUSVRpeiMCgaOhaA0vt4rH+DKkT
         HLRNwXe5QlaiUxquwsipBoCgPWwOIlCu2WiH9AzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Laight <David.Laight@ACULAB.COM>,
        Borislav Petkov <bp@alien8.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 070/846] mm_zone: add function to check if managed dma zone exists
Date:   Mon, 24 Jan 2022 19:33:07 +0100
Message-Id: <20220124184103.388875588@linuxfoundation.org>
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

commit 62b3107073646e0946bd97ff926832bafb846d17 upstream.

Patch series "Handle warning of allocation failure on DMA zone w/o
managed pages", v4.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |    9 +++++++++
 mm/page_alloc.c        |   15 +++++++++++++++
 2 files changed, 24 insertions(+)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1031,6 +1031,15 @@ static inline int is_highmem_idx(enum zo
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
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -9449,3 +9449,18 @@ bool take_page_off_buddy(struct page *pa
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



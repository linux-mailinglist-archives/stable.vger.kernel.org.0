Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1195203A2
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbiEIRig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 13:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbiEIRig (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 13:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E782415E9;
        Mon,  9 May 2022 10:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A90861594;
        Mon,  9 May 2022 17:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E2C385B2;
        Mon,  9 May 2022 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652117680;
        bh=K0Xa/ePGixBjtV19iXDf76f9F1aE0pPc6HJseapHjfo=;
        h=Date:To:From:Subject:From;
        b=GeI3EluaUBXDzYRA24S0OhDciyi3M9PnP2buAo1f3E5BVLhyUNBXSqcy+kTBXdkiJ
         O9WK5a3D4BVmYC5wJsa3OejR/H+CdEMjWtiNcfoAgsaSviFvwpDlC0QcmKqVn4D/C3
         GX5ApFpJLAAU2R9wOFR9lxmyr+88M4XkQWsyywXw=
Date:   Mon, 09 May 2022 10:34:39 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        m.szyprowski@samsung.com, minchan@kernel.org,
        lecopzer.chen@mediatek.com, david@redhat.com, aisheng.dong@nxp.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-cmac-remove-redundant-cma_mutex-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20220509173440.911E2C385B2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "mm/cma.c: remove redundant cma_mutex lock"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-cmac-remove-redundant-cma_mutex-lock.patch

This patch should soon appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dong Aisheng <aisheng.dong@nxp.com>
Subject: Revert "mm/cma.c: remove redundant cma_mutex lock"

This reverts commit a4efc174b382fcdb which introduced a regression issue
that when there're multiple processes allocating dma memory in parallel by
calling dma_alloc_coherent(), it may fail sometimes as follows:

Error log:
cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
cma: number of available pages:
3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages

When issue happened, we saw there were still 33161 pages (129M) free CMA
memory and a lot available free slots for 148 pages in CMA bitmap that we
want to allocate.

When dumping memory info, we found that there was also ~342M normal
memory, but only 1352K CMA memory left in buddy system while a lot of
pageblocks were isolated.

Memory info log:
Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
	    active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
	    unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
	    bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
	36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
	8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB

The root cause of this issue is that since commit a4efc174b382 ("mm/cma.c:
remove redundant cma_mutex lock"), CMA supports concurrent memory
allocation.  It's possible that the memory range process A trying to alloc
has already been isolated by the allocation of process B during memory
migration.

The problem here is that the memory range isolated during one allocation
by start_isolate_page_range() could be much bigger than the real size we
want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.

Taking an ARMv7 platform with 1G memory as an example, when
MAX_ORDER_NR_PAGES is big (e.g.  32M with max_order 14) and CMA memory is
relatively small (e.g.  128M), there're only 4 MAX_ORDER slot, then it's
very easy that all CMA memory may have already been isolated by other
processes when one trying to allocate memory using dma_alloc_coherent(). 
Since current CMA code will only scan one time of whole available CMA
memory, then dma_alloc_coherent() may easy fail due to contention with
other processes.

This patch simply falls back to the original method that using cma_mutex
to make alloc_contig_range() run sequentially to avoid the issue.

Link: https://lkml.kernel.org/r/20220509094551.3596244-1-aisheng.dong@nxp.com
Link: https://lore.kernel.org/all/20220315144521.3810298-2-aisheng.dong@nxp.com/
Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[5.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/cma.c~revert-mm-cmac-remove-redundant-cma_mutex-lock
+++ a/mm/cma.c
@@ -37,6 +37,7 @@
 
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned cma_area_count;
+static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(const struct cma *cma)
 {
@@ -468,9 +469,10 @@ struct page *cma_alloc(struct cma *cma,
 		spin_unlock_irq(&cma->lock);
 
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
+		mutex_lock(&cma_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
 				     GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-
+		mutex_unlock(&cma_mutex);
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
 			break;
_

Patches currently in -mm which might be from aisheng.dong@nxp.com are

revert-mm-cmac-remove-redundant-cma_mutex-lock.patch


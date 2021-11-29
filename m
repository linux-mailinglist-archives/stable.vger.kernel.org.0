Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858C14627AE
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbhK2XIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbhK2XIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:08:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC17C1E0FD8;
        Mon, 29 Nov 2021 10:42:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4421DCE13E0;
        Mon, 29 Nov 2021 18:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07D8C53FCD;
        Mon, 29 Nov 2021 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211330;
        bh=huEPUdk5fDgkijk94EmR3pclF+CiY+4NuPSjQOSdgzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEw3O3uEdB1rtDXUng8vy2+3La2vKVKUFmZgfVHvmKruTSHw5+YuafBEc36tZrC6j
         TznCeyCGMzJp94c2uTo6ovPjm0/cNQgbspyQoINOMs11G9lI6oeNrlpGVGTZaqP+iG
         8SjkwAm6VZpvksJM2UqCKKMo/UNZE3kaumEFNlqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/179] iommu/vt-d: Fix unmap_pages support
Date:   Mon, 29 Nov 2021 19:19:13 +0100
Message-Id: <20211129181724.175269934@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 86dc40c7ea9c22f64571e0e45f695de73a0e2644 ]

When supporting only the .map and .unmap callbacks of iommu_ops,
the IOMMU driver can make assumptions about the size and alignment
used for mappings based on the driver provided pgsize_bitmap.  VT-d
previously used essentially PAGE_MASK for this bitmap as any power
of two mapping was acceptably filled by native page sizes.

However, with the .map_pages and .unmap_pages interface we're now
getting page-size and count arguments.  If we simply combine these
as (page-size * count) and make use of the previous map/unmap
functions internally, any size and alignment assumptions are very
different.

As an example, a given vfio device assignment VM will often create
a 4MB mapping at IOVA pfn [0x3fe00 - 0x401ff].  On a system that
does not support IOMMU super pages, the unmap_pages interface will
ask to unmap 1024 4KB pages at the base IOVA.  dma_pte_clear_level()
will recurse down to level 2 of the page table where the first half
of the pfn range exactly matches the entire pte level.  We clear the
pte, increment the pfn by the level size, but (oops) the next pte is
on a new page, so we exit the loop an pop back up a level.  When we
then update the pfn based on that higher level, we seem to assume
that the previous pfn value was at the start of the level.  In this
case the level size is 256K pfns, which we add to the base pfn and
get a results of 0x7fe00, which is clearly greater than 0x401ff,
so we're done.  Meanwhile we never cleared the ptes for the remainder
of the range.  When the VM remaps this range, we're overwriting valid
ptes and the VT-d driver complains loudly, as reported by the user
report linked below.

The fix for this seems relatively simple, if each iteration of the
loop in dma_pte_clear_level() is assumed to clear to the end of the
level pte page, then our next pfn should be calculated from level_pfn
rather than our working pfn.

Fixes: 3f34f1259776 ("iommu/vt-d: Implement map/unmap_pages() iommu_ops callback")
Reported-by: Ajay Garg <ajaygargnsit@gmail.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Link: https://lore.kernel.org/all/20211002124012.18186-1-ajaygargnsit@gmail.com/
Link: https://lore.kernel.org/r/163659074748.1617923.12716161410774184024.stgit@omen
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20211126135556.397932-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9a356075d3450..78f8c8e6803e9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1226,13 +1226,11 @@ static struct page *dma_pte_clear_level(struct dmar_domain *domain, int level,
 	pte = &pte[pfn_level_offset(pfn, level)];
 
 	do {
-		unsigned long level_pfn;
+		unsigned long level_pfn = pfn & level_mask(level);
 
 		if (!dma_pte_present(pte))
 			goto next;
 
-		level_pfn = pfn & level_mask(level);
-
 		/* If range covers entire pagetable, free it */
 		if (start_pfn <= level_pfn &&
 		    last_pfn >= level_pfn + level_size(level) - 1) {
@@ -1253,7 +1251,7 @@ static struct page *dma_pte_clear_level(struct dmar_domain *domain, int level,
 						       freelist);
 		}
 next:
-		pfn += level_size(level);
+		pfn = level_pfn + level_size(level);
 	} while (!first_pte_in_page(++pte) && pfn <= last_pfn);
 
 	if (first_pte)
-- 
2.33.0




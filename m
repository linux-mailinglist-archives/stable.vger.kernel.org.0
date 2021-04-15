Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6C135FEFF
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 02:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhDOArH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 20:47:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16588 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhDOArH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 20:47:07 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FLLFf3sFvz16KDb;
        Thu, 15 Apr 2021 08:44:22 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.151.207) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 08:46:31 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC:     <longpeng2@huawei.com>, David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Gonglei <arei.gonglei@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] iommu/vt-d: Force to flush iotlb before creating superpage
Date:   Thu, 15 Apr 2021 08:46:28 +0800
Message-ID: <20210415004628.1779-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.151.207]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The translation caches may preserve obsolete data when the
mapping size is changed, suppose the following sequence which
can reveal the problem with high probability.

1.mmap(4GB,MAP_HUGETLB)
2.
  while (1) {
   (a)    DMA MAP   0,0xa0000
   (b)    DMA UNMAP 0,0xa0000
   (c)    DMA MAP   0,0xc0000000
             * DMA read IOVA 0 may failure here (Not present)
             * if the problem occurs.
   (d)    DMA UNMAP 0,0xc0000000
  }

The page table(only focus on IOVA 0) after (a) is:
 PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
  PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
   PDE: 0x1a30a72003  entry:0xffff89b39cacb000
    PTE: 0x21d200803  entry:0xffff89b3b0a72000

The page table after (b) is:
 PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
  PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
   PDE: 0x1a30a72003  entry:0xffff89b39cacb000
    PTE: 0x0          entry:0xffff89b3b0a72000

The page table after (c) is:
 PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
  PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
   PDE: 0x21d200883   entry:0xffff89b39cacb000 (*)

Because the PDE entry after (b) is present, it won't be
flushed even if the iommu driver flush cache when unmap,
so the obsolete data may be preserved in cache, which
would cause the wrong translation at end.

However, we can see the PDE entry is finally switch to
2M-superpage mapping, but it does not transform
to 0x21d200883 directly:

1. PDE: 0x1a30a72003
2. __domain_mapping
     dma_pte_free_pagetable
       Set the PDE entry to ZERO
     Set the PDE entry to 0x21d200883

So we must flush the cache after the entry switch to ZERO
to avoid the obsolete info be preserved.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Gonglei (Arei) <arei.gonglei@huawei.com>

Fixes: 6491d4d02893 ("intel-iommu: Free old page tables before creating superpage")
Cc: <stable@vger.kernel.org> # v3.0+
Link: https://lore.kernel.org/linux-iommu/670baaf8-4ff8-4e84-4be3-030b95ab5a5e@huawei.com/
Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
v1 -> v2:
  - add Joerg
  - reconstruct the solution base on the Baolu's suggestion
---
 drivers/iommu/intel/iommu.c | 52 +++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ee09323..881c9f2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2289,6 +2289,41 @@ static inline int hardware_largepage_caps(struct dmar_domain *domain,
 	return level;
 }
 
+/*
+ * Ensure that old small page tables are removed to make room for superpage(s).
+ * We're going to add new large pages, so make sure we don't remove their parent
+ * tables. The IOTLB/devTLBs should be flushed if any PDE/PTEs are cleared.
+ */
+static void switch_to_super_page(struct dmar_domain *domain,
+				 unsigned long start_pfn,
+				 unsigned long end_pfn, int level)
+{
+	unsigned long lvl_pages = lvl_to_nr_pages(level);
+	struct dma_pte *pte = NULL;
+	int i;
+
+	while (start_pfn <= end_pfn) {
+		if (!pte)
+			pte = pfn_to_dma_pte(domain, start_pfn, &level);
+
+		if (dma_pte_present(pte)) {
+			dma_pte_free_pagetable(domain, start_pfn,
+					       start_pfn + lvl_pages - 1,
+					       level + 1);
+
+			for_each_domain_iommu(i, domain)
+				iommu_flush_iotlb_psi(g_iommus[i], domain,
+						      start_pfn, lvl_pages,
+						      0, 0);
+		}
+
+		pte++;
+		start_pfn += lvl_pages;
+		if (first_pte_in_page(pte))
+			pte = NULL;
+	}
+}
+
 static int
 __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		 unsigned long phys_pfn, unsigned long nr_pages, int prot)
@@ -2329,22 +2364,11 @@ static inline int hardware_largepage_caps(struct dmar_domain *domain,
 				return -ENOMEM;
 			/* It is large page*/
 			if (largepage_lvl > 1) {
-				unsigned long nr_superpages, end_pfn;
+				unsigned long end_pfn;
 
 				pteval |= DMA_PTE_LARGE_PAGE;
-				lvl_pages = lvl_to_nr_pages(largepage_lvl);
-
-				nr_superpages = nr_pages / lvl_pages;
-				end_pfn = iov_pfn + nr_superpages * lvl_pages - 1;
-
-				/*
-				 * Ensure that old small page tables are
-				 * removed to make room for superpage(s).
-				 * We're adding new large pages, so make sure
-				 * we don't remove their parent tables.
-				 */
-				dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
-						       largepage_lvl + 1);
+				end_pfn = ((iov_pfn + nr_pages) & level_mask(largepage_lvl)) - 1;
+				switch_to_super_page(domain, iov_pfn, end_pfn, largepage_lvl);
 			} else {
 				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
 			}
-- 
1.8.3.1


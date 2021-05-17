Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFABD38232C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 05:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhEQDv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 23:51:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:27592 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhEQDv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 May 2021 23:51:27 -0400
IronPort-SDR: F13MYEXJuruYxAQQHkq3fIkpXjGGywpLBWgIu1ZRG73zS9uXy2RUX+8shXiJz4nTiufwXh2tx4
 gO94HUuzoRMA==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="261613206"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="261613206"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2021 20:50:11 -0700
IronPort-SDR: PsPjHXGapbhLOIluvi7jsUk7/tP/cHlCgbhzRctSmfzMIK0Kwv9/M2GuDbC+yXpQH9pCZ5Zuz/
 ENhtzz7Ayg5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="460079875"
Received: from allen-box.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2021 20:50:09 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     sashal@kernel.org, gregkh@linuxfoundation.org
Cc:     ashok.raj@intel.com, jroedel@suse.de, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [REWORKED PATCH 1/1] iommu/vt-d: Preset Access/Dirty bits for IOVA over FL
Date:   Mon, 17 May 2021 11:49:13 +0800
Message-Id: <20210517034913.3432-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 ]

The Access/Dirty bits in the first level page table entry will be set
whenever a page table entry was used for address translation or write
permission was successfully translated. This is always true when using
the first-level page table for kernel IOVA. Instead of wasting hardware
cycles to update the certain bits, it's better to set them up at the
beginning.

Suggested-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210115004202.953965-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 14 ++++++++++++--
 include/linux/intel-iommu.h |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

[Note:
- This is a reworked patch of
  https://lore.kernel.org/stable/20210512144819.664462530@linuxfoundation.org/T/#m65267f0a0091c2fcbde097cea91089775908faad.
- It aims to fix a reported issue of
  https://bugzilla.kernel.org/show_bug.cgi?id=213077.
- Please help to review and test.]

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3295e5e162a4..33ffbcb53dec 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1028,8 +1028,11 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
 			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
-			if (domain_use_first_level(domain))
+			if (domain_use_first_level(domain)) {
 				pteval |= DMA_FL_PTE_XD | DMA_FL_PTE_US;
+				if (domain->domain.type == IOMMU_DOMAIN_DMA)
+					pteval |= DMA_FL_PTE_ACCESS;
+			}
 			if (cmpxchg64(&pte->val, 0ULL, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
 				free_pgtable_page(tmp_page);
@@ -2354,9 +2357,16 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		return -EINVAL;
 
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
-	if (domain_use_first_level(domain))
+	if (domain_use_first_level(domain)) {
 		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD | DMA_FL_PTE_US;
 
+		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
+			attr |= DMA_FL_PTE_ACCESS;
+			if (prot & DMA_PTE_WRITE)
+				attr |= DMA_FL_PTE_DIRTY;
+		}
+	}
+
 	if (!sg) {
 		sg_res = nr_pages;
 		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 94522685a0d9..ccaa057faf8c 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -42,6 +42,8 @@
 
 #define DMA_FL_PTE_PRESENT	BIT_ULL(0)
 #define DMA_FL_PTE_US		BIT_ULL(2)
+#define DMA_FL_PTE_ACCESS	BIT_ULL(5)
+#define DMA_FL_PTE_DIRTY	BIT_ULL(6)
 #define DMA_FL_PTE_XD		BIT_ULL(63)
 
 #define ADDR_WIDTH_5LEVEL	(57)
-- 
2.25.1


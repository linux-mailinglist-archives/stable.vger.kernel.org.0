Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCE837C5AE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhELPmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236156AbhELPhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A2561C4E;
        Wed, 12 May 2021 15:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832712;
        bh=Yf8qw+FhU0gn+AhqcJV42bubC8diNGShU7v2phVauxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBvHAsJzVNQoBlwDApJgZZKu4BvPPpNc/SARuepv9Bp7LYwmSpDPabUUIBLhhhT6h
         y+ThPynbheSpqDq4192a+1VdiE38gJGUiw44wqvhNxo0sUL1rYRb7k0YZtsZJvsM17
         DkCMFnIp5M5zAfQ8IFYkeUFEfbt6WnXhpAmgguiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/530] iommu/vt-d: Preset Access/Dirty bits for IOVA over FL
Date:   Wed, 12 May 2021 16:48:22 +0200
Message-Id: <20210512144832.660153884@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

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
 drivers/iommu/intel/iommu.c | 17 ++++++++++++-----
 include/linux/intel-iommu.h |  2 ++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3295e5e162a4..8010c3895f8c 100644
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
@@ -2354,14 +2357,18 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		return -EINVAL;
 
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
-	if (domain_use_first_level(domain))
+	if (domain_use_first_level(domain)) {
 		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD | DMA_FL_PTE_US;
 
-	if (!sg) {
-		sg_res = nr_pages;
-		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
+		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
+			attr |= DMA_FL_PTE_ACCESS;
+			if (prot & DMA_PTE_WRITE)
+				attr |= DMA_FL_PTE_DIRTY;
+		}
 	}
 
+	pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
+
 	while (nr_pages > 0) {
 		uint64_t tmp;
 
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
2.30.2




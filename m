Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBD538383B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbhEQPuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236801AbhEQPsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:48:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4164F61D3E;
        Mon, 17 May 2021 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262703;
        bh=2eQ1qHTJq6cqie3db6kFAzA/7Phu+3ozOdCWCnigtUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlTlOld4LZyV5SPypunSojuGKPnMRGjtsJBGhlGPzXUYI1SpbFGnwASSG5lLOflWu
         i1Uqq9Uzu0iEZgCDClSqBzZUa0ganJc7MbFuNZuNqceVTLZxpasxsFDnv5MOLOXwhO
         1CjZgYySEzriqWm7MoU0tKM6JvesiEjvzEdGXOg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 263/289] iommu/vt-d: Preset Access/Dirty bits for IOVA over FL
Date:   Mon, 17 May 2021 16:03:08 +0200
Message-Id: <20210517140313.999886927@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |   14 ++++++++++++--
 include/linux/intel-iommu.h |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1028,8 +1028,11 @@ static struct dma_pte *pfn_to_dma_pte(st
 
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
@@ -2359,9 +2362,16 @@ static int __domain_mapping(struct dmar_
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
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -42,6 +42,8 @@
 
 #define DMA_FL_PTE_PRESENT	BIT_ULL(0)
 #define DMA_FL_PTE_US		BIT_ULL(2)
+#define DMA_FL_PTE_ACCESS	BIT_ULL(5)
+#define DMA_FL_PTE_DIRTY	BIT_ULL(6)
 #define DMA_FL_PTE_XD		BIT_ULL(63)
 
 #define ADDR_WIDTH_5LEVEL	(57)



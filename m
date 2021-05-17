Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124B6383873
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243818AbhEQPxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241559AbhEQPuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA73361442;
        Mon, 17 May 2021 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262763;
        bh=VM1rfCZqGRioSwtoMBQhxfkw1LM++KGXzZ0aJsaCq9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2PLnBpA3MeMIzYuB08PTti1eWpSMh3kjPJ2Am+8G/59I5PGmc0AG0H/HNzFmAddE
         dSFYT50NgoWi7Rh2wsY03YVHCG0MVveaEfV9w3L5uhIzF/6h6jsbneprr+kEhC+5Ht
         eVhdj5eidBcuPrApzTuETXRaR7+J+B4EX1Ff3B58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Wolfgang=20M=C3=BCller?= <wolf@oriole.systems>,
        Charles Wright <charles@charleswright.co>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/289] Revert "iommu/vt-d: Preset Access/Dirty bits for IOVA over FL"
Date:   Mon, 17 May 2021 16:03:07 +0200
Message-Id: <20210517140313.969017886@linuxfoundation.org>
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

This reverts commit 416fa531c8160151090206a51b829b9218b804d9 which is
commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 upstream as it was
backported incorrectly and is causing problems for some systems.

Reported-by: Wolfgang Müller <wolf@oriole.systems>
Reported-by: Charles Wright <charles@charleswright.co>
Reported-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |   17 +++++------------
 include/linux/intel-iommu.h |    2 --
 2 files changed, 5 insertions(+), 14 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1028,11 +1028,8 @@ static struct dma_pte *pfn_to_dma_pte(st
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
 			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
-			if (domain_use_first_level(domain)) {
+			if (domain_use_first_level(domain))
 				pteval |= DMA_FL_PTE_XD | DMA_FL_PTE_US;
-				if (domain->domain.type == IOMMU_DOMAIN_DMA)
-					pteval |= DMA_FL_PTE_ACCESS;
-			}
 			if (cmpxchg64(&pte->val, 0ULL, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
 				free_pgtable_page(tmp_page);
@@ -2362,18 +2359,14 @@ static int __domain_mapping(struct dmar_
 		return -EINVAL;
 
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
-	if (domain_use_first_level(domain)) {
+	if (domain_use_first_level(domain))
 		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD | DMA_FL_PTE_US;
 
-		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
-			attr |= DMA_FL_PTE_ACCESS;
-			if (prot & DMA_PTE_WRITE)
-				attr |= DMA_FL_PTE_DIRTY;
-		}
+	if (!sg) {
+		sg_res = nr_pages;
+		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
 	}
 
-	pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
-
 	while (nr_pages > 0) {
 		uint64_t tmp;
 
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -42,8 +42,6 @@
 
 #define DMA_FL_PTE_PRESENT	BIT_ULL(0)
 #define DMA_FL_PTE_US		BIT_ULL(2)
-#define DMA_FL_PTE_ACCESS	BIT_ULL(5)
-#define DMA_FL_PTE_DIRTY	BIT_ULL(6)
 #define DMA_FL_PTE_XD		BIT_ULL(63)
 
 #define ADDR_WIDTH_5LEVEL	(57)



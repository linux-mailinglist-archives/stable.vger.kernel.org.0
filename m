Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DA91CAF94
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgEHMme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbgEHMme (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F0BA20731;
        Fri,  8 May 2020 12:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941753;
        bh=DOq5NyZI2kGxV9MUSFomxzrGe8f3TwtoAqsyEsp4P68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUHG7V+IpaLNqtTDXm53e3KHnyOhsV89o7aCK9nw7t1+WpGjGlxKBNtC8rQQHK/8b
         U6riamlxUtpyJV8n1F7raSBtuun2DX6nk2iB3Or1sU4zP0dwrJCBpKl3qPXFJgCWxU
         fgJg3lF9tObUdf2TApaFmTWSvHyxLvr1cyhv4kig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.4 159/312] iommu/dma: Respect IOMMU aperture when allocating
Date:   Fri,  8 May 2020 14:32:30 +0200
Message-Id: <20200508123135.636127742@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit c987ff0d3cb37d7fe1ddaa370811dfd9f73643fa upstream.

Where a device driver has set a 64-bit DMA mask to indicate the absence
of addressing limitations, we still need to ensure that we don't
allocate IOVAs beyond the actual input size of the IOMMU. The reported
aperture is the most reliable way we have of inferring that input
address size, so use that to enforce a hard upper limit where available.

Fixes: 0db2e5d18f76 ("iommu: Implement common IOMMU ops for DMA mapping")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/dma-iommu.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -152,12 +152,15 @@ int dma_direction_to_prot(enum dma_data_
 	}
 }
 
-static struct iova *__alloc_iova(struct iova_domain *iovad, size_t size,
+static struct iova *__alloc_iova(struct iommu_domain *domain, size_t size,
 		dma_addr_t dma_limit)
 {
+	struct iova_domain *iovad = domain->iova_cookie;
 	unsigned long shift = iova_shift(iovad);
 	unsigned long length = iova_align(iovad, size) >> shift;
 
+	if (domain->geometry.force_aperture)
+		dma_limit = min(dma_limit, domain->geometry.aperture_end);
 	/*
 	 * Enforce size-alignment to be safe - there could perhaps be an
 	 * attribute to control this per-device, or at least per-domain...
@@ -297,7 +300,7 @@ struct page **iommu_dma_alloc(struct dev
 	if (!pages)
 		return NULL;
 
-	iova = __alloc_iova(iovad, size, dev->coherent_dma_mask);
+	iova = __alloc_iova(domain, size, dev->coherent_dma_mask);
 	if (!iova)
 		goto out_free_pages;
 
@@ -369,7 +372,7 @@ dma_addr_t iommu_dma_map_page(struct dev
 	phys_addr_t phys = page_to_phys(page) + offset;
 	size_t iova_off = iova_offset(iovad, phys);
 	size_t len = iova_align(iovad, size + iova_off);
-	struct iova *iova = __alloc_iova(iovad, len, dma_get_mask(dev));
+	struct iova *iova = __alloc_iova(domain, len, dma_get_mask(dev));
 
 	if (!iova)
 		return DMA_ERROR_CODE;
@@ -483,7 +486,7 @@ int iommu_dma_map_sg(struct device *dev,
 		prev = s;
 	}
 
-	iova = __alloc_iova(iovad, iova_len, dma_get_mask(dev));
+	iova = __alloc_iova(domain, iova_len, dma_get_mask(dev));
 	if (!iova)
 		goto out_restore_sg;
 



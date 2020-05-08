Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305011CAD30
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgEHMxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730098AbgEHMxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:53:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A19C24963;
        Fri,  8 May 2020 12:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942423;
        bh=4aXsBr/dL/0+ttwploB5BdhKcSkd4UKS64y/LQDQrx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejdPe8AGsWE9UVkzZXshRPEIgLM+FudRgAwrizcnXUsdPy/Zeiu13ilZLwh5Fu/w7
         rqlVzBIPDJB5o08ZVRiTv4UG73wCSepzASkkGuMN0xQ8i664wKwYymWWE215ETS2Ux
         oz6af/lGmnKQCUM/fdc/uCrDIES0iwaBGLUM/+Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 40/50] dma-direct: exclude dma_direct_map_resource from the min_low_pfn check
Date:   Fri,  8 May 2020 14:35:46 +0200
Message-Id: <20200508123048.730720753@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 68a33b1794665ba8a1d1ef1d3bfcc7c587d380a6 upstream.

The valid memory address check in dma_capable only makes sense when mapping
normal memory, not when using dma_map_resource to map a device resource.
Add a new boolean argument to dma_capable to exclude that check for the
dma_map_resource case.

Fixes: b12d66278dd6 ("dma-direct: check for overflows on 32 bit DMA addresses")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/amd_gart_64.c |    4 ++--
 drivers/xen/swiotlb-xen.c     |    4 ++--
 include/linux/dma-direct.h    |    5 +++--
 kernel/dma/direct.c           |    4 ++--
 kernel/dma/swiotlb.c          |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -185,13 +185,13 @@ static void iommu_full(struct device *de
 static inline int
 need_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	return force_iommu || !dma_capable(dev, addr, size);
+	return force_iommu || !dma_capable(dev, addr, size, true);
 }
 
 static inline int
 nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	return !dma_capable(dev, addr, size);
+	return !dma_capable(dev, addr, size, true);
 }
 
 /* Map a single continuous physical area into the IOMMU.
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -375,7 +375,7 @@ static dma_addr_t xen_swiotlb_map_page(s
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (dma_capable(dev, dev_addr, size) &&
+	if (dma_capable(dev, dev_addr, size, true) &&
 	    !range_straddles_page_boundary(phys, size) &&
 		!xen_arch_need_swiotlb(dev, phys, dev_addr) &&
 		swiotlb_force != SWIOTLB_FORCE)
@@ -397,7 +397,7 @@ static dma_addr_t xen_swiotlb_map_page(s
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (unlikely(!dma_capable(dev, dev_addr, size))) {
+	if (unlikely(!dma_capable(dev, dev_addr, size, true))) {
 		swiotlb_tbl_unmap_single(dev, map, size, size, dir,
 				attrs | DMA_ATTR_SKIP_CPU_SYNC);
 		return DMA_MAPPING_ERROR;
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -25,14 +25,15 @@ static inline phys_addr_t __dma_to_phys(
 	return paddr + ((phys_addr_t)dev->dma_pfn_offset << PAGE_SHIFT);
 }
 
-static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
+		bool is_ram)
 {
 	dma_addr_t end = addr + size - 1;
 
 	if (!dev->dma_mask)
 		return false;
 
-	if (!IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
+	if (is_ram && !IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
 	    min(addr, end) < phys_to_dma(dev, PFN_PHYS(min_low_pfn)))
 		return false;
 
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -327,7 +327,7 @@ static inline bool dma_direct_possible(s
 		size_t size)
 {
 	return swiotlb_force != SWIOTLB_FORCE &&
-		dma_capable(dev, dma_addr, size);
+		dma_capable(dev, dma_addr, size, true);
 }
 
 dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
@@ -376,7 +376,7 @@ dma_addr_t dma_direct_map_resource(struc
 {
 	dma_addr_t dma_addr = paddr;
 
-	if (unlikely(!dma_capable(dev, dma_addr, size))) {
+	if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
 		report_addr(dev, dma_addr, size);
 		return DMA_MAPPING_ERROR;
 	}
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -678,7 +678,7 @@ bool swiotlb_map(struct device *dev, phy
 
 	/* Ensure that the address returned is DMA'ble */
 	*dma_addr = __phys_to_dma(dev, *phys);
-	if (unlikely(!dma_capable(dev, *dma_addr, size))) {
+	if (unlikely(!dma_capable(dev, *dma_addr, size, true))) {
 		swiotlb_tbl_unmap_single(dev, *phys, size, size, dir,
 			attrs | DMA_ATTR_SKIP_CPU_SYNC);
 		return false;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B35D29BA22
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783116AbgJ0P5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802783AbgJ0PvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:51:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1698A2225E;
        Tue, 27 Oct 2020 15:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813883;
        bh=9iPo4/hp2YEw3swUk+14mrzdWhjCjXb3i5AxyrV/VZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mi6o7c2afhDYR/hSfqEM0/4ZxO3S6BGhkRYwMct037p8KDeuJobFLDYikeYWu7R70
         Xhq3DyCQ8UOverduO4VUdg77kz86f38cdyAP46MtrsE7BXSpmuGWkYv+P1dHcQW6WK
         W9DKlNXS5YI8ml7J+P+z8JlZ0PEtiPdQEeiBO2AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Tai <thomas.tai@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 702/757] dma-direct: Fix potential NULL pointer dereference
Date:   Tue, 27 Oct 2020 14:55:52 +0100
Message-Id: <20201027135523.426340054@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Tai <thomas.tai@oracle.com>

[ Upstream commit f959dcd6ddfd29235030e8026471ac1b022ad2b0 ]

When booting the kernel v5.9-rc4 on a VM, the kernel would panic when
printing a warning message in swiotlb_map(). The dev->dma_mask must not
be a NULL pointer when calling the dma mapping layer. A NULL pointer
check can potentially avoid the panic.

Signed-off-by: Thomas Tai <thomas.tai@oracle.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-direct.h |  3 ---
 kernel/dma/mapping.c       | 11 +++++++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 6e87225600ae3..064870844f06c 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -62,9 +62,6 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
 {
 	dma_addr_t end = addr + size - 1;
 
-	if (!dev->dma_mask)
-		return false;
-
 	if (is_ram && !IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
 	    min(addr, end) < phys_to_dma(dev, PFN_PHYS(min_low_pfn)))
 		return false;
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 0d129421e75fc..7133d5c6e1a6d 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -144,6 +144,10 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
+
+	if (WARN_ON_ONCE(!dev->dma_mask))
+		return DMA_MAPPING_ERROR;
+
 	if (dma_map_direct(dev, ops))
 		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
 	else
@@ -179,6 +183,10 @@ int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg, int nents,
 	int ents;
 
 	BUG_ON(!valid_dma_direction(dir));
+
+	if (WARN_ON_ONCE(!dev->dma_mask))
+		return 0;
+
 	if (dma_map_direct(dev, ops))
 		ents = dma_direct_map_sg(dev, sg, nents, dir, attrs);
 	else
@@ -213,6 +221,9 @@ dma_addr_t dma_map_resource(struct device *dev, phys_addr_t phys_addr,
 
 	BUG_ON(!valid_dma_direction(dir));
 
+	if (WARN_ON_ONCE(!dev->dma_mask))
+		return DMA_MAPPING_ERROR;
+
 	/* Don't allow RAM to be mapped */
 	if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
 		return DMA_MAPPING_ERROR;
-- 
2.25.1




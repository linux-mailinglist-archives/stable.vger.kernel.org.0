Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D633D311A
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 03:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhGWAZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 20:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhGWAZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 20:25:37 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B90C061575;
        Thu, 22 Jul 2021 18:06:11 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 5C8B01F447F8
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     iommu@lists.linux-foundation.org, linux-media@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com,
        stable@vger.kernel.org
Subject: [PATCH] iommu/dma: Fix leak in non-contiguous API
Date:   Thu, 22 Jul 2021 22:05:52 -0300
Message-Id: <20210723010552.50969-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, iommu_dma_alloc_noncontiguous() allocates a
struct dma_sgt_handle object to hold some state needed for
iommu_dma_free_noncontiguous().

However, the handle is neither freed nor returned explicitly by
the ->alloc_noncontiguous method, and therefore seems leaked.
This was found by code inspection, so please review carefully and test.

As a side note, it appears the struct dma_sgt_handle type is exposed
to users of the DMA-API by linux/dma-map-ops.h, but is has no users
or functions returning the type explicitly.

This may indicate it's a good idea to move the struct dma_sgt_handle type
to drivers/iommu/dma-iommu.c. The decision is left to maintainers :-)

Cc: stable@vger.kernel.org
Fixes: e817ee5f2f95c ("dma-iommu: implement ->alloc_noncontiguous")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/iommu/dma-iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 4e34e8b26579..16c06a1aab80 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -768,6 +768,7 @@ static void iommu_dma_free_noncontiguous(struct device *dev, size_t size,
 	__iommu_dma_unmap(dev, sgt->sgl->dma_address, size);
 	__iommu_dma_free_pages(sh->pages, PAGE_ALIGN(size) >> PAGE_SHIFT);
 	sg_free_table(&sh->sgt);
+	kfree(sh);
 }
 #endif /* CONFIG_DMA_REMAP */
 
-- 
2.32.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5073B769FC
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387859AbfGZNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387845AbfGZNmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F109822CBF;
        Fri, 26 Jul 2019 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148527;
        bh=63hZ9egKx37hVIVrHIR+iW3hIjhT86QqwlTUfbow8ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13drCaaYs1fy5Q4V6I3OCj9rdrrttgeYO9n6Owl7/KqxJ/icOXa6WZ8Enwn3rrHKV
         RJEhosfZ1DSVPVKh7alUMar8RTqijvfhq175z/bpQB97fvvvgDjKOTKnnIhqA3+9y0
         0JGWouMllXHX5Svv7NCkxdVACi3DCEMZCBb4PA8U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.2 84/85] dma-direct: correct the physical addr in dma_direct_sync_sg_for_cpu/device
Date:   Fri, 26 Jul 2019 09:39:34 -0400
Message-Id: <20190726133936.11177-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 449fa54d6815be8c2c1f68fa9dbbae9384a7c03e ]

dma_map_sg() may use swiotlb buffer when the kernel command line includes
"swiotlb=force" or the dma_addr is out of dev->dma_mask range.  After
DMA complete the memory moving from device to memory, then user call
dma_sync_sg_for_cpu() to sync with DMA buffer, and copy the original
virtual buffer to other space.

So dma_direct_sync_sg_for_cpu() should use swiotlb physical addr, not
the original physical addr from sg_phys(sg).

dma_direct_sync_sg_for_device() also has the same issue, correct it as
well.

Fixes: 55897af63091("dma-direct: merge swiotlb_dma_ops into the dma_direct code")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 2c2772e9702a..2c6d51a62251 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -231,12 +231,14 @@ void dma_direct_sync_sg_for_device(struct device *dev,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i) {
-		if (unlikely(is_swiotlb_buffer(sg_phys(sg))))
-			swiotlb_tbl_sync_single(dev, sg_phys(sg), sg->length,
+		phys_addr_t paddr = dma_to_phys(dev, sg_dma_address(sg));
+
+		if (unlikely(is_swiotlb_buffer(paddr)))
+			swiotlb_tbl_sync_single(dev, paddr, sg->length,
 					dir, SYNC_FOR_DEVICE);
 
 		if (!dev_is_dma_coherent(dev))
-			arch_sync_dma_for_device(dev, sg_phys(sg), sg->length,
+			arch_sync_dma_for_device(dev, paddr, sg->length,
 					dir);
 	}
 }
@@ -268,11 +270,13 @@ void dma_direct_sync_sg_for_cpu(struct device *dev,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i) {
+		phys_addr_t paddr = dma_to_phys(dev, sg_dma_address(sg));
+
 		if (!dev_is_dma_coherent(dev))
-			arch_sync_dma_for_cpu(dev, sg_phys(sg), sg->length, dir);
-	
-		if (unlikely(is_swiotlb_buffer(sg_phys(sg))))
-			swiotlb_tbl_sync_single(dev, sg_phys(sg), sg->length, dir,
+			arch_sync_dma_for_cpu(dev, paddr, sg->length, dir);
+
+		if (unlikely(is_swiotlb_buffer(paddr)))
+			swiotlb_tbl_sync_single(dev, paddr, sg->length, dir,
 					SYNC_FOR_CPU);
 	}
 
-- 
2.20.1


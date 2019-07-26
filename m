Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26C376AB6
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfGZOAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfGZNkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A19122CBF;
        Fri, 26 Jul 2019 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148409;
        bh=tm7Y0GezpikEYvCrzvAS38HkjuB5/K0CmseOd6YnkoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLhHdUp7e30CpRtubBfT+2W//1zpenTCCn+xphNeETZ/dwPZWO2m7aNeFgZ6yCaAy
         CMo6B3a4boVTGqMQgmJ6jqRTv48/Cub3OUMDruGi7CnsWaLd4y03LOG1UV/yIM/LRw
         IKNbkadJVHvEZxFzmbLiyPRf3I7m9S9d1wd0G01A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.2 18/85] swiotlb: fix phys_addr_t overflow warning
Date:   Fri, 26 Jul 2019 09:38:28 -0400
Message-Id: <20190726133936.11177-18-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9c106119f6538f65bdddb7948a157d90625effa7 ]

On architectures that have a larger dma_addr_t than phys_addr_t,
the swiotlb_tbl_map_single() function truncates its return code
in the failure path, making it impossible to identify the error
later, as we compare to the original value:

kernel/dma/swiotlb.c:551:9: error: implicit conversion from 'dma_addr_t' (aka 'unsigned long long') to 'phys_addr_t' (aka 'unsigned int') changes value from 18446744073709551615 to 4294967295 [-Werror,-Wconstant-conversion]
        return DMA_MAPPING_ERROR;

Use an explicit typecast here to convert it to the narrower type,
and use the same expression in the error handling later.

Fixes: b907e20508d0 ("swiotlb: remove SWIOTLB_MAP_ERROR")
Acked-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 kernel/dma/swiotlb.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index d53f3493a6b9..cfbe46785a3b 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -402,7 +402,7 @@ static dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 
 	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir,
 				     attrs);
-	if (map == DMA_MAPPING_ERROR)
+	if (map == (phys_addr_t)DMA_MAPPING_ERROR)
 		return DMA_MAPPING_ERROR;
 
 	dev_addr = xen_phys_to_bus(map);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 13f0cb080a4d..5f4e1b78babb 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -546,7 +546,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	if (!(attrs & DMA_ATTR_NO_WARN) && printk_ratelimit())
 		dev_warn(hwdev, "swiotlb buffer is full (sz: %zd bytes), total %lu (slots), used %lu (slots)\n",
 			 size, io_tlb_nslabs, tmp_io_tlb_used);
-	return DMA_MAPPING_ERROR;
+	return (phys_addr_t)DMA_MAPPING_ERROR;
 found:
 	io_tlb_used += nslots;
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
@@ -664,7 +664,7 @@ bool swiotlb_map(struct device *dev, phys_addr_t *phys, dma_addr_t *dma_addr,
 	/* Oh well, have to allocate and map a bounce buffer. */
 	*phys = swiotlb_tbl_map_single(dev, __phys_to_dma(dev, io_tlb_start),
 			*phys, size, dir, attrs);
-	if (*phys == DMA_MAPPING_ERROR)
+	if (*phys == (phys_addr_t)DMA_MAPPING_ERROR)
 		return false;
 
 	/* Ensure that the address returned is DMA'ble */
-- 
2.20.1


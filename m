Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC141288B7
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 11:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLUKtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 05:49:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:43116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfLUKtx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 05:49:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B691AAAC2;
        Sat, 21 Dec 2019 10:49:50 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v4.4] net: davinci_cpdma: use dma_addr_t for DMA address
Date:   Sat, 21 Dec 2019 11:49:48 +0100
Message-Id: <20191221104948.10233-1-dwagner@suse.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 84092996673211f16ef3b942a191d7952e9dfea9 ]

The davinci_cpdma mixes up physical addresses as seen from the CPU
and DMA addresses as seen from a DMA master, since it can operate
on both normal memory or an on-chip buffer. If dma_addr_t is
different from phys_addr_t, this means we get a compile-time warning
about the type mismatch:

ethernet/ti/davinci_cpdma.c: In function 'cpdma_desc_pool_create':
ethernet/ti/davinci_cpdma.c:182:48: error: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
   pool->cpumap = dma_alloc_coherent(dev, size, &pool->phys,
In file included from ethernet/ti/davinci_cpdma.c:21:0:
dma-mapping.h:398:21: note: expected 'dma_addr_t * {aka long long unsigned int *}' but argument is of type 'phys_addr_t * {aka unsigned int *}'
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,

This slightly restructures the code so the address we use for
mapping RAM into a DMA address is always a dma_addr_t, avoiding
the warning. The code is correct even if both types are 32-bit
because the DMA master in this device only supports 32-bit addressing
anyway, independent of the types that are used.

We still assign this value to pool->phys, and that is wrong if
the driver is ever used with an IOMMU, but that value appears to
be never used, so there is no problem really. I've added a couple
of comments about where we do things that are slightly violating
the API.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---

Hi,

Pavel reported this fix is needed for the CIP kernel.

Since this patch was added to v4.5, we only need to backport
to v4.4.

Thanks,
Daniel

 drivers/net/ethernet/ti/davinci_cpdma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 657b65bf5cac..18bf3a8fdc50 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -82,7 +82,7 @@ struct cpdma_desc {
 
 struct cpdma_desc_pool {
 	phys_addr_t		phys;
-	u32			hw_addr;
+	dma_addr_t		hw_addr;
 	void __iomem		*iomap;		/* ioremap map */
 	void			*cpumap;	/* dma_alloc map */
 	int			desc_size, mem_size;
@@ -152,7 +152,7 @@ struct cpdma_chan {
  * abstract out these details
  */
 static struct cpdma_desc_pool *
-cpdma_desc_pool_create(struct device *dev, u32 phys, u32 hw_addr,
+cpdma_desc_pool_create(struct device *dev, u32 phys, dma_addr_t hw_addr,
 				int size, int align)
 {
 	int bitmap_size;
@@ -176,13 +176,13 @@ cpdma_desc_pool_create(struct device *dev, u32 phys, u32 hw_addr,
 
 	if (phys) {
 		pool->phys  = phys;
-		pool->iomap = ioremap(phys, size);
+		pool->iomap = ioremap(phys, size); /* should be memremap? */
 		pool->hw_addr = hw_addr;
 	} else {
-		pool->cpumap = dma_alloc_coherent(dev, size, &pool->phys,
+		pool->cpumap = dma_alloc_coherent(dev, size, &pool->hw_addr,
 						  GFP_KERNEL);
-		pool->iomap = pool->cpumap;
-		pool->hw_addr = pool->phys;
+		pool->iomap = (void __iomem __force *)pool->cpumap;
+		pool->phys = pool->hw_addr; /* assumes no IOMMU, don't use this value */
 	}
 
 	if (pool->iomap)
-- 
2.24.0


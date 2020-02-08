Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135B91565D4
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgBHS3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33454 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727543AbgBHS3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:33 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrC-0003Zr-6E; Sat, 08 Feb 2020 18:29:30 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CIl-Bu; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>, "Pavel Machek" <pavel@denx.de>,
        "Daniel Wagner" <dwagner@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 08 Feb 2020 18:19:04 +0000
Message-ID: <lsq.1581185940.230442033@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 005/148] net: davinci_cpdma: use dma_addr_t for DMA
 address
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 84092996673211f16ef3b942a191d7952e9dfea9 upstream.

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
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Pavel Machek <pavel@denx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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
@@ -176,13 +176,13 @@ cpdma_desc_pool_create(struct device *de
 
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


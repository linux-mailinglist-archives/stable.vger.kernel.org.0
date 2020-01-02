Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2F12EE79
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgABWiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:38:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731136AbgABWiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:38:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D1D620863;
        Thu,  2 Jan 2020 22:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004733;
        bh=/g65bUBkUZz6J1YbcMzmMsnYXMy3bnSpWKDlcEJBmV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPkY85Qf05aVWMFV6gAjw6ylcxXiXdrF11NwpLHY0PGKdX0qp9D5wuu/cg4oxt2C0
         GZluzglvR9N99urCtTVHWgz0EzbE50bVigGcUlG09tiPdc/vafvVOYQcYRvCZAgib3
         Cw3DB2Ua0k1hMPfzuKWw1/MKTyIqSmmQZKaIQhqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 4.4 130/137] net: davinci_cpdma: use dma_addr_t for DMA address
Date:   Thu,  2 Jan 2020 23:08:23 +0100
Message-Id: <20200102220604.672480604@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/davinci_cpdma.c |   12 ++++++------
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



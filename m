Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AE012F169
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgABXAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 18:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbgABWNF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6D721D7D;
        Thu,  2 Jan 2020 22:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003184;
        bh=PBHb5ijfB+T3bwG+9x4hokUpoUPYGrSirFzfyZnrxJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZT+rDLKybt1uOAMNvSI0/2gZfPqfatkYhUewVfcTTnvR4zPtcYjLxGc1XjCkVQrE
         LMWryoQW80m6MBL/7spyXRCy/Wd3ItNVw/9TZ2qXfqiHJp8C8VkdchCHFQLsMaeRQ0
         bnUYzTCRw6TBah1lM+J4eeazru/ZuhM8X64Luack=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/191] dma-direct: check for overflows on 32 bit DMA addresses
Date:   Thu,  2 Jan 2020 23:05:36 +0100
Message-Id: <20200102215835.696014868@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit b12d66278dd627cbe1ea7c000aa4715aaf8830c8 ]

As seen on the new Raspberry Pi 4 and sta2x11's DMA implementation it is
possible for a device configured with 32 bit DMA addresses and a partial
DMA mapping located at the end of the address space to overflow. It
happens when a higher physical address, not DMAable, is translated to
it's DMA counterpart.

For example the Raspberry Pi 4, configurable up to 4 GB of memory, has
an interconnect capable of addressing the lower 1 GB of physical memory
with a DMA offset of 0xc0000000. It transpires that, any attempt to
translate physical addresses higher than the first GB will result in an
overflow which dma_capable() can't detect as it only checks for
addresses bigger then the maximum allowed DMA address.

Fix this by verifying in dma_capable() if the DMA address range provided
is at any point lower than the minimum possible DMA address on the bus.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-direct.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index adf993a3bd58..6a18a97b76a8 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -3,8 +3,11 @@
 #define _LINUX_DMA_DIRECT_H 1
 
 #include <linux/dma-mapping.h>
+#include <linux/memblock.h> /* for min_low_pfn */
 #include <linux/mem_encrypt.h>
 
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
+
 #ifdef CONFIG_ARCH_HAS_PHYS_TO_DMA
 #include <asm/dma-direct.h>
 #else
@@ -24,11 +27,16 @@ static inline phys_addr_t __dma_to_phys(struct device *dev, dma_addr_t dev_addr)
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
+	dma_addr_t end = addr + size - 1;
+
 	if (!dev->dma_mask)
 		return false;
 
-	return addr + size - 1 <=
-		min_not_zero(*dev->dma_mask, dev->bus_dma_mask);
+	if (!IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
+	    min(addr, end) < phys_to_dma(dev, PFN_PHYS(min_low_pfn)))
+		return false;
+
+	return end <= min_not_zero(*dev->dma_mask, dev->bus_dma_mask);
 }
 #endif /* !CONFIG_ARCH_HAS_PHYS_TO_DMA */
 
-- 
2.20.1




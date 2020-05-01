Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2901C165E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgEANrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731276AbgEANn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75003205C9;
        Fri,  1 May 2020 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340607;
        bh=Qy/7ktWiUWN9KLOmaszlUgnhiu3dsgRzyfBpp7k6h2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8J+OMJp8I6k1egNjdZId2TYqQCJTi/yBjp8G+hYc28v/1WeL0HwfCNMbqcKXJ4VM
         Dt9OshMmcoWOfWRf8B2k/JFbKtnjFJ71p8C3qdRcJDLNYpVI4qPdhuzcz5kzVbttnJ
         EzJr9dAn3gkYzOIm1TXpW/yYWH4IhJM8Dd4avnkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.6 051/106] remoteproc: mtk_scp: use dma_addr_t for DMA API
Date:   Fri,  1 May 2020 15:23:24 +0200
Message-Id: <20200501131549.784321275@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit c2781e4d9bc6d925dfc1ff833dfdaf12b69679de upstream.

dma_addr_t and phys_addr_t are distinct types and must not be
mixed, as both the values and the size of the type may be
different depending on what the remote device uses.

In this driver the compiler warns when the two types are different:

drivers/remoteproc/mtk_scp.c: In function 'scp_map_memory_region':
drivers/remoteproc/mtk_scp.c:454:9: error: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
  454 |         &scp->phys_addr, GFP_KERNEL);
      |         ^~~~~~~~~~~~~~~
      |         |
      |         phys_addr_t * {aka unsigned int *}
In file included from drivers/remoteproc/mtk_scp.c:7:
include/linux/dma-mapping.h:642:15: note: expected 'dma_addr_t *' {aka 'long long unsigned int *'} but argument is of type 'phys_addr_t *' {aka 'unsigned int *'}
  642 |   dma_addr_t *dma_handle, gfp_t gfp)

Change the phys_addr member to be typed and named according
to how it is allocated.

Fixes: 63c13d61eafe ("remoteproc/mediatek: add SCP support for mt8183")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200408155450.2186471-1-arnd@arndb.de
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/mtk_common.h |    2 +-
 drivers/remoteproc/mtk_scp.c    |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/remoteproc/mtk_common.h
+++ b/drivers/remoteproc/mtk_common.h
@@ -68,7 +68,7 @@ struct mtk_scp {
 	wait_queue_head_t ack_wq;
 
 	void __iomem *cpu_addr;
-	phys_addr_t phys_addr;
+	dma_addr_t dma_addr;
 	size_t dram_size;
 
 	struct rproc_subdev *rpmsg_subdev;
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -330,7 +330,7 @@ static void *scp_da_to_va(struct rproc *
 		if (offset >= 0 && (offset + len) < scp->sram_size)
 			return (void __force *)scp->sram_base + offset;
 	} else {
-		offset = da - scp->phys_addr;
+		offset = da - scp->dma_addr;
 		if (offset >= 0 && (offset + len) < scp->dram_size)
 			return (void __force *)scp->cpu_addr + offset;
 	}
@@ -451,7 +451,7 @@ static int scp_map_memory_region(struct
 	/* Reserved SCP code size */
 	scp->dram_size = MAX_CODE_SIZE;
 	scp->cpu_addr = dma_alloc_coherent(scp->dev, scp->dram_size,
-					   &scp->phys_addr, GFP_KERNEL);
+					   &scp->dma_addr, GFP_KERNEL);
 	if (!scp->cpu_addr)
 		return -ENOMEM;
 
@@ -461,7 +461,7 @@ static int scp_map_memory_region(struct
 static void scp_unmap_memory_region(struct mtk_scp *scp)
 {
 	dma_free_coherent(scp->dev, scp->dram_size, scp->cpu_addr,
-			  scp->phys_addr);
+			  scp->dma_addr);
 	of_reserved_mem_device_release(scp->dev);
 }
 



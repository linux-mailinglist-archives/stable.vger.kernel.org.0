Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93951CAB03
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgEHMi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbgEHMi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03BD2495C;
        Fri,  8 May 2020 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941536;
        bh=g7dkK5wMR0y6SBVbVTqEjvDrlL3ZWZMY2ps1yXBix4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6jOX1P3Y17lKYxBxJWpd/r5V9kHx+DygimENpSdBsH9wsE1ExGanDB/74SmgJYf7
         agXbxeDSnI2vBj4+gUDIkfUTRZ+mG9JX1S94gkFqraaikhmFCR5ZFovxgSu8Ot8ag6
         plF7j+4Yigg2xAUQSRuKbS9g0aw/d45c0TffLkSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Noa Osherovich <noaos@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 072/312] net/mlx5: Avoid passing dma address 0 to firmware
Date:   Fri,  8 May 2020 14:31:03 +0200
Message-Id: <20200508123129.605731047@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noa Osherovich <noaos@mellanox.com>

commit 6b276190c50a12511d889d9079ffb901ff94a822 upstream.

Currently the firmware can't work with a page with dma address 0.
Passing such an address to the firmware will cause the give_pages
command to fail.

To avoid this, in case we get a 0 dma address of a page from the
dma engine, we avoid passing it to FW by remapping to get an address
other than 0.

Fixes: bf0bf77f6519 ('mlx5: Support communicating arbitrary host...')
Signed-off-by: Noa Osherovich <noaos@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c |   26 +++++++++++++-------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -243,6 +243,7 @@ static void free_4k(struct mlx5_core_dev
 static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
 {
 	struct page *page;
+	u64 zero_addr = 1;
 	u64 addr;
 	int err;
 	int nid = dev_to_node(&dev->pdev->dev);
@@ -252,26 +253,35 @@ static int alloc_system_page(struct mlx5
 		mlx5_core_warn(dev, "failed to allocate page\n");
 		return -ENOMEM;
 	}
+map:
 	addr = dma_map_page(&dev->pdev->dev, page, 0,
 			    PAGE_SIZE, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(&dev->pdev->dev, addr)) {
 		mlx5_core_warn(dev, "failed dma mapping page\n");
 		err = -ENOMEM;
-		goto out_alloc;
+		goto err_mapping;
 	}
+
+	/* Firmware doesn't support page with physical address 0 */
+	if (addr == 0) {
+		zero_addr = addr;
+		goto map;
+	}
+
 	err = insert_page(dev, addr, page, func_id);
 	if (err) {
 		mlx5_core_err(dev, "failed to track allocated page\n");
-		goto out_mapping;
+		dma_unmap_page(&dev->pdev->dev, addr, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
 	}
 
-	return 0;
-
-out_mapping:
-	dma_unmap_page(&dev->pdev->dev, addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
+err_mapping:
+	if (err)
+		__free_page(page);
 
-out_alloc:
-	__free_page(page);
+	if (zero_addr == 0)
+		dma_unmap_page(&dev->pdev->dev, zero_addr, PAGE_SIZE,
+			       DMA_BIDIRECTIONAL);
 
 	return err;
 }



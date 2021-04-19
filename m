Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F94364363
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbhDSNRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240404AbhDSNPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD81D6127C;
        Mon, 19 Apr 2021 13:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838009;
        bh=zxkNcddKMUsHiXp2yYbnePjYjDTXeYUPh6UwRyVjd1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drLZysN0VSU9aUZG0LWftI5T6Yfx0RebUOb+f2/rF0IQANsrYA7N5zkmK2395lMLp
         CmY6L6ufwn9kk+TVQOWBCxtBU2SaNYAK6lEZxIMQFVl1FW1O5tdsBP92vD/J4+U1+f
         KwuCBAzoHmkIc/nH2IgzxnIJ2KA36u9uWro1DAic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/103] dmaengine: plx_dma: add a missing put_device() on error path
Date:   Mon, 19 Apr 2021 15:05:22 +0200
Message-Id: <20210419130528.181031299@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 07503e6aefe4a6efd777062191944a14f03b3a18 ]

Add a missing put_device(&pdev->dev) if the call to
dma_async_device_register(dma); fails.

Fixes: 905ca51e63be ("dmaengine: plx-dma: Introduce PLX DMA engine PCI driver skeleton")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://lore.kernel.org/r/YFnq/0IQzixtAbC1@mwanda
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/plx_dma.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/plx_dma.c b/drivers/dma/plx_dma.c
index f387c5bbc170..166934544161 100644
--- a/drivers/dma/plx_dma.c
+++ b/drivers/dma/plx_dma.c
@@ -507,10 +507,8 @@ static int plx_dma_create(struct pci_dev *pdev)
 
 	rc = request_irq(pci_irq_vector(pdev, 0), plx_dma_isr, 0,
 			 KBUILD_MODNAME, plxdev);
-	if (rc) {
-		kfree(plxdev);
-		return rc;
-	}
+	if (rc)
+		goto free_plx;
 
 	spin_lock_init(&plxdev->ring_lock);
 	tasklet_setup(&plxdev->desc_task, plx_dma_desc_task);
@@ -540,14 +538,20 @@ static int plx_dma_create(struct pci_dev *pdev)
 	rc = dma_async_device_register(dma);
 	if (rc) {
 		pci_err(pdev, "Failed to register dma device: %d\n", rc);
-		free_irq(pci_irq_vector(pdev, 0),  plxdev);
-		kfree(plxdev);
-		return rc;
+		goto put_device;
 	}
 
 	pci_set_drvdata(pdev, plxdev);
 
 	return 0;
+
+put_device:
+	put_device(&pdev->dev);
+	free_irq(pci_irq_vector(pdev, 0),  plxdev);
+free_plx:
+	kfree(plxdev);
+
+	return rc;
 }
 
 static int plx_dma_probe(struct pci_dev *pdev,
-- 
2.30.2




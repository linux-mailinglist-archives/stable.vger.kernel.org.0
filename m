Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF9840E865
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355122AbhIPRo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355115AbhIPRlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22A5C6325C;
        Thu, 16 Sep 2021 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811140;
        bh=d2zN46M7dViF3bSk5TZ29MJ30B7PIC5iRpNK9pXKP0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQx4DnxO9GSj7rfci7eRiFCzv5tc63QqdaQNgMXNKODFh7V2MdK6x2ZvRGYEw6kRx
         Oe/SSlywi+NDGp8QxshqfxU6c7RNeMBoihWMP9xM727ybGtqVrcc/BRtAT8fstcPhO
         wcVRBzlBPw0kYVuUwmAyinHrd4kD8d/iEs1NPPsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Anton Vasilyev <vasilyev@ispras.ru>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.14 398/432] mtd: rawnand: intel: Fix error handling in probe
Date:   Thu, 16 Sep 2021 18:02:27 +0200
Message-Id: <20210916155824.315987763@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

commit 0792ec82175ec45a0f45af6e0f2d3cb49c527cd4 upstream.

ebu_nand_probe() did not invoke ebu_dma_cleanup() and
clk_disable_unprepare() on some error handling paths. The patch fixes
that.

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: 0b1039f016e8 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Co-developed-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Signed-off-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Co-developed-by: Anton Vasilyev <vasilyev@ispras.ru>
Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210817092930.23040-1-novikov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -631,19 +631,26 @@ static int ebu_nand_probe(struct platfor
 	ebu_host->clk_rate = clk_get_rate(ebu_host->clk);
 
 	ebu_host->dma_tx = dma_request_chan(dev, "tx");
-	if (IS_ERR(ebu_host->dma_tx))
-		return dev_err_probe(dev, PTR_ERR(ebu_host->dma_tx),
-				     "failed to request DMA tx chan!.\n");
+	if (IS_ERR(ebu_host->dma_tx)) {
+		ret = dev_err_probe(dev, PTR_ERR(ebu_host->dma_tx),
+				    "failed to request DMA tx chan!.\n");
+		goto err_disable_unprepare_clk;
+	}
 
 	ebu_host->dma_rx = dma_request_chan(dev, "rx");
-	if (IS_ERR(ebu_host->dma_rx))
-		return dev_err_probe(dev, PTR_ERR(ebu_host->dma_rx),
-				     "failed to request DMA rx chan!.\n");
+	if (IS_ERR(ebu_host->dma_rx)) {
+		ret = dev_err_probe(dev, PTR_ERR(ebu_host->dma_rx),
+				    "failed to request DMA rx chan!.\n");
+		ebu_host->dma_rx = NULL;
+		goto err_cleanup_dma;
+	}
 
 	resname = devm_kasprintf(dev, GFP_KERNEL, "addr_sel%d", cs);
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, resname);
-	if (!res)
-		return -EINVAL;
+	if (!res) {
+		ret = -EINVAL;
+		goto err_cleanup_dma;
+	}
 	ebu_host->cs[cs].addr_sel = res->start;
 	writel(ebu_host->cs[cs].addr_sel | EBU_ADDR_MASK(5) | EBU_ADDR_SEL_REGEN,
 	       ebu_host->ebu + EBU_ADDR_SEL(cs));
@@ -653,7 +660,8 @@ static int ebu_nand_probe(struct platfor
 	mtd = nand_to_mtd(&ebu_host->chip);
 	if (!mtd->name) {
 		dev_err(ebu_host->dev, "NAND label property is mandatory\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_cleanup_dma;
 	}
 
 	mtd->dev.parent = dev;
@@ -681,6 +689,7 @@ err_clean_nand:
 	nand_cleanup(&ebu_host->chip);
 err_cleanup_dma:
 	ebu_dma_cleanup(ebu_host);
+err_disable_unprepare_clk:
 	clk_disable_unprepare(ebu_host->clk);
 
 	return ret;



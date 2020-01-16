Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D4913FEE5
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390754AbgAPX2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390734AbgAPX2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D4620684;
        Thu, 16 Jan 2020 23:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217294;
        bh=ocAANWlWEdcaXT6VbO9RDlKzdJkJnLOESxnJLG+KFdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzihyre7pjoVDGFiknGoCfTnLMTZ6kPGxfAyUJ8ju3Iu/r4mqfKrXb315iTXfv5Wd
         gXUsWLhuWakz9QaJG08e0dkAGzKZeA/1+TfyQMBQD/PEXIsiWQI1JXxTdEed2bdCVr
         njGdeYecaYgfsZ7WDQKu+pW/ps9Sqjq7gi3yhOEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 23/84] mtd: onenand: omap2: Pass correct flags for prep_dma_memcpy
Date:   Fri, 17 Jan 2020 00:17:57 +0100
Message-Id: <20200116231716.388547311@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 8bcef0d54067077cf9a6cb129022c77559926e8c upstream.

The commit converting the driver to DMAengine was missing the flags for
the memcpy prepare call.
It went unnoticed since the omap-dma driver was ignoring them.

Fixes: 3ed6a4d1de2c5 (" mtd: onenand: omap2: Convert to use dmaengine for memcp")
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/onenand/omap2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/onenand/omap2.c
+++ b/drivers/mtd/nand/onenand/omap2.c
@@ -341,7 +341,8 @@ static inline int omap2_onenand_dma_tran
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie;
 
-	tx = dmaengine_prep_dma_memcpy(c->dma_chan, dst, src, count, 0);
+	tx = dmaengine_prep_dma_memcpy(c->dma_chan, dst, src, count,
+				       DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(&c->pdev->dev, "Failed to prepare DMA memcpy\n");
 		return -EIO;



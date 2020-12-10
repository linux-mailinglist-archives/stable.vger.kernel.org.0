Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091112D5DC6
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390294AbgLJOal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733026AbgLJOaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:30:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Mark Brown <broonie@kernel.org>, Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 4.9 40/45] spi: bcm2835: Release the DMA channel if probe fails after dma_init
Date:   Thu, 10 Dec 2020 15:26:54 +0100
Message-Id: <20201210142604.326645697@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 666224b43b4bd4612ce3b758c038f9bc5c5e3fcb ]

The DMA channel was not released if either devm_request_irq() or
devm_spi_register_controller() failed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20191212135550.4634-3-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to 4.19-stable]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm2835.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -787,18 +787,19 @@ static int bcm2835_spi_probe(struct plat
 			       dev_name(&pdev->dev), master);
 	if (err) {
 		dev_err(&pdev->dev, "could not request IRQ: %d\n", err);
-		goto out_clk_disable;
+		goto out_dma_release;
 	}
 
 	err = spi_register_master(master);
 	if (err) {
 		dev_err(&pdev->dev, "could not register SPI master: %d\n", err);
-		goto out_clk_disable;
+		goto out_dma_release;
 	}
 
 	return 0;
 
-out_clk_disable:
+out_dma_release:
+	bcm2835_dma_release(master);
 	clk_disable_unprepare(bs->clk);
 	return err;
 }



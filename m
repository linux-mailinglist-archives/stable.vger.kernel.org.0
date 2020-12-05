Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB0D2CFB58
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 13:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgLEK3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 05:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgLEK2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 05:28:40 -0500
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7333AC061A4F
        for <stable@vger.kernel.org>; Sat,  5 Dec 2020 02:19:15 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 38325100DA1D5;
        Sat,  5 Dec 2020 11:19:12 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id DA4988147; Sat,  5 Dec 2020 11:19:13 +0100 (CET)
Date:   Sat, 5 Dec 2020 11:19:13 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     peter.ujfalusi@ti.com, nsaenzjulienne@suse.de,
        stable@vger.kernel.org, broonie@kernel.org
Subject: Backport 666224b43b4b to 4.19-stable
Message-ID: <20201205101913.GA7875@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

commit 666224b43b4b ("spi: bcm2835: Release the DMA channel if probe
fails after dma_init") was not marked for stable but really should
have been.  Here's a backport for 4.19:

-- >8 --
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Date: Thu, 12 Dec 2019 15:55:43 +0200
Subject: [PATCH] spi: bcm2835: Release the DMA channel if probe fails after
 dma_init

[ Upstream commit 666224b43b4bd4612ce3b758c038f9bc5c5e3fcb ]

The DMA channel was not released if either devm_request_irq() or
devm_spi_register_controller() failed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20191212135550.4634-3-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to 4.19-stable]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/spi/spi-bcm2835.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 2908df35466f..6824beae18e4 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -787,18 +787,19 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
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
-- 
2.29.2


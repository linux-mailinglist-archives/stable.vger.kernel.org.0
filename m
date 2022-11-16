Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A4662C562
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 17:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiKPQvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 11:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiKPQut (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 11:50:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A92BD3
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 08:49:36 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ovLbT-0003pO-4U
        for stable@vger.kernel.org; Wed, 16 Nov 2022 17:49:35 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 957DA12043E
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 16:49:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E7FA2120433;
        Wed, 16 Nov 2022 16:49:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 756466ff;
        Wed, 16 Nov 2022 16:49:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Cc:     kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>, stable@vger.kernel.org
Subject: [PATCH] spi: spi-imx: spi_imx_transfer_one(): check for DMA transfer first
Date:   Wed, 16 Nov 2022 17:49:30 +0100
Message-Id: <20221116164930.855362-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SPI framework checks for each transfer (with the struct
spi_controller::can_dma callback) whether the driver wants to use DMA
for the transfer. If the driver returns true, the SPI framework will
map the transfer's data to the device, start the actual transfer and
map the data back.

In commit 07e759387788 ("spi: spi-imx: add PIO polling support") the
spi-imx driver's spi_imx_transfer_one() function was extended. If the
estimated duration of a transfer does not exceed a configurable
duration, a polling transfer function is used. This check happens
before checking if the driver decided earlier for a DMA transfer.

If spi_imx_can_dma() decided to use a DMA transfer, and the user
configured a big maximum polling duration, a polling transfer will be
used. The DMA unmap after the transfer destroys the transferred data.

To fix this problem check in spi_imx_transfer_one() if the driver
decided for DMA transfer first, then check the limits for a polling
transfer.

Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
Link: https://lore.kernel.org/all/20221111003032.82371-1-festevam@gmail.com
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Fabio Estevam <festevam@gmail.com>
Cc: David Jander <david@protonic.nl>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/spi/spi-imx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 30d82cc7300b..3240c139f8f3 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1607,6 +1607,13 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 	if (spi_imx->slave_mode)
 		return spi_imx_pio_transfer_slave(spi, transfer);
 
+	/*
+	 * If we decided in spi_imx_can_dma() that we want to do a DMA
+	 * transfer, the SPI transfer has already been mapped, so we
+	 * have to do the DMA transfer here.
+	 */
+	if (spi_imx->usedma)
+		return spi_imx_dma_transfer(spi_imx, transfer);
 	/*
 	 * Calculate the estimated time in us the transfer runs. Find
 	 * the number of Hz per byte per polling limit.
@@ -1618,9 +1625,6 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 	if (transfer->len < byte_limit)
 		return spi_imx_poll_transfer(spi, transfer);
 
-	if (spi_imx->usedma)
-		return spi_imx_dma_transfer(spi_imx, transfer);
-
 	return spi_imx_pio_transfer(spi, transfer);
 }
 
-- 
2.35.1



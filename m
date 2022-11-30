Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812FE63DFD4
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiK3SvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiK3Suq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB369FED6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7FDBB81CAA
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F086C433D7;
        Wed, 30 Nov 2022 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834242;
        bh=HcP+71BM3SnGxy9OqCi44C8XtNSsKtqVG0uhMhAkcNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj++1DQsL446iN3gZLMxA53vk2IXB6wlnM4SMFaLPsQyMF+gJjZZwXcreCxYswHR/
         YjvB1Z+rWmNgPMDDWwyouZsaKjbGQvwUji+5m+YMq88JwMOuoLr9FMQJ59EkycT8T9
         6KvN6gzjU6TQLF/aQywm3DZ7xuSd6NRIhamooV2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 182/289] spi: spi-imx: spi_imx_transfer_one(): check for DMA transfer first
Date:   Wed, 30 Nov 2022 19:22:47 +0100
Message-Id: <20221130180548.253428826@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit e85e9e0d8cb759013d6474011c227f92e442d746 upstream.

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
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20221116164930.855362-1-mkl@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 468ce0a2b282..d209930069cf 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1606,6 +1606,13 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
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
@@ -1617,9 +1624,6 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 	if (transfer->len < byte_limit)
 		return spi_imx_poll_transfer(spi, transfer);
 
-	if (spi_imx->usedma)
-		return spi_imx_dma_transfer(spi_imx, transfer);
-
 	return spi_imx_pio_transfer(spi, transfer);
 }
 
-- 
2.38.1




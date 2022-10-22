Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5286086EB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiJVHzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiJVHxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:53:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C583E66F3D;
        Sat, 22 Oct 2022 00:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90DE560ADA;
        Sat, 22 Oct 2022 07:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F45EC433D6;
        Sat, 22 Oct 2022 07:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424780;
        bh=WFKe53kAeWTn6rXCQwWFO44BGTReVqKDgbguBaL8nb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnsl3KXWXqQVp2/TOOLDwSJy4YsEp2tzGvBBGtSF/9sVbg368RFonLgXRyWLSJem7
         TaGHHURiloVR2jTamkvlPFuxXyV0wkd8Ua/txUeaWQ3KS7N48HaJS1Ago2cm3kLtZD
         MfZAC0GjmTYZ/HBvsHTbae8iO8g3maZsKiORB35I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 274/717] spi: s3c64xx: Fix large transfers with DMA
Date:   Sat, 22 Oct 2022 09:22:33 +0200
Message-Id: <20221022072502.830055066@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 1224e29572f655facfcd850cf0f0a4784f36a903 ]

The COUNT_VALUE in the PACKET_CNT register is 16-bit so the maximum
value is 65535.  Asking the driver to transfer a larger size currently
leads to the DMA transfer timing out.  Implement ->max_transfer_size()
and have the core split the transfer as needed.

Fixes: 230d42d422e7 ("spi: Add s3c64xx SPI Controller driver")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20220927112117.77599-5-vincent.whitchurch@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 8fa21afc6a35..b77c98bcf93f 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -83,6 +83,7 @@
 #define S3C64XX_SPI_ST_TX_FIFORDY		(1<<0)
 
 #define S3C64XX_SPI_PACKET_CNT_EN		(1<<16)
+#define S3C64XX_SPI_PACKET_CNT_MASK		GENMASK(15, 0)
 
 #define S3C64XX_SPI_PND_TX_UNDERRUN_CLR		(1<<4)
 #define S3C64XX_SPI_PND_TX_OVERRUN_CLR		(1<<3)
@@ -663,6 +664,13 @@ static int s3c64xx_spi_prepare_message(struct spi_master *master,
 	return 0;
 }
 
+static size_t s3c64xx_spi_max_transfer_size(struct spi_device *spi)
+{
+	struct spi_controller *ctlr = spi->controller;
+
+	return ctlr->can_dma ? S3C64XX_SPI_PACKET_CNT_MASK : SIZE_MAX;
+}
+
 static int s3c64xx_spi_transfer_one(struct spi_master *master,
 				    struct spi_device *spi,
 				    struct spi_transfer *xfer)
@@ -1100,6 +1108,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	master->prepare_transfer_hardware = s3c64xx_spi_prepare_transfer;
 	master->prepare_message = s3c64xx_spi_prepare_message;
 	master->transfer_one = s3c64xx_spi_transfer_one;
+	master->max_transfer_size = s3c64xx_spi_max_transfer_size;
 	master->num_chipselect = sci->num_cs;
 	master->use_gpio_descriptors = true;
 	master->dma_alignment = 8;
-- 
2.35.1




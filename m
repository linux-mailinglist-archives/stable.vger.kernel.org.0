Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D05760B1DB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbiJXQjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiJXQjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:39:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD87192B88;
        Mon, 24 Oct 2022 08:26:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD986B81981;
        Mon, 24 Oct 2022 12:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B6BC433D6;
        Mon, 24 Oct 2022 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615290;
        bh=tR1Vw8yGULqRNjjnN8SN66mQXN/N8hhYvrowv+pMP60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGVYzLDDXZBleVGPZ3aulm1M2bW6bTgLJZ6hAIKoVVuuNGbtFlpBzYlyyXkpPkSj+
         NVOkwueNvhZnDjkKMag35EiurPJCVumkKsO4kEtnpccBiQlzBhten/DMoqNx8CXkXf
         UELsUfLNzZRrDUozHmIf0Ps4Ik0GMTD1KOu19cR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/530] spi: s3c64xx: Fix large transfers with DMA
Date:   Mon, 24 Oct 2022 13:28:57 +0200
Message-Id: <20221024113053.786994648@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8755cd85e83c..90c70d53e85e 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -85,6 +85,7 @@
 #define S3C64XX_SPI_ST_TX_FIFORDY		(1<<0)
 
 #define S3C64XX_SPI_PACKET_CNT_EN		(1<<16)
+#define S3C64XX_SPI_PACKET_CNT_MASK		GENMASK(15, 0)
 
 #define S3C64XX_SPI_PND_TX_UNDERRUN_CLR		(1<<4)
 #define S3C64XX_SPI_PND_TX_OVERRUN_CLR		(1<<3)
@@ -661,6 +662,13 @@ static int s3c64xx_spi_prepare_message(struct spi_master *master,
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
@@ -1130,6 +1138,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	master->prepare_transfer_hardware = s3c64xx_spi_prepare_transfer;
 	master->prepare_message = s3c64xx_spi_prepare_message;
 	master->transfer_one = s3c64xx_spi_transfer_one;
+	master->max_transfer_size = s3c64xx_spi_max_transfer_size;
 	master->num_chipselect = sci->num_cs;
 	master->dma_alignment = 8;
 	master->bits_per_word_mask = SPI_BPW_MASK(32) | SPI_BPW_MASK(16) |
-- 
2.35.1




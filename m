Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF1749A049
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843617AbiAXXFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841261AbiAXW6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:58:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF50C02B74C;
        Mon, 24 Jan 2022 13:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDC9261471;
        Mon, 24 Jan 2022 21:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF661C340E5;
        Mon, 24 Jan 2022 21:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058794;
        bh=/o+LUW1Cr2cpX0MN9+mBS9URWFlB9//SCkxN0ezCjhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVzhVm/n7u+jMNVM6y6Nx1iPwjsY6NQztRX0+4FFuqY1Joua31EHIXbsrgz7UNmmS
         YdGNqgmCF8BbdhsIOaSKP+gLZvZ5sdkEnEQieUEu3ku1z0nh9lsAVVjyj8x5mdDB4Y
         H3oB6givGPC21THMjsSsfqKlVTh1PiRIwldiXLbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0403/1039] spi: qcom: geni: handle timeout for gpi mode
Date:   Mon, 24 Jan 2022 19:36:32 +0100
Message-Id: <20220124184138.856581651@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit f8039ea55d4ccac2238a247a574f0acb3bc1dc4b ]

We missed adding handle_err for gpi mode, so add a new function
spi_geni_handle_err() which would call handle_fifo_timeout() or newly
added handle_gpi_timeout() based on mode

Fixes: b59c122484ec ("spi: spi-geni-qcom: Add support for GPI dma")
Reported-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20220103071118.27220-2-vkoul@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 69e71aac85129..079d0cb783ee3 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -168,6 +168,30 @@ static void handle_fifo_timeout(struct spi_master *spi,
 	}
 }
 
+static void handle_gpi_timeout(struct spi_master *spi, struct spi_message *msg)
+{
+	struct spi_geni_master *mas = spi_master_get_devdata(spi);
+
+	dmaengine_terminate_sync(mas->tx);
+	dmaengine_terminate_sync(mas->rx);
+}
+
+static void spi_geni_handle_err(struct spi_master *spi, struct spi_message *msg)
+{
+	struct spi_geni_master *mas = spi_master_get_devdata(spi);
+
+	switch (mas->cur_xfer_mode) {
+	case GENI_SE_FIFO:
+		handle_fifo_timeout(spi, msg);
+		break;
+	case GENI_GPI_DMA:
+		handle_gpi_timeout(spi, msg);
+		break;
+	default:
+		dev_err(mas->dev, "Abort on Mode:%d not supported", mas->cur_xfer_mode);
+	}
+}
+
 static bool spi_geni_is_abort_still_pending(struct spi_geni_master *mas)
 {
 	struct geni_se *se = &mas->se;
@@ -926,7 +950,7 @@ static int spi_geni_probe(struct platform_device *pdev)
 	spi->can_dma = geni_can_dma;
 	spi->dma_map_dev = dev->parent;
 	spi->auto_runtime_pm = true;
-	spi->handle_err = handle_fifo_timeout;
+	spi->handle_err = spi_geni_handle_err;
 	spi->use_gpio_descriptors = true;
 
 	init_completion(&mas->cs_done);
-- 
2.34.1




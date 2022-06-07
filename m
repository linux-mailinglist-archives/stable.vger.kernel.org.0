Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523A2541390
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353602AbiFGUC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358374AbiFGUA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:00:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8207FD4A3D;
        Tue,  7 Jun 2022 11:24:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52B1CB8237F;
        Tue,  7 Jun 2022 18:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0297C385A5;
        Tue,  7 Jun 2022 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626257;
        bh=fnG+UK/GdWNYtSgoQqZ5bqzvkDaVX9q79kRygAvrBt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cz5nDozrmhMe308RjGfkgdF3SinEA4mN6zz54qWSdU4X4bT8qgsRPGmuaWsv6I5qu
         WNW/yCUkDjW6XpZYoIly8lyxvru2s0i+9PUj9PCyh87n+1KmU3WXyIIXEG4hZZ37A5
         HYUiJzpy2xnt3eHtUeMrRx8PbXqWnlcLHaHHL1Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Ceresoli <luca.ceresoli@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 296/772] spi: rockchip: fix missing error on unsupported SPI_CS_HIGH
Date:   Tue,  7 Jun 2022 18:58:08 +0200
Message-Id: <20220607164957.745814757@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit d5d933f09ac326aebad85bfb787cc786ad477711 ]

The hardware (except for the ROCKCHIP_SPI_VER2_TYPE2 version) does not
support active-high native chip selects. However if such a CS is configured
the core does not error as it normally should, because the
'ctlr->use_gpio_descriptors = true' line in rockchip_spi_probe() makes the
core set SPI_CS_HIGH in ctlr->mode_bits.

In such a case the spi-rockchip driver operates normally but produces an
active-low chip select signal without notice.

There is no provision in the current core code to handle this
situation. Fix by adding a check in the ctlr->setup function (similarly to
what spi-atmel.c does).

This cannot be done reading the SPI_CS_HIGH but in ctlr->mode_bits because
that bit gets always set by the core for master mode (see above).

Fixes: eb1262e3cc8b ("spi: spi-rockchip: use num-cs property and ctlr->enable_gpiods")
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20220421213251.1077899-1-luca.ceresoli@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 83da8fdb3c02..b721b62118e1 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -196,6 +196,8 @@ struct rockchip_spi {
 
 	bool slave_abort;
 	bool cs_inactive; /* spi slave tansmition stop when cs inactive */
+	bool cs_high_supported; /* native CS supports active-high polarity */
+
 	struct spi_transfer *xfer; /* Store xfer temporarily */
 };
 
@@ -718,6 +720,11 @@ static int rockchip_spi_setup(struct spi_device *spi)
 	struct rockchip_spi *rs = spi_controller_get_devdata(spi->controller);
 	u32 cr0;
 
+	if (!spi->cs_gpiod && (spi->mode & SPI_CS_HIGH) && !rs->cs_high_supported) {
+		dev_warn(&spi->dev, "setup: non GPIO CS can't be active-high\n");
+		return -EINVAL;
+	}
+
 	pm_runtime_get_sync(rs->dev);
 
 	cr0 = readl_relaxed(rs->regs + ROCKCHIP_SPI_CTRLR0);
@@ -898,6 +905,7 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 
 	switch (readl_relaxed(rs->regs + ROCKCHIP_SPI_VERSION)) {
 	case ROCKCHIP_SPI_VER2_TYPE2:
+		rs->cs_high_supported = true;
 		ctlr->mode_bits |= SPI_CS_HIGH;
 		if (ctlr->can_dma && slave_mode)
 			rs->cs_inactive = true;
-- 
2.35.1




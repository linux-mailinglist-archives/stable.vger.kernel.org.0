Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3212D9F92
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440576AbgLNSvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:51:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502264AbgLNRhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 024/105] can: m_can: tcan4x5x_can_probe(): fix error path: remove erroneous clk_disable_unprepare()
Date:   Mon, 14 Dec 2020 18:27:58 +0100
Message-Id: <20201214172556.440531465@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit ad1f5e826d91d6c27ecd36a607ad7c7f4d0b0733 ]

The clocks mcan_class->cclk and mcan_class->hclk are not prepared by any call
during tcan4x5x_can_probe(), so remove erroneous clk_disable_unprepare() on
them.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Link: http://lore.kernel.org/r/20201130114252.215334-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index e5d7d85e0b6d1..7347ab39c5b65 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -489,18 +489,18 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	spi->bits_per_word = 32;
 	ret = spi_setup(spi);
 	if (ret)
-		goto out_clk;
+		goto out_m_can_class_free_dev;
 
 	priv->regmap = devm_regmap_init(&spi->dev, &tcan4x5x_bus,
 					&spi->dev, &tcan4x5x_regmap);
 	if (IS_ERR(priv->regmap)) {
 		ret = PTR_ERR(priv->regmap);
-		goto out_clk;
+		goto out_m_can_class_free_dev;
 	}
 
 	ret = tcan4x5x_power_enable(priv->power, 1);
 	if (ret)
-		goto out_clk;
+		goto out_m_can_class_free_dev;
 
 	ret = tcan4x5x_parse_config(mcan_class);
 	if (ret)
@@ -519,11 +519,6 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 
 out_power:
 	tcan4x5x_power_enable(priv->power, 0);
-out_clk:
-	if (!IS_ERR(mcan_class->cclk)) {
-		clk_disable_unprepare(mcan_class->cclk);
-		clk_disable_unprepare(mcan_class->hclk);
-	}
  out_m_can_class_free_dev:
 	m_can_class_free_dev(mcan_class->net);
 	dev_err(&spi->dev, "Probe failed, err=%d\n", ret);
-- 
2.27.0




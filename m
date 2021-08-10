Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E853E7EE7
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhHJRgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhHJRfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB3E060F41;
        Tue, 10 Aug 2021 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616879;
        bh=UEf2N945SoxE+9lyO+dyfP4aukvxJnJC8bp0bYGkoNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtH8T+VbgCpYNO860f/kZKiwwZwzKuLzT4acoleZSxbOG4avLl9t/P8VslcNWlS3O
         tDRaoa7EjThm91FaYBz8P3OQATTr/ib9rsyIQZznucQ7saelN/r5nvdIBselQIQWmF
         xqZaYfULQ8dwdTiaMMKSPUmjA0fCLRSqHOb8c7Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/85] spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay
Date:   Tue, 10 Aug 2021 19:29:48 +0200
Message-Id: <20210810172948.720822791@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 135cbd378eab336da15de9c84bbb22bf743b38a5 ]

Since 00b80ac935539 ("spi: imx: mx51-ecspi: Move some initialisation to
prepare_message hook."), the MX51_ECSPI_CONFIG write no longer happens
in prepare_transfer hook, but rather in prepare_message hook, however
the MX51_ECSPI_CONFIG delay is still left in prepare_transfer hook and
thus has no effect. This leads to low bus frequency operation problems
described in 6fd8b8503a0dc ("spi: spi-imx: Fix out-of-order CS/SCLK
operation at low speeds") again.

Move the MX51_ECSPI_CONFIG write delay into the prepare_message hook
as well, thus reinstating the low bus frequency fix.

Fixes: 00b80ac935539 ("spi: imx: mx51-ecspi: Move some initialisation to prepare_message hook.")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210703022300.296114-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index e237481dbbbb..14cebcda0ccc 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -498,7 +498,7 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 {
 	struct spi_device *spi = msg->spi;
 	u32 ctrl = MX51_ECSPI_CTRL_ENABLE;
-	u32 testreg;
+	u32 testreg, delay;
 	u32 cfg = readl(spi_imx->base + MX51_ECSPI_CONFIG);
 
 	/* set Master or Slave mode */
@@ -559,6 +559,23 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 
 	writel(cfg, spi_imx->base + MX51_ECSPI_CONFIG);
 
+	/*
+	 * Wait until the changes in the configuration register CONFIGREG
+	 * propagate into the hardware. It takes exactly one tick of the
+	 * SCLK clock, but we will wait two SCLK clock just to be sure. The
+	 * effect of the delay it takes for the hardware to apply changes
+	 * is noticable if the SCLK clock run very slow. In such a case, if
+	 * the polarity of SCLK should be inverted, the GPIO ChipSelect might
+	 * be asserted before the SCLK polarity changes, which would disrupt
+	 * the SPI communication as the device on the other end would consider
+	 * the change of SCLK polarity as a clock tick already.
+	 */
+	delay = (2 * 1000000) / spi_imx->spi_bus_clk;
+	if (likely(delay < 10))	/* SCLK is faster than 100 kHz */
+		udelay(delay);
+	else			/* SCLK is _very_ slow */
+		usleep_range(delay, delay + 10);
+
 	return 0;
 }
 
@@ -566,7 +583,7 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 				       struct spi_device *spi)
 {
 	u32 ctrl = readl(spi_imx->base + MX51_ECSPI_CTRL);
-	u32 clk, delay;
+	u32 clk;
 
 	/* Clear BL field and set the right value */
 	ctrl &= ~MX51_ECSPI_CTRL_BL_MASK;
@@ -588,23 +605,6 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 
 	writel(ctrl, spi_imx->base + MX51_ECSPI_CTRL);
 
-	/*
-	 * Wait until the changes in the configuration register CONFIGREG
-	 * propagate into the hardware. It takes exactly one tick of the
-	 * SCLK clock, but we will wait two SCLK clock just to be sure. The
-	 * effect of the delay it takes for the hardware to apply changes
-	 * is noticable if the SCLK clock run very slow. In such a case, if
-	 * the polarity of SCLK should be inverted, the GPIO ChipSelect might
-	 * be asserted before the SCLK polarity changes, which would disrupt
-	 * the SPI communication as the device on the other end would consider
-	 * the change of SCLK polarity as a clock tick already.
-	 */
-	delay = (2 * 1000000) / clk;
-	if (likely(delay < 10))	/* SCLK is faster than 100 kHz */
-		udelay(delay);
-	else			/* SCLK is _very_ slow */
-		usleep_range(delay, delay + 10);
-
 	return 0;
 }
 
-- 
2.30.2




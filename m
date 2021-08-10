Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733153E7F97
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhHJRlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235542AbhHJRjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAAEF61205;
        Tue, 10 Aug 2021 17:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617052;
        bh=uNRiHPmOFngc/3txJLuzFgzffMJx3gU4J64hQMU7bh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYsf23qA6FTuHDEwJJrYK0iRkBbzLVS0wufccyCkmywv2bTP4xUJ5c3Ms8Q26Qd26
         XzDW4gqpt2n8HYV8TmnN2A5Popy4d3Hi7FL7SpE2Nueu1Yw8ToXs7Ywf/ZBA7OE1Y0
         EoSXiyMd8R2YdyGQe/1cA2PAkp4KLD2I9w4Tx2zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/135] spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay
Date:   Tue, 10 Aug 2021 19:29:17 +0200
Message-Id: <20210810172956.457357248@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
index c8b750d8ac35..8c0a6ea941ad 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -506,7 +506,7 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 {
 	struct spi_device *spi = msg->spi;
 	u32 ctrl = MX51_ECSPI_CTRL_ENABLE;
-	u32 testreg;
+	u32 testreg, delay;
 	u32 cfg = readl(spi_imx->base + MX51_ECSPI_CONFIG);
 
 	/* set Master or Slave mode */
@@ -567,6 +567,23 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 
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
 
@@ -574,7 +591,7 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 				       struct spi_device *spi)
 {
 	u32 ctrl = readl(spi_imx->base + MX51_ECSPI_CTRL);
-	u32 clk, delay;
+	u32 clk;
 
 	/* Clear BL field and set the right value */
 	ctrl &= ~MX51_ECSPI_CTRL_BL_MASK;
@@ -596,23 +613,6 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 
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




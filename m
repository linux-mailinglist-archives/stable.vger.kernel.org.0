Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE473D5FAB
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbhGZPSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236504AbhGZPRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:17:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F19EF60F57;
        Mon, 26 Jul 2021 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315048;
        bh=vFtNwNhO7ogjJmAmR0VtzXgCbNLe44s5XRACk+jCG74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caZ4N+SVdsruzs4dsKJmbMBbZ4mVseZ9tnHkXy7YHZoThpcf65uR0xzawZs1ctLgG
         nIlIUT7hjr9sMQUeLJzpjr9vJqtBIg3bTQ+NJ7yL1jsZzc2ULhdgamhojX20f63TzH
         EqWKFTuEKHwlmI4AdHsxfMiUrNx546xy+88VBKvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clark Wang <xiaoning.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/108] spi: imx: add a check for speed_hz before calculating the clock
Date:   Mon, 26 Jul 2021 17:38:31 +0200
Message-Id: <20210726153832.663088454@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 4df2f5e1372e9eec8f9e1b4a3025b9be23487d36 ]

When some drivers use spi to send data, spi_transfer->speed_hz is
not assigned. If spidev->max_speed_hz is not assigned as well, it
will cause an error in configuring the clock.
Add a check for these two values before configuring the clock. An
error will be returned when they are not assigned.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Link: https://lore.kernel.org/r/20210408103347.244313-2-xiaoning.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 09c9a1edb2c6..e237481dbbbb 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -64,8 +64,7 @@ struct spi_imx_data;
 struct spi_imx_devtype_data {
 	void (*intctrl)(struct spi_imx_data *, int);
 	int (*prepare_message)(struct spi_imx_data *, struct spi_message *);
-	int (*prepare_transfer)(struct spi_imx_data *, struct spi_device *,
-				struct spi_transfer *);
+	int (*prepare_transfer)(struct spi_imx_data *, struct spi_device *);
 	void (*trigger)(struct spi_imx_data *);
 	int (*rx_available)(struct spi_imx_data *);
 	void (*reset)(struct spi_imx_data *);
@@ -564,11 +563,10 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 }
 
 static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
-				       struct spi_device *spi,
-				       struct spi_transfer *t)
+				       struct spi_device *spi)
 {
 	u32 ctrl = readl(spi_imx->base + MX51_ECSPI_CTRL);
-	u32 clk = t->speed_hz, delay;
+	u32 clk, delay;
 
 	/* Clear BL field and set the right value */
 	ctrl &= ~MX51_ECSPI_CTRL_BL_MASK;
@@ -582,7 +580,7 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 	/* set clock speed */
 	ctrl &= ~(0xf << MX51_ECSPI_CTRL_POSTDIV_OFFSET |
 		  0xf << MX51_ECSPI_CTRL_PREDIV_OFFSET);
-	ctrl |= mx51_ecspi_clkdiv(spi_imx, t->speed_hz, &clk);
+	ctrl |= mx51_ecspi_clkdiv(spi_imx, spi_imx->spi_bus_clk, &clk);
 	spi_imx->spi_bus_clk = clk;
 
 	if (spi_imx->usedma)
@@ -694,13 +692,12 @@ static int mx31_prepare_message(struct spi_imx_data *spi_imx,
 }
 
 static int mx31_prepare_transfer(struct spi_imx_data *spi_imx,
-				 struct spi_device *spi,
-				 struct spi_transfer *t)
+				 struct spi_device *spi)
 {
 	unsigned int reg = MX31_CSPICTRL_ENABLE | MX31_CSPICTRL_MASTER;
 	unsigned int clk;
 
-	reg |= spi_imx_clkdiv_2(spi_imx->spi_clk, t->speed_hz, &clk) <<
+	reg |= spi_imx_clkdiv_2(spi_imx->spi_clk, spi_imx->spi_bus_clk, &clk) <<
 		MX31_CSPICTRL_DR_SHIFT;
 	spi_imx->spi_bus_clk = clk;
 
@@ -799,14 +796,13 @@ static int mx21_prepare_message(struct spi_imx_data *spi_imx,
 }
 
 static int mx21_prepare_transfer(struct spi_imx_data *spi_imx,
-				 struct spi_device *spi,
-				 struct spi_transfer *t)
+				 struct spi_device *spi)
 {
 	unsigned int reg = MX21_CSPICTRL_ENABLE | MX21_CSPICTRL_MASTER;
 	unsigned int max = is_imx27_cspi(spi_imx) ? 16 : 18;
 	unsigned int clk;
 
-	reg |= spi_imx_clkdiv_1(spi_imx->spi_clk, t->speed_hz, max, &clk)
+	reg |= spi_imx_clkdiv_1(spi_imx->spi_clk, spi_imx->spi_bus_clk, max, &clk)
 		<< MX21_CSPICTRL_DR_SHIFT;
 	spi_imx->spi_bus_clk = clk;
 
@@ -875,13 +871,12 @@ static int mx1_prepare_message(struct spi_imx_data *spi_imx,
 }
 
 static int mx1_prepare_transfer(struct spi_imx_data *spi_imx,
-				struct spi_device *spi,
-				struct spi_transfer *t)
+				struct spi_device *spi)
 {
 	unsigned int reg = MX1_CSPICTRL_ENABLE | MX1_CSPICTRL_MASTER;
 	unsigned int clk;
 
-	reg |= spi_imx_clkdiv_2(spi_imx->spi_clk, t->speed_hz, &clk) <<
+	reg |= spi_imx_clkdiv_2(spi_imx->spi_clk, spi_imx->spi_bus_clk, &clk) <<
 		MX1_CSPICTRL_DR_SHIFT;
 	spi_imx->spi_bus_clk = clk;
 
@@ -1199,6 +1194,16 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 	if (!t)
 		return 0;
 
+	if (!t->speed_hz) {
+		if (!spi->max_speed_hz) {
+			dev_err(&spi->dev, "no speed_hz provided!\n");
+			return -EINVAL;
+		}
+		dev_dbg(&spi->dev, "using spi->max_speed_hz!\n");
+		spi_imx->spi_bus_clk = spi->max_speed_hz;
+	} else
+		spi_imx->spi_bus_clk = t->speed_hz;
+
 	spi_imx->bits_per_word = t->bits_per_word;
 
 	/*
@@ -1240,7 +1245,7 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 		spi_imx->slave_burst = t->len;
 	}
 
-	spi_imx->devtype_data->prepare_transfer(spi_imx, spi, t);
+	spi_imx->devtype_data->prepare_transfer(spi_imx, spi);
 
 	return 0;
 }
-- 
2.30.2




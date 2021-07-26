Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9383D603B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhGZPV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235945AbhGZPV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B3A60E09;
        Mon, 26 Jul 2021 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315315;
        bh=dwpDajoW10WXI2ovg4AgN7tgkZzFAbCWnXo0opXsZsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djkD60OKJmFqIcRFA6CBV6ymlIEHmxESh4+m5XQeiuBS+Yw9YNG6MRIMYgWR1hXci
         LrS7jUPjj74PI4D+wCmAutQpPtnWJwlbT5Z1Sl+30bLwREXla7pQtcuVZY3hi0lNZX
         djZEtSCp2R6S5Aw6ALpOL8P2e2auRdBsNIND4Chs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clark Wang <xiaoning.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/167] spi: imx: add a check for speed_hz before calculating the clock
Date:   Mon, 26 Jul 2021 17:38:02 +0200
Message-Id: <20210726153841.044672333@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index 831a38920fa9..c8b750d8ac35 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -66,8 +66,7 @@ struct spi_imx_data;
 struct spi_imx_devtype_data {
 	void (*intctrl)(struct spi_imx_data *, int);
 	int (*prepare_message)(struct spi_imx_data *, struct spi_message *);
-	int (*prepare_transfer)(struct spi_imx_data *, struct spi_device *,
-				struct spi_transfer *);
+	int (*prepare_transfer)(struct spi_imx_data *, struct spi_device *);
 	void (*trigger)(struct spi_imx_data *);
 	int (*rx_available)(struct spi_imx_data *);
 	void (*reset)(struct spi_imx_data *);
@@ -572,11 +571,10 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
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
@@ -590,7 +588,7 @@ static int mx51_ecspi_prepare_transfer(struct spi_imx_data *spi_imx,
 	/* set clock speed */
 	ctrl &= ~(0xf << MX51_ECSPI_CTRL_POSTDIV_OFFSET |
 		  0xf << MX51_ECSPI_CTRL_PREDIV_OFFSET);
-	ctrl |= mx51_ecspi_clkdiv(spi_imx, t->speed_hz, &clk);
+	ctrl |= mx51_ecspi_clkdiv(spi_imx, spi_imx->spi_bus_clk, &clk);
 	spi_imx->spi_bus_clk = clk;
 
 	if (spi_imx->usedma)
@@ -702,13 +700,12 @@ static int mx31_prepare_message(struct spi_imx_data *spi_imx,
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
 
@@ -807,14 +804,13 @@ static int mx21_prepare_message(struct spi_imx_data *spi_imx,
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
 
@@ -883,13 +879,12 @@ static int mx1_prepare_message(struct spi_imx_data *spi_imx,
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
 
@@ -1195,6 +1190,16 @@ static int spi_imx_setupxfer(struct spi_device *spi,
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
@@ -1236,7 +1241,7 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 		spi_imx->slave_burst = t->len;
 	}
 
-	spi_imx->devtype_data->prepare_transfer(spi_imx, spi, t);
+	spi_imx->devtype_data->prepare_transfer(spi_imx, spi);
 
 	return 0;
 }
-- 
2.30.2




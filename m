Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD4C35BEC2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhDLJB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238808AbhDLI5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BFD061221;
        Mon, 12 Apr 2021 08:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217816;
        bh=Gs8Mok6pUNRSTlJ+vELUt1S67amvbgujMW3lkWone0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlggXExZGHzgn+zC927W0kBeZHB6FiddxPKZxDKgVVKBVfL2ZYHj35LZ5L3YB2cdp
         aLZYqvJKRVw+MMfbbyZDXShzxUbTRJq2Bm14DyBHLA2aF43jW1gh9qk1USdWguA5Vo
         5j9h8r8JzltfO06uudugdVqukL+QxUy/8VDBeZco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Gerhard Bertelsmann <info@gerhard-bertelsmann.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/188] can: mcp251x: fix support for half duplex SPI host controllers
Date:   Mon, 12 Apr 2021 10:41:09 +0200
Message-Id: <20210412084018.780508685@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 617085fca6375e2c1667d1fbfc6adc4034c85f04 ]

Some SPI host controllers do not support full-duplex SPI transfers.

The function mcp251x_spi_trans() does a full duplex transfer. It is
used in several places in the driver, where a TX half duplex transfer
is sufficient.

To fix support for half duplex SPI host controllers, this patch
introduces a new function mcp251x_spi_write() and changes all callers
that do a TX half duplex transfer to use mcp251x_spi_write().

Fixes: e0e25001d088 ("can: mcp251x: add support for half duplex controllers")
Link: https://lore.kernel.org/r/20210330100246.1074375-1-mkl@pengutronix.de
Cc: Tim Harvey <tharvey@gateworks.com>
Tested-By: Tim Harvey <tharvey@gateworks.com>
Reported-by: Gerhard Bertelsmann <info@gerhard-bertelsmann.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 22d814ae4edc..42c3046fa304 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -314,6 +314,18 @@ static int mcp251x_spi_trans(struct spi_device *spi, int len)
 	return ret;
 }
 
+static int mcp251x_spi_write(struct spi_device *spi, int len)
+{
+	struct mcp251x_priv *priv = spi_get_drvdata(spi);
+	int ret;
+
+	ret = spi_write(spi, priv->spi_tx_buf, len);
+	if (ret)
+		dev_err(&spi->dev, "spi write failed: ret = %d\n", ret);
+
+	return ret;
+}
+
 static u8 mcp251x_read_reg(struct spi_device *spi, u8 reg)
 {
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
@@ -361,7 +373,7 @@ static void mcp251x_write_reg(struct spi_device *spi, u8 reg, u8 val)
 	priv->spi_tx_buf[1] = reg;
 	priv->spi_tx_buf[2] = val;
 
-	mcp251x_spi_trans(spi, 3);
+	mcp251x_spi_write(spi, 3);
 }
 
 static void mcp251x_write_2regs(struct spi_device *spi, u8 reg, u8 v1, u8 v2)
@@ -373,7 +385,7 @@ static void mcp251x_write_2regs(struct spi_device *spi, u8 reg, u8 v1, u8 v2)
 	priv->spi_tx_buf[2] = v1;
 	priv->spi_tx_buf[3] = v2;
 
-	mcp251x_spi_trans(spi, 4);
+	mcp251x_spi_write(spi, 4);
 }
 
 static void mcp251x_write_bits(struct spi_device *spi, u8 reg,
@@ -386,7 +398,7 @@ static void mcp251x_write_bits(struct spi_device *spi, u8 reg,
 	priv->spi_tx_buf[2] = mask;
 	priv->spi_tx_buf[3] = val;
 
-	mcp251x_spi_trans(spi, 4);
+	mcp251x_spi_write(spi, 4);
 }
 
 static u8 mcp251x_read_stat(struct spi_device *spi)
@@ -618,7 +630,7 @@ static void mcp251x_hw_tx_frame(struct spi_device *spi, u8 *buf,
 					  buf[i]);
 	} else {
 		memcpy(priv->spi_tx_buf, buf, TXBDAT_OFF + len);
-		mcp251x_spi_trans(spi, TXBDAT_OFF + len);
+		mcp251x_spi_write(spi, TXBDAT_OFF + len);
 	}
 }
 
@@ -650,7 +662,7 @@ static void mcp251x_hw_tx(struct spi_device *spi, struct can_frame *frame,
 
 	/* use INSTRUCTION_RTS, to avoid "repeated frame problem" */
 	priv->spi_tx_buf[0] = INSTRUCTION_RTS(1 << tx_buf_idx);
-	mcp251x_spi_trans(priv->spi, 1);
+	mcp251x_spi_write(priv->spi, 1);
 }
 
 static void mcp251x_hw_rx_frame(struct spi_device *spi, u8 *buf,
@@ -888,7 +900,7 @@ static int mcp251x_hw_reset(struct spi_device *spi)
 	mdelay(MCP251X_OST_DELAY_MS);
 
 	priv->spi_tx_buf[0] = INSTRUCTION_RESET;
-	ret = mcp251x_spi_trans(spi, 1);
+	ret = mcp251x_spi_write(spi, 1);
 	if (ret)
 		return ret;
 
-- 
2.30.2




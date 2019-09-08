Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70067ACE7F
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbfIHMqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbfIHMp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:45:59 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E3CB21A49;
        Sun,  8 Sep 2019 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946758;
        bh=rBYyaw2fFXbK2tMlFMR++K1OgXVKO8FT5BhnKRKLqZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfJpDcTtM9R1YDr8nRObhWNu6FCZWftAOlbkQBWmKiaWlxSfTB7/q1U+pvWgJ9gWl
         EE9HX1Rn564bcZ0YmDZSjMDVmkc7chz84fAwonnUp+N5cSXTben+MDedzS30dFxJrE
         YGPn3x8ZliRPg2wIDNXklRqsMkXnjJh3Bz6MZB7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/40] spi: bcm2835aux: unifying code between polling and interrupt driven code
Date:   Sun,  8 Sep 2019 13:42:02 +0100
Message-Id: <20190908121128.223401411@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7188a6f0eee3f1fae5d826cfc6d569657ff950ec ]

Sharing more code between polling and interrupt-driven mode.

Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835aux.c | 51 +++++++++++++-----------------------
 1 file changed, 18 insertions(+), 33 deletions(-)

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index bd00b7cc8b78b..97cb3beb9cc62 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -178,23 +178,13 @@ static void bcm2835aux_spi_reset_hw(struct bcm2835aux_spi *bs)
 		      BCM2835_AUX_SPI_CNTL0_CLEARFIFO);
 }
 
-static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
+static void bcm2835aux_spi_transfer_helper(struct bcm2835aux_spi *bs)
 {
-	struct spi_master *master = dev_id;
-	struct bcm2835aux_spi *bs = spi_master_get_devdata(master);
-	irqreturn_t ret = IRQ_NONE;
-
-	/* IRQ may be shared, so return if our interrupts are disabled */
-	if (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_CNTL1) &
-	      (BCM2835_AUX_SPI_CNTL1_TXEMPTY | BCM2835_AUX_SPI_CNTL1_IDLE)))
-		return ret;
-
 	/* check if we have data to read */
 	while (bs->rx_len &&
 	       (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT) &
 		  BCM2835_AUX_SPI_STAT_RX_EMPTY))) {
 		bcm2835aux_rd_fifo(bs);
-		ret = IRQ_HANDLED;
 	}
 
 	/* check if we have data to write */
@@ -203,7 +193,6 @@ static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
 	       (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT) &
 		  BCM2835_AUX_SPI_STAT_TX_FULL))) {
 		bcm2835aux_wr_fifo(bs);
-		ret = IRQ_HANDLED;
 	}
 
 	/* and check if we have reached "done" */
@@ -211,8 +200,21 @@ static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
 	       (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT) &
 		  BCM2835_AUX_SPI_STAT_BUSY))) {
 		bcm2835aux_rd_fifo(bs);
-		ret = IRQ_HANDLED;
 	}
+}
+
+static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
+{
+	struct spi_master *master = dev_id;
+	struct bcm2835aux_spi *bs = spi_master_get_devdata(master);
+
+	/* IRQ may be shared, so return if our interrupts are disabled */
+	if (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_CNTL1) &
+	      (BCM2835_AUX_SPI_CNTL1_TXEMPTY | BCM2835_AUX_SPI_CNTL1_IDLE)))
+		return IRQ_NONE;
+
+	/* do common fifo handling */
+	bcm2835aux_spi_transfer_helper(bs);
 
 	if (!bs->tx_len) {
 		/* disable tx fifo empty interrupt */
@@ -226,8 +228,7 @@ static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
 		complete(&master->xfer_completion);
 	}
 
-	/* and return */
-	return ret;
+	return IRQ_HANDLED;
 }
 
 static int __bcm2835aux_spi_transfer_one_irq(struct spi_master *master,
@@ -273,7 +274,6 @@ static int bcm2835aux_spi_transfer_one_poll(struct spi_master *master,
 {
 	struct bcm2835aux_spi *bs = spi_master_get_devdata(master);
 	unsigned long timeout;
-	u32 stat;
 
 	/* configure spi */
 	bcm2835aux_wr(bs, BCM2835_AUX_SPI_CNTL1, bs->cntl[1]);
@@ -284,24 +284,9 @@ static int bcm2835aux_spi_transfer_one_poll(struct spi_master *master,
 
 	/* loop until finished the transfer */
 	while (bs->rx_len) {
-		/* read status */
-		stat = bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT);
-
-		/* fill in tx fifo with remaining data */
-		if ((bs->tx_len) && (!(stat & BCM2835_AUX_SPI_STAT_TX_FULL))) {
-			bcm2835aux_wr_fifo(bs);
-			continue;
-		}
 
-		/* read data from fifo for both cases */
-		if (!(stat & BCM2835_AUX_SPI_STAT_RX_EMPTY)) {
-			bcm2835aux_rd_fifo(bs);
-			continue;
-		}
-		if (!(stat & BCM2835_AUX_SPI_STAT_BUSY)) {
-			bcm2835aux_rd_fifo(bs);
-			continue;
-		}
+		/* do common fifo handling */
+		bcm2835aux_spi_transfer_helper(bs);
 
 		/* there is still data pending to read check the timeout */
 		if (bs->rx_len && time_after(jiffies, timeout)) {
-- 
2.20.1




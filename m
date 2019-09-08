Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7601ACCE5
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfIHMni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729509AbfIHMng (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:43:36 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC56B21927;
        Sun,  8 Sep 2019 12:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946615;
        bh=WSTuLqsXqlvcR8hsFVkmN87TeOnrEFWdE+TxzTDFBcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TiP4TY/2Qm+Pwlgy0U4v0Qn8xSGCC0syuABk+udG7LmCK5d3Va0Tb4bPMSvc/la6
         1yHzyzpD+AJJmOozGWTTdXvfBRhEhsCE/3WWRpbOaOeiDYUc5OqjVduLixZy7V7aeM
         ebUtQW3Ihq4FXrY8tB5eY00oRgwfwWWXPkVVQBM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/23] spi: bcm2835aux: unifying code between polling and interrupt driven code
Date:   Sun,  8 Sep 2019 13:41:53 +0100
Message-Id: <20190908121101.187172199@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121052.898169328@linuxfoundation.org>
References: <20190908121052.898169328@linuxfoundation.org>
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
index 6f4c6aa801f14..5b2c2b2e13396 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -181,23 +181,13 @@ static void bcm2835aux_spi_reset_hw(struct bcm2835aux_spi *bs)
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
@@ -206,7 +196,6 @@ static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
 	       (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT) &
 		  BCM2835_AUX_SPI_STAT_TX_FULL))) {
 		bcm2835aux_wr_fifo(bs);
-		ret = IRQ_HANDLED;
 	}
 
 	/* and check if we have reached "done" */
@@ -214,8 +203,21 @@ static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
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
 
 	/* and if rx_len is 0 then wake up completion and disable spi */
 	if (!bs->rx_len) {
@@ -223,8 +225,7 @@ static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
 		complete(&master->xfer_completion);
 	}
 
-	/* and return */
-	return ret;
+	return IRQ_HANDLED;
 }
 
 static int __bcm2835aux_spi_transfer_one_irq(struct spi_master *master,
@@ -270,7 +271,6 @@ static int bcm2835aux_spi_transfer_one_poll(struct spi_master *master,
 {
 	struct bcm2835aux_spi *bs = spi_master_get_devdata(master);
 	unsigned long timeout;
-	u32 stat;
 
 	/* configure spi */
 	bcm2835aux_wr(bs, BCM2835_AUX_SPI_CNTL1, bs->cntl[1]);
@@ -281,24 +281,9 @@ static int bcm2835aux_spi_transfer_one_poll(struct spi_master *master,
 
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




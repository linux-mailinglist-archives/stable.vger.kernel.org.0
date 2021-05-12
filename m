Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B921437CC80
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241886AbhELQpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243268AbhELQhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBD4661C7A;
        Wed, 12 May 2021 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835319;
        bh=Q5BspRQzNnqc+6X4c93kwbJhgMHXEihDL2kbOP77Tp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xurA/4a2BZHpOfWr9s4+OkTPdMd7OhEVYHJASTf7Ntak3c3dxeSh84nd7yq4NU7XE
         ai8EkmQ2nFXDi0rjTkNkWyOiZoW7MwNWAA5Wj0JEHMpw+hCCe95z2DGwZ0numcMQOl
         mmsfG4b4alho4KJ/uBlWGgDP/3UDxdio2vcRS074=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 295/677] spi: spi-zynqmp-gqspi: transmit dummy circles by using the controllers internal functionality
Date:   Wed, 12 May 2021 16:45:41 +0200
Message-Id: <20210512144847.016849355@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 8ad07d79bd56a531990a1a3f3f1c0eb19d2de806 ]

There is a data corruption issue that occurs in the reading operation
(cmd:0x6c) when transmitting common data as dummy circles.

The gqspi controller has the functionality to send dummy clock circles.
When writing data with the fields [receive, transmit, data_xfer] = [0,0,1]
to the Generic FIFO, and configuring the correct SPI mode, the controller
will transmit dummy circles.

So let's switch to hardware dummy cycles transfer to fix this issue.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Link: https://lore.kernel.org/r/20210408040223.23134-4-quanyang.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 40 +++++++++++++++-------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 3b39461d58b3..cf73a069b759 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -521,7 +521,7 @@ static void zynqmp_qspi_filltxfifo(struct zynqmp_qspi *xqspi, int size)
 {
 	u32 count = 0, intermediate;
 
-	while ((xqspi->bytes_to_transfer > 0) && (count < size)) {
+	while ((xqspi->bytes_to_transfer > 0) && (count < size) && (xqspi->txbuf)) {
 		memcpy(&intermediate, xqspi->txbuf, 4);
 		zynqmp_gqspi_write(xqspi, GQSPI_TXD_OFST, intermediate);
 
@@ -580,7 +580,7 @@ static void zynqmp_qspi_fillgenfifo(struct zynqmp_qspi *xqspi, u8 nbits,
 		genfifoentry |= GQSPI_GENFIFO_DATA_XFER;
 		genfifoentry |= GQSPI_GENFIFO_TX;
 		transfer_len = xqspi->bytes_to_transfer;
-	} else {
+	} else if (xqspi->rxbuf) {
 		genfifoentry &= ~GQSPI_GENFIFO_TX;
 		genfifoentry |= GQSPI_GENFIFO_DATA_XFER;
 		genfifoentry |= GQSPI_GENFIFO_RX;
@@ -588,6 +588,11 @@ static void zynqmp_qspi_fillgenfifo(struct zynqmp_qspi *xqspi, u8 nbits,
 			transfer_len = xqspi->dma_rx_bytes;
 		else
 			transfer_len = xqspi->bytes_to_receive;
+	} else {
+		/* Sending dummy circles here */
+		genfifoentry &= ~(GQSPI_GENFIFO_TX | GQSPI_GENFIFO_RX);
+		genfifoentry |= GQSPI_GENFIFO_DATA_XFER;
+		transfer_len = xqspi->bytes_to_transfer;
 	}
 	genfifoentry |= zynqmp_qspi_selectspimode(xqspi, nbits);
 	xqspi->genfifoentry = genfifoentry;
@@ -1011,32 +1016,23 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 	}
 
 	if (op->dummy.nbytes) {
-		tmpbuf = kzalloc(op->dummy.nbytes, GFP_KERNEL | GFP_DMA);
-		if (!tmpbuf)
-			return -ENOMEM;
-		memset(tmpbuf, 0xff, op->dummy.nbytes);
-		reinit_completion(&xqspi->data_completion);
-		xqspi->txbuf = tmpbuf;
+		xqspi->txbuf = NULL;
 		xqspi->rxbuf = NULL;
-		xqspi->bytes_to_transfer = op->dummy.nbytes;
+		/*
+		 * xqspi->bytes_to_transfer here represents the dummy circles
+		 * which need to be sent.
+		 */
+		xqspi->bytes_to_transfer = op->dummy.nbytes * 8 / op->dummy.buswidth;
 		xqspi->bytes_to_receive = 0;
-		zynqmp_qspi_write_op(xqspi, op->dummy.buswidth,
+		/*
+		 * Using op->data.buswidth instead of op->dummy.buswidth here because
+		 * we need to use it to configure the correct SPI mode.
+		 */
+		zynqmp_qspi_write_op(xqspi, op->data.buswidth,
 				     genfifoentry);
 		zynqmp_gqspi_write(xqspi, GQSPI_CONFIG_OFST,
 				   zynqmp_gqspi_read(xqspi, GQSPI_CONFIG_OFST) |
 				   GQSPI_CFG_START_GEN_FIFO_MASK);
-		zynqmp_gqspi_write(xqspi, GQSPI_IER_OFST,
-				   GQSPI_IER_TXEMPTY_MASK |
-				   GQSPI_IER_GENFIFOEMPTY_MASK |
-				   GQSPI_IER_TXNOT_FULL_MASK);
-		if (!wait_for_completion_interruptible_timeout
-		    (&xqspi->data_completion, msecs_to_jiffies(1000))) {
-			err = -ETIMEDOUT;
-			kfree(tmpbuf);
-			goto return_err;
-		}
-
-		kfree(tmpbuf);
 	}
 
 	if (op->data.nbytes) {
-- 
2.30.2




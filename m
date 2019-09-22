Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE8BA46F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391742AbfIVSso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391723AbfIVSsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D86D21907;
        Sun, 22 Sep 2019 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178122;
        bh=NSNR2feGXDxKkK6lSElq1QS3FPtFBflExVHOssRHZzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDI2+Iv5W2R+RUNwsoJyasNXnvDO2i3eyA6zuD21QccSX7jRsEt4hvy6mEDfvx65L
         TjVNCJoFmrhYzHvKmS79VIkFR6v+ZJYBx53mVRr8M6yakm6qdbYYWV8d4a0sNBweAz
         TQWeoLSGfmtTSybQZFsUTxGBfe23VHqVmvVXtAhY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Martin Sperl <kernel@martin.sperl.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 177/203] spi: bcm2835: Work around DONE bit erratum
Date:   Sun, 22 Sep 2019 14:43:23 -0400
Message-Id: <20190922184350.30563-177-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 4c524191c0a21d758b519087c64f84348095e940 ]

Commit 3bd7f6589f67 ("spi: bcm2835: Overcome sglist entry length
limitation") amended the BCM2835 SPI driver with support for DMA
transfers whose buffers are not aligned to 4 bytes and require more than
one sglist entry.

When testing this feature with upcoming commits to speed up TX-only and
RX-only transfers, I noticed that SPI transmission sometimes breaks.
A function introduced by the commit, bcm2835_spi_transfer_prologue(),
performs one or two PIO transmissions as a prologue to the actual DMA
transmission.  It turns out that the breakage goes away if the DONE bit
in the CS register is set when ending such a PIO transmission.

The DONE bit signifies emptiness of the TX FIFO.  According to the spec,
the bit is of type RO, so writing it should never have any effect.
Perhaps the spec is wrong and the bit is actually of type RW1C.
E.g. the I2C controller on the BCM2835 does have an RW1C DONE bit which
needs to be cleared by the driver.  Another, possibly more likely
explanation is that it's a hardware erratum since the issue does not
occur consistently.

Either way, amend bcm2835_spi_transfer_prologue() to always write the
DONE bit.

Usually a transmission is ended by bcm2835_spi_reset_hw().  If the
transmission was successful, the TX FIFO is empty and thus the DONE bit
is set when bcm2835_spi_reset_hw() reads the CS register.  The bit is
then written back to the register, so we happen to do the right thing.

However if DONE is not set, e.g. because transmission is aborted with
a non-empty TX FIFO, the bit won't be written by bcm2835_spi_reset_hw()
and it seems possible that transmission might subsequently break.  To be
on the safe side, likewise amend bcm2835_spi_reset_hw() to always write
the bit.

Tested-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Martin Sperl <kernel@martin.sperl.org>
Link: https://lore.kernel.org/r/edb004dff4af6106f6bfcb89e1a96391e96eb857.1564825752.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 840b1b8ff3dcb..dfdcebb38830a 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -319,6 +319,13 @@ static void bcm2835_spi_reset_hw(struct spi_controller *ctlr)
 		BCM2835_SPI_CS_INTD |
 		BCM2835_SPI_CS_DMAEN |
 		BCM2835_SPI_CS_TA);
+	/*
+	 * Transmission sometimes breaks unless the DONE bit is written at the
+	 * end of every transfer.  The spec says it's a RO bit.  Either the
+	 * spec is wrong and the bit is actually of type RW1C, or it's a
+	 * hardware erratum.
+	 */
+	cs |= BCM2835_SPI_CS_DONE;
 	/* and reset RX/TX FIFOS */
 	cs |= BCM2835_SPI_CS_CLEAR_RX | BCM2835_SPI_CS_CLEAR_TX;
 
@@ -477,7 +484,9 @@ static void bcm2835_spi_transfer_prologue(struct spi_controller *ctlr,
 		bcm2835_wr_fifo_count(bs, bs->rx_prologue);
 		bcm2835_wait_tx_fifo_empty(bs);
 		bcm2835_rd_fifo_count(bs, bs->rx_prologue);
-		bcm2835_spi_reset_hw(ctlr);
+		bcm2835_wr(bs, BCM2835_SPI_CS, cs | BCM2835_SPI_CS_CLEAR_RX
+						  | BCM2835_SPI_CS_CLEAR_TX
+						  | BCM2835_SPI_CS_DONE);
 
 		dma_sync_single_for_device(ctlr->dma_rx->device->dev,
 					   sg_dma_address(&tfr->rx_sg.sgl[0]),
@@ -498,7 +507,8 @@ static void bcm2835_spi_transfer_prologue(struct spi_controller *ctlr,
 						  | BCM2835_SPI_CS_DMAEN);
 		bcm2835_wr_fifo_count(bs, tx_remaining);
 		bcm2835_wait_tx_fifo_empty(bs);
-		bcm2835_wr(bs, BCM2835_SPI_CS, cs | BCM2835_SPI_CS_CLEAR_TX);
+		bcm2835_wr(bs, BCM2835_SPI_CS, cs | BCM2835_SPI_CS_CLEAR_TX
+						  | BCM2835_SPI_CS_DONE);
 	}
 
 	if (likely(!bs->tx_spillover)) {
-- 
2.20.1


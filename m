Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0798CA9C3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbfJCQrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405156AbfJCQrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B742070B;
        Thu,  3 Oct 2019 16:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121243;
        bh=NSNR2feGXDxKkK6lSElq1QS3FPtFBflExVHOssRHZzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QylRAJuVjchnv/T/YEbmICIkiw0/8rrbZ5bRwUV3Pn7gwfflr/uc7SQ0gqrtQ3PT+
         lsQlIkfYsm7zidvNq401/DoxrwIHRHTy2N44lj2VWLB9pfjFIHlVcmIelfIYIScgjP
         Q1mciAlD7+JGKbhf6PyC4UGhneFoQ6Gki/Ifb4uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Lukas Wunner <lukas@wunner.de>,
        Stefan Wahren <wahrenst@gmx.net>,
        Martin Sperl <kernel@martin.sperl.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 207/344] spi: bcm2835: Work around DONE bit erratum
Date:   Thu,  3 Oct 2019 17:52:52 +0200
Message-Id: <20191003154600.694120974@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




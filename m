Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05CE2ACEB7
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbfIHMnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbfIHMnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:43:42 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AA27218AF;
        Sun,  8 Sep 2019 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946620;
        bh=uIHMUGNDhwuNAp0dkcKHC4ABTqlt4tfH3UwvmLyQCeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtEQRPbSXQX2xpPtTCFwIP+mZVMOT/z0Ircv4bwpHFjTkfJVjJG0PZjxMme89o3jM
         JsB56SP41pCYy/3oUc7tRyG0e4qJRfxV9CPOfvUdrZ4y2KkUV4Ge4B82V0Qsv0u77v
         ewNSiGOOXtQFq8ue2TgnqNuOy4dgQV/UcGNGi6I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hubert Denkmair <h.denkmair@intence.de>,
        Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/23] spi: bcm2835aux: fix corruptions for longer spi transfers
Date:   Sun,  8 Sep 2019 13:41:55 +0100
Message-Id: <20190908121103.259656286@linuxfoundation.org>
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

[ Upstream commit 73b114ee7db1750c0b535199fae383b109bd61d0 ]

On long running tests with a mcp2517fd can controller it showed that
on rare occations the data read shows corruptions for longer spi transfers.

Example of a 22 byte transfer:

expected (as captured on logic analyzer):
FF FF 78 00 00 00 08 06 00 00 91 20 77 56 84 85 86 87 88 89 8a 8b

read by the driver:
FF FF 78 00 00 00 08 06 00 00 91 20 77 56 84 88 89 8a 00 00 8b 9b

To fix this use BCM2835_AUX_SPI_STAT_RX_LVL to determine when we may
read data from the fifo reliably without any corruption.

Surprisingly the only values ever empirically read in
BCM2835_AUX_SPI_STAT_RX_LVL are 0x00, 0x10, 0x20 and 0x30.
So whenever the mask is not 0 we can read from the fifo in a safe manner.

The patch has now been tested intensively and we are no longer
able to reproduce the "RX" issue any longer.

Fixes: 1ea29b39f4c812ec ("spi: bcm2835aux: add bcm2835 auxiliary spi device...")
Reported-by: Hubert Denkmair <h.denkmair@intence.de>
Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835aux.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index 4d233356772aa..ca655593c5e0e 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -183,12 +183,12 @@ static void bcm2835aux_spi_reset_hw(struct bcm2835aux_spi *bs)
 
 static void bcm2835aux_spi_transfer_helper(struct bcm2835aux_spi *bs)
 {
+	u32 stat = bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT);
+
 	/* check if we have data to read */
-	while (bs->rx_len &&
-	       (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT) &
-		  BCM2835_AUX_SPI_STAT_RX_EMPTY))) {
+	for (; bs->rx_len && (stat & BCM2835_AUX_SPI_STAT_RX_LVL);
+	     stat = bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT))
 		bcm2835aux_rd_fifo(bs);
-	}
 
 	/* check if we have data to write */
 	while (bs->tx_len &&
-- 
2.20.1




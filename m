Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54802F017
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfE3EAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbfE3DSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A3E247AF;
        Thu, 30 May 2019 03:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186301;
        bh=EZBzuhK/Xg9IZDP/FXOwCB5SEoTCStbb2YO/OA05ksU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVJk64uqHDoErSIdN9dyWHMtQxwUenB63MBwaxF2ZhUkkIjbKZipYHdvX9n+LjAzM
         cSZZMs1R+etnbjwaDgQu1zbnY6uL019t8YjvhgiBG9sHTAac5QCX4CnDQvTn+iGZi4
         VXMeodLKUPD/ON/Q4Bqribsx4tpX4MlIzCbbyOjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiada Wang <jiada_wang@mentor.com>,
        Fabio Estevam <festevam@gmail.com>,
        Stefan Agner <stefan@agner.ch>,
        Shawn Guo <shawnguo@kernel.org>,
        Trent Piepho <tpiepho@impinj.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 267/276] spi: imx: stop buffer overflow in RX FIFO flush
Date:   Wed, 29 May 2019 20:07:05 -0700
Message-Id: <20190530030541.898993692@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c842749ea1d32513f9e603c074d60d7aa07cb2ef ]

Commit 71abd29057cb ("spi: imx: Add support for SPI Slave mode") added
an RX FIFO flush before start of a transfer.  In slave mode, the master
may have sent more data than expected and this data will still be in the
RX FIFO at the start of the next transfer, and so needs to be flushed.

However, the code to do the flush was accidentally saving this data into
the previous transfer's RX buffer, clobbering the contents of whatever
followed that buffer.

Change it to empty the FIFO and throw away the data.  Every one of the
RX functions for the different eCSPI versions and modes reads the RX
FIFO data using the same readl() call, so just use that, rather than
using the spi_imx->rx function pointer and making sure all the different
rx functions have a working "throw away" mode.

There is another issue, which affects master mode when switching from
DMA to PIO.  There can be extra data in the RX FIFO which triggers this
flush code, causing memory corruption in the same manner.  I don't know
why this data is unexpectedly in the FIFO.  It's likely there is a
different bug or erratum responsible for that.  But regardless of that,
I think this is proper fix the for bug at hand here.

Fixes: 71abd29057cb ("spi: imx: Add support for SPI Slave mode")
Cc: Jiada Wang <jiada_wang@mentor.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Trent Piepho <tpiepho@impinj.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 08dd3a31a3e5f..5b6f3655c366a 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1427,7 +1427,7 @@ static int spi_imx_transfer(struct spi_device *spi,
 
 	/* flush rxfifo before transfer */
 	while (spi_imx->devtype_data->rx_available(spi_imx))
-		spi_imx->rx(spi_imx);
+		readl(spi_imx->base + MXC_CSPIRXDATA);
 
 	if (spi_imx->slave_mode)
 		return spi_imx_pio_transfer_slave(spi, transfer);
-- 
2.20.1




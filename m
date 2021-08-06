Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762003E251E
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243144AbhHFIRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243942AbhHFIQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD7A6103B;
        Fri,  6 Aug 2021 08:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237761;
        bh=tWFm5KO6SzEo9Xw90zcZWaWl25jHCye4tIAZBR2peUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HDQAygaxHs+hDOxGbT13mUarsI5/mWSHerofZjYXlKOrKzvpchgwT6Dgr5SigMUv
         qHInqejrDIc09Q0os4lLYVbd5fDXoOGKM78Ai64Q4Qd4NRfkc0F3W2aDWe+pZrZj8Q
         Gl+5n4rjQhNOurmc2RUrMTqpltS706PnwBhNRn2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/16] Revert "spi: mediatek: fix fifo rx mode"
Date:   Fri,  6 Aug 2021 10:15:01 +0200
Message-Id: <20210806081111.473948710@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bd0447f72de0963129612bf18202204d5b25e133 which is
commit 3a70dd2d050331ee4cf5ad9d5c0a32d83ead9a43 upstream.

It has been found to have problems.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Peter Hess <peter.hess@ph-home.de>
Cc: Frank Wunderlich <frank-w@public-files.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mt65xx.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -392,23 +392,13 @@ static int mtk_spi_fifo_transfer(struct
 	mtk_spi_setup_packet(master);
 
 	cnt = xfer->len / 4;
-	if (xfer->tx_buf)
-		iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
-
-	if (xfer->rx_buf)
-		ioread32_rep(mdata->base + SPI_RX_DATA_REG, xfer->rx_buf, cnt);
+	iowrite32_rep(mdata->base + SPI_TX_DATA_REG, xfer->tx_buf, cnt);
 
 	remainder = xfer->len % 4;
 	if (remainder > 0) {
 		reg_val = 0;
-		if (xfer->tx_buf) {
-			memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
-			writel(reg_val, mdata->base + SPI_TX_DATA_REG);
-		}
-		if (xfer->rx_buf) {
-			reg_val = readl(mdata->base + SPI_RX_DATA_REG);
-			memcpy(xfer->rx_buf + (cnt * 4), &reg_val, remainder);
-		}
+		memcpy(&reg_val, xfer->tx_buf + (cnt * 4), remainder);
+		writel(reg_val, mdata->base + SPI_TX_DATA_REG);
 	}
 
 	mtk_spi_enable_transfer(master);



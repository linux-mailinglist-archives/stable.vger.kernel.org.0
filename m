Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67C13E2511
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244019AbhHFIQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243900AbhHFIP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C673611CE;
        Fri,  6 Aug 2021 08:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237743;
        bh=X5OoLP40SLMJExy2I+2pWTpnb1+yy/Vn1uUrqXy3jT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgjyKKM9YRbCAdd1NTLef5szyqIVDuRkaLnoGJsKq3k7/EkjyaVlWCdwPmBU4AGcz
         Sjj3P7qVe/BDzeiP+dKLpQrq5sRx/Z7FAh9pOLeq/TbMVGc2ARPP6fSTMz28Qs0Ool
         Z+Xkl7Vls+6oFrqNm/rPhw1D77m2CWyNbuNSX+D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/11] Revert "spi: mediatek: fix fifo rx mode"
Date:   Fri,  6 Aug 2021 10:14:49 +0200
Message-Id: <20210806081110.723203076@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081110.511221879@linuxfoundation.org>
References: <20210806081110.511221879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 5391ab22bead617d00346d86109e19c7a7288b29 which is
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



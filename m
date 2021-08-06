Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4704A3E2580
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244160AbhHFIUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244297AbhHFITd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56B9E61206;
        Fri,  6 Aug 2021 08:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237957;
        bh=7Hr6HNXRZ5qtxvCoRW1jPF50KSlB2rwvYL0Rzok0DYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkfTQVIViCVrziVTD7avuUDMmuEHVMPg/7xppI44zscBd3VxxCNeK8WjyRWYM9d1l
         hKFPWwz3wP9QawlJI/F/KSbQvWDHtWnU90zubgYGcytNWj1Yn0lyIVjEYfW5U/fbBU
         WNMaBBww0CwMBhPmhrZ0ImCzBNzdOswOujm6r430=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Peter Hess <peter.hess@ph-home.de>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/30] Revert "spi: mediatek: fix fifo rx mode"
Date:   Fri,  6 Aug 2021 10:16:58 +0200
Message-Id: <20210806081113.814362149@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 2435dcfd16ac482803c6ecf2ba0d2a0553214d54 which is
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
@@ -434,23 +434,13 @@ static int mtk_spi_fifo_transfer(struct
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



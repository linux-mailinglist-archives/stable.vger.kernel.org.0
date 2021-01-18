Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464E92FA2DE
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392005AbhAROWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390644AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D97222EBD;
        Mon, 18 Jan 2021 11:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970259;
        bh=51Jmu/SJM7Ea2UJoap9WzV6FlX6Y8pOBAlT9SW9jlRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6gZH+HkOfvq+xyjT+kIqhCjUc7SXnqcFGflvEjnk3ayN0iPk3ewVqwHxkYMMawwd
         odTs13nuFPL4zuqWUXlWKE8xYPQpO+Py9lKbyj+VZzD3Ek52o2Imqb5os0IOh0seNT
         kvhKEdq7hbgnNgtG6sQV6dYPkumEVgPuYY1s54K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/152] spi: altera: fix return value for altera_spi_txrx()
Date:   Mon, 18 Jan 2021 12:34:08 +0100
Message-Id: <20210118113356.286436601@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yilun <yilun.xu@intel.com>

[ Upstream commit ede090f5a438e97d0586f64067bbb956e30a2a31 ]

This patch fixes the return value for altera_spi_txrx. It should return
1 for interrupt transfer mode, and return 0 for polling transfer mode.

The altera_spi_txrx() implements the spi_controller.transfer_one
callback. According to the spi-summary.rst, the transfer_one should
return 0 when transfer is finished, return 1 when transfer is still in
progress.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/1609219662-27057-2-git-send-email-yilun.xu@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-altera.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-altera.c b/drivers/spi/spi-altera.c
index 809bfff3690ab..cbc4c28c1541c 100644
--- a/drivers/spi/spi-altera.c
+++ b/drivers/spi/spi-altera.c
@@ -189,24 +189,26 @@ static int altera_spi_txrx(struct spi_master *master,
 
 		/* send the first byte */
 		altera_spi_tx_word(hw);
-	} else {
-		while (hw->count < hw->len) {
-			altera_spi_tx_word(hw);
 
-			for (;;) {
-				altr_spi_readl(hw, ALTERA_SPI_STATUS, &val);
-				if (val & ALTERA_SPI_STATUS_RRDY_MSK)
-					break;
+		return 1;
+	}
+
+	while (hw->count < hw->len) {
+		altera_spi_tx_word(hw);
 
-				cpu_relax();
-			}
+		for (;;) {
+			altr_spi_readl(hw, ALTERA_SPI_STATUS, &val);
+			if (val & ALTERA_SPI_STATUS_RRDY_MSK)
+				break;
 
-			altera_spi_rx_word(hw);
+			cpu_relax();
 		}
-		spi_finalize_current_transfer(master);
+
+		altera_spi_rx_word(hw);
 	}
+	spi_finalize_current_transfer(master);
 
-	return t->len;
+	return 0;
 }
 
 static irqreturn_t altera_spi_irq(int irq, void *dev)
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B78C2F3154
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhALNRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:17:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389811AbhALM5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46AE423136;
        Tue, 12 Jan 2021 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456167;
        bh=51Jmu/SJM7Ea2UJoap9WzV6FlX6Y8pOBAlT9SW9jlRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWOUPmYjMMJpyiKdw1yYenknBG06OGEZOmoaTquecwG8nAran33sZWs3RJdsYJx5L
         OubpnMas8yXrV39Lj7OT6QJcUYvUKBjKcZuj7uBz+VSJO3PZl0gjsnKZevHv+CsenW
         AwxSjchkPtEIKy3zNM0fzlh0jmNJ4g2pK7u7w2z5axhHrP7Ai6Fenl5c2zK+ytdKt9
         hOx/B37AFS3e4DsaCzXOAfhDRg6aEQltcUvOGAh9fjmW9C8WmAD8UsqNOaExSpeVXZ
         2yx28/4EWqqbXOKTmWqCmJm24ah+D3iFCP6mKB6DJ0phWgFGEDr2DvWLffYVkTnqtq
         SKBEAS+Ph/j0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xu Yilun <yilun.xu@intel.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/51] spi: altera: fix return value for altera_spi_txrx()
Date:   Tue, 12 Jan 2021 07:55:06 -0500
Message-Id: <20210112125534.70280-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


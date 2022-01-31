Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FF64A4581
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350646AbiAaLmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358648AbiAaLft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:35:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6E3C0797A0;
        Mon, 31 Jan 2022 03:23:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C0B4B82A61;
        Mon, 31 Jan 2022 11:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F841C340E8;
        Mon, 31 Jan 2022 11:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628233;
        bh=5fxfTELMQUQVDkvIVOXfIZzFJxL7rjRhJULPrrz4ABU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4ICpwzS6myprAhfNa4HeXP3yTPv8fIsd20CBI7qk3W7V8crzgj/X7bi/JhGAv2Vw
         ML2Lci4pMC7qBMq3vXiuO1n3V+p1L15l9s+NJJBCx7NAg8oyVukQPsMPy3VnM5Yp2j
         lhy6CYHbX5jHxigJyE9DpGwTMKRORg3XxYwiFuec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 134/200] net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode
Date:   Mon, 31 Jan 2022 11:56:37 +0100
Message-Id: <20220131105238.062966793@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>

[ Upstream commit 0959bc4bd4206433ed101a1332a23e93ad16ec77 ]

Bit pattern of the ETHER_CLOCK_SEL register for RMII/MII mode should be fixed.
Also, some control bits should be modified with a specific sequence.

Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
Signed-off-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 32 ++++++++++++-------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index 43a446ceadf7a..dde5b772a5af7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -96,31 +96,41 @@ static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 	val |= ETHER_CLK_SEL_TX_O_E_N_IN;
 	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 
+	/* Set Clock-Mux, Start clock, Set TX_O direction */
 	switch (dwmac->phy_intf_sel) {
 	case ETHER_CONFIG_INTF_RGMII:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val &= ~ETHER_CLK_SEL_TX_O_E_N_IN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	case ETHER_CONFIG_INTF_RMII:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV |
-			ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC | ETHER_CLK_SEL_TX_O_E_N_IN |
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV | ETHER_CLK_SEL_TX_O_E_N_IN |
 			ETHER_CLK_SEL_RMII_CLK_SEL_RX_C;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RMII_CLK_RST;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RMII_CLK_EN | ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	case ETHER_CONFIG_INTF_MII:
 	default:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC |
-			ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV | ETHER_CLK_SEL_TX_O_E_N_IN |
-			ETHER_CLK_SEL_RMII_CLK_EN;
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC | ETHER_CLK_SEL_TX_O_E_N_IN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	}
 
-	/* Start clock */
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-	val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-
-	val &= ~ETHER_CLK_SEL_TX_O_E_N_IN;
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-
 	spin_unlock_irqrestore(&dwmac->lock, flags);
 }
 
-- 
2.34.1




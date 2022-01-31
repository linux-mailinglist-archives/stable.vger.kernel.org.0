Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F2F4A42C8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiAaLOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:14:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45658 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359735AbiAaLMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:12:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C0246114D;
        Mon, 31 Jan 2022 11:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF22DC340E8;
        Mon, 31 Jan 2022 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627522;
        bh=4THibdvVjlt20zkomRauh+nWUGEj2f/erCuVvO5br2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KB8GrMzTDVIedQ0f99wYwGaTGnxkdXzoY6ZfyQAimsHXa38Lmk125T2WKDQWda6Mz
         oxnbN2cinuwV1QBFTwccbfXb82zITXp6DLbuJKIqMHf0mxsiWmBD+BHYn8GWsn6IIK
         Ygp1A/h/lawfI4p15I2KcqazXMkpLIp+FU0U0dkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/171] net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode
Date:   Mon, 31 Jan 2022 11:56:17 +0100
Message-Id: <20220131105233.825490332@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
index 1c599a005aab6..4578c64953eac 100644
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




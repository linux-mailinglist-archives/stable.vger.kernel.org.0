Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13219499368
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348522AbiAXUdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59238 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382039AbiAXUZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:25:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BF6CB8121A;
        Mon, 24 Jan 2022 20:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85392C340E5;
        Mon, 24 Jan 2022 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055906;
        bh=xdgjS3mVQChhF70ldCsToTvWsLdPLVKFsZ1ngsqTNhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFeggJW/ZUZHkxK6jsIkQ5mgAYbw1daSsqLvBKE72dxXiGUqxO4Pl73qrzoWN//zX
         HbqD3sdejx7x9fmVNvyxSMa5r2LyqVxXSL4nKOCgtSq7EbNTamL2m1FtBly2PIrDEk
         Wk/76wCaGGJkHM7x4A6DJuCX+p29L2iyNbjkuFkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/846] net: ethernet: mtk_eth_soc: fix return values and refactor MDIO ops
Date:   Mon, 24 Jan 2022 19:37:03 +0100
Message-Id: <20220124184111.466072787@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit eda80b249df7bbc7b3dd13907343a3e59bfc57fd ]

Instead of returning -1 (-EPERM) when MDIO bus is stuck busy
while writing or 0xffff if it happens while reading, return the
appropriate -ETIMEDOUT. Also fix return type to int instead of u32.
Refactor functions to use bitfield helpers instead of having various
masking and shifting constants in the code, which also results in the
register definitions in the header file being more obviously related
to what is stated in the MediaTek's Reference Manual.

Fixes: 656e705243fd0 ("net-next: mediatek: add support for MT7623 ethernet")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 53 ++++++++++++---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 16 +++++--
 2 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 398c23cec8151..9e7a872426fc4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -91,46 +91,53 @@ static int mtk_mdio_busy_wait(struct mtk_eth *eth)
 	}
 
 	dev_err(eth->dev, "mdio: MDIO timeout\n");
-	return -1;
+	return -ETIMEDOUT;
 }
 
-static u32 _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr,
-			   u32 phy_register, u32 write_data)
+static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
+			   u32 write_data)
 {
-	if (mtk_mdio_busy_wait(eth))
-		return -1;
+	int ret;
 
-	write_data &= 0xffff;
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
 
-	mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_WRITE |
-		(phy_register << PHY_IAC_REG_SHIFT) |
-		(phy_addr << PHY_IAC_ADDR_SHIFT) | write_data,
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		     PHY_IAC_START_C22 |
+		     PHY_IAC_CMD_WRITE |
+		     PHY_IAC_REG(phy_reg) |
+		     PHY_IAC_ADDR(phy_addr) |
+		     PHY_IAC_DATA(write_data),
 		MTK_PHY_IAC);
 
-	if (mtk_mdio_busy_wait(eth))
-		return -1;
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }
 
-static u32 _mtk_mdio_read(struct mtk_eth *eth, int phy_addr, int phy_reg)
+static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
 {
-	u32 d;
+	int ret;
 
-	if (mtk_mdio_busy_wait(eth))
-		return 0xffff;
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
 
-	mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_READ |
-		(phy_reg << PHY_IAC_REG_SHIFT) |
-		(phy_addr << PHY_IAC_ADDR_SHIFT),
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		     PHY_IAC_START_C22 |
+		     PHY_IAC_CMD_C22_READ |
+		     PHY_IAC_REG(phy_reg) |
+		     PHY_IAC_ADDR(phy_addr),
 		MTK_PHY_IAC);
 
-	if (mtk_mdio_busy_wait(eth))
-		return 0xffff;
-
-	d = mtk_r32(eth, MTK_PHY_IAC) & 0xffff;
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
 
-	return d;
+	return mtk_r32(eth, MTK_PHY_IAC) & PHY_IAC_DATA_MASK;
 }
 
 static int mtk_mdio_write(struct mii_bus *bus, int phy_addr,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 5ef70dd8b49c6..f2d90639d7ed1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -341,11 +341,17 @@
 /* PHY Indirect Access Control registers */
 #define MTK_PHY_IAC		0x10004
 #define PHY_IAC_ACCESS		BIT(31)
-#define PHY_IAC_READ		BIT(19)
-#define PHY_IAC_WRITE		BIT(18)
-#define PHY_IAC_START		BIT(16)
-#define PHY_IAC_ADDR_SHIFT	20
-#define PHY_IAC_REG_SHIFT	25
+#define PHY_IAC_REG_MASK	GENMASK(29, 25)
+#define PHY_IAC_REG(x)		FIELD_PREP(PHY_IAC_REG_MASK, (x))
+#define PHY_IAC_ADDR_MASK	GENMASK(24, 20)
+#define PHY_IAC_ADDR(x)		FIELD_PREP(PHY_IAC_ADDR_MASK, (x))
+#define PHY_IAC_CMD_MASK	GENMASK(19, 18)
+#define PHY_IAC_CMD_WRITE	FIELD_PREP(PHY_IAC_CMD_MASK, 1)
+#define PHY_IAC_CMD_C22_READ	FIELD_PREP(PHY_IAC_CMD_MASK, 2)
+#define PHY_IAC_START_MASK	GENMASK(17, 16)
+#define PHY_IAC_START_C22	FIELD_PREP(PHY_IAC_START_MASK, 1)
+#define PHY_IAC_DATA_MASK	GENMASK(15, 0)
+#define PHY_IAC_DATA(x)		FIELD_PREP(PHY_IAC_DATA_MASK, (x))
 #define PHY_IAC_TIMEOUT		HZ
 
 #define MTK_MAC_MISC		0x1000c
-- 
2.34.1




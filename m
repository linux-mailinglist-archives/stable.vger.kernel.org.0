Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4407D50554E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbiDRNK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240949AbiDRNFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:05:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCD529CBB;
        Mon, 18 Apr 2022 05:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2019CB80E44;
        Mon, 18 Apr 2022 12:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFBCC385A7;
        Mon, 18 Apr 2022 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285990;
        bh=PIKSrYrmqMtZ8E664NQk1+Mn3l/xkzBH+ARjWDPYrzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMJ62DDQsPJztoZ5KpUl5fe/NpDmrqa80Gq8ixXkGRys6PIb/2PSHtfSatb5Bp8dE
         7EN+Wpm53Jd24ZLX0xmx1UhgVn+0qIGPIufcXWmZD4U/qtxJqykzMZOKsRpnsRdfco
         o/CESniF7XedclwPkKC7Bgm6NC6vhypwQeK4o9Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/32] net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link
Date:   Mon, 18 Apr 2022 14:13:46 +0200
Message-Id: <20220418121127.313985949@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit a6aaa00324240967272b451bfa772547bd576ee6 ]

When using a fixed-link, the altr_tse_pcs driver crashes
due to null-pointer dereference as no phy_device is provided to
tse_pcs_fix_mac_speed function. Fix this by adding a check for
phy_dev before calling the tse_pcs_fix_mac_speed() function.

Also clean up the tse_pcs_fix_mac_speed function a bit. There is
no need to check for splitter_base and sgmii_adapter_base
because the driver will fail if these 2 variables are not
derived from the device tree.

Fixes: fb3bbdb85989 ("net: ethernet: Add TSE PCS support to dwmac-socfpga")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c  |  8 --------
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h  |  4 ++++
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 13 +++++--------
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
index 8b50afcdb52d..729df169faa2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
@@ -68,10 +68,6 @@
 #define TSE_PCS_USE_SGMII_ENA				BIT(0)
 #define TSE_PCS_IF_USE_SGMII				0x03
 
-#define SGMII_ADAPTER_CTRL_REG				0x00
-#define SGMII_ADAPTER_DISABLE				0x0001
-#define SGMII_ADAPTER_ENABLE				0x0000
-
 #define AUTONEGO_LINK_TIMER				20
 
 static int tse_pcs_reset(void __iomem *base, struct tse_pcs *pcs)
@@ -213,12 +209,8 @@ void tse_pcs_fix_mac_speed(struct tse_pcs *pcs, struct phy_device *phy_dev,
 			   unsigned int speed)
 {
 	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
-	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
 	u32 val;
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-
 	pcs->autoneg = phy_dev->autoneg;
 
 	if (phy_dev->autoneg == AUTONEG_ENABLE) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
index 2f5882450b06..254199f2efdb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
@@ -21,6 +21,10 @@
 #include <linux/phy.h>
 #include <linux/timer.h>
 
+#define SGMII_ADAPTER_CTRL_REG		0x00
+#define SGMII_ADAPTER_ENABLE		0x0000
+#define SGMII_ADAPTER_DISABLE		0x0001
+
 struct tse_pcs {
 	struct device *dev;
 	void __iomem *tse_pcs_base;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 33407df6bea6..32ead4a4b460 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -29,9 +29,6 @@
 
 #include "altr_tse_pcs.h"
 
-#define SGMII_ADAPTER_CTRL_REG                          0x00
-#define SGMII_ADAPTER_DISABLE                           0x0001
-
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII 0x2
@@ -65,16 +62,14 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
 	void __iomem *splitter_base = dwmac->splitter_base;
-	void __iomem *tse_pcs_base = dwmac->pcs.tse_pcs_base;
 	void __iomem *sgmii_adapter_base = dwmac->pcs.sgmii_adapter_base;
 	struct device *dev = dwmac->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	if ((tse_pcs_base) && (sgmii_adapter_base))
-		writew(SGMII_ADAPTER_DISABLE,
-		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	writew(SGMII_ADAPTER_DISABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -96,7 +91,9 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	if (tse_pcs_base && sgmii_adapter_base)
+	writew(SGMII_ADAPTER_ENABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if (phy_dev)
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
 }
 
-- 
2.35.1




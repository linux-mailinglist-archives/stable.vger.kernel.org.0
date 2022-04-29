Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01C95146F6
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357570AbiD2KpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357686AbiD2KpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6020C749B;
        Fri, 29 Apr 2022 03:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F50B83450;
        Fri, 29 Apr 2022 10:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76019C385A7;
        Fri, 29 Apr 2022 10:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228903;
        bh=mdSNBUIKfti/7pnocwwIpeg6Zp7dOfO1v0imMvszI7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiVMbcjwLnHYd096a/ChBm4qichTzj4ulbkUtXiysTR5UroYIl5zKt0o+DCYGQUnQ
         V3P8mjgO1CtZWXOzRMTTkhdr8JTHjzexkcmnRNTRqrpUdTmYLNCoqOyP07tMdOqLB5
         yXlLFfDnPm1sWPaMOYSIF0sn3pSl2fnivElVczs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Dinh Nguyen <dinguyen@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/12] Revert "net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link"
Date:   Fri, 29 Apr 2022 12:41:28 +0200
Message-Id: <20220429104048.791910983@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit e2423aa174e6c3e9805e96db778245ba73cdd88c which is
commit a6aaa00324240967272b451bfa772547bd576ee6 upstream.

Pavel reports that it causes boot issues, so revert it for now.

Link: https://lore.kernel.org/r/20220429074341.GB1423@amd
Reported-by: Pavel Machek <pavel@denx.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c  |    8 ++++++++
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h  |    4 ----
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c |   13 ++++++++-----
 3 files changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
@@ -68,6 +68,10 @@
 #define TSE_PCS_USE_SGMII_ENA				BIT(0)
 #define TSE_PCS_IF_USE_SGMII				0x03
 
+#define SGMII_ADAPTER_CTRL_REG				0x00
+#define SGMII_ADAPTER_DISABLE				0x0001
+#define SGMII_ADAPTER_ENABLE				0x0000
+
 #define AUTONEGO_LINK_TIMER				20
 
 static int tse_pcs_reset(void __iomem *base, struct tse_pcs *pcs)
@@ -209,8 +213,12 @@ void tse_pcs_fix_mac_speed(struct tse_pc
 			   unsigned int speed)
 {
 	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
+	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
 	u32 val;
 
+	writew(SGMII_ADAPTER_ENABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+
 	pcs->autoneg = phy_dev->autoneg;
 
 	if (phy_dev->autoneg == AUTONEG_ENABLE) {
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
@@ -21,10 +21,6 @@
 #include <linux/phy.h>
 #include <linux/timer.h>
 
-#define SGMII_ADAPTER_CTRL_REG		0x00
-#define SGMII_ADAPTER_ENABLE		0x0000
-#define SGMII_ADAPTER_DISABLE		0x0001
-
 struct tse_pcs {
 	struct device *dev;
 	void __iomem *tse_pcs_base;
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -29,6 +29,9 @@
 
 #include "altr_tse_pcs.h"
 
+#define SGMII_ADAPTER_CTRL_REG                          0x00
+#define SGMII_ADAPTER_DISABLE                           0x0001
+
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII 0x2
@@ -62,14 +65,16 @@ static void socfpga_dwmac_fix_mac_speed(
 {
 	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
 	void __iomem *splitter_base = dwmac->splitter_base;
+	void __iomem *tse_pcs_base = dwmac->pcs.tse_pcs_base;
 	void __iomem *sgmii_adapter_base = dwmac->pcs.sgmii_adapter_base;
 	struct device *dev = dwmac->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	writew(SGMII_ADAPTER_DISABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if ((tse_pcs_base) && (sgmii_adapter_base))
+		writew(SGMII_ADAPTER_DISABLE,
+		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -91,9 +96,7 @@ static void socfpga_dwmac_fix_mac_speed(
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-	if (phy_dev)
+	if (tse_pcs_base && sgmii_adapter_base)
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
 }
 



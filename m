Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88A5EA13E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiIZKqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbiIZKow (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:44:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFAF558DA;
        Mon, 26 Sep 2022 03:25:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8838BB802C5;
        Mon, 26 Sep 2022 10:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5A6C4347C;
        Mon, 26 Sep 2022 10:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187934;
        bh=kEcA/9wTN6peHSuhYVAET0L6NbfiIGmPkAVhetaQM1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuA2+btOmDCc1/A6ftTXnYhPPm4KNrpCXJLPv4F4mJetJle5ke2ic3Q9nCD44f4WE
         Oea7z/tkMcq77UkmQN3gdUD/pePcEMVU46sM8wXMxSI5CH6C2k0MyQzpGL1nvQ2riT
         aHzfGVG1nEQ9XbR67R9qQlY42BAz0MzBoeK377v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Keguang Zhang <keguang.zhang@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/120] MIPS: Loongson32: Fix PHY-mode being left unspecified
Date:   Mon, 26 Sep 2022 12:11:49 +0200
Message-Id: <20220926100753.789656004@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit e9f3f8f488005f6da3cfb66070706770ecaef747 ]

commit 0060c8783330 ("net: stmmac: implement support for passive mode
converters via dt") has changed the plat->interface field semantics from
containing the PHY-mode to specifying the MAC-PCS interface mode. Due to
that the loongson32 platform code will leave the phylink interface
uninitialized with the PHY-mode intended by the means of the actual
platform setup. The commit-author most likely has just missed the
arch-specific code to fix. Let's mend the Loongson32 platform code then by
assigning the PHY-mode to the phy_interface field of the STMMAC platform
data.

Fixes: 0060c8783330 ("net: stmmac: implement support for passive mode converters via dt")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Keguang Zhang <keguang.zhang@gmail.com>
Tested-by: Keguang Zhang <keguang.zhang@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson32/common/platform.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/loongson32/common/platform.c b/arch/mips/loongson32/common/platform.c
index 794c96c2a4cd..311dc1580bbd 100644
--- a/arch/mips/loongson32/common/platform.c
+++ b/arch/mips/loongson32/common/platform.c
@@ -98,7 +98,7 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 	if (plat_dat->bus_id) {
 		__raw_writel(__raw_readl(LS1X_MUX_CTRL0) | GMAC1_USE_UART1 |
 			     GMAC1_USE_UART0, LS1X_MUX_CTRL0);
-		switch (plat_dat->interface) {
+		switch (plat_dat->phy_interface) {
 		case PHY_INTERFACE_MODE_RGMII:
 			val &= ~(GMAC1_USE_TXCLK | GMAC1_USE_PWM23);
 			break;
@@ -107,12 +107,12 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 			break;
 		default:
 			pr_err("unsupported mii mode %d\n",
-			       plat_dat->interface);
+			       plat_dat->phy_interface);
 			return -ENOTSUPP;
 		}
 		val &= ~GMAC1_SHUT;
 	} else {
-		switch (plat_dat->interface) {
+		switch (plat_dat->phy_interface) {
 		case PHY_INTERFACE_MODE_RGMII:
 			val &= ~(GMAC0_USE_TXCLK | GMAC0_USE_PWM01);
 			break;
@@ -121,7 +121,7 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 			break;
 		default:
 			pr_err("unsupported mii mode %d\n",
-			       plat_dat->interface);
+			       plat_dat->phy_interface);
 			return -ENOTSUPP;
 		}
 		val &= ~GMAC0_SHUT;
@@ -131,7 +131,7 @@ int ls1x_eth_mux_init(struct platform_device *pdev, void *priv)
 	plat_dat = dev_get_platdata(&pdev->dev);
 
 	val &= ~PHY_INTF_SELI;
-	if (plat_dat->interface == PHY_INTERFACE_MODE_RMII)
+	if (plat_dat->phy_interface == PHY_INTERFACE_MODE_RMII)
 		val |= 0x4 << PHY_INTF_SELI_SHIFT;
 	__raw_writel(val, LS1X_MUX_CTRL1);
 
@@ -146,9 +146,9 @@ static struct plat_stmmacenet_data ls1x_eth0_pdata = {
 	.bus_id			= 0,
 	.phy_addr		= -1,
 #if defined(CONFIG_LOONGSON1_LS1B)
-	.interface		= PHY_INTERFACE_MODE_MII,
+	.phy_interface		= PHY_INTERFACE_MODE_MII,
 #elif defined(CONFIG_LOONGSON1_LS1C)
-	.interface		= PHY_INTERFACE_MODE_RMII,
+	.phy_interface		= PHY_INTERFACE_MODE_RMII,
 #endif
 	.mdio_bus_data		= &ls1x_mdio_bus_data,
 	.dma_cfg		= &ls1x_eth_dma_cfg,
@@ -186,7 +186,7 @@ struct platform_device ls1x_eth0_pdev = {
 static struct plat_stmmacenet_data ls1x_eth1_pdata = {
 	.bus_id			= 1,
 	.phy_addr		= -1,
-	.interface		= PHY_INTERFACE_MODE_MII,
+	.phy_interface		= PHY_INTERFACE_MODE_MII,
 	.mdio_bus_data		= &ls1x_mdio_bus_data,
 	.dma_cfg		= &ls1x_eth_dma_cfg,
 	.has_gmac		= 1,
-- 
2.35.1




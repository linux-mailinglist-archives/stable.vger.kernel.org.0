Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E831C5A48E7
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiH2LRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiH2LRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:17:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD7673927;
        Mon, 29 Aug 2022 04:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BBD611F1;
        Mon, 29 Aug 2022 11:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E91C433C1;
        Mon, 29 Aug 2022 11:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771350;
        bh=V9jVGqk7lz1UgihqpJfWjn5UtbbfwutqK2q9IUj0wAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9GSHAhTGytasI5CrrHQsyQrE41tZaiWx0dvXudvDZU6m8fo40HYTrP4lE2XGydpV
         mH3LYKt7pZAMyjdP68111yLHBLbGmnf0qRpjM0M5rKQS5IHaJ7kNq7XFRwMTtbPbuS
         h5XKZ4h7JOJIc1dnacGzfz4zx7ML6Rc7IrLTB+No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qi Duan <qi.duan@amlogic.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/136] net: stmmac: work around sporadic tx issue on link-up
Date:   Mon, 29 Aug 2022 12:59:21 +0200
Message-Id: <20220829105808.525512557@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit a3a57bf07de23fe1ff779e0fdf710aa581c3ff73 ]

This is a follow-up to the discussion in [0]. It seems to me that
at least the IP version used on Amlogic SoC's sometimes has a problem
if register MAC_CTRL_REG is written whilst the chip is still processing
a previous write. But that's just a guess.
Adding a delay between two writes to this register helps, but we can
also simply omit the offending second write. This patch uses the second
approach and is based on a suggestion from Qi Duan.
Benefit of this approach is that we can save few register writes, also
on not affected chip versions.

[0] https://www.spinics.net/lists/netdev/msg831526.html

Fixes: bfab27a146ed ("stmmac: add the experimental PCI support")
Suggested-by: Qi Duan <qi.duan@amlogic.com>
Suggested-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/e99857ce-bd90-5093-ca8c-8cd480b5a0a2@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c   | 8 ++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index d1c31200bb911..01d0a14f67520 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -258,14 +258,18 @@ EXPORT_SYMBOL_GPL(stmmac_set_mac_addr);
 /* Enable disable MAC RX/TX */
 void stmmac_set_mac(void __iomem *ioaddr, bool enable)
 {
-	u32 value = readl(ioaddr + MAC_CTRL_REG);
+	u32 old_val, value;
+
+	old_val = readl(ioaddr + MAC_CTRL_REG);
+	value = old_val;
 
 	if (enable)
 		value |= MAC_ENABLE_RX | MAC_ENABLE_TX;
 	else
 		value &= ~(MAC_ENABLE_TX | MAC_ENABLE_RX);
 
-	writel(value, ioaddr + MAC_CTRL_REG);
+	if (value != old_val)
+		writel(value, ioaddr + MAC_CTRL_REG);
 }
 
 void stmmac_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b4f83c8655684..2569673559df3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1083,10 +1083,10 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 			       bool tx_pause, bool rx_pause)
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
-	u32 ctrl;
+	u32 old_ctrl, ctrl;
 
-	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
-	ctrl &= ~priv->hw->link.speed_mask;
+	old_ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
+	ctrl = old_ctrl & ~priv->hw->link.speed_mask;
 
 	if (interface == PHY_INTERFACE_MODE_USXGMII) {
 		switch (speed) {
@@ -1161,7 +1161,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	if (tx_pause && rx_pause)
 		stmmac_mac_flow_ctrl(priv, duplex);
 
-	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
+	if (ctrl != old_ctrl)
+		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-- 
2.35.1




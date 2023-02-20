Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85C269CE57
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjBTN6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjBTN6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF49B1DB8D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4D1660CEB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AC7C433EF;
        Mon, 20 Feb 2023 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901455;
        bh=H6C+4vrhtGEElUVrGafR8vgBWxmAKGYPNQIs9NU39OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etMrx4+KuJUkl8cjnNQWy6GEOKpuq1XebeTA/t0L3X/2YLELWvtKzmtGbNhswoySF
         +1AYu8b3kW55teXB/NPRTE60k9eIC16+ZHOgrmw/R1Xa3e/+PgPaOwFtvEcCKzL3XG
         jle+XIRg6woNR6fS72VCeJbJ6KJQQJrgwNnxvj7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/118] net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC
Date:   Mon, 20 Feb 2023 14:35:39 +0100
Message-Id: <20230220133601.354318482@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andrey.konovalov@linaro.org>

[ Upstream commit 54aa39a513dbf2164ca462a19f04519b2407a224 ]

Currently in phy_init_eee() the driver unconditionally configures the PHY
to stop RX_CLK after entering Rx LPI state. This causes an LPI interrupt
storm on my qcs404-base board.

Change the PHY initialization so that for "qcom,qcs404-ethqos" compatible
device RX_CLK continues to run even in Rx LPI state.

Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 3 ++-
 include/linux/stmmac.h                                  | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 835caa15d55ff..732774645c1a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -560,6 +560,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	plat_dat->has_gmac4 = 1;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
+	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
+		plat_dat->rx_clk_runs_in_lpi = 1;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4bba0444c764a..84e1740b12f1b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1077,7 +1077,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-		priv->eee_active = phy_init_eee(phy, 1) >= 0;
+		priv->eee_active =
+			phy_init_eee(phy, !priv->plat->rx_clk_runs_in_lpi) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
 		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fb2e88614f5d1..313edd19bf545 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -252,6 +252,7 @@ struct plat_stmmacenet_data {
 	int rss_en;
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
+	bool rx_clk_runs_in_lpi;
 	int has_xgmac;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
-- 
2.39.0




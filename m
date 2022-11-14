Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C928627F56
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbiKNM5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiKNM5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:57:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E55527CF7
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:57:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC126116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BB1C433D6;
        Mon, 14 Nov 2022 12:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430670;
        bh=YMBm1Gl4Z+01QRAfQpWxo8V6HKDcTUEM4apX4uHn8ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMOkv2+CQnuIeZE9BsekhVRQuhOTPwj0+JJ9ypyXB5z7TeOw87E15MZWLzPhah+b7
         Of9Xj2woAk8pXq8maZnTnwEeJenstOujXiRWyNeCDwajpa6D5+QK62C29YtfR+Lpo7
         vUkLNPVSI62YhE1PrxYq3O2okjFXsl/NLVonZacw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ling Pei Lee <pei.lee.ling@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Tan@vger.kernel.org
Subject: [PATCH 5.15 067/131] stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz
Date:   Mon, 14 Nov 2022 13:45:36 +0100
Message-Id: <20221114124451.536247869@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Tan, Tee Min <tee.min.tan@intel.com>

[ Upstream commit dcea1a8107c04b9521dee1dd37971757a22db162 ]

Current Intel platform has an output of ~976ms interval
when probed on 1 Pulse-per-Second(PPS) hardware pin.

The correct PTP clock frequency for PCH GbE should be 204.8MHz
instead of 200MHz. PSE GbE PTP clock rate remains at 200MHz.

Fixes: 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
Signed-off-by: Ling Pei Lee <pei.lee.ling@intel.com>
Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Gan Yi Fang <yi.fang.gan@intel.com>
Link: https://lore.kernel.org/r/20221108020811.12919-1-yi.fang.gan@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 3829bd23e47d..fb9ff4ce9453 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -593,7 +593,6 @@ static int ehl_common_data(struct pci_dev *pdev,
 {
 	plat->rx_queues_to_use = 8;
 	plat->tx_queues_to_use = 8;
-	plat->clk_ptp_rate = 200000000;
 	plat->use_phy_wol = 1;
 
 	plat->safety_feat_cfg->tsoee = 1;
@@ -618,6 +617,8 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 
+	plat->clk_ptp_rate = 204800000;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -631,6 +632,8 @@ static int ehl_rgmii_data(struct pci_dev *pdev,
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
 
+	plat->clk_ptp_rate = 204800000;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -647,6 +650,8 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
 	plat->bus_id = 2;
 	plat->addr64 = 32;
 
+	plat->clk_ptp_rate = 200000000;
+
 	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
 
 	return ehl_common_data(pdev, plat);
@@ -686,6 +691,8 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
 	plat->bus_id = 3;
 	plat->addr64 = 32;
 
+	plat->clk_ptp_rate = 200000000;
+
 	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
 
 	return ehl_common_data(pdev, plat);
@@ -721,7 +728,7 @@ static int tgl_common_data(struct pci_dev *pdev,
 {
 	plat->rx_queues_to_use = 6;
 	plat->tx_queues_to_use = 4;
-	plat->clk_ptp_rate = 200000000;
+	plat->clk_ptp_rate = 204800000;
 	plat->speed_mode_2500 = intel_speed_mode_2500;
 
 	plat->safety_feat_cfg->tsoee = 1;
-- 
2.35.1




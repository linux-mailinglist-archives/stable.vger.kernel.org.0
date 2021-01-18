Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B81D2FA404
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392625AbhARPD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390793AbhARLmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B104F22D37;
        Mon, 18 Jan 2021 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970127;
        bh=j9Cu8FmBgXApO8MFpbZjqoJFNnXF/9w5EI8fVEKtMzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRDfpsWcbK5o2kR3ISPtxYJlvi95BHZLOv/sJ1IpH4c9KNQ8QZxprN5zmr7F/6bij
         BoOu6y4nOwtGHdfAK0rE1CA9ukmZwo740huFQby1tXoukFOyNLxYKOPuNqoV3ecxo2
         gSR/bNdmSRTAakEzDIQqjZez5KcUFmPe1US5Q6Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 049/152] stmmac: intel: change all EHL/TGL to auto detect phy addr
Date:   Mon, 18 Jan 2021 12:33:44 +0100
Message-Id: <20210118113355.139874911@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

commit bff6f1db91e330d7fba56f815cdbc412c75fe163 upstream.

Set all EHL/TGL phy_addr to -1 so that the driver will automatically
detect it at run-time by probing all the possible 32 addresses.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
Link: https://lore.kernel.org/r/20201106094341.4241-1-vee.khee.wong@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -236,6 +236,7 @@ static int intel_mgbe_common_data(struct
 	int ret;
 	int i;
 
+	plat->phy_addr = -1;
 	plat->clk_csr = 5;
 	plat->has_gmac = 0;
 	plat->has_gmac4 = 1;
@@ -345,7 +346,6 @@ static int ehl_sgmii_data(struct pci_dev
 			  struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 1;
-	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 
 	plat->serdes_powerup = intel_serdes_powerup;
@@ -362,7 +362,6 @@ static int ehl_rgmii_data(struct pci_dev
 			  struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 1;
-	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
 
 	return ehl_common_data(pdev, plat);
@@ -376,7 +375,6 @@ static int ehl_pse0_common_data(struct p
 				struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 2;
-	plat->phy_addr = 1;
 	return ehl_common_data(pdev, plat);
 }
 
@@ -408,7 +406,6 @@ static int ehl_pse1_common_data(struct p
 				struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 3;
-	plat->phy_addr = 1;
 	return ehl_common_data(pdev, plat);
 }
 
@@ -450,7 +447,6 @@ static int tgl_sgmii_data(struct pci_dev
 			  struct plat_stmmacenet_data *plat)
 {
 	plat->bus_id = 1;
-	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9685461F3C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379871AbhK2SpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48114 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380139AbhK2SnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:43:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86738B815C3;
        Mon, 29 Nov 2021 18:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F9EC53FAD;
        Mon, 29 Nov 2021 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211185;
        bh=K5Bd1cx7KusivuH+fjCx+qyWDJhKuWzLW6akozb/WCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6Y3paUnsrmAJbQhLiHAPzc7CpHvWK7LwGB8oVPIiznspXQ8SmXTHJiq/00a0XLl/
         2tehEdWSIf2OgPuGmiu5EuZCCkngg+KL17MyWEdQkCEamG5lG596PJtAAyfBMA48o2
         11bl4JU/NS4EMsh+OjwLp1SkWHqcGmY9E0YSezWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alessandro B Maurici <abmaurici@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/179] lan743x: fix deadlock in lan743x_phy_link_status_change()
Date:   Mon, 29 Nov 2021 19:18:48 +0100
Message-Id: <20211129181723.357798205@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit ddb826c2c92d461f290a7bab89e7c28696191875 ]

Usage of phy_ethtool_get_link_ksettings() in the link status change
handler isn't needed, and in combination with the referenced change
it results in a deadlock. Simply remove the call and replace it with
direct access to phydev->speed. The duplex argument of
lan743x_phy_update_flowcontrol() isn't used and can be removed.

Fixes: c10a485c3de5 ("phy: phy_ethtool_ksettings_get: Lock the phy for consistency")
Reported-by: Alessandro B Maurici <abmaurici@gmail.com>
Tested-by: Alessandro B Maurici <abmaurici@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/40e27f76-0ba3-dcef-ee32-a78b9df38b0f@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 4d5a5d6595b3b..d64ce65a3c174 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -914,8 +914,7 @@ static int lan743x_phy_reset(struct lan743x_adapter *adapter)
 }
 
 static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
-					   u8 duplex, u16 local_adv,
-					   u16 remote_adv)
+					   u16 local_adv, u16 remote_adv)
 {
 	struct lan743x_phy *phy = &adapter->phy;
 	u8 cap;
@@ -943,7 +942,6 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
-		struct ethtool_link_ksettings ksettings;
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
@@ -980,18 +978,14 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		}
 		lan743x_csr_write(adapter, MAC_CR, data);
 
-		memset(&ksettings, 0, sizeof(ksettings));
-		phy_ethtool_get_link_ksettings(netdev, &ksettings);
 		local_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->advertising);
 		remote_advertisement =
 			linkmode_adv_to_mii_adv_t(phydev->lp_advertising);
 
-		lan743x_phy_update_flowcontrol(adapter,
-					       ksettings.base.duplex,
-					       local_advertisement,
+		lan743x_phy_update_flowcontrol(adapter, local_advertisement,
 					       remote_advertisement);
-		lan743x_ptp_update_latency(adapter, ksettings.base.speed);
+		lan743x_ptp_update_latency(adapter, phydev->speed);
 	}
 }
 
-- 
2.33.0




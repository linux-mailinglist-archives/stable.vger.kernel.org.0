Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF36462591
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhK2WlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbhK2WkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23703C047CE3;
        Mon, 29 Nov 2021 10:31:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BDD2CE1412;
        Mon, 29 Nov 2021 18:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47321C53FAD;
        Mon, 29 Nov 2021 18:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210694;
        bh=MXSe230fZrR/MrrpQUhCLTmj/f+27LZwHX4BSqDKQEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxXvBtWNSUpPy42x4ys+nJfAxgzWPN1F2haimpmwzVilJTbP9Bflg7LT+7gP2oPun
         tlacIapSFa0kS3bkZi9mNHGQ7czGLJpt4WJUgpfb7J/VKI7mM7Z0wVhzD++XbB7vUm
         VmzCZUMlzG2y9uuxSwqC9TwYy/6bbaOj1FvOjz6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alessandro B Maurici <abmaurici@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/121] lan743x: fix deadlock in lan743x_phy_link_status_change()
Date:   Mon, 29 Nov 2021 19:18:35 +0100
Message-Id: <20211129181714.489077987@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 3eea8cf076c48..481f89d193f77 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -922,8 +922,7 @@ static int lan743x_phy_reset(struct lan743x_adapter *adapter)
 }
 
 static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
-					   u8 duplex, u16 local_adv,
-					   u16 remote_adv)
+					   u16 local_adv, u16 remote_adv)
 {
 	struct lan743x_phy *phy = &adapter->phy;
 	u8 cap;
@@ -951,7 +950,6 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 
 	phy_print_status(phydev);
 	if (phydev->state == PHY_RUNNING) {
-		struct ethtool_link_ksettings ksettings;
 		int remote_advertisement = 0;
 		int local_advertisement = 0;
 
@@ -988,18 +986,14 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
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




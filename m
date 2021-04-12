Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F76B35BD62
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbhDLIvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238020AbhDLIsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:48:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1826061279;
        Mon, 12 Apr 2021 08:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217275;
        bh=bJfR3G0c/1iZa+d8UgeqFhSPFQg+veg3k275rUoBN08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMLFmQEs1rZc26HdhzmFt/6k00f+k0klIzyempRBgxtXyTB6Pep3dP5leHqLcz03+
         0zL/eJJr+71kGtexjH17dkS6wT5aQwCHjQEzRhPeEny4Xfa8oml2fcr6s4tpSFwcvx
         YRl+qKAtmEHfI+TGLmKbmdhWCvM/vgm+/Gx477NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/111] net: phy: broadcom: Only advertise EEE for supported modes
Date:   Mon, 12 Apr 2021 10:40:45 +0200
Message-Id: <20210412084006.491220825@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c056d480b40a68f2520ccc156c7fae672d69d57d ]

We should not be advertising EEE for modes that we do not support,
correct that oversight by looking at the PHY device supported linkmodes.

Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm-phy-lib.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index e0d3310957ff..c99883120556 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -190,7 +190,7 @@ EXPORT_SYMBOL_GPL(bcm_phy_enable_apd);
 
 int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 {
-	int val;
+	int val, mask = 0;
 
 	/* Enable EEE at PHY level */
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, BRCM_CL45VEN_EEE_CONTROL);
@@ -209,10 +209,17 @@ int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 	if (val < 0)
 		return val;
 
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+			      phydev->supported))
+		mask |= MDIO_EEE_1000T;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			      phydev->supported))
+		mask |= MDIO_EEE_100TX;
+
 	if (enable)
-		val |= (MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val |= mask;
 	else
-		val &= ~(MDIO_EEE_100TX | MDIO_EEE_1000T);
+		val &= ~mask;
 
 	phy_write_mmd(phydev, MDIO_MMD_AN, BCM_CL45VEN_EEE_ADV, (u32)val);
 
-- 
2.30.2




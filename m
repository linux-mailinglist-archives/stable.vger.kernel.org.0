Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6355B360D67
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhDOPCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhDOO7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C40D7613EE;
        Thu, 15 Apr 2021 14:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498538;
        bh=D+TMlE0bVfus2t30ciHyN6PfYXCRJH+fAQ9WU9+t1hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEcIaL1tNDWXvNTM41CeEIn/S63+6+XCpmfml4/HpAPp4LdAcsk6kP45RmL8zLInb
         xN1l18nYT+yt3UOraNDDM4Rf8AlTDw1Mc6M5MJl4P58n/VOXE8tPC68567DK28iSEq
         MueI1ZeMxECI6exN1XxskMZvNCBaYO8Jd9HX7C18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 65/68] net: phy: broadcom: Only advertise EEE for supported modes
Date:   Thu, 15 Apr 2021 16:47:46 +0200
Message-Id: <20210415144416.609781223@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit c056d480b40a68f2520ccc156c7fae672d69d57d upstream

We should not be advertising EEE for modes that we do not support,
correct that oversight by looking at the PHY device supported linkmodes.

Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm-phy-lib.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index d5e0833d69b9..66e4ef8ed345 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL_GPL(bcm_phy_enable_apd);
 
 int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 {
-	int val;
+	int val, mask = 0;
 
 	/* Enable EEE at PHY level */
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, BRCM_CL45VEN_EEE_CONTROL);
@@ -217,10 +217,15 @@ int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 	if (val < 0)
 		return val;
 
+	if (phydev->supported & SUPPORTED_1000baseT_Full)
+		mask |= MDIO_EEE_1000T;
+	if (phydev->supported & SUPPORTED_100baseT_Full)
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




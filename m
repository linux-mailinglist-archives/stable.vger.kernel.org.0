Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44FB35B88E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbhDLCXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236613AbhDLCXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38A7961209;
        Mon, 12 Apr 2021 02:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194193;
        bh=WFs51tLDIZAoBvxKzfmu2NLa/+xHmjWS4yB6yCan+uU=;
        h=From:To:Cc:Subject:Date:From;
        b=vOZJnm4jRv1Y1wDX1a7zN86GOqrKOClO74m4ZyxXjTWQyesdl7mh+EMw1yC+TLfXz
         B4zr9/7Mx/+wA544KPJYDh7PuN8UKyw6naJdTZv+9YjF54BFiVcfIuPAvAyEMa0cSU
         lvfkl0R7NW2QeqGEumO9N67WR9E06hiVuSRNnIWdbFQmvc/UpKwW7ip4pZvvn5PjQ7
         P+xQFLsYs118yWDZumKE9rDBvG8CLqWny1tqgkMPgMqVMWGncNO8yPwXcxvnny2gaW
         Z6Utcl2D84lT8iZo6cfA8+maKwl3le2Gum4XVFMNkHgmmdbbRciYtQhiA0jf5VO5E9
         XKVsU8RSlz+6A==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, f.fainelli@gmail.com
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "net: phy: broadcom: Only advertise EEE for supported modes" failed to apply to 4.19-stable tree
Date:   Sun, 11 Apr 2021 22:23:12 -0400
Message-Id: <20210412022312.283964-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From c056d480b40a68f2520ccc156c7fae672d69d57d Mon Sep 17 00:00:00 2001
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 30 Mar 2021 15:00:24 -0700
Subject: [PATCH] net: phy: broadcom: Only advertise EEE for supported modes

We should not be advertising EEE for modes that we do not support,
correct that oversight by looking at the PHY device supported linkmodes.

Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/bcm-phy-lib.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index 53282a6d5928..287cccf8f7f4 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -369,7 +369,7 @@ EXPORT_SYMBOL_GPL(bcm_phy_enable_apd);
 
 int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
 {
-	int val;
+	int val, mask = 0;
 
 	/* Enable EEE at PHY level */
 	val = phy_read_mmd(phydev, MDIO_MMD_AN, BRCM_CL45VEN_EEE_CONTROL);
@@ -388,10 +388,17 @@ int bcm_phy_set_eee(struct phy_device *phydev, bool enable)
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





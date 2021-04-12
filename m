Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1F35B894
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhDLCXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236622AbhDLCXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 257AF6121E;
        Mon, 12 Apr 2021 02:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194206;
        bh=pdf6s8qKPJVUK70iiETT7IxPKnYfzv28yMTvUkabAXI=;
        h=From:To:Cc:Subject:Date:From;
        b=Z25VDzhMTbMjWk6ORXBzi9XzITIlmYVflMtAqDLeLD4gYXKiSj+UYGse8WdI6cMjy
         OsB6s0ap5RKunispqlCMzKhN6d995YhUVRGUoYKgYzB7JGNMKV+jlF3hid98TrxIVn
         X6yghvnpPyR2jWh/Xh1jsZhjY8eyxFpM94MeEmJrtbd4FNOSIZogmJDWcA7L3EQPP2
         LnB/OKHjzqQVVP1F1TiiyqiKjYhYV9PRJ+UcacY5JZctXzPvxOCKsxP9PFSpUcAkkQ
         Ly4KVlcUjherVa7/gDsHqBwdqdE7B2zwznDBRlPVQ9g+pBZlz5WZ3ftoDZmCAwmG0f
         or9g0zfrTzSWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, f.fainelli@gmail.com
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "net: phy: broadcom: Only advertise EEE for supported modes" failed to apply to 4.14-stable tree
Date:   Sun, 11 Apr 2021 22:23:25 -0400
Message-Id: <20210412022325.284395-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.14-stable tree.
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





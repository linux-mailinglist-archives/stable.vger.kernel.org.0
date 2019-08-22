Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA0B99A09
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390775AbfHVRJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388988AbfHVRJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:26 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCEB233FC;
        Thu, 22 Aug 2019 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493766;
        bh=uJ8/sfbdlDqAU12PFDiJWwX+LpQ0OAKi2RRJzveFS8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yp+KrW1aiAVgJaYFHjH3f/k4arr6dfNsqalYpoW0i9QDwSN7xc2O7BhaW5EO8L8V0
         5OG/8+4bpxjhEjzFJQFLAs/LmOpAKPyM48Bo5jWIOmxLyt1qKTU4AigbxY3FS2FdVF
         Abb3E0X+2ngc6rfvbu36sYe6KExiZqoKe6bDMIXo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 133/135] net: phy: consider AN_RESTART status when reading link status
Date:   Thu, 22 Aug 2019 13:08:09 -0400
Message-Id: <20190822170811.13303-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit c36757eb9dee13681227ad3676d37f14b3a2b2af ]

After configuring and restarting aneg we immediately try to read the
link status. On some systems the PHY may not yet have cleared the
"aneg complete" and "link up" bits, resulting in a false link-up
signal. See [0] for a report.
Clause 22 and 45 both require the PHY to keep the AN_RESTART
bit set until the PHY actually starts auto-negotiation.
Let's consider this in the generic functions for reading link status.
The commit marked as fixed is the first one where the patch applies
cleanly.

[0] https://marc.info/?t=156518400300003&r=1&w=2

Fixes: c1164bb1a631 ("net: phy: check PMAPMD link status only in genphy_c45_read_link")
Tested-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy-c45.c    | 14 ++++++++++++++
 drivers/net/phy/phy_device.c | 12 +++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index b9d4145781caa..58bb25e4af106 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -219,6 +219,20 @@ int genphy_c45_read_link(struct phy_device *phydev)
 	int val, devad;
 	bool link = true;
 
+	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
+		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
+		if (val < 0)
+			return val;
+
+		/* Autoneg is being started, therefore disregard current
+		 * link status and report link as down.
+		 */
+		if (val & MDIO_AN_CTRL1_RESTART) {
+			phydev->link = 0;
+			return 0;
+		}
+	}
+
 	while (mmd_mask && link) {
 		devad = __ffs(mmd_mask);
 		mmd_mask &= ~BIT(devad);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ffa402732aea8..3af0af495cf14 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1708,7 +1708,17 @@ EXPORT_SYMBOL(genphy_aneg_done);
  */
 int genphy_update_link(struct phy_device *phydev)
 {
-	int status;
+	int status = 0, bmcr;
+
+	bmcr = phy_read(phydev, MII_BMCR);
+	if (bmcr < 0)
+		return bmcr;
+
+	/* Autoneg is being started, therefore disregard BMSR value and
+	 * report link as down.
+	 */
+	if (bmcr & BMCR_ANRESTART)
+		goto done;
 
 	/* The link state is latched low so that momentary link
 	 * drops can be detected. Do not double-read the status
-- 
2.20.1


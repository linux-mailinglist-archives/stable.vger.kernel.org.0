Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3211112C740
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbfL2Rzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732924AbfL2Rza (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 506A42467C;
        Sun, 29 Dec 2019 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642129;
        bh=4Mzfrn2wNKIAI1Ihcb5rO6qINSLcOWz1XQG8/ZxA7cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avFHVqn8FtpDbNYZqI27eTJ2yUefxbA1UXY+Tah/ESUZoj4sBMurDjIOx+hZ63YEL
         RVdUsXwlGKAufuv7D0rVkUne0z6VI2wZqfVx3DRlZU0NWkrwH+o+8qHGi+y5E/jXvo
         y9vwl6rRHvEw+SR+S5xRQqtPN9iZxB83DLoR5cnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 327/434] net: phy: avoid matching all-ones clause 45 PHY IDs
Date:   Sun, 29 Dec 2019 18:26:20 +0100
Message-Id: <20191229172723.689874888@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit b95e86d846b63b02ecdc94802ddbeaf9005fb6d9 ]

We currently match clause 45 PHYs using any ID read from a MMD marked
as present in the "Devices in package" registers 5 and 6.  However,
this is incorrect.  45.2 says:

  "The definition of the term package is vendor specific and could be
   a chip, module, or other similar entity."

so a package could be more or less than the whole PHY - a PHY could be
made up of several modules instantiated onto a single chip such as the
Marvell 88x3310, or some of the MMDs could be disabled according to
chip configuration, such as the Broadcom 84881.

In the case of Broadcom 84881, the "Devices in package" registers
contain 0xc000009b, meaning that there is a PHYXS present in the
package, but all registers in MMD 4 return 0xffff.  This leads to our
matching code incorrectly binding this PHY to one of our generic PHY
drivers.

This patch changes the way we determine whether to attempt to match a
MMD identifier, or use it to request a module - if the identifier is
all-ones, then we skip over it. When reading the identifiers, we
initialise phydev->c45_ids.device_ids to all-ones, only reading the
device ID if the "Devices in package" registers indicates we should.

This avoids the generic drivers incorrectly matching on a PHY ID of
0xffffffff.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index adb66a2fae18..14c6b7597b06 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -488,7 +488,7 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 
 	if (phydev->is_c45) {
 		for (i = 1; i < num_ids; i++) {
-			if (!(phydev->c45_ids.devices_in_package & (1 << i)))
+			if (phydev->c45_ids.device_ids[i] == 0xffffffff)
 				continue;
 
 			if ((phydrv->phy_id & phydrv->phy_id_mask) ==
@@ -632,7 +632,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
 		int i;
 
 		for (i = 1; i < num_ids; i++) {
-			if (!(c45_ids->devices_in_package & (1 << i)))
+			if (c45_ids->device_ids[i] == 0xffffffff)
 				continue;
 
 			ret = phy_request_driver_module(dev,
@@ -812,10 +812,13 @@ static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
  */
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-	struct phy_c45_device_ids c45_ids = {0};
+	struct phy_c45_device_ids c45_ids;
 	u32 phy_id = 0;
 	int r;
 
+	c45_ids.devices_in_package = 0;
+	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
+
 	r = get_phy_id(bus, addr, &phy_id, is_c45, &c45_ids);
 	if (r)
 		return ERR_PTR(r);
-- 
2.20.1




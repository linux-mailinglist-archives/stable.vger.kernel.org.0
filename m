Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2A04095FB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347023AbhIMOql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347893AbhIMOoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511F563214;
        Mon, 13 Sep 2021 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541468;
        bh=x/T83cRhfcs7rqm0aNliY6nJnUf4flwgib6m3IqIFo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZHbVoxXh/Dudq7dr2j4M7iNEoeFO+3ct6VkFJBTw60gu4BH2dERrFmSfhzrFZOYv
         yzy05cF9JuAIU+4iX6WHBenBf5UebfFyCvQmhghssvkXVpmJND/A7XrW25IYfXdPmK
         x6QXWjVzYTN7GnoJXyoSnOQVOrXUhb0hGjzmTrMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 278/334] net: phy: marvell10g: fix broken PHY interrupts for anyone after us in the driver probe list
Date:   Mon, 13 Sep 2021 15:15:32 +0200
Message-Id: <20210913131122.822291284@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0d55649d2ad7296acfda9127e1d05518d025734a ]

Enabling interrupts via device tree for the internal PHYs on the
mv88e6390 DSA switch does not work. The driver insists to use poll mode.

Stage one debugging shows that the fwnode_mdiobus_phy_device_register
function calls fwnode_irq_get properly, and phy->irq is set to a valid
interrupt line initially.

But it is then cleared.

Stage two debugging shows that it is cleared here:

phy_probe:

  /* Disable the interrupt if the PHY doesn't support it
   * but the interrupt is still a valid one
   */
  if (!phy_drv_supports_irq(phydrv) && phy_interrupt_is_valid(phydev))
	phydev->irq = PHY_POLL;

Okay, so does the "Marvell 88E6390 Family" PHY driver not have the
.config_intr and .handle_interrupt function pointers? Yes it does.

Stage three debugging shows that the PHY device does not attempt a probe
against the "Marvell 88E6390 Family" driver, but against the "mv88x3310"
driver.

Okay, so why does the "mv88x3310" driver match on a mv88x6390 internal
PHY? The PHY IDs (MARVELL_PHY_ID_88E6390_FAMILY vs
MARVELL_PHY_ID_88X3310) are way different.

Stage four debugging has us looking through:

phy_device_register
-> device_add
   -> bus_probe_device
      -> device_initial_probe
         -> __device_attach
            -> bus_for_each_drv
               -> driver_match_device
                  -> drv->bus->match
                     -> phy_bus_match

Okay, so as we said, the MII_PHYSID1 of mv88e6390 does not match the
mv88x3310 driver's PHY mask & ID, so why would phy_bus_match return...

Ahh, phy_bus_match calls a shortcircuit method,
phydrv->match_phy_device, and does not even bother to compare the PHY ID
if that is implemented.

So of course, we go inside the marvell10g.c driver and sure enough, it
implements .match_phy_device and does not bother to check the PHY ID.

What's interesting though is that at the end of the device_add() from
phy_device_register(), the driver for the internal PHYs _is_ the proper
"Marvell 88E6390 Family". This is because "mv88x3310" ends up failing to
probe after all, and __device_attach_driver(), to quote:

  /*
   * Ignore errors returned by ->probe so that the next driver can try
   * its luck.
   */

The next (and only other) driver that matches is the 6390 driver. For
this one, phy_probe doesn't fail, and everything expects to work as
normal, EXCEPT phydev->irq has already been cleared by the previous
unsuccessful probe of a driver which did not implement PHY interrupts,
and therefore cleared that IRQ.

Okay, so it is not just Marvell 6390 that has PHY interrupts broken.
Stuff like Atheros, Aquantia, Broadcom, Qualcomm work because they are
lexicographically before Marvell, and stuff like NXP, Realtek, Vitesse
are broken.

This goes to show how fragile it is to reset phydev->irq = PHY_POLL from
the actual beginning of phy_probe itself. That seems like an actual bug
of its own too, since phy_probe has side effects which are not restored
on probe failure, but the line of thought probably was, the same driver
will attempt probe again, so it doesn't matter. Well, looks like it
does.

Maybe it would make more sense to move the phydev->irq clearing after
the actual device_add() in phy_device_register() completes, and the
bound driver is the actual final one.

(also, a bit frightening that drivers are permitted to bypass the MDIO
bus matching in such a trivial way and perform PHY reads and writes from
the .match_phy_device method, on devices that do not even belong to
them. In the general case it might not be guaranteed that the MDIO
accesses one driver needs to make to figure out whether to match on a
device is safe for all other PHY devices)

Fixes: a5de4be0aaaa ("net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210827132541.28953-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell10g.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 53a433442803..f4d758f8a1ee 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -987,11 +987,19 @@ static int mv3310_get_number_of_ports(struct phy_device *phydev)
 
 static int mv3310_match_phy_device(struct phy_device *phydev)
 {
+	if ((phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] &
+	     MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	return mv3310_get_number_of_ports(phydev) == 1;
 }
 
 static int mv3340_match_phy_device(struct phy_device *phydev)
 {
+	if ((phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] &
+	     MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88X3310)
+		return 0;
+
 	return mv3310_get_number_of_ports(phydev) == 4;
 }
 
-- 
2.30.2




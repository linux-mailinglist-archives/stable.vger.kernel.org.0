Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F2B18B754
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgCSNPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgCSNPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF15A20724;
        Thu, 19 Mar 2020 13:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623715;
        bh=lTJ/hevi2Fpxe8gohbznTq9UURuuyOF+S5hRr9kQW6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peCfvM1honIRGcQPPyRIo7p91tTabpKLgOeaqXdVN0K1i8cLb6esZlRxebq1ilRlA
         EzV4xuaT8X02N/2gH2DhwCGW8d9HVPP40dhSyjxxl2aEVRM1tMH8uaKw8Ag3M5axwP
         o2g8BhYR0VGPtmb6gCVkisIzJ8i6eh1h0ALaE5Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 28/99] net: phy: fix MDIO bus PM PHY resuming
Date:   Thu, 19 Mar 2020 14:03:06 +0100
Message-Id: <20200319123950.287587516@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 611d779af7cad2b87487ff58e4931a90c20b113c ]

So far we have the unfortunate situation that mdio_bus_phy_may_suspend()
is called in suspend AND resume path, assuming that function result is
the same. After the original change this is no longer the case,
resulting in broken resume as reported by Geert.

To fix this call mdio_bus_phy_may_suspend() in the suspend path only,
and let the phy_device store the info whether it was suspended by
MDIO bus PM.

Fixes: 503ba7c69610 ("net: phy: Avoid multiple suspends")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    6 +++++-
 include/linux/phy.h          |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -125,6 +125,8 @@ static int mdio_bus_phy_suspend(struct d
 	if (!mdio_bus_phy_may_suspend(phydev))
 		return 0;
 
+	phydev->suspended_by_mdio_bus = true;
+
 	return phy_suspend(phydev);
 }
 
@@ -133,9 +135,11 @@ static int mdio_bus_phy_resume(struct de
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
-	if (!mdio_bus_phy_may_suspend(phydev))
+	if (!phydev->suspended_by_mdio_bus)
 		goto no_resume;
 
+	phydev->suspended_by_mdio_bus = false;
+
 	ret = phy_resume(phydev);
 	if (ret < 0)
 		return ret;
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -372,6 +372,7 @@ struct phy_c45_device_ids {
  * is_pseudo_fixed_link: Set to true if this phy is an Ethernet switch, etc.
  * has_fixups: Set to true if this phy has fixups/quirks.
  * suspended: Set to true if this phy has been suspended successfully.
+ * suspended_by_mdio_bus: Set to true if this phy was suspended by MDIO bus.
  * sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
  * loopback_enabled: Set true if this phy has been loopbacked successfully.
  * state: state of the PHY for management purposes
@@ -410,6 +411,7 @@ struct phy_device {
 	bool is_pseudo_fixed_link;
 	bool has_fixups;
 	bool suspended;
+	bool suspended_by_mdio_bus;
 	bool sysfs_links;
 	bool loopback_enabled;
 



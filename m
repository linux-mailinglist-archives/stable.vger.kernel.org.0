Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C7D18B7D5
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgCSNKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbgCSNKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:10:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48262145D;
        Thu, 19 Mar 2020 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623448;
        bh=6UjSgcbQnk73zTfNrkP2gQ8Vocq5lCa1JwxxrhLwVlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzGYYUtAjn8S8kzhf2OE4mWVItcYqv+rQNo5V0+b+keSi0b+5knWks5t+Pgts70NV
         w/SA0GT1/xf+mt9vsEvV1hMo37E1nVZLPzoFrgh//W9CN/le1tKn6TUDDwPRHM0D5L
         QtjmoTEvB8r4wNhVPKpTMTpJAfG1JQF89qSqtcUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 30/90] net: phy: fix MDIO bus PM PHY resuming
Date:   Thu, 19 Mar 2020 13:59:52 +0100
Message-Id: <20200319123937.932178563@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
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
@@ -129,6 +129,8 @@ static int mdio_bus_phy_suspend(struct d
 	if (!mdio_bus_phy_may_suspend(phydev))
 		return 0;
 
+	phydev->suspended_by_mdio_bus = true;
+
 	return phy_suspend(phydev);
 }
 
@@ -137,9 +139,11 @@ static int mdio_bus_phy_resume(struct de
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
@@ -333,6 +333,7 @@ struct phy_c45_device_ids {
  * is_pseudo_fixed_link: Set to true if this phy is an Ethernet switch, etc.
  * has_fixups: Set to true if this phy has fixups/quirks.
  * suspended: Set to true if this phy has been suspended successfully.
+ * suspended_by_mdio_bus: Set to true if this phy was suspended by MDIO bus.
  * state: state of the PHY for management purposes
  * dev_flags: Device-specific flags used by the PHY driver.
  * link_timeout: The number of timer firings to wait before the
@@ -369,6 +370,7 @@ struct phy_device {
 	bool is_pseudo_fixed_link;
 	bool has_fixups;
 	bool suspended;
+	bool suspended_by_mdio_bus;
 
 	enum phy_state state;
 



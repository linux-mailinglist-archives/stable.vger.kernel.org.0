Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C37C18B74F
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgCSNOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgCSNOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9362221556;
        Thu, 19 Mar 2020 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623686;
        bh=DqO9/iv8SausIf0ErNujnvWT67yrgKL8xbrVoJGk0T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0NHZrkqyWc6tuhnhGHvD6VcoYczQ/eM9kkSXbFm3h6xDeX34KiK/CWTQIIyPUN9S
         OmyLvtJiUYrghkx/NZdqvYn1cSGEKv1717B0ogGUtv8JldF3f633FAlmE9KfgWOPK6
         TBNXwMzJnPmQ5Ru7brIXQwHemcmp9MNzkKQnVtIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 02/99] net: phy: Avoid multiple suspends
Date:   Thu, 19 Mar 2020 14:02:40 +0100
Message-Id: <20200319123942.261617076@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

commit 503ba7c6961034ff0047707685644cad9287c226 upstream.

It is currently possible for a PHY device to be suspended as part of a
network device driver's suspend call while it is still being attached to
that net_device, either via phy_suspend() or implicitly via phy_stop().

Later on, when the MDIO bus controller get suspended, we would attempt
to suspend again the PHY because it is still attached to a network
device.

This is both a waste of time and creates an opportunity for improper
clock/power management bugs to creep in.

Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/phy_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -91,7 +91,7 @@ static bool mdio_bus_phy_may_suspend(str
 	 * MDIO bus driver and clock gated at this point.
 	 */
 	if (!netdev)
-		return !phydev->suspended;
+		goto out;
 
 	/* Don't suspend PHY if the attached netdev parent may wakeup.
 	 * The parent may point to a PCI device, as in tg3 driver.
@@ -106,7 +106,8 @@ static bool mdio_bus_phy_may_suspend(str
 	if (device_may_wakeup(&netdev->dev))
 		return false;
 
-	return true;
+out:
+	return !phydev->suspended;
 }
 
 static int mdio_bus_phy_suspend(struct device *dev)



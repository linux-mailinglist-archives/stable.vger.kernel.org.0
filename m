Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C8927C455
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgI2LNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbgI2LMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:12:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70722158C;
        Tue, 29 Sep 2020 11:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377960;
        bh=UxunQbslXvAqscfRlbbOD5E44laN1yYyIwyWDa3PMIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUlsh2FWHnFGO3iXFbzZ4oa/YRhbUHSO8U0gVxIh3m8owFKEEKYWnOr8tIw273oie
         V0W0EjJ/sZxIpHHdRPBAJFTBzd6DodOhNoAjT5niJHkISaU80t/J08dxHC3obIXdwL
         yGiQVzcwHBzPO6qNiWBNwjT+UCQoRO1Cu7LkVCu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 013/166] net: phy: Avoid NPD upon phy_detach() when driver is unbound
Date:   Tue, 29 Sep 2020 12:58:45 +0200
Message-Id: <20200929105935.850984691@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c2b727df7caa33876e7066bde090f40001b6d643 ]

If we have unbound the PHY driver prior to calling phy_detach() (often
via phy_disconnect()) then we can cause a NULL pointer de-reference
accessing the driver owner member. The steps to reproduce are:

echo unimac-mdio-0:01 > /sys/class/net/eth0/phydev/driver/unbind
ip link set eth0 down

Fixes: cafe8df8b9bc ("net: phy: Fix lack of reference count on PHY driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1121,7 +1121,8 @@ void phy_detach(struct phy_device *phyde
 
 	phy_led_triggers_unregister(phydev);
 
-	module_put(phydev->mdio.dev.driver->owner);
+	if (phydev->mdio.dev.driver)
+		module_put(phydev->mdio.dev.driver->owner);
 
 	/* If the device had no specific driver before (i.e. - it
 	 * was using the generic driver), we unbind the device



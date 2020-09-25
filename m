Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A742787D7
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgIYMvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgIYMu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D65202075E;
        Fri, 25 Sep 2020 12:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038258;
        bh=y+GQbXTaidAAY0N1sPQ/gYgts01Bp6ydqL0LMW4IpvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRpGML6o5h7PwsOriBWoLjdwILPMxsKO9sZRnRqlATzDIIYB5fhXPQCco/p0nPusF
         ohhS6Oisg+xWuKRx4Vrh0B8alwDBNnofl8cd9HFDq2fcaawDLZ5oFL/ibRLHVKPswO
         TlTlbnYxme9Z7sKdka3TFf840i4ARz8q4by8GN2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 39/56] net: phy: Avoid NPD upon phy_detach() when driver is unbound
Date:   Fri, 25 Sep 2020 14:48:29 +0200
Message-Id: <20200925124733.718921386@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
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
@@ -1631,7 +1631,8 @@ void phy_detach(struct phy_device *phyde
 
 	phy_led_triggers_unregister(phydev);
 
-	module_put(phydev->mdio.dev.driver->owner);
+	if (phydev->mdio.dev.driver)
+		module_put(phydev->mdio.dev.driver->owner);
 
 	/* If the device had no specific driver before (i.e. - it
 	 * was using the generic driver), we unbind the device



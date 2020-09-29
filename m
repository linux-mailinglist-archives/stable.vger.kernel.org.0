Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199E127C39F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgI2LHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbgI2LGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82491221EF;
        Tue, 29 Sep 2020 11:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377614;
        bh=rFxmEVQR9wP/72O/0BiaSDmF96l1Q0UFY45Hj8vFi9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwFPYd5eT3GdrKKmmcuLcrGIDZk2iYLVDPwQDlE7MRx7gY0xHfU3TsTzPvVay0YHI
         UcQaH/TAICrQ2ssc2tw11MVjQX6h57TwVrv6vocUpDH0xfZtM4nWdwgULP/AmE3Q6k
         A8hEjwR3bIdKb7oIosAD9Q2myFEriOXSLtFFErmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 010/121] net: phy: Avoid NPD upon phy_detach() when driver is unbound
Date:   Tue, 29 Sep 2020 12:59:14 +0200
Message-Id: <20200929105930.696434798@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
@@ -1013,7 +1013,8 @@ void phy_detach(struct phy_device *phyde
 	phydev->attached_dev = NULL;
 	phy_suspend(phydev);
 
-	module_put(phydev->mdio.dev.driver->owner);
+	if (phydev->mdio.dev.driver)
+		module_put(phydev->mdio.dev.driver->owner);
 
 	/* If the device had no specific driver before (i.e. - it
 	 * was using the generic driver), we unbind the device



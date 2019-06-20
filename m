Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E724D7FC
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfFTSVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfFTSML (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:12:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3128B2082C;
        Thu, 20 Jun 2019 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054330;
        bh=7JGQuOrvcmw+F3qIhdXalM05EVaBfo4bHhekHH3nPUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdoSbGlzKCFXBMBnM/3OaKNXgq1HvUzz6loz6MSw9YmXBbMdJiBkMN30gNsO7mY2z
         g2UxrHoJm3NSlv/TS+YlekcCAdXh/icD2W/hF1OM6hqWitt4csQH2dwT63tB5T5aha
         UHHi3vsLBWYshKA7CrMxMqOlPzcxKlp9ScxKDrzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Uvarov <muvarov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/61] net: phy: dp83867: Set up RGMII TX delay
Date:   Thu, 20 Jun 2019 19:57:48 +0200
Message-Id: <20190620174346.433171819@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2b892649254fec01678c64f16427622b41fa27f4 ]

PHY_INTERFACE_MODE_RGMII_RXID is less then TXID
so code to set tx delay is never called.

Fixes: 2a10154abcb75 ("net: phy: dp83867: Add TI dp83867 phy")
Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index b3935778b19f..e4bf9e7d7583 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -260,10 +260,8 @@ static int dp83867_config_init(struct phy_device *phydev)
 		ret = phy_write(phydev, MII_DP83867_PHYCTRL, val);
 		if (ret)
 			return ret;
-	}
 
-	if ((phydev->interface >= PHY_INTERFACE_MODE_RGMII_ID) &&
-	    (phydev->interface <= PHY_INTERFACE_MODE_RGMII_RXID)) {
+		/* Set up RGMII delays */
 		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIICTL);
 
 		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE90312C5EF
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbfL2RmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730265AbfL2RmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33AA721744;
        Sun, 29 Dec 2019 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641333;
        bh=I6zI39l6Sk+6XVLTpSxrMkQlRx8BuEn9+5eZRkxxKH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5Oq+QX/eaYbdjrGCvBa7X6RbK4vhaQBip9lBcSiwO0yAPl1VV6XdxPqDazAIuv+M
         2XVSU3IhTKj9e1PmGKIICrRqkXTbzkzQ3vyximQ4/u6FwI3rHmvg9nwW7OfLt7u8Wx
         mbeWdECak5ru8mEylfGW51JO6VwUvA+gwOS00nu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 008/434] net: phy: ensure that phy IDs are correctly typed
Date:   Sun, 29 Dec 2019 18:21:01 +0100
Message-Id: <20191229172702.855371602@linuxfoundation.org>
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

[ Upstream commit 7d49a32a66d2215c5b3bf9bc67c9036ea9904111 ]

PHY IDs are 32-bit unsigned quantities. Ensure that they are always
treated as such, and not passed around as "int"s.

Fixes: 13d0ab6750b2 ("net: phy: check return code when requesting PHY driver module")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    8 ++++----
 include/linux/phy.h          |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -552,7 +552,7 @@ static const struct device_type mdio_bus
 	.pm = MDIO_BUS_PHY_PM_OPS,
 };
 
-static int phy_request_driver_module(struct phy_device *dev, int phy_id)
+static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 {
 	int ret;
 
@@ -564,15 +564,15 @@ static int phy_request_driver_module(str
 	 * then modprobe isn't available.
 	 */
 	if (IS_ENABLED(CONFIG_MODULES) && ret < 0 && ret != -ENOENT) {
-		phydev_err(dev, "error %d loading PHY driver module for ID 0x%08x\n",
-			   ret, phy_id);
+		phydev_err(dev, "error %d loading PHY driver module for ID 0x%08lx\n",
+			   ret, (unsigned long)phy_id);
 		return ret;
 	}
 
 	return 0;
 }
 
-struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
+struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids)
 {
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -993,7 +993,7 @@ int phy_modify_paged_changed(struct phy_
 int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
 		     u16 mask, u16 set);
 
-struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
+struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)



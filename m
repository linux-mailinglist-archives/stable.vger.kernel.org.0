Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D206D12C419
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfL2R0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbfL2R0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E33EA207FF;
        Sun, 29 Dec 2019 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640380;
        bh=QLSXoaU+EitGCTeCJX2uXYUbAWclxZysmq/yrb3//AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1ktnjLNxjTcT4QAJHdnK59xItBXW/Vdg5hKqJ6338L5C/OM+hwz/zQpbK4aI9vGq
         K4CSruhXRiBwZNisHT10tirLi0YNokD1KhBKE+lHATGEm7CW05rHpgtxUVCOlcGKUR
         f47PurbHoozVTnG+e4nUg/zrOX5b/7ejq/6W0X7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 135/161] net: phy: initialise phydev speed and duplex sanely
Date:   Sun, 29 Dec 2019 18:19:43 +0100
Message-Id: <20191229162439.561110593@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit a5d66f810061e2dd70fb7a108dcd14e535bc639f ]

When a phydev is created, the speed and duplex are set to zero and
-1 respectively, rather than using the predefined SPEED_UNKNOWN and
DUPLEX_UNKNOWN constants.

There is a window at initialisation time where we may report link
down using the 0/-1 values.  Tidy this up and use the predefined
constants, so debug doesn't complain with:

"Unsupported (update phy-core.c)/Unsupported (update phy-core.c)"

when the speed and duplex settings are printed.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ed7e3c70b511..a98c227a4c2e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -367,8 +367,8 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
 	mdiodev->device_free = phy_mdio_device_free;
 	mdiodev->device_remove = phy_mdio_device_remove;
 
-	dev->speed = 0;
-	dev->duplex = -1;
+	dev->speed = SPEED_UNKNOWN;
+	dev->duplex = DUPLEX_UNKNOWN;
 	dev->pause = 0;
 	dev->asym_pause = 0;
 	dev->link = 1;
-- 
2.20.1




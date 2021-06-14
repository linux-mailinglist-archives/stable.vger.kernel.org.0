Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8563A60CB
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhFNKh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhFNKgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:36:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE26261403;
        Mon, 14 Jun 2021 10:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666769;
        bh=OduFFxGahl0LqRAzegpmCRYK1Csic7OHYh/+II9U6o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlD2fMu4ITipPVl9Z0onp5YTiMGhyNeZwkLnuARogJ131xTuF3YLX3EK7HKCrCJQ1
         ySjM+LkMuXZ/9uS0Pv6w026hVRDFPWKu618F7HlhuTlmx7yyK+CjDOK/wFx7F1ksmv
         5xggGEBM2VhMHTqr1SKl1yaxZ3FLmDK4r/csxuB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/49] net: mdiobus: get rid of a BUG_ON()
Date:   Mon, 14 Jun 2021 12:27:00 +0200
Message-Id: <20210614102642.101164531@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1dde47a66d4fb181830d6fa000e5ea86907b639e ]

We spotted a bug recently during a review where a driver was
unregistering a bus that wasn't registered, which would trigger this
BUG_ON().  Let's handle that situation more gracefully, and just print
a warning and return.

Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c545fb1f82bd..5fc7b6c1a442 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -412,7 +412,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	struct mdio_device *mdiodev;
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2




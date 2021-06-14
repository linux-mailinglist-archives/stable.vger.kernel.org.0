Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F5A3A6082
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhFNKfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhFNKdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D19D611C1;
        Mon, 14 Jun 2021 10:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666685;
        bh=v/zXBpze0qVz5SNggLiUZSwQ8Z80KlcQCzMin2Dijwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4nWwAzcQsC7NvWYA6xX7sFc+ETsNWD9LDqB9kN8mOmkxBoQCHZw8IdCRMagufaox
         ueJUGIdvVgTbobqZpgFzgIsDGj8/kgUgRegz3sdCIv0Cx7u/92OdlhIKNoMSw070ro
         LYQhBiQhZbnzWGboq2FMZKu2XnV/H90OWFPSeMdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/42] net: mdiobus: get rid of a BUG_ON()
Date:   Mon, 14 Jun 2021 12:26:58 +0200
Message-Id: <20210614102642.939885834@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102642.700712386@linuxfoundation.org>
References: <20210614102642.700712386@linuxfoundation.org>
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
index a9bbdcec0bad..8cc7563ab103 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -362,7 +362,8 @@ void mdiobus_unregister(struct mii_bus *bus)
 	struct mdio_device *mdiodev;
 	int i;
 
-	BUG_ON(bus->state != MDIOBUS_REGISTERED);
+	if (WARN_ON_ONCE(bus->state != MDIOBUS_REGISTERED))
+		return;
 	bus->state = MDIOBUS_UNREGISTERED;
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
-- 
2.30.2




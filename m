Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B303F65E8
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhHXRSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237916AbhHXRQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:16:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17EB61AA7;
        Tue, 24 Aug 2021 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824508;
        bh=c6UOVEcLzK/fQL941pQHu4b3XY4b67aszf/JywBfVts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOBfJFvEc7viL5l6/vrejK0z2Vzld75Ib2YoscDJ0iesbibTOHkHE8QCiF3IYIG2M
         2MuzcqlsddP9zKGv7ozAhoADlMs19PBz2/rSOJkt+xUp8s4HIiMoGpe2vbcLHzLK2c
         eiIBjujavy1FHbXxN6BIuUCh8vkwYSe/SpD0diPSxM8EFOOBS1Ifs5PXe+BnWYNySJ
         +vcsUvOxcZ2KfqiCT3UzBwNQ0GkqBVY/UE9LXzbvoPfc78xi6n9HqIJZMEJOyeFi6Y
         5PKWDf8H+yTSWHvxJC4RQTW+EPkN3KmLIaRZAydKBmStXfGjN4+mwgEFSdeor7swU4
         F7mYaPFmS8Ulg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/61] net: mdio-mux: Handle -EPROBE_DEFER correctly
Date:   Tue, 24 Aug 2021 13:00:46 -0400
Message-Id: <20210824170106.710221-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 7bd0cef5dac685f09ef8b0b2a7748ff42d284dc7 ]

When registering mdiobus children, if we get an -EPROBE_DEFER, we shouldn't
ignore it and continue registering the rest of the mdiobus children. This
would permanently prevent the deferring child mdiobus from working instead
of reattempting it in the future. So, if a child mdiobus needs to be
reattempted in the future, defer the entire mdio-mux initialization.

This fixes the issue where PHYs sitting under the mdio-mux aren't
initialized correctly if the PHY's interrupt controller is not yet ready
when the mdio-mux is being probed. Additional context in the link below.

Fixes: 0ca2997d1452 ("netdev/of/phy: Add MDIO bus multiplexer support.")
Link: https://lore.kernel.org/lkml/CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com/#t
Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio-mux.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio-mux.c b/drivers/net/phy/mdio-mux.c
index c96ef3b3fa3a..ccb3ee704eb1 100644
--- a/drivers/net/phy/mdio-mux.c
+++ b/drivers/net/phy/mdio-mux.c
@@ -175,11 +175,15 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus->write = mdio_mux_write;
 		r = of_mdiobus_register(cb->mii_bus, child_bus_node);
 		if (r) {
+			mdiobus_free(cb->mii_bus);
+			if (r == -EPROBE_DEFER) {
+				ret_val = r;
+				goto err_loop;
+			}
+			devm_kfree(dev, cb);
 			dev_err(dev,
 				"Error: Failed to register MDIO bus for child %pOF\n",
 				child_bus_node);
-			mdiobus_free(cb->mii_bus);
-			devm_kfree(dev, cb);
 		} else {
 			cb->next = pb->children;
 			pb->children = cb;
-- 
2.30.2


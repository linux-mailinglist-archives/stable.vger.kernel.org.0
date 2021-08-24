Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F203F63F9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhHXRAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235000AbhHXQ6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6955613B1;
        Tue, 24 Aug 2021 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824234;
        bh=EwT0B2S1XgskTufYh5xi7N7TyU/h3WjAGvHnXhoS3f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQyVJRrUczX4IIBhic3sI/sXW/nVq3CMXJ+c2ORjiged2CF8zsdwSAaGQRazVtkvx
         IuFaju4+h0pBCYGzBRzwgD6GCy0PKU4FAj/W2n+F4SMMMr8PHMh0+caLS2FhA35l5o
         oG/vduA6CZ8vFon3mwAMqSpou3UboUCDky9ai9ycn3pwPdqcmIulWKSHmyB02Z+Plq
         AUT8nQAM1bE8EdWxQDZVFnG66AnO1vLnQWIADt7+cMvvkCOCLY0KFuDuKks+h8M0bw
         b6Tv+DU3F8JwObVep1kAyyVDY8mGw8HbTf6NI1L1hTOe3OzoEsXq+bO8hkq0Ir5Mv2
         bB4uMFkpV3T3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 067/127] net: mdio-mux: Handle -EPROBE_DEFER correctly
Date:   Tue, 24 Aug 2021 12:55:07 -0400
Message-Id: <20210824165607.709387-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
 drivers/net/mdio/mdio-mux.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index d6ed9033339c..3dde0c2b3e09 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
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


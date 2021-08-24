Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0969A3F66B1
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbhHXR0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241384AbhHXRYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:24:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A65D761B2A;
        Tue, 24 Aug 2021 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824637;
        bh=h+YeNfH66MeNb6WUgwhqBZ4WAHXSEvz0AE0irN4zS/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuOF4Lzyb2bRm4pD6VPLmSzrF7n7H9rEd5X3J+0cROHjqfDUnyALgvaMNS+Ls4fL8
         nIPHyJwvgcjr/wbsgbXm+vx99poNAg9SpD81opB4D7flUhY7bSk7z3EOe/JtdHaMh1
         L+gWnEAfdju91i3Zcx+IBpNtXLGFP15Sw454jVqNLrw52uU2X51/xgVwugJQONVHrK
         SVN2Gp5gwXT4mJH1mDWcloWLfNRnwo+thoMCwzYnf7frNV1eni27xHT2UxHAXw6MEZ
         ryQrRpaC9ib5fWOaHtEVxzkv/sK0t8kAOtxgVV8ioEO04IOkXX/v2BFQifwDcY0rN4
         Agu/1qNmpZInQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 68/84] net: mdio-mux: Don't ignore memory allocation errors
Date:   Tue, 24 Aug 2021 13:02:34 -0400
Message-Id: <20210824170250.710392-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 99d81e942474cc7677d12f673f42a7ea699e2589 ]

If we are seeing memory allocation errors, don't try to continue
registering child mdiobus devices. It's unlikely they'll succeed.

Fixes: 342fa1964439 ("mdio: mux: make child bus walking more permissive and errors more verbose")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio-mux.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/mdio-mux.c b/drivers/net/phy/mdio-mux.c
index 0a86f1e4c02f..bb7e3f12a003 100644
--- a/drivers/net/phy/mdio-mux.c
+++ b/drivers/net/phy/mdio-mux.c
@@ -85,6 +85,17 @@ out:
 
 static int parent_count;
 
+static void mdio_mux_uninit_children(struct mdio_mux_parent_bus *pb)
+{
+	struct mdio_mux_child_bus *cb = pb->children;
+
+	while (cb) {
+		mdiobus_unregister(cb->mii_bus);
+		mdiobus_free(cb->mii_bus);
+		cb = cb->next;
+	}
+}
+
 int mdio_mux_init(struct device *dev,
 		  struct device_node *mux_node,
 		  int (*switch_fn)(int cur, int desired, void *data),
@@ -147,7 +158,7 @@ int mdio_mux_init(struct device *dev,
 		cb = devm_kzalloc(dev, sizeof(*cb), GFP_KERNEL);
 		if (!cb) {
 			ret_val = -ENOMEM;
-			continue;
+			goto err_loop;
 		}
 		cb->bus_number = v;
 		cb->parent = pb;
@@ -155,8 +166,7 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus = mdiobus_alloc();
 		if (!cb->mii_bus) {
 			ret_val = -ENOMEM;
-			devm_kfree(dev, cb);
-			continue;
+			goto err_loop;
 		}
 		cb->mii_bus->priv = cb;
 
@@ -185,6 +195,10 @@ int mdio_mux_init(struct device *dev,
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
 	devm_kfree(dev, pb);
+
+err_loop:
+	mdio_mux_uninit_children(pb);
+	of_node_put(child_bus_node);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
@@ -196,14 +210,8 @@ EXPORT_SYMBOL_GPL(mdio_mux_init);
 void mdio_mux_uninit(void *mux_handle)
 {
 	struct mdio_mux_parent_bus *pb = mux_handle;
-	struct mdio_mux_child_bus *cb = pb->children;
-
-	while (cb) {
-		mdiobus_unregister(cb->mii_bus);
-		mdiobus_free(cb->mii_bus);
-		cb = cb->next;
-	}
 
+	mdio_mux_uninit_children(pb);
 	put_device(&pb->mii_bus->dev);
 }
 EXPORT_SYMBOL_GPL(mdio_mux_uninit);
-- 
2.30.2


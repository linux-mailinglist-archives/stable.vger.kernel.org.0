Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF97F3F65E2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238992AbhHXRRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239986AbhHXRPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADEE961A8C;
        Tue, 24 Aug 2021 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824507;
        bh=pPm7qFIa8uFuzH1Z2KuX4Sxkam7n7y9z9FcSM0jIv4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzcKgLBhqDmT9EnGY6vy3cMO9INj3dBG3WklP8QAK27LnZS242Rie6zwHwRKl8Cjy
         Z+dC8WKJwtpyVlQcuaZCv/ZC4zk99WEXWEM5lZHdAeb9+3ORRfBZWQ4L3V4xJZUgJ/
         14BUF4pgyRlQmOFA739wS3B57shc4MSafrTxjokAsf+phMz0UQErPic3XS7yKIcBGc
         xB0dfGY2G7V1Tv/4+RsAtKLEhFWADtmwla3A0ufsFRB08vTpPm66JLusNe+jdNI3sx
         nfK/cb+GPzhGmKkVgFN8znP/nGL7gSxqj4duMGZO4kyTjixaFDdzb3yAYq6PrcytgG
         KhIGIpfA+wvcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/61] net: mdio-mux: Don't ignore memory allocation errors
Date:   Tue, 24 Aug 2021 13:00:45 -0400
Message-Id: <20210824170106.710221-41-sashal@kernel.org>
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
index 6a1d3540210b..c96ef3b3fa3a 100644
--- a/drivers/net/phy/mdio-mux.c
+++ b/drivers/net/phy/mdio-mux.c
@@ -82,6 +82,17 @@ out:
 
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
@@ -144,7 +155,7 @@ int mdio_mux_init(struct device *dev,
 		cb = devm_kzalloc(dev, sizeof(*cb), GFP_KERNEL);
 		if (!cb) {
 			ret_val = -ENOMEM;
-			continue;
+			goto err_loop;
 		}
 		cb->bus_number = v;
 		cb->parent = pb;
@@ -152,8 +163,7 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus = mdiobus_alloc();
 		if (!cb->mii_bus) {
 			ret_val = -ENOMEM;
-			devm_kfree(dev, cb);
-			continue;
+			goto err_loop;
 		}
 		cb->mii_bus->priv = cb;
 
@@ -182,6 +192,10 @@ int mdio_mux_init(struct device *dev,
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
 	devm_kfree(dev, pb);
+
+err_loop:
+	mdio_mux_uninit_children(pb);
+	of_node_put(child_bus_node);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
@@ -193,14 +207,8 @@ EXPORT_SYMBOL_GPL(mdio_mux_init);
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


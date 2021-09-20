Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392A041256F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350010AbhITSpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382801AbhITSmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC2C61501;
        Mon, 20 Sep 2021 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159116;
        bh=Di7UY+cfXsOr+OyDEehos6xzazNzv8QpkITODh5AWd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdUMEdl4pC1Bq0r4Bk58yHtx7buVqiRQXhBdt8JDbMPxvMIKpeUUYi/L+SXaayJtZ
         AJFUebWV7c6ExsDS9CR4RWRjahU/qyK5OVh5pHqqC3VkkGJC7PsVNAqRCZZJ0xZ6Ju
         VZ3zq1y4ngWl2LZFtbFTp02fI48XKSAMQvSvMfYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 083/168] net: dsa: qca8k: fix kernel panic with legacy mdio mapping
Date:   Mon, 20 Sep 2021 18:43:41 +0200
Message-Id: <20210920163924.366027280@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit ce062a0adbfe933b1932235fdfd874c4c91d1bb0 ]

When the mdio legacy mapping is used the mii_bus priv registered by DSA
refer to the dsa switch struct instead of the qca8k_priv struct and
causes a kernel panic. Create dedicated function when the internal
dedicated mdio driver is used to properly handle the 2 different
implementation.

Fixes: 759bafb8a322 ("net: dsa: qca8k: add support for internal phy and internal mdio")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca8k.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1f63f50f73f1..bda5a9bf4f52 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -643,10 +643,8 @@ qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 }
 
 static int
-qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
+qca8k_mdio_write(struct mii_bus *bus, int phy, int regnum, u16 data)
 {
-	struct qca8k_priv *priv = salve_bus->priv;
-	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -682,10 +680,8 @@ exit:
 }
 
 static int
-qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
+qca8k_mdio_read(struct mii_bus *bus, int phy, int regnum)
 {
-	struct qca8k_priv *priv = salve_bus->priv;
-	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
@@ -726,6 +722,24 @@ exit:
 	return ret;
 }
 
+static int
+qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 data)
+{
+	struct qca8k_priv *priv = slave_bus->priv;
+	struct mii_bus *bus = priv->bus;
+
+	return qca8k_mdio_write(bus, phy, regnum, data);
+}
+
+static int
+qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
+{
+	struct qca8k_priv *priv = slave_bus->priv;
+	struct mii_bus *bus = priv->bus;
+
+	return qca8k_mdio_read(bus, phy, regnum);
+}
+
 static int
 qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
@@ -775,8 +789,8 @@ qca8k_mdio_register(struct qca8k_priv *priv, struct device_node *mdio)
 
 	bus->priv = (void *)priv;
 	bus->name = "qca8k slave mii";
-	bus->read = qca8k_mdio_read;
-	bus->write = qca8k_mdio_write;
+	bus->read = qca8k_internal_mdio_read;
+	bus->write = qca8k_internal_mdio_write;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d",
 		 ds->index);
 
-- 
2.30.2




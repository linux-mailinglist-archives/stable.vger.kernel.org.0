Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F322F1E5
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbgG0OfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729546AbgG0OPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:15:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D918E2073E;
        Mon, 27 Jul 2020 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859302;
        bh=uRkdKpOKc6DURCEGWHEF4JkRyIvCDu5bJ9vbFOCZPrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLF4vC6mGc3yIyyXZDmzPeKD7R/lsT3MWkL6ZqO+Mie/mbXFfd6Ws+VdMDTluuMME
         FrmjU0UkuL3TI4QANnt4GuJeUYa8iRz+3pnOq4zmwDtAZv8mDxnEABVy16kBfjbZt+
         DplCH7uD4qkl7o4M5tqqFNc1g9BrSB+Yl9thbvt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helmut Grohne <helmut.grohne@intenta.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/138] net: dsa: microchip: call phy_remove_link_mode during probe
Date:   Mon, 27 Jul 2020 16:04:10 +0200
Message-Id: <20200727134928.104718012@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>

[ Upstream commit 3506b2f42dff66ea6814c3dfa1988bafb79e6f88 ]

When doing "ip link set dev ... up" for a ksz9477 backed link,
ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
called. Doing so reverts any previous change to advertised link modes
e.g. using a udevd .link file.

phy_remove_link_mode is not meant to be used while opening a link and
should be called during phy probe when the link is not yet available to
userspace.

Therefore move the phy_remove_link_mode calls into
ksz9477_switch_register. It indirectly calls dsa_register_switch, which
creates the relevant struct phy_devices and we update the link modes
right after that. At that time dev->features is already initialized by
ksz9477_switch_detect.

Remove phy_setup from ksz_dev_ops as no users remain.

Link: https://lore.kernel.org/netdev/20200715192722.GD1256692@lunn.ch/
Fixes: 42fc6a4c613019 ("net: dsa: microchip: prepare PHY for proper advertisement")
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c    | 42 ++++++++++++++------------
 drivers/net/dsa/microchip/ksz_common.c |  2 --
 drivers/net/dsa/microchip/ksz_common.h |  2 --
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index f600874e24763..b15da9a8e3bb9 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -976,23 +976,6 @@ static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
-static void ksz9477_phy_setup(struct ksz_device *dev, int port,
-			      struct phy_device *phy)
-{
-	/* Only apply to port with PHY. */
-	if (port >= dev->phy_port_cnt)
-		return;
-
-	/* The MAC actually cannot run in 1000 half-duplex mode. */
-	phy_remove_link_mode(phy,
-			     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-
-	/* PHY does not support gigabit. */
-	if (!(dev->features & GBIT_SUPPORT))
-		phy_remove_link_mode(phy,
-				     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
-}
-
 static bool ksz9477_get_gbit(struct ksz_device *dev, u8 data)
 {
 	bool gbit;
@@ -1605,7 +1588,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.get_port_addr = ksz9477_get_port_addr,
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
-	.phy_setup = ksz9477_phy_setup,
 	.port_setup = ksz9477_port_setup,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
@@ -1619,7 +1601,29 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 
 int ksz9477_switch_register(struct ksz_device *dev)
 {
-	return ksz_switch_register(dev, &ksz9477_dev_ops);
+	int ret, i;
+	struct phy_device *phydev;
+
+	ret = ksz_switch_register(dev, &ksz9477_dev_ops);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < dev->phy_port_cnt; ++i) {
+		if (!dsa_is_user_port(dev->ds, i))
+			continue;
+
+		phydev = dsa_to_port(dev->ds, i)->slave->phydev;
+
+		/* The MAC actually cannot run in 1000 half-duplex mode. */
+		phy_remove_link_mode(phydev,
+				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+
+		/* PHY does not support gigabit. */
+		if (!(dev->features & GBIT_SUPPORT))
+			phy_remove_link_mode(phydev,
+					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
+	}
+	return ret;
 }
 EXPORT_SYMBOL(ksz9477_switch_register);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fe47180c908b9..7fabc0e3d807a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -366,8 +366,6 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 
 	/* setup slave port */
 	dev->dev_ops->port_setup(dev, port, false);
-	if (dev->dev_ops->phy_setup)
-		dev->dev_ops->phy_setup(dev, port, phy);
 
 	/* port_stp_state_set() will be called after to enable the port so
 	 * there is no need to do anything.
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a20ebb749377c..061142b183cb9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -120,8 +120,6 @@ struct ksz_dev_ops {
 	u32 (*get_port_addr)(int port, int offset);
 	void (*cfg_port_member)(struct ksz_device *dev, int port, u8 member);
 	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
-	void (*phy_setup)(struct ksz_device *dev, int port,
-			  struct phy_device *phy);
 	void (*port_cleanup)(struct ksz_device *dev, int port);
 	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
 	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
-- 
2.25.1




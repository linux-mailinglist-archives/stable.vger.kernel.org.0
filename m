Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55BA22F144
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732059AbgG0Oaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731698AbgG0OVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14FF42070B;
        Mon, 27 Jul 2020 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859677;
        bh=U1vHDKNq8WHILmUU+SD2QZgy44JApUdZ+BAhy+I1cx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/8yDaZPW6rpFagCGVWI8LKmkKG/fz8iNUMn7L50ps6AePONx5mAK3/PtKilbi1H0
         wdBoVrazYOIcQGfnNAGYZQUsE+ENIUvGvFQnV2d4mn8/3QmHzcVxUioqTKHgfXaHVF
         37WZEbo0Zx7gQJDwtB2dzVRWEXPYi+YrOGed3Ubw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 063/179] net: dsa: mv88e6xxx: fix in-band AN link establishment
Date:   Mon, 27 Jul 2020 16:03:58 +0200
Message-Id: <20200727134935.740410070@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit fad58190c0ffd72c394722928cd3e919b6e18357 ]

If in-band negotiation or fixed-link modes are specified for a DSA
port, the DSA code will force the link down during initialisation. For
fixed-link mode, this is fine, as phylink will manage the link state.
However, for in-band mode, phylink expects the PCS to detect link,
which will not happen if the link is forced down.

There is a related issue that in in-band mode, the link could come up
while we are making configuration changes, so we should force the link
down prior to reconfiguring the interface mode.

This patch addresses both issues.

Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 22 +++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2b4a723c83065..e065be419a03d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -664,8 +664,11 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 const struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p;
 	int err;
 
+	p = &chip->ports[port];
+
 	/* FIXME: is this the correct test? If we're in fixed mode on an
 	 * internal port, why should we process this any different from
 	 * PHY mode? On the other hand, the port may be automedia between
@@ -675,10 +678,14 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_reg_lock(chip);
-	/* FIXME: should we force the link down here - but if we do, how
-	 * do we restore the link force/unforce state? The driver layering
-	 * gets in the way.
+	/* In inband mode, the link may come up at any time while the link
+	 * is not forced down. Force the link down while we reconfigure the
+	 * interface mode.
 	 */
+	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
+	    chip->info->ops->port_set_link)
+		chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
+
 	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
 	if (err && err != -EOPNOTSUPP)
 		goto err_unlock;
@@ -691,6 +698,15 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 	if (err > 0)
 		err = 0;
 
+	/* Undo the forced down state above after completing configuration
+	 * irrespective of its state on entry, which allows the link to come up.
+	 */
+	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
+	    chip->info->ops->port_set_link)
+		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
+
+	p->interface = state->interface;
+
 err_unlock:
 	mv88e6xxx_reg_unlock(chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e5430cf2ad711..6476524e8239d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -232,6 +232,7 @@ struct mv88e6xxx_port {
 	u64 atu_full_violation;
 	u64 vtu_member_violation;
 	u64 vtu_miss_violation;
+	phy_interface_t interface;
 	u8 cmode;
 	bool mirror_ingress;
 	bool mirror_egress;
-- 
2.25.1




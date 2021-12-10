Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F5470081
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 13:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbhLJMT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 07:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbhLJMT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 07:19:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7764BC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 04:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44A8DB827EB
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72399C341E2;
        Fri, 10 Dec 2021 12:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639138579;
        bh=yt+qRh+CsseVaUTSK6AlePs5/tQZzIDYeeGkwxBfSO8=;
        h=Subject:To:Cc:From:Date:From;
        b=lOudVjEfObc6Gjc1AmVdFwSK57aVlpQ19YVLXVnvfZ6RY3s86ifoQIPmqP/YWHWWq
         GRkDKKxAlMDpN8qFDMLbkbJyMRnPHrQ52Gshlq+aOwKElf0Ey4/qSpIoTvTqwF/GMm
         xR154pHJOK0Ef5TVuTxKAHd7H5AHDaCQUwh4PzHs=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports" failed to apply to 5.10-stable tree
To:     rmk+kernel@armlinux.org.uk, kuba@kernel.org,
        martyn.welch@collabora.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 13:16:16 +0100
Message-ID: <1639138576254210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 04ec4e6250e5f58b525b08f3dca45c7d7427620e Mon Sep 17 00:00:00 2001
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Date: Thu, 9 Dec 2021 09:26:47 +0000
Subject: [PATCH] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports

Martyn Welch reports that his CPU port is unable to link where it has
been necessary to use one of the switch ports with an internal PHY for
the CPU port. The reason behind this is the port control register is
left forcing the link down, preventing traffic flow.

This occurs because during initialisation, phylink expects the link to
be down, and DSA forces the link down by synthesising a call to the
DSA drivers phylink_mac_link_down() method, but we don't touch the
forced-link state when we later reconfigure the port.

Resolve this by also unforcing the link state when we are operating in
PHY mode and the PPU is set to poll the PHY to retrieve link status
information.

Reported-by: Martyn Welch <martyn.welch@collabora.com>
Tested-by: Martyn Welch <martyn.welch@collabora.com>
Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")
Cc: <stable@vger.kernel.org> # 5.7: 2b29cb9e3f7f: net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal PHY's"
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1mvFhP-00F8Zb-Ul@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9f675464efc3..14f87f6ac479 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -698,44 +698,48 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port *p;
-	int err;
+	int err = 0;
 
 	p = &chip->ports[port];
 
-	/* FIXME: is this the correct test? If we're in fixed mode on an
-	 * internal port, why should we process this any different from
-	 * PHY mode? On the other hand, the port may be automedia between
-	 * an internal PHY and the serdes...
-	 */
-	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
-		return;
-
 	mv88e6xxx_reg_lock(chip);
-	/* In inband mode, the link may come up at any time while the link
-	 * is not forced down. Force the link down while we reconfigure the
-	 * interface mode.
-	 */
-	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
-	    chip->info->ops->port_set_link)
-		chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
-
-	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
-	if (err && err != -EOPNOTSUPP)
-		goto err_unlock;
 
-	err = mv88e6xxx_serdes_pcs_config(chip, port, mode, state->interface,
-					  state->advertising);
-	/* FIXME: we should restart negotiation if something changed - which
-	 * is something we get if we convert to using phylinks PCS operations.
-	 */
-	if (err > 0)
-		err = 0;
+	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
+		/* In inband mode, the link may come up at any time while the
+		 * link is not forced down. Force the link down while we
+		 * reconfigure the interface mode.
+		 */
+		if (mode == MLO_AN_INBAND &&
+		    p->interface != state->interface &&
+		    chip->info->ops->port_set_link)
+			chip->info->ops->port_set_link(chip, port,
+						       LINK_FORCED_DOWN);
+
+		err = mv88e6xxx_port_config_interface(chip, port,
+						      state->interface);
+		if (err && err != -EOPNOTSUPP)
+			goto err_unlock;
+
+		err = mv88e6xxx_serdes_pcs_config(chip, port, mode,
+						  state->interface,
+						  state->advertising);
+		/* FIXME: we should restart negotiation if something changed -
+		 * which is something we get if we convert to using phylinks
+		 * PCS operations.
+		 */
+		if (err > 0)
+			err = 0;
+	}
 
 	/* Undo the forced down state above after completing configuration
-	 * irrespective of its state on entry, which allows the link to come up.
+	 * irrespective of its state on entry, which allows the link to come
+	 * up in the in-band case where there is no separate SERDES. Also
+	 * ensure that the link can come up if the PPU is in use and we are
+	 * in PHY mode (we treat the PPU as an effective in-band mechanism.)
 	 */
-	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
-	    chip->info->ops->port_set_link)
+	if (chip->info->ops->port_set_link &&
+	    ((mode == MLO_AN_INBAND && p->interface != state->interface) ||
+	     (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))))
 		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
 
 	p->interface = state->interface;


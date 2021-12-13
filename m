Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A9847292B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242391AbhLMKSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241410AbhLMKQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:16:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7215FC110F2F;
        Mon, 13 Dec 2021 01:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BED40CE0DDE;
        Mon, 13 Dec 2021 09:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E94EC34600;
        Mon, 13 Dec 2021 09:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389333;
        bh=dBdJHs7ksAkcvPHLNr+nz7ADHUY+P2yCOwXF6qMH+VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmfHgB5GoroH4rZwinONt/jg5704OKRu0XHynk+kWFmvaj77RZaua6c9DVsx0bv3E
         UCYca1LXtqZ81VlwMkNExBi2NVMy2rnMgla+NcWD/wqxuUmPiBTXiArZ/Kjw8K54WU
         RKwPfz0PvtNgPQcO5m0BT84zua6dNejywZ/KtOfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martyn Welch <martyn.welch@collabora.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 030/171] net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports
Date:   Mon, 13 Dec 2021 10:29:05 +0100
Message-Id: <20211213092946.079023692@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 04ec4e6250e5f58b525b08f3dca45c7d7427620e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |   66 ++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -699,44 +699,48 @@ static void mv88e6xxx_mac_config(struct
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
-
-	err = mv88e6xxx_serdes_pcs_config(chip, port, mode, state->interface,
-					  state->advertising);
-	/* FIXME: we should restart negotiation if something changed - which
-	 * is something we get if we convert to using phylinks PCS operations.
-	 */
-	if (err > 0)
-		err = 0;
+
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



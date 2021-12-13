Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072974729A1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244171AbhLMKXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbhLMKQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:16:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DA8C110F2B;
        Mon, 13 Dec 2021 01:55:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1A2CCE0E7D;
        Mon, 13 Dec 2021 09:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D49C34600;
        Mon, 13 Dec 2021 09:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389330;
        bh=+Fbey8t6tGChg+w6blG37u1MpyKeFJaz57PNqXChuko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjfVBBJ3e0CscLLftmYrz8cd9g16KOmKmIxHN3ESNUfrC658Le38R26M8+CqpklS6
         2aqd4z8nxuXKCSbT8lyLUUoTmagGFQhhDV5M48Z8TLMc18UOE2uRdzPs7dIzVa6dI7
         E2yWMyZSNilSXXMO5N1GSrPzXXcOsWzHG6bP1byw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Maarten Zanders <maarten.zanders@mind.be>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 029/171] net: dsa: mv88e6xxx: fix "dont use PHY_DETECT on internal PHYs"
Date:   Mon, 13 Dec 2021 10:29:04 +0100
Message-Id: <20211213092946.047009548@linuxfoundation.org>
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

commit 2b29cb9e3f7f038c7f50ad2583b47caf5cb1eaf2 upstream.

This commit fixes a misunderstanding in commit 4a3e0aeddf09 ("net: dsa:
mv88e6xxx: don't use PHY_DETECT on internal PHY's").

For Marvell DSA switches with the PHY_DETECT bit (for non-6250 family
devices), controls whether the PPU polls the PHY to retrieve the link,
speed, duplex and pause status to update the port configuration. This
applies for both internal and external PHYs.

For some switches such as 88E6352 and 88E6390X, PHY_DETECT has an
additional function of enabling auto-media mode between the internal
PHY and SERDES blocks depending on which first gains link.

The original intention of commit 5d5b231da7ac (net: dsa: mv88e6xxx: use
PHY_DETECT in mac_link_up/mac_link_down) was to allow this bit to be
used to detect when this propagation is enabled, and allow software to
update the port configuration. This has found to be necessary for some
switches which do not automatically propagate status from the SERDES to
the port, which includes the 88E6390. However, commit 4a3e0aeddf09
("net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's") breaks
this assumption.

Maarten Zanders has confirmed that the issue he was addressing was for
an 88E6250 switch, which does not have a PHY_DETECT bit in bit 12, but
instead a link status bit. Therefore, mv88e6xxx_port_ppu_updates() does
not report correctly.

This patch resolves the above issues by reverting Maarten's change and
instead making mv88e6xxx_port_ppu_updates() indicate whether the port
is internal for the 88E6250 family of switches.

  Yes, you're right, I'm targeting the 6250 family. And yes, your
  suggestion would solve my case and is a better implementation for
  the other devices (as far as I can see).

Fixes: 4a3e0aeddf09 ("net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Tested-by: Maarten Zanders <maarten.zanders@mind.be>
Link: https://lore.kernel.org/r/E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -471,6 +471,12 @@ static int mv88e6xxx_port_ppu_updates(st
 	u16 reg;
 	int err;
 
+	/* The 88e6250 family does not have the PHY detect bit. Instead,
+	 * report whether the port is internal.
+	 */
+	if (chip->info->family == MV88E6XXX_FAMILY_6250)
+		return port < chip->info->num_internal_phys;
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
 	if (err) {
 		dev_err(chip->dev,
@@ -753,11 +759,10 @@ static void mv88e6xxx_mac_link_down(stru
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	/* Internal PHYs propagate their configuration directly to the MAC.
-	 * External PHYs depend on whether the PPU is enabled for this port.
+	/* Force the link down if we know the port may not be automatically
+	 * updated by the switch or if we are using fixed-link mode.
 	 */
-	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
-	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
 	     mode == MLO_AN_FIXED) && ops->port_sync_link)
 		err = ops->port_sync_link(chip, port, mode, false);
 	mv88e6xxx_reg_unlock(chip);
@@ -780,11 +785,11 @@ static void mv88e6xxx_mac_link_up(struct
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	/* Internal PHYs propagate their configuration directly to the MAC.
-	 * External PHYs depend on whether the PPU is enabled for this port.
+	/* Configure and force the link up if we know that the port may not
+	 * automatically updated by the switch or if we are using fixed-link
+	 * mode.
 	 */
-	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
-	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	if (!mv88e6xxx_port_ppu_updates(chip, port) ||
 	    mode == MLO_AN_FIXED) {
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media



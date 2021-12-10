Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AC947007C
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 13:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhLJMTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 07:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhLJMTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 07:19:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA86C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 04:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B332EB827EB
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F089BC00446;
        Fri, 10 Dec 2021 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639138568;
        bh=vhqIqVLuLrm+IIkqZLOStUj9KjmQvOGdmf19DYEwyJM=;
        h=Subject:To:Cc:From:Date:From;
        b=seUaleH+cZYBBTewcl+cRarsWJAyGgwOOSMsJr79viFgsjsMe0MQxjk5YEWM6OhWc
         1awY2NvR8omz6BXqEHx3kB4vII5xFXlwdpWyT7eJN8YNlE2tB7Z2UvQX6bBj0PdIEq
         ZjAiZmPkHKbVWKVi4CROBa51KIfzzFTBiWVrFxmw=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal" failed to apply to 5.10-stable tree
To:     rmk+kernel@armlinux.org.uk, kuba@kernel.org,
        maarten.zanders@mind.be
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 13:16:05 +0100
Message-ID: <16391385654242@kroah.com>
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

From 2b29cb9e3f7f038c7f50ad2583b47caf5cb1eaf2 Mon Sep 17 00:00:00 2001
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Date: Tue, 7 Dec 2021 10:32:43 +0000
Subject: [PATCH] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on internal
 PHY's"

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

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f00cbf5753b9..9f675464efc3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -471,6 +471,12 @@ static int mv88e6xxx_port_ppu_updates(struct mv88e6xxx_chip *chip, int port)
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
@@ -752,11 +758,10 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
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
@@ -779,11 +784,11 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
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


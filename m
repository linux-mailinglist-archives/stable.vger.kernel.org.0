Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3794316D0
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJRLHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhJRLHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 253EB6103C;
        Mon, 18 Oct 2021 11:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634555122;
        bh=jJA5Dpg7TkEED/kvvN44JhP+Dx6W1q+kG/UIDXe40jM=;
        h=Subject:To:Cc:From:Date:From;
        b=ou2p5ZSUINebwzY8v0JW/inL7zU6ZHuwS8CZ2G08HjtlxarKjEX/iBClDiYQME1qE
         jjSxSqN7GRZ7LYN58oQMPDnQhR6ThTt8K9ICLK+rMtl0wSZPPFjgEjXBItoT31MuTe
         ajmYIwsbnlGWK3ksmCi+1/0iY8Zd3FWx+unEHIe4=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's" failed to apply to 5.10-stable tree
To:     maarten.zanders@mind.be, davem@davemloft.net,
        m.zanders@televic.com, maxime.chevallier@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:05:20 +0200
Message-ID: <163455512012621@kroah.com>
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

From 4a3e0aeddf091f00974b02627c157843ce382a24 Mon Sep 17 00:00:00 2001
From: Maarten Zanders <maarten.zanders@mind.be>
Date: Mon, 11 Oct 2021 16:27:20 +0200
Subject: [PATCH] net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's

mv88e6xxx_port_ppu_updates() interpretes data in the PORT_STS
register incorrectly for internal ports (ie no PPU). In these
cases, the PHY_DETECT bit indicates link status. This results
in forcing the MAC state whenever the PHY link goes down which
is not intended. As a side effect, LED's configured to show
link status stay lit even though the physical link is down.

Add a check in mac_link_down and mac_link_up to see if it
concerns an external port and only then, look at PPU status.

Fixes: 5d5b231da7ac (net: dsa: mv88e6xxx: use PHY_DETECT in mac_link_up/mac_link_down)
Reported-by: Maarten Zanders <m.zanders@televic.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Maarten Zanders <maarten.zanders@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d7b29792732b..8dadcae93c9b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -750,7 +750,11 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 */
+	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
+	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
 	     mode == MLO_AN_FIXED) && ops->port_sync_link)
 		err = ops->port_sync_link(chip, port, mode, false);
 	mv88e6xxx_reg_unlock(chip);
@@ -773,7 +777,12 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 */
+	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
+	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
+	    mode == MLO_AN_FIXED) {
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
 		 * while we're bringing the port up, how is the exclusivity


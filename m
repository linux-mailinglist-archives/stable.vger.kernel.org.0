Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC964431D46
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhJRNth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233721AbhJRNrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:47:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30AD961362;
        Mon, 18 Oct 2021 13:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564201;
        bh=yLn3k5DtQT0PdlV2+BI5NbqHLvBYEVN2RQCrVWRpfyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TWSLJxL8xgyqoiBdSGHqet9LK2Fnw3HUkmSot1WLSkc4t0XrAkiUkvmB9LioYvmFS
         93k7KCppBFK0DodON1muXMOrzg2suL9h98DNoyo2/nUSnTqWbHQ1wrY96E5WmExj9W
         NqONTN59EU4CFVulR7BTuZGJ6Y3iIbz+vzArUXvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maarten Zanders <m.zanders@televic.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Maarten Zanders <maarten.zanders@mind.be>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 103/103] net: dsa: mv88e6xxx: dont use PHY_DETECT on internal PHYs
Date:   Mon, 18 Oct 2021 15:25:19 +0200
Message-Id: <20211018132338.204807441@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maarten Zanders <maarten.zanders@mind.be>

commit 4a3e0aeddf091f00974b02627c157843ce382a24 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/mv88e6xxx/chip.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -726,7 +726,11 @@ static void mv88e6xxx_mac_link_down(stru
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
+	/* Internal PHYs propagate their configuration directly to the MAC.
+	 * External PHYs depend on whether the PPU is enabled for this port.
+	 */
+	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
+	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
 	     mode == MLO_AN_FIXED) && ops->port_set_link)
 		err = ops->port_set_link(chip, port, LINK_FORCED_DOWN);
 	mv88e6xxx_reg_unlock(chip);
@@ -749,7 +753,12 @@ static void mv88e6xxx_mac_link_up(struct
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



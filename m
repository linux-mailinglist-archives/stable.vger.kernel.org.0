Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E574408FD
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhJ3NM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhJ3NM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:12:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D1960FD9;
        Sat, 30 Oct 2021 13:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599426;
        bh=s3l8+qtk+GsvfMycZaEuNrNP9IxGkleQ3b6/izYQC6w=;
        h=Subject:To:Cc:From:Date:From;
        b=doDRWRwgYpZi3seQWA3JpzBF6VSFkyBs55HnFNMe3CyQy7blA+N5FokhuSZEOo4Gg
         rFL0RttD1pJoh8F1HPcbABJbwadX3eBFhk7C4XnPcWcONelWtcPjfDwTBoQE8du9cZ
         OqweNw4tqU9hjoyW0R96qO9IMhRoKK/FugNIPbtk=
Subject: FAILED: patch "[PATCH] phy: phy_ethtool_ksettings_get: Lock the phy for consistency" failed to apply to 4.14-stable tree
To:     andrew@lunn.ch, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:10:14 +0200
Message-ID: <1635599414239107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c10a485c3de5ccbf1fff65a382cebcb2730c6b06 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 24 Oct 2021 21:48:02 +0200
Subject: [PATCH] phy: phy_ethtool_ksettings_get: Lock the phy for consistency

The PHY structure should be locked while copying information out if
it, otherwise there is no guarantee of self consistency. Without the
lock the PHY state machine could be updating the structure.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f124a8a58bd4..8457b829667e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -299,6 +299,7 @@ EXPORT_SYMBOL(phy_ethtool_ksettings_set);
 void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd)
 {
+	mutex_lock(&phydev->lock);
 	linkmode_copy(cmd->link_modes.supported, phydev->supported);
 	linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
 	linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
@@ -317,6 +318,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	cmd->base.autoneg = phydev->autoneg;
 	cmd->base.eth_tp_mdix_ctrl = phydev->mdix_ctrl;
 	cmd->base.eth_tp_mdix = phydev->mdix;
+	mutex_unlock(&phydev->lock);
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_get);
 


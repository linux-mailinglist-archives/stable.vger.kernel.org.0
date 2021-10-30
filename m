Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52A5440907
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhJ3NPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhJ3NPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:15:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F327560E8F;
        Sat, 30 Oct 2021 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599551;
        bh=gVCFJ1jTjBcPfRbgD7FfcL1xe6P9Y2+z7P7CsSx+61A=;
        h=Subject:To:Cc:From:Date:From;
        b=HCAHYttO9SXCqKSLM7SY2WmQv/wK8whR3QvyL3SmYijwbV/8K0FP7OnFunDL6LM9n
         6a0qweFsLBrDgmevI9lZGX3/hWUXsfBp/7GC+NChFcZe9ZkNEHypMpzCN4E/73z4eX
         001Isf20NzqQ3Mu2WnNtWF9pDCe34fmKUggLRBII=
Subject: FAILED: patch "[PATCH] phy: phy_ethtool_ksettings_set: Lock the PHY while changing" failed to apply to 4.9-stable tree
To:     andrew@lunn.ch, Walter.Stoll@duagon.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:12:29 +0200
Message-ID: <1635599549215148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af1a02aa23c37045e6adfcf074cf7dbac167a403 Mon Sep 17 00:00:00 2001
From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 24 Oct 2021 21:48:05 +0200
Subject: [PATCH] phy: phy_ethtool_ksettings_set: Lock the PHY while changing
 settings

There is a race condition where the PHY state machine can change
members of the phydev structure at the same time userspace requests a
change via ethtool. To prevent this, have phy_ethtool_ksettings_set
take the PHY lock.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Reported-by: Walter Stoll <Walter.Stoll@duagon.com>
Suggested-by: Walter Stoll <Walter.Stoll@duagon.com>
Tested-by: Walter Stoll <Walter.Stoll@duagon.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d845afab1af7..a3bfb156c83d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -798,6 +798,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	      duplex != DUPLEX_FULL)))
 		return -EINVAL;
 
+	mutex_lock(&phydev->lock);
 	phydev->autoneg = autoneg;
 
 	if (autoneg == AUTONEG_DISABLE) {
@@ -814,8 +815,9 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	phy_start_aneg(phydev);
+	_phy_start_aneg(phydev);
 
+	mutex_unlock(&phydev->lock);
 	return 0;
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_set);


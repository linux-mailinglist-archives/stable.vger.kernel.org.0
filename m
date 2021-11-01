Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF97441892
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhKAJtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234133AbhKAJrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 968D2613D5;
        Mon,  1 Nov 2021 09:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759054;
        bh=QLN1NfppkSWzVDuYNxx1VFzeAylfpOOQObfwOAeHt5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1eQOzRbFstdvY8UvyEFXasE+XDXDkmwiedmC1icB7nG+OhEvW2Nae+oFQTtOb4+O
         7H2IjLcyATLHP8tcdnEPK9doK5RpohMzohE00t9LgJy96MIJKXYiKDod+MrMpUlXUP
         u6FXQ+VWvk+Upi3K/kq0z4z/s+APWcifegGcgwU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walter Stoll <Walter.Stoll@duagon.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 095/125] phy: phy_ethtool_ksettings_set: Lock the PHY while changing settings
Date:   Mon,  1 Nov 2021 10:17:48 +0100
Message-Id: <20211101082551.144238316@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit af1a02aa23c37045e6adfcf074cf7dbac167a403 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -798,6 +798,7 @@ int phy_ethtool_ksettings_set(struct phy
 	      duplex != DUPLEX_FULL)))
 		return -EINVAL;
 
+	mutex_lock(&phydev->lock);
 	phydev->autoneg = autoneg;
 
 	if (autoneg == AUTONEG_DISABLE) {
@@ -814,8 +815,9 @@ int phy_ethtool_ksettings_set(struct phy
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	phy_start_aneg(phydev);
+	_phy_start_aneg(phydev);
 
+	mutex_unlock(&phydev->lock);
 	return 0;
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_set);



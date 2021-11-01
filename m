Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB64C4417BF
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhKAJjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhKAJhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E610861355;
        Mon,  1 Nov 2021 09:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758793;
        bh=0ieW+fV6l2QpNpy+89oS+MUGfuk6JQOELQCaNI6S3C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjghneodGqM5j7TVquKtFmpOyqrm8WuJ9JF3bWO5TJXp/iqrqED3NAxMqulJBfD8F
         4gvq+OOUyC6oNGFP1iIKD5nllDN6HwGQUnFxe87ziuSYmVtDwS/Q7m1ONwNJKF2/UT
         oNfkwfPHGIt4djOYfXj5ilY465djpo0wEL0BJFG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 61/77] phy: phy_ethtool_ksettings_get: Lock the phy for consistency
Date:   Mon,  1 Nov 2021 10:17:49 +0100
Message-Id: <20211101082524.459421206@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit c10a485c3de5ccbf1fff65a382cebcb2730c6b06 upstream.

The PHY structure should be locked while copying information out if
it, otherwise there is no guarantee of self consistency. Without the
lock the PHY state machine could be updating the structure.

Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -316,6 +316,7 @@ EXPORT_SYMBOL(phy_ethtool_ksettings_set)
 void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd)
 {
+	mutex_lock(&phydev->lock);
 	linkmode_copy(cmd->link_modes.supported, phydev->supported);
 	linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
 	linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
@@ -334,6 +335,7 @@ void phy_ethtool_ksettings_get(struct ph
 	cmd->base.autoneg = phydev->autoneg;
 	cmd->base.eth_tp_mdix_ctrl = phydev->mdix_ctrl;
 	cmd->base.eth_tp_mdix = phydev->mdix;
+	mutex_unlock(&phydev->lock);
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_get);
 



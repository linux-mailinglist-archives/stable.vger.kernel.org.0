Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18514417DE
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhKAJki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhKAJhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4468C61353;
        Mon,  1 Nov 2021 09:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758802;
        bh=L0e9MjlUSI+T7GeM+QozspY/hywwhA4+PDtzbxM3ylQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBF6lM5JSJr5Fv/DnVUdkmkPb5Bp7YHSKm+2PgzPN9Zdx5iANoU3ev4ub0nMoehHf
         FYkeDZOl4BUPEupTpuTbvjAakbl3PMOMjgOC7Oms+vo/QLbe74Wl3jkrwPgVzCyKit
         hptKno0Pr24Zb55SfxMjdGOTVl4WOI5VQ+JItiFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walter Stoll <Walter.Stoll@duagon.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 64/77] phy: phy_ethtool_ksettings_set: Lock the PHY while changing settings
Date:   Mon,  1 Nov 2021 10:17:52 +0100
Message-Id: <20211101082525.050743740@linuxfoundation.org>
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
@@ -814,6 +814,7 @@ int phy_ethtool_ksettings_set(struct phy
 	      duplex != DUPLEX_FULL)))
 		return -EINVAL;
 
+	mutex_lock(&phydev->lock);
 	phydev->autoneg = autoneg;
 
 	if (autoneg == AUTONEG_DISABLE) {
@@ -830,8 +831,9 @@ int phy_ethtool_ksettings_set(struct phy
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-	phy_start_aneg(phydev);
+	_phy_start_aneg(phydev);
 
+	mutex_unlock(&phydev->lock);
 	return 0;
 }
 EXPORT_SYMBOL(phy_ethtool_ksettings_set);



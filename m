Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0A633B738
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhCON7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232414AbhCON6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DCA64F2F;
        Mon, 15 Mar 2021 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816711;
        bh=VupWNzS1C9FEPcZk+mVDKvKN4MycCpmLi/K35zgcKvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqXx+/lxwrbGeskdeKoapC+wZUyYEipA0S2B0FHGfo1OF0vxSFX3OJoJj4PzyLW0G
         zqYqYbjK+3JXG4inAnOdmBjUIPQXRlhp/QBPU3Cj/cNMKlLjFJoTRni4AevwWtIb5E
         tO1hJyxzAGYbIidhKsyNmfHriatxF96JK4zNbIyU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/168] net: phy: fix save wrong speed and duplex problem if autoneg is on
Date:   Mon, 15 Mar 2021 14:54:53 +0100
Message-Id: <20210315135552.371764008@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit d9032dba5a2b2bbf0fdce67c8795300ec9923b43 ]

If phy uses generic driver and autoneg is on, enter command
"ethtool -s eth0 speed 50" will not change phy speed actually, but
command "ethtool eth0" shows speed is 50Mb/s because phydev->speed
has been set to 50 and no update later.

And duplex setting has same problem too.

However, if autoneg is on, phy only changes speed and duplex according to
phydev->advertising, but not phydev->speed and phydev->duplex. So in this
case, phydev->speed and phydev->duplex don't need to be set in function
phy_ethtool_ksettings_set() if autoneg is on.

Fixes: 51e2a3846eab ("PHY: Avoid unnecessary aneg restarts")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index b718b11607fc..b0b8a3ce82b6 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -345,15 +345,16 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 
 	phydev->autoneg = autoneg;
 
-	phydev->speed = speed;
+	if (autoneg == AUTONEG_DISABLE) {
+		phydev->speed = speed;
+		phydev->duplex = duplex;
+	}
 
 	linkmode_copy(phydev->advertising, advertising);
 
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
 			 phydev->advertising, autoneg == AUTONEG_ENABLE);
 
-	phydev->duplex = duplex;
-
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 
 	/* Restart the PHY */
-- 
2.30.1




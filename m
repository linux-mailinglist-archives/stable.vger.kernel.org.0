Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E1733B650
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhCON5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231299AbhCON5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B84364F0C;
        Mon, 15 Mar 2021 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816626;
        bh=QBRAwhpye3waUYbqT08YlDboSZ3WWwEkgwyh6D7dgjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNjbfgobUwf7/VvMxVtq+9zVhhMCLD+XzI+JzGih7MNW9DGH3pTwCgmQxDcNFKilT
         XvZJSMTMi5Sj/yVTX4hVvQ2iRV64fwHAJ3zjM+OeBSOwpLEs0f3fnmUvgHKPEi1Xnj
         /BAz3oxsSgPHDKqZxITQzAyvxvwOhezi0/qt+tV4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 028/306] net: phy: fix save wrong speed and duplex problem if autoneg is on
Date:   Mon, 15 Mar 2021 14:51:31 +0100
Message-Id: <20210315135508.570816874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Guangbin Huang <huangguangbin2@huawei.com>

commit d9032dba5a2b2bbf0fdce67c8795300ec9923b43 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -276,14 +276,16 @@ int phy_ethtool_ksettings_set(struct phy
 
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
 	phydev->master_slave_set = cmd->base.master_slave_cfg;
 	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
 



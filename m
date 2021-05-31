Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B905396265
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhEaOz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234038AbhEaOxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3285061CA9;
        Mon, 31 May 2021 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469516;
        bh=UsRoQph7bPCB4D4xwZJzWM88k0G/GJ6TuUufsaaESV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaNl67pS1xTMXlfhaf/WIbGUiDuRmLIKF1Ka4YodmkyG73DjyAOrf1c2GD6pUXsLy
         POp4ytvC2IOG4taJVF9gek2ShiYE8lUOL7phD494lyFb3w1Bgt1tYBkjw9c6FKRNrd
         rJikt/cSeWT7s/1KivTeBZjJyTJ0ND7LEP95paWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 227/296] net: stmmac: Fix MAC WoL not working if PHY does not support WoL
Date:   Mon, 31 May 2021 15:14:42 +0200
Message-Id: <20210531130711.456128315@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 576f9eacc680d2b1f37e8010cff62f7b227ea769 ]

Both get and set WoL will check device_can_wakeup(), if MAC supports PMT, it
will set device wakeup capability. After commit 1d8e5b0f3f2c ("net: stmmac:
Support WOL with phy"), device wakeup capability will be overwrite in
stmmac_init_phy() according to phy's Wol feature. If phy doesn't support WoL,
then MAC will lose wakeup capability. To fix this issue, only overwrite device
wakeup capability when MAC doesn't support PMT.

For STMMAC now driver checks MAC's WoL capability if MAC supports PMT, if
not support, driver will check PHY's WoL capability.

Fixes: 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
Reviewed-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 369d7cde3993..492415790b13 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1076,7 +1076,6 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
  */
 static int stmmac_init_phy(struct net_device *dev)
 {
-	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct device_node *node;
 	int ret;
@@ -1102,8 +1101,12 @@ static int stmmac_init_phy(struct net_device *dev)
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-	phylink_ethtool_get_wol(priv->phylink, &wol);
-	device_set_wakeup_capable(priv->device, !!wol.supported);
+	if (!priv->plat->pmt) {
+		struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
+
+		phylink_ethtool_get_wol(priv->phylink, &wol);
+		device_set_wakeup_capable(priv->device, !!wol.supported);
+	}
 
 	return ret;
 }
-- 
2.30.2




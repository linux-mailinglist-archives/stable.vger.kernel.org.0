Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC764094FF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbhIMOgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346313AbhIMOco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09AB861BC0;
        Mon, 13 Sep 2021 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541135;
        bh=1AF68cQr4/O4j0EQ5X/lheLJUU/RqH7zAw8SKQiywqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfJZZPnc1o3ikj2dy7UPw9hWlclMZsrt9KBY2XSVsxJeIgNecy8nIBKL/Zhlr5JyZ
         IfspNpw7srmSVn0gVNfJ3kyAjQFoEWvYvQJzbRYduVz09tRBrC97trGaFsbKIOLO5E
         9VvybzdzptruCV7KVVuMY0+aujQUPCiEhdd+tho8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 178/334] net: dsa: mt7530: remove the .port_set_mrouter implementation
Date:   Mon, 13 Sep 2021 15:13:52 +0200
Message-Id: <20210913131119.371725244@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit cbbf09b5771e6e9da268bc0d2fb6e428afa787bc ]

DSA's idea of optimizing out multicast flooding to the CPU port leaves
quite a few holes open, so it should be reverted.

The mt7530 driver is the only new driver which added a .port_set_mrouter
implementation after the reorg from commit a8b659e7ff75 ("net: dsa: act
as passthrough for bridge port flags"), so it needs to be reverted
separately so that the other revert commit can go a bit further down the
git history.

Fixes: 5a30833b9a16 ("net: dsa: mt7530: support MDB and bridge flag operations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 05bc46634b36..0cea1572f826 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1185,18 +1185,6 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int
-mt7530_port_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-			struct netlink_ext_ack *extack)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	mt7530_rmw(priv, MT7530_MFC, UNM_FFP(BIT(port)),
-		   mrouter ? UNM_FFP(BIT(port)) : 0);
-
-	return 0;
-}
-
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			struct net_device *bridge)
@@ -3058,7 +3046,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_stp_state_set	= mt7530_stp_state_set,
 	.port_pre_bridge_flags	= mt7530_port_pre_bridge_flags,
 	.port_bridge_flags	= mt7530_port_bridge_flags,
-	.port_set_mrouter	= mt7530_port_set_mrouter,
 	.port_bridge_join	= mt7530_port_bridge_join,
 	.port_bridge_leave	= mt7530_port_bridge_leave,
 	.port_fdb_add		= mt7530_port_fdb_add,
-- 
2.30.2




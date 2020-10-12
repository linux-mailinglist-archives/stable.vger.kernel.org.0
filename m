Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0A928B7D3
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731491AbgJLNq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389840AbgJLNqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:46:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237D72074F;
        Mon, 12 Oct 2020 13:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510373;
        bh=j1EHIglPkQ402XuMZYkaeAreo2z+JYKGreHr9r3/aXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF2OD0S6nW2Jn+pmHCLs7cdv3Ah5r68UUk0cQZ/bpYNwjESXIi+vwp9+uthQnc1we
         nb8LD1dK5nVLO0pngZKdR6njT7Qi/GhJz3/+4ByfQLtcpItF454TLRnKqYcVfHaBgk
         EcvH3KFdIJiUPlUrekdjeNEUfOIlN5cotdhTbzBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Khoronzhuk <ikhoronz@cisco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 071/124] net: ethernet: cavium: octeon_mgmt: use phy_start and phy_stop
Date:   Mon, 12 Oct 2020 15:31:15 +0200
Message-Id: <20201012133150.291963774@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@gmail.com>

[ Upstream commit 4663ff60257aec4ee1e2e969a7c046f0aff35ab8 ]

To start also "phy state machine", with UP state as it should be,
the phy_start() has to be used, in another case machine even is not
triggered. After this change negotiation is supposed to be triggered
by SM workqueue.

It's not correct usage, but it appears after the following patch,
so add it as a fix.

Fixes: 74a992b3598a ("net: phy: add phy_check_link_status")
Signed-off-by: Ivan Khoronzhuk <ikhoronz@cisco.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index cbaa1924afbe1..706e959bf02ac 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1219,7 +1219,7 @@ static int octeon_mgmt_open(struct net_device *netdev)
 	 */
 	if (netdev->phydev) {
 		netif_carrier_off(netdev);
-		phy_start_aneg(netdev->phydev);
+		phy_start(netdev->phydev);
 	}
 
 	netif_wake_queue(netdev);
@@ -1247,8 +1247,10 @@ static int octeon_mgmt_stop(struct net_device *netdev)
 	napi_disable(&p->napi);
 	netif_stop_queue(netdev);
 
-	if (netdev->phydev)
+	if (netdev->phydev) {
+		phy_stop(netdev->phydev);
 		phy_disconnect(netdev->phydev);
+	}
 
 	netif_carrier_off(netdev);
 
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9848F28B75E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgJLNm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389240AbgJLNmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA4DC22258;
        Mon, 12 Oct 2020 13:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510141;
        bh=L9dPZE/RKFQvpjg8FwbM1ATyvHGThL0hF9imxpcw4js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eROlEBn1X9ffIuyGYe5mB5p6hf1BWNvT9BJwIx9voIL3MiQmi+j/F9GKXNyW/+a/w
         7IedyGnDOi9wQKjL+MS/V7HFf/h8K0fBaDMx05FxPcnPzI8KWqT1tHFruK5AsDI/Ja
         a9LsB1jMmGHjoy+ti7BQDg8oqjnY7KP7tBo+wn/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Khoronzhuk <ikhoronz@cisco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 58/85] net: ethernet: cavium: octeon_mgmt: use phy_start and phy_stop
Date:   Mon, 12 Oct 2020 15:27:21 +0200
Message-Id: <20201012132635.651037462@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
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
index d375e438d8054..4fa9d485e2096 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1222,7 +1222,7 @@ static int octeon_mgmt_open(struct net_device *netdev)
 	 */
 	if (netdev->phydev) {
 		netif_carrier_off(netdev);
-		phy_start_aneg(netdev->phydev);
+		phy_start(netdev->phydev);
 	}
 
 	netif_wake_queue(netdev);
@@ -1250,8 +1250,10 @@ static int octeon_mgmt_stop(struct net_device *netdev)
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




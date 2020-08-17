Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD4B2469FB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgHQP2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbgHQP2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E425F23B40;
        Mon, 17 Aug 2020 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678106;
        bh=Ayp/4nbw5HvV5c5EArbyB4xMrIEgilEBRcS1f8aK9F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMpqWL8F8r1jNfqu5d3AOF1UdbeBxLpZHRQOU5AySE2QP9AQpZKgAQQdlGCzyt23U
         uFfh2cYGhWMlaeFQg65xBYOpdR39iraqyapq+bzdL10bEhtn8X0AbD40K40lBRHo/U
         f7yMu1xttpovC7i+i7RjJJ1itDjK1FczHbqLaBy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 190/464] net: ethernet: ti: am65-cpsw-nuss: restore vlan configuration while down/up
Date:   Mon, 17 Aug 2020 17:12:23 +0200
Message-Id: <20200817143842.923412596@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 7bcffde02152dd3cb180f6f3aef27e8586b2a905 ]

The vlan configuration is not restored after interface down/up sequence.

Steps to check:
 # ip link add link eth0 name eth0.100 type vlan id 100
 # ifconfig eth0 down
 # ifconfig eth0 up

This patch fixes it, restoring vlan ALE entries on .ndo_open().

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6d778bc3d012f..88832277edd5a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -223,6 +223,9 @@ static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
 	u32 port_mask, unreg_mcast = 0;
 	int ret;
 
+	if (!netif_running(ndev) || !vid)
+		return 0;
+
 	ret = pm_runtime_get_sync(common->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(common->dev);
@@ -246,6 +249,9 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	int ret;
 
+	if (!netif_running(ndev) || !vid)
+		return 0;
+
 	ret = pm_runtime_get_sync(common->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(common->dev);
@@ -571,6 +577,16 @@ static int am65_cpsw_nuss_ndo_slave_stop(struct net_device *ndev)
 	return 0;
 }
 
+static int cpsw_restore_vlans(struct net_device *vdev, int vid, void *arg)
+{
+	struct am65_cpsw_port *port = arg;
+
+	if (!vdev)
+		return 0;
+
+	return am65_cpsw_nuss_ndo_slave_add_vid(port->ndev, 0, vid);
+}
+
 static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
@@ -644,6 +660,9 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 		}
 	}
 
+	/* restore vlan configurations */
+	vlan_for_each(ndev, cpsw_restore_vlans, port);
+
 	phy_attached_info(port->slave.phy);
 	phy_start(port->slave.phy);
 
-- 
2.25.1




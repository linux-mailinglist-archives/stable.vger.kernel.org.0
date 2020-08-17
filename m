Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950572473AE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388755AbgHQS72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbgHQPsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:48:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55CA62067C;
        Mon, 17 Aug 2020 15:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679310;
        bh=SOZN3vB8b/e9xXVr3NCnRkVcHjwE78Nhys0Nf+rGu6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqhDwspYfQ+NgN7RlEBUlc56Np/+rsiVmWSyn6mJGVdTP4anChlndV4gSIiGk7zXF
         Jrm1LtLMS+rbJwL6/DqTDelsQN2iwwwTXbfKdL1Gg7OJUNSvepkiMNSHaO/QGht3lz
         N2AOih6PP0nmUNVQ1P8BeIUagE5WGFpp6FQFJbB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 168/393] net: ethernet: ti: am65-cpsw-nuss: restore vlan configuration while down/up
Date:   Mon, 17 Aug 2020 17:13:38 +0200
Message-Id: <20200817143827.769585713@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
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
index 3e4388e6b5fa1..61b59a3b277ec 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -217,6 +217,9 @@ static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
 	u32 port_mask, unreg_mcast = 0;
 	int ret;
 
+	if (!netif_running(ndev) || !vid)
+		return 0;
+
 	ret = pm_runtime_get_sync(common->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(common->dev);
@@ -240,6 +243,9 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	int ret;
 
+	if (!netif_running(ndev) || !vid)
+		return 0;
+
 	ret = pm_runtime_get_sync(common->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(common->dev);
@@ -565,6 +571,16 @@ static int am65_cpsw_nuss_ndo_slave_stop(struct net_device *ndev)
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
@@ -638,6 +654,9 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 		}
 	}
 
+	/* restore vlan configurations */
+	vlan_for_each(ndev, cpsw_restore_vlans, port);
+
 	phy_attached_info(port->slave.phy);
 	phy_start(port->slave.phy);
 
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3AC2B6431
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgKQNi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733056AbgKQNiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D53920870;
        Tue, 17 Nov 2020 13:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620299;
        bh=OVbaHfWOr7z7UMHvYVcobnP2alaoJh/dzSPHxWg185E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzXi9okvSKY+ysuGOd0kWwNGUEB6FT5aERqddyejDvojN3/de24UkAzGNoNwJzrX/
         yX7izzSZTRTGsvx7qdQtfe73JGiyyjapqQceBwzuz+m/PocIcjZxvsFM+pBCaYijCc
         4QuG36Nv5xI/nYtK5tJhaJkBz7zicjaag+md16G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 155/255] igc: Fix returning wrong statistics
Date:   Tue, 17 Nov 2020 14:04:55 +0100
Message-Id: <20201117122146.492809796@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 6b7ed22ae4c96a415001f0c3116ebee15bb8491a ]

'igc_update_stats()' was not updating 'netdev->stats', so the returned
statistics, for example, requested by:

$ ip -s link show dev enp3s0

were not being updated and were always zero.

Fix by returning a set of statistics that are actually being
updated (adapter->stats64).

Fixes: c9a11c23ceb6 ("igc: Add netdev")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9593aa4eea369..1358a39c34ad3 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3890,21 +3890,23 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
 }
 
 /**
- * igc_get_stats - Get System Network Statistics
+ * igc_get_stats64 - Get System Network Statistics
  * @netdev: network interface device structure
+ * @stats: rtnl_link_stats64 pointer
  *
  * Returns the address of the device statistics structure.
  * The statistics are updated here and also from the timer callback.
  */
-static struct net_device_stats *igc_get_stats(struct net_device *netdev)
+static void igc_get_stats64(struct net_device *netdev,
+			    struct rtnl_link_stats64 *stats)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
+	spin_lock(&adapter->stats64_lock);
 	if (!test_bit(__IGC_RESETTING, &adapter->state))
 		igc_update_stats(adapter);
-
-	/* only return the current stats */
-	return &netdev->stats;
+	memcpy(stats, &adapter->stats64, sizeof(*stats));
+	spin_unlock(&adapter->stats64_lock);
 }
 
 static netdev_features_t igc_fix_features(struct net_device *netdev,
@@ -4833,7 +4835,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_set_rx_mode	= igc_set_rx_mode,
 	.ndo_set_mac_address	= igc_set_mac,
 	.ndo_change_mtu		= igc_change_mtu,
-	.ndo_get_stats		= igc_get_stats,
+	.ndo_get_stats64	= igc_get_stats64,
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
 	.ndo_features_check	= igc_features_check,
-- 
2.27.0




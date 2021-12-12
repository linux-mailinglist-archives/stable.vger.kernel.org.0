Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8660E471ACA
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhLLOdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:33:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60534 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhLLOdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:33:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6262B80CDD
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ACBC341C5;
        Sun, 12 Dec 2021 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639319617;
        bh=/sR+yIs3Aa9RWzfHEenwRP3DPgZJQ6BtUG+YhZ1a9pE=;
        h=Subject:To:Cc:From:Date:From;
        b=H+Ty91Q2zX4Jy12FuBD66SjV1zX2s8XCfN+igWoa1MsV/IE38UyfB/EUmHysbaMD6
         tB1bsI+9eFi7DCJ2721ZKLeKqFseP2XeNssqDAETqZE9DGYiFlSRp5z4qizQOEj+jc
         elI9I3RKIa9G1Sjg+KOd4vx64rfY9fEOYeWINlx8=
Subject: FAILED: patch "[PATCH] ice: safer stats processing" failed to apply to 5.15-stable tree
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        gurucharanx.g@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:33:24 +0100
Message-ID: <1639319604173229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1a0f25a52e08b1f67510cabbb44888d2b3c46359 Mon Sep 17 00:00:00 2001
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Fri, 12 Nov 2021 17:06:02 -0800
Subject: [PATCH] ice: safer stats processing

The driver was zeroing live stats that could be fetched by
ndo_get_stats64 at any time. This could result in inconsistent
statistics, and the telltale sign was when reading stats frequently from
/proc/net/dev, the stats would go backwards.

Fix by collecting stats into a local, and delaying when we write to the
structure so it's not incremental.

Fixes: fcea6f3da546 ("ice: Add stats and ethtool support")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c6d6ce52e2ca..73c61cdb036f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5930,14 +5930,15 @@ ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp, struct ice_q_stats st
 /**
  * ice_update_vsi_tx_ring_stats - Update VSI Tx ring stats counters
  * @vsi: the VSI to be updated
+ * @vsi_stats: the stats struct to be updated
  * @rings: rings to work on
  * @count: number of rings
  */
 static void
-ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_tx_ring **rings,
-			     u16 count)
+ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
+			     struct rtnl_link_stats64 *vsi_stats,
+			     struct ice_tx_ring **rings, u16 count)
 {
-	struct rtnl_link_stats64 *vsi_stats = &vsi->net_stats;
 	u16 i;
 
 	for (i = 0; i < count; i++) {
@@ -5961,15 +5962,13 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_tx_ring **rings,
  */
 static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 {
-	struct rtnl_link_stats64 *vsi_stats = &vsi->net_stats;
+	struct rtnl_link_stats64 *vsi_stats;
 	u64 pkts, bytes;
 	int i;
 
-	/* reset netdev stats */
-	vsi_stats->tx_packets = 0;
-	vsi_stats->tx_bytes = 0;
-	vsi_stats->rx_packets = 0;
-	vsi_stats->rx_bytes = 0;
+	vsi_stats = kzalloc(sizeof(*vsi_stats), GFP_ATOMIC);
+	if (!vsi_stats)
+		return;
 
 	/* reset non-netdev (extended) stats */
 	vsi->tx_restart = 0;
@@ -5981,7 +5980,8 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 	rcu_read_lock();
 
 	/* update Tx rings counters */
-	ice_update_vsi_tx_ring_stats(vsi, vsi->tx_rings, vsi->num_txq);
+	ice_update_vsi_tx_ring_stats(vsi, vsi_stats, vsi->tx_rings,
+				     vsi->num_txq);
 
 	/* update Rx rings counters */
 	ice_for_each_rxq(vsi, i) {
@@ -5996,10 +5996,17 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 
 	/* update XDP Tx rings counters */
 	if (ice_is_xdp_ena_vsi(vsi))
-		ice_update_vsi_tx_ring_stats(vsi, vsi->xdp_rings,
+		ice_update_vsi_tx_ring_stats(vsi, vsi_stats, vsi->xdp_rings,
 					     vsi->num_xdp_txq);
 
 	rcu_read_unlock();
+
+	vsi->net_stats.tx_packets = vsi_stats->tx_packets;
+	vsi->net_stats.tx_bytes = vsi_stats->tx_bytes;
+	vsi->net_stats.rx_packets = vsi_stats->rx_packets;
+	vsi->net_stats.rx_bytes = vsi_stats->rx_bytes;
+
+	kfree(vsi_stats);
 }
 
 /**


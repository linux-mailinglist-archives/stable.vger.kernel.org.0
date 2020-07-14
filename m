Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292B321FC54
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgGNTI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729741AbgGNSuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA91C207F5;
        Tue, 14 Jul 2020 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752623;
        bh=49qUf6Pee7v1XrKB0RGEegsA3cDs8+wRd1v2gKqYmWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czt4yaLiS4/+kibZLyaRkDooMdO2WPc31GCRNEdwjEwEitE0mtAuoaBJTol1NsJXH
         YcfXUYIYUT/Y0FtDYyiyOCdPZNIUfT6d43a6AMyE6Be09Ts5NBg7okpkhfsIzhm/xj
         oYTJ71tpGaSApN8A8LtBhA+bnKu9jU7KcRWtZOXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/109] ixgbe: protect ring accesses with READ- and WRITE_ONCE
Date:   Tue, 14 Jul 2020 20:43:21 +0200
Message-Id: <20200714184106.394531883@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

[ Upstream commit f140ad9fe2ae16f385f8fe4dc9cf67bb4c51d794 ]

READ_ONCE should be used when reading rings prior to accessing the
statistics pointer. Introduce this as well as the corresponding WRITE_ONCE
usage when allocating and freeing the rings, to ensure protected access.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 12 ++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 14 +++++++++++---
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index cc3196ae5aea8..636e6e840afa2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -923,7 +923,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		ring->queue_index = txr_idx;
 
 		/* assign ring to adapter */
-		adapter->tx_ring[txr_idx] = ring;
+		WRITE_ONCE(adapter->tx_ring[txr_idx], ring);
 
 		/* update count and index */
 		txr_count--;
@@ -950,7 +950,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		set_ring_xdp(ring);
 
 		/* assign ring to adapter */
-		adapter->xdp_ring[xdp_idx] = ring;
+		WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
 
 		/* update count and index */
 		xdp_count--;
@@ -993,7 +993,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
 		ring->queue_index = rxr_idx;
 
 		/* assign ring to adapter */
-		adapter->rx_ring[rxr_idx] = ring;
+		WRITE_ONCE(adapter->rx_ring[rxr_idx], ring);
 
 		/* update count and index */
 		rxr_count--;
@@ -1022,13 +1022,13 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
 
 	ixgbe_for_each_ring(ring, q_vector->tx) {
 		if (ring_is_xdp(ring))
-			adapter->xdp_ring[ring->queue_index] = NULL;
+			WRITE_ONCE(adapter->xdp_ring[ring->queue_index], NULL);
 		else
-			adapter->tx_ring[ring->queue_index] = NULL;
+			WRITE_ONCE(adapter->tx_ring[ring->queue_index], NULL);
 	}
 
 	ixgbe_for_each_ring(ring, q_vector->rx)
-		adapter->rx_ring[ring->queue_index] = NULL;
+		WRITE_ONCE(adapter->rx_ring[ring->queue_index], NULL);
 
 	adapter->q_vector[v_idx] = NULL;
 	napi_hash_del(&q_vector->napi);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index edaa0bffa5c35..5336bfcd2d701 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7064,7 +7064,10 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
 	}
 
 	for (i = 0; i < adapter->num_rx_queues; i++) {
-		struct ixgbe_ring *rx_ring = adapter->rx_ring[i];
+		struct ixgbe_ring *rx_ring = READ_ONCE(adapter->rx_ring[i]);
+
+		if (!rx_ring)
+			continue;
 		non_eop_descs += rx_ring->rx_stats.non_eop_descs;
 		alloc_rx_page += rx_ring->rx_stats.alloc_rx_page;
 		alloc_rx_page_failed += rx_ring->rx_stats.alloc_rx_page_failed;
@@ -7085,15 +7088,20 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
 	packets = 0;
 	/* gather some stats to the adapter struct that are per queue */
 	for (i = 0; i < adapter->num_tx_queues; i++) {
-		struct ixgbe_ring *tx_ring = adapter->tx_ring[i];
+		struct ixgbe_ring *tx_ring = READ_ONCE(adapter->tx_ring[i]);
+
+		if (!tx_ring)
+			continue;
 		restart_queue += tx_ring->tx_stats.restart_queue;
 		tx_busy += tx_ring->tx_stats.tx_busy;
 		bytes += tx_ring->stats.bytes;
 		packets += tx_ring->stats.packets;
 	}
 	for (i = 0; i < adapter->num_xdp_queues; i++) {
-		struct ixgbe_ring *xdp_ring = adapter->xdp_ring[i];
+		struct ixgbe_ring *xdp_ring = READ_ONCE(adapter->xdp_ring[i]);
 
+		if (!xdp_ring)
+			continue;
 		restart_queue += xdp_ring->tx_stats.restart_queue;
 		tx_busy += xdp_ring->tx_stats.tx_busy;
 		bytes += xdp_ring->stats.bytes;
-- 
2.25.1




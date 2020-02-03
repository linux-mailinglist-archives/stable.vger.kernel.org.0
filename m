Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0365C150D4E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgBCQc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:32:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730413AbgBCQcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:23 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF25421741;
        Mon,  3 Feb 2020 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747542;
        bh=DxN8coZhDZX7wQFQzVq2wymNWBofR8Gq1Op8S0pVaGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMU7/9YA7xZEPaz0uPseRMeocXLNfciJTvXJQqCzwvN1XoaTpgbZl1yYkEchuUV05
         01b2b2Mxc8hFwS/ioQdYEDWMpD2RgCh7EgQcq9xOzPUsCQBax0dCJX4TuDI7rMXuMC
         U8LN3qBi5A4dFYmuXw+zalpYBk7yzlxfoHavl6II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cambda Zhu <cambda@linux.alibaba.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/70] ixgbe: Fix calculation of queue with VFs and flow director on interface flap
Date:   Mon,  3 Feb 2020 16:19:48 +0000
Message-Id: <20200203161917.694078668@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>

[ Upstream commit 4fad78ad6422d9bca62135bbed8b6abc4cbb85b8 ]

This patch fixes the calculation of queue when we restore flow director
filters after resetting adapter. In ixgbe_fdir_filter_restore(), filter's
vf may be zero which makes the queue outside of the rx_ring array.

The calculation is changed to the same as ixgbe_add_ethtool_fdir_entry().

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 37 ++++++++++++++-----
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 51cd58fbab695..8177276500f5a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5189,7 +5189,7 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct hlist_node *node2;
 	struct ixgbe_fdir_filter *filter;
-	u64 action;
+	u8 queue;
 
 	spin_lock(&adapter->fdir_perfect_lock);
 
@@ -5198,17 +5198,34 @@ static void ixgbe_fdir_filter_restore(struct ixgbe_adapter *adapter)
 
 	hlist_for_each_entry_safe(filter, node2,
 				  &adapter->fdir_filter_list, fdir_node) {
-		action = filter->action;
-		if (action != IXGBE_FDIR_DROP_QUEUE && action != 0)
-			action =
-			(action >> ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF) - 1;
+		if (filter->action == IXGBE_FDIR_DROP_QUEUE) {
+			queue = IXGBE_FDIR_DROP_QUEUE;
+		} else {
+			u32 ring = ethtool_get_flow_spec_ring(filter->action);
+			u8 vf = ethtool_get_flow_spec_ring_vf(filter->action);
+
+			if (!vf && (ring >= adapter->num_rx_queues)) {
+				e_err(drv, "FDIR restore failed without VF, ring: %u\n",
+				      ring);
+				continue;
+			} else if (vf &&
+				   ((vf > adapter->num_vfs) ||
+				     ring >= adapter->num_rx_queues_per_pool)) {
+				e_err(drv, "FDIR restore failed with VF, vf: %hhu, ring: %u\n",
+				      vf, ring);
+				continue;
+			}
+
+			/* Map the ring onto the absolute queue index */
+			if (!vf)
+				queue = adapter->rx_ring[ring]->reg_idx;
+			else
+				queue = ((vf - 1) *
+					adapter->num_rx_queues_per_pool) + ring;
+		}
 
 		ixgbe_fdir_write_perfect_filter_82599(hw,
-				&filter->filter,
-				filter->sw_idx,
-				(action == IXGBE_FDIR_DROP_QUEUE) ?
-				IXGBE_FDIR_DROP_QUEUE :
-				adapter->rx_ring[action]->reg_idx);
+				&filter->filter, filter->sw_idx, queue);
 	}
 
 	spin_unlock(&adapter->fdir_perfect_lock);
-- 
2.20.1




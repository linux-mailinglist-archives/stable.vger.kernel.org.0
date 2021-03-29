Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF0C34CA3B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbhC2IgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhC2Ief (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:34:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA05A61613;
        Mon, 29 Mar 2021 08:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006874;
        bh=tmjMgf5ChpP25+m30hjGZnen8ecaQEiplts2GSxlndw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhVDTPFqdubgt1N0h4G4w6d5JMlYKcMR5ZbE+vNIumxAKci68aCW6QsIEX4/a3d1e
         QCwwbtYTrtTc7q6Had0ar+gpXlQ2jUYXUxoOgJ4PWMrW4ml+D5ugzLaRiGaxnKqlvE
         xGVPwnqa+7/bg4cVO0G3uDZzlj+EAS0z7sQ8f2OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 134/254] ice: fix napi work done reporting in xsk path
Date:   Mon, 29 Mar 2021 09:57:30 +0200
Message-Id: <20210329075637.625230509@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit ed0907e3bdcfc7fe1c1756a480451e757b207a69 ]

Fix the wrong napi work done reporting in the xsk path of the ice
driver. The code in the main Rx processing loop was written to assume
that the buffer allocation code returns true if all allocations where
successful and false if not. In contrast with all other Intel NIC xsk
drivers, the ice_alloc_rx_bufs_zc() has the inverted logic messing up
the work done reporting in the napi loop.

This can be fixed either by inverting the return value from
ice_alloc_rx_bufs_zc() in the function that uses this in an incorrect
way, or by changing the return value of ice_alloc_rx_bufs_zc(). We
chose the latter as it makes all the xsk allocation functions for
Intel NICs behave in the same way. My guess is that it was this
unexpected discrepancy that gave rise to this bug in the first place.

Fixes: 5bb0c4b5eb61 ("ice, xsk: Move Rx allocation out of while-loop")
Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c |  6 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 10 +++++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 3124a3bf519a..952e41a1e001 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -418,6 +418,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	writel(0, ring->tail);
 
 	if (ring->xsk_pool) {
+		bool ok;
+
 		if (!xsk_buff_can_alloc(ring->xsk_pool, num_bufs)) {
 			dev_warn(dev, "XSK buffer pool does not provide enough addresses to fill %d buffers on Rx ring %d\n",
 				 num_bufs, ring->q_index);
@@ -426,8 +428,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 			return 0;
 		}
 
-		err = ice_alloc_rx_bufs_zc(ring, num_bufs);
-		if (err)
+		ok = ice_alloc_rx_bufs_zc(ring, num_bufs);
+		if (!ok)
 			dev_info(dev, "Failed to allocate some buffers on XSK buffer pool enabled Rx ring %d (pf_q %d)\n",
 				 ring->q_index, pf_q);
 		return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 1782146db644..69ee1a8e87ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -408,18 +408,18 @@ xsk_pool_if_up:
  * This function allocates a number of Rx buffers from the fill ring
  * or the internal recycle mechanism and places them on the Rx ring.
  *
- * Returns false if all allocations were successful, true if any fail.
+ * Returns true if all allocations were successful, false if any fail.
  */
 bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
 	struct ice_rx_buf *rx_buf;
-	bool ret = false;
+	bool ok = true;
 	dma_addr_t dma;
 
 	if (!count)
-		return false;
+		return true;
 
 	rx_desc = ICE_RX_DESC(rx_ring, ntu);
 	rx_buf = &rx_ring->rx_buf[ntu];
@@ -427,7 +427,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 	do {
 		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool);
 		if (!rx_buf->xdp) {
-			ret = true;
+			ok = false;
 			break;
 		}
 
@@ -452,7 +452,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 		ice_release_rx_desc(rx_ring, ntu);
 	}
 
-	return ret;
+	return ok;
 }
 
 /**
-- 
2.30.1




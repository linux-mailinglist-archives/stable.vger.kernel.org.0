Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C803AEE3A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhFUQ1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhFUQZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE236128A;
        Mon, 21 Jun 2021 16:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292502;
        bh=9YYe7ZqJ7+65s68bUX18QLvHYeEpE8mpjaZEI1M5D/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GpcWtAIZS8F0jCf5AR4swOitgLw/ru5eQs+BjbZ3BmcYT9T51ffdiO/QE9dWdU+s
         4CNpZv7PNB3XCYd58QLxU6eFaZNS14+elfZIH02HdswZVF9vY2JPYEP6B2NqFo0lb2
         QJORGpiMDbe/qzQT8/YsQWlAmdcB6VfUnG8B6P2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/146] ice: parameterize functions responsible for Tx ring management
Date:   Mon, 21 Jun 2021 18:14:14 +0200
Message-Id: <20210621154912.093482985@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 2e84f6b3773f43263124c76499c0c4ec3f40aa9b ]

Commit ae15e0ba1b33 ("ice: Change number of XDP Tx queues to match
number of Rx queues") tried to address the incorrect setting of XDP
queue count that was based on the Tx queue count, whereas in theory we
should provide the XDP queue per Rx queue. However, the routines that
setup and destroy the set of Tx resources are still based on the
vsi->num_txq.

Ice supports the asynchronous Tx/Rx queue count, so for a setup where
vsi->num_txq > vsi->num_rxq, ice_vsi_stop_tx_rings and ice_vsi_cfg_txqs
will be accessing the vsi->xdp_rings out of the bounds.

Parameterize two mentioned functions so they get the size of Tx resources
array as the input.

Fixes: ae15e0ba1b33 ("ice: Change number of XDP Tx queues to match number of Rx queues")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index fb20c6971f4c..dc944d605a74 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1705,12 +1705,13 @@ setup_rings:
  * ice_vsi_cfg_txqs - Configure the VSI for Tx
  * @vsi: the VSI being configured
  * @rings: Tx ring array to be configured
+ * @count: number of Tx ring array elements
  *
  * Return 0 on success and a negative value on error
  * Configure the Tx VSI for operation.
  */
 static int
-ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings)
+ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings, u16 count)
 {
 	struct ice_aqc_add_tx_qgrp *qg_buf;
 	u16 q_idx = 0;
@@ -1722,7 +1723,7 @@ ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings)
 
 	qg_buf->num_txqs = 1;
 
-	for (q_idx = 0; q_idx < vsi->num_txq; q_idx++) {
+	for (q_idx = 0; q_idx < count; q_idx++) {
 		err = ice_vsi_cfg_txq(vsi, rings[q_idx], qg_buf);
 		if (err)
 			goto err_cfg_txqs;
@@ -1742,7 +1743,7 @@ err_cfg_txqs:
  */
 int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
 {
-	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings);
+	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings, vsi->num_txq);
 }
 
 /**
@@ -1757,7 +1758,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
 	int ret;
 	int i;
 
-	ret = ice_vsi_cfg_txqs(vsi, vsi->xdp_rings);
+	ret = ice_vsi_cfg_txqs(vsi, vsi->xdp_rings, vsi->num_xdp_txq);
 	if (ret)
 		return ret;
 
@@ -1955,17 +1956,18 @@ int ice_vsi_stop_all_rx_rings(struct ice_vsi *vsi)
  * @rst_src: reset source
  * @rel_vmvf_num: Relative ID of VF/VM
  * @rings: Tx ring array to be stopped
+ * @count: number of Tx ring array elements
  */
 static int
 ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
-		      u16 rel_vmvf_num, struct ice_ring **rings)
+		      u16 rel_vmvf_num, struct ice_ring **rings, u16 count)
 {
 	u16 q_idx;
 
 	if (vsi->num_txq > ICE_LAN_TXQ_MAX_QDIS)
 		return -EINVAL;
 
-	for (q_idx = 0; q_idx < vsi->num_txq; q_idx++) {
+	for (q_idx = 0; q_idx < count; q_idx++) {
 		struct ice_txq_meta txq_meta = { };
 		int status;
 
@@ -1993,7 +1995,7 @@ int
 ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			  u16 rel_vmvf_num)
 {
-	return ice_vsi_stop_tx_rings(vsi, rst_src, rel_vmvf_num, vsi->tx_rings);
+	return ice_vsi_stop_tx_rings(vsi, rst_src, rel_vmvf_num, vsi->tx_rings, vsi->num_txq);
 }
 
 /**
@@ -2002,7 +2004,7 @@ ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
  */
 int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi)
 {
-	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings);
+	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings, vsi->num_xdp_txq);
 }
 
 /**
-- 
2.30.2




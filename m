Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABFE5290F7
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244605AbiEPUHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349648AbiEPUAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2050E42EDD;
        Mon, 16 May 2022 12:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B4F60ED0;
        Mon, 16 May 2022 19:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F52C385AA;
        Mon, 16 May 2022 19:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730819;
        bh=F1CCOG2LTf3l8bdmYcTfYACHq8uRKBCAoBGQK7amE2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O31vF2uO3y3D3yjg3texrKXm2h16yRYz7gTKs6QmUv5DbpdhLNhnDDRno43ofLEsp
         ofvEiIOcTiKJvEhkMYpGg0f8McAd7HU3/RCRANq5KlGzq2pl5jquXta42NvL81Jzgq
         zuM4cO6SM7aDOQcKl3vsdr7iFAngNOi5ZjNFsTsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 016/114] ice: clear stale Tx queue settings before configuring
Date:   Mon, 16 May 2022 21:35:50 +0200
Message-Id: <20220516193625.962990265@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

[ Upstream commit 6096dae926a22e2892ef9169f582589c16d39639 ]

The iAVF driver uses 3 virtchnl op codes to communicate with the PF
regarding the VF Tx queues:

* VIRTCHNL_OP_CONFIG_VSI_QUEUES configures the hardware and firmware
logic for the Tx queues

* VIRTCHNL_OP_ENABLE_QUEUES configures the queue interrupts

* VIRTCHNL_OP_DISABLE_QUEUES disables the queue interrupts and Tx rings.

There is a bug in the iAVF driver due to the race condition between VF
reset request and shutdown being executed in parallel. This leads to a
break in logic and VIRTCHNL_OP_DISABLE_QUEUES is not being sent.

If this occurs, the PF driver never cleans up the Tx queues. This results
in leaving behind stale Tx queue settings in the hardware and firmware.

The most obvious outcome is that upon the next
VIRTCHNL_OP_CONFIG_VSI_QUEUES, the PF will fail to program the Tx
scheduler node due to a lack of space.

We need to protect ICE driver against such situation.

To fix this, make sure we clear existing stale settings out when
handling VIRTCHNL_OP_CONFIG_VSI_QUEUES. This ensures we remove the
previous settings.

Calling ice_vf_vsi_dis_single_txq should be safe as it will do nothing if
the queue is not configured. The function already handles the case when the
Tx queue is not currently configured and exits with a 0 return in that
case.

Fixes: 7ad15440acf8 ("ice: Refactor VIRTCHNL_OP_CONFIG_VSI_QUEUES handling")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 68 ++++++++++++++-----
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 2bee8f10ad89..0cc8b7e06b72 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3300,13 +3300,52 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 				     NULL, 0);
 }
 
+/**
+ * ice_vf_vsi_dis_single_txq - disable a single Tx queue
+ * @vf: VF to disable queue for
+ * @vsi: VSI for the VF
+ * @q_id: VF relative (0-based) queue ID
+ *
+ * Attempt to disable the Tx queue passed in. If the Tx queue was successfully
+ * disabled then clear q_id bit in the enabled queues bitmap and return
+ * success. Otherwise return error.
+ */
+static int
+ice_vf_vsi_dis_single_txq(struct ice_vf *vf, struct ice_vsi *vsi, u16 q_id)
+{
+	struct ice_txq_meta txq_meta = { 0 };
+	struct ice_tx_ring *ring;
+	int err;
+
+	if (!test_bit(q_id, vf->txq_ena))
+		dev_dbg(ice_pf_to_dev(vsi->back), "Queue %u on VSI %u is not enabled, but stopping it anyway\n",
+			q_id, vsi->vsi_num);
+
+	ring = vsi->tx_rings[q_id];
+	if (!ring)
+		return -EINVAL;
+
+	ice_fill_txq_meta(vsi, ring, &txq_meta);
+
+	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id, ring, &txq_meta);
+	if (err) {
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
+			q_id, vsi->vsi_num);
+		return err;
+	}
+
+	/* Clear enabled queues flag */
+	clear_bit(q_id, vf->txq_ena);
+
+	return 0;
+}
+
 /**
  * ice_vc_dis_qs_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
  *
- * called from the VF to disable all or specific
- * queue(s)
+ * called from the VF to disable all or specific queue(s)
  */
 static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 {
@@ -3343,30 +3382,15 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 		q_map = vqs->tx_queues;
 
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			struct ice_tx_ring *ring = vsi->tx_rings[vf_q_id];
-			struct ice_txq_meta txq_meta = { 0 };
-
 			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
 
-			if (!test_bit(vf_q_id, vf->txq_ena))
-				dev_dbg(ice_pf_to_dev(vsi->back), "Queue %u on VSI %u is not enabled, but stopping it anyway\n",
-					vf_q_id, vsi->vsi_num);
-
-			ice_fill_txq_meta(vsi, ring, &txq_meta);
-
-			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
-						 ring, &txq_meta)) {
-				dev_err(ice_pf_to_dev(vsi->back), "Failed to stop Tx ring %d on VSI %d\n",
-					vf_q_id, vsi->vsi_num);
+			if (ice_vf_vsi_dis_single_txq(vf, vsi, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
-
-			/* Clear enabled queues flag */
-			clear_bit(vf_q_id, vf->txq_ena);
 		}
 	}
 
@@ -3615,6 +3639,14 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		if (qpi->txq.ring_len > 0) {
 			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
 			vsi->tx_rings[i]->count = qpi->txq.ring_len;
+
+			/* Disable any existing queue first */
+			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+
+			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
-- 
2.35.1




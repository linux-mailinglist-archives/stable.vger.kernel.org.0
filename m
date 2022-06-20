Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF675551A4E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbiFTNB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239153AbiFTNBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:01:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0651A3A8;
        Mon, 20 Jun 2022 05:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5213ECE138D;
        Mon, 20 Jun 2022 12:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390C2C3411B;
        Mon, 20 Jun 2022 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729826;
        bh=ULXuZEx+wPprd2ATZdU7/l5I6Y3n1V0jGzccBRPto+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5wCsvGSAO44I06SqCRYHkk90FLKBmnCIJQSu8LNjQFf2Tx58F9+OjDmqYe///Ubw
         s2QpzIlcbinMoTBIGjJwz7pKkVh4FLNU/XhvpoEwlwkFsvJQctH9kD/N8KR5rCAYjs
         X59/N7AWj5QadAba4BNI1Pl7dC2rKpUMSmeUdLT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 078/141] ice: Fix queue config fail handling
Date:   Mon, 20 Jun 2022 14:50:16 +0200
Message-Id: <20220620124731.844684308@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

[ Upstream commit be2af71496a54a7195ac62caba6fab49cfe5006c ]

Disable VF's RX/TX queues, when VIRTCHNL_OP_CONFIG_VSI_QUEUES fail.
Not disabling them might lead to scenario, where PF driver leaves VF
queues enabled, when VF's VSI failed queue config.
In this scenario VF should not have RX/TX queues enabled. If PF failed
to set up VF's queues, VF will reset due to TX timeouts in VF driver.
Initialize iterator 'i' to -1, so if error happens prior to configuring
queues then error path code will not disable queue 0. Loop that
configures queues will is using same iterator, so error path code will
only disable queues that were configured.

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")
Suggested-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 53 +++++++++----------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 5405a0e752cf..da7c5ce15be0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1587,35 +1587,27 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
  */
 static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 {
-	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_vsi_queue_config_info *qci =
 	    (struct virtchnl_vsi_queue_config_info *)msg;
 	struct virtchnl_queue_pair_info *qpi;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
-	int i, q_idx;
+	int i = -1, q_idx;
 
-	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
 		goto error_param;
-	}
 
-	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id)) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!ice_vc_isvalid_vsi_id(vf, qci->vsi_id))
 		goto error_param;
-	}
 
 	vsi = ice_get_vf_vsi(vf);
-	if (!vsi) {
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (!vsi)
 		goto error_param;
-	}
 
 	if (qci->num_queue_pairs > ICE_MAX_RSS_QS_PER_VF ||
 	    qci->num_queue_pairs > min_t(u16, vsi->alloc_txq, vsi->alloc_rxq)) {
 		dev_err(ice_pf_to_dev(pf), "VF-%d requesting more than supported number of queues: %d\n",
 			vf->vf_id, min_t(u16, vsi->alloc_txq, vsi->alloc_rxq));
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
@@ -1628,7 +1620,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
 		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
 		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
 
@@ -1638,7 +1629,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		 * for selected "vsi"
 		 */
 		if (q_idx >= vsi->alloc_txq || q_idx >= vsi->alloc_rxq) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
 
@@ -1648,14 +1638,13 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			vsi->tx_rings[i]->count = qpi->txq.ring_len;
 
 			/* Disable any existing queue first */
-			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx))
 				goto error_param;
-			}
 
 			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure TX queue %d\n",
+					 vf->vf_id, i);
 				goto error_param;
 			}
 		}
@@ -1669,17 +1658,13 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (qpi->rxq.databuffer_size != 0 &&
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
-			     qpi->rxq.databuffer_size < 1024)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			     qpi->rxq.databuffer_size < 1024))
 				goto error_param;
-			}
 			vsi->rx_buf_len = qpi->rxq.databuffer_size;
 			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
 			if (qpi->rxq.max_pkt_size > max_frame_size ||
-			    qpi->rxq.max_pkt_size < 64) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			    qpi->rxq.max_pkt_size < 64)
 				goto error_param;
-			}
 
 			vsi->max_frame = qpi->rxq.max_pkt_size;
 			/* add space for the port VLAN since the VF driver is
@@ -1690,16 +1675,30 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 				vsi->max_frame += VLAN_HLEN;
 
 			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
-				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure RX queue %d\n",
+					 vf->vf_id, i);
 				goto error_param;
 			}
 		}
 	}
 
+	/* send the response to the VF */
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				     VIRTCHNL_STATUS_SUCCESS, NULL, 0);
 error_param:
+	/* disable whatever we can */
+	for (; i >= 0; i--) {
+		if (ice_vsi_ctrl_one_rx_ring(vsi, false, i, true))
+			dev_err(ice_pf_to_dev(pf), "VF-%d could not disable RX queue %d\n",
+				vf->vf_id, i);
+		if (ice_vf_vsi_dis_single_txq(vf, vsi, i))
+			dev_err(ice_pf_to_dev(pf), "VF-%d could not disable TX queue %d\n",
+				vf->vf_id, i);
+	}
+
 	/* send the response to the VF */
-	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES, v_ret,
-				     NULL, 0);
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
+				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
 }
 
 /**
-- 
2.35.1




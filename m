Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817CB2F47A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfE3Eit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbfE3DMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CF8E23C5A;
        Thu, 30 May 2019 03:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185962;
        bh=CV2P2AQ9r4NomortA6jE1SZ0yiNzLAxNBhcm96WN2f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lS3+SALXMhQaBuE3rC6Gq00wcoImTmF+8iEm01A3SL2X/00rc8Wq/AVeZFkhqFGJD
         Ex/eg6KdN+1SZtvx0J9BtONM647sFU2bAUKFxpqy4QJ9RIAOzUIPGHs1nQFTMHNrDN
         q4GsM23lQK4T1XU9Sae+dSywNsiwl3Ur6FTKj6p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 339/405] ice: Fix issue with VF reset and multiple VFs support on PFs
Date:   Wed, 29 May 2019 20:05:37 -0700
Message-Id: <20190530030557.848317296@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 42b2cc83afb4d1afcf7794148dd4e8e45ba32943 ]

This patch fixes issues with VF queues being disabled, and VF netdev
network carrier being lost after reset. Basically, we need to check if VF
is enabled, and queue configured in reset_all_vfs flow, and disable/enable
those queues appropriately whenever the function is called after
Global/CORER/PFR reset/rebuild/replay.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 57155b4a59dc1..8b1ee9f3a39d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -764,6 +764,7 @@ static void ice_cleanup_and_realloc_vf(struct ice_vf *vf)
 bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 {
 	struct ice_hw *hw = &pf->hw;
+	struct ice_vf *vf;
 	int v, i;
 
 	/* If we don't have any VFs, then there is nothing to reset */
@@ -778,12 +779,17 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	for (v = 0; v < pf->num_alloc_vfs; v++)
 		ice_trigger_vf_reset(&pf->vf[v], is_vflr);
 
-	/* Call Disable LAN Tx queue AQ call with VFR bit set and 0
-	 * queues to inform Firmware about VF reset.
-	 */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
-		ice_dis_vsi_txq(pf->vsi[0]->port_info, 0, NULL, NULL,
-				ICE_VF_RESET, v, NULL);
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		struct ice_vsi *vsi;
+
+		vf = &pf->vf[v];
+		vsi = pf->vsi[vf->lan_vsi_idx];
+		if (test_bit(ICE_VF_STATE_ENA, vf->vf_states)) {
+			ice_vsi_stop_lan_tx_rings(vsi, ICE_VF_RESET, vf->vf_id);
+			ice_vsi_stop_rx_rings(vsi);
+			clear_bit(ICE_VF_STATE_ENA, vf->vf_states);
+		}
+	}
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
@@ -796,9 +802,9 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 
 		/* Check each VF in sequence */
 		while (v < pf->num_alloc_vfs) {
-			struct ice_vf *vf = &pf->vf[v];
 			u32 reg;
 
+			vf = &pf->vf[v];
 			reg = rd32(hw, VPGEN_VFRSTAT(vf->vf_id));
 			if (!(reg & VPGEN_VFRSTAT_VFRD_M))
 				break;
-- 
2.20.1




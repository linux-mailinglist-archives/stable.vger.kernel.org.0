Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D632F45C381
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346717AbhKXNjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352262AbhKXNhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:37:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C15761D7C;
        Wed, 24 Nov 2021 12:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758533;
        bh=h2FQ6c81wvOsp7iDw64ZL7YMBzZnOHCOfq69dHuhyps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mt3xh9qkSbBQ624OzmmtXKb4520PWz8vPTEVs3fbViTJmaC4K8HDXarhTNdFjWD6f
         NQrzotxBGuwXNMIgXd6ya8b7PLprpYL8SPdy2jXYp6I6uxavb7Cf+fMq0kV2gFn8J+
         UJqZK6jKz6C/CUXrfNGdrydF7qtyELtuFHU5s/7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Eryk Rybak <eryk.roch.rybak@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/154] i40e: Fix correct max_pkt_size on VF RX queue
Date:   Wed, 24 Nov 2021 12:58:16 +0100
Message-Id: <20211124115705.527264811@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

[ Upstream commit 6afbd7b3c53cb7417189f476e99d431daccb85b0 ]

Setting VLAN port increasing RX queue max_pkt_size
by 4 bytes to take VLAN tag into account.
Trigger the VF reset when setting port VLAN for
VF to renegotiate its capabilities and reinitialize.

Fixes: ba4e003d29c1 ("i40e: don't hold spinlock while resetting VF")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 53 ++++---------------
 1 file changed, 9 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index a02167cce81e1..dacd1453b7311 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -621,14 +621,13 @@ static int i40e_config_vsi_rx_queue(struct i40e_vf *vf, u16 vsi_id,
 				    u16 vsi_queue_id,
 				    struct virtchnl_rxq_info *info)
 {
+	u16 pf_queue_id = i40e_vc_get_pf_queue_id(vf, vsi_id, vsi_queue_id);
 	struct i40e_pf *pf = vf->pf;
+	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_hmc_obj_rxq rx_ctx;
-	u16 pf_queue_id;
 	int ret = 0;
 
-	pf_queue_id = i40e_vc_get_pf_queue_id(vf, vsi_id, vsi_queue_id);
-
 	/* clear the context structure first */
 	memset(&rx_ctx, 0, sizeof(struct i40e_hmc_obj_rxq));
 
@@ -666,6 +665,10 @@ static int i40e_config_vsi_rx_queue(struct i40e_vf *vf, u16 vsi_id,
 	}
 	rx_ctx.rxmax = info->max_pkt_size;
 
+	/* if port VLAN is configured increase the max packet size */
+	if (vsi->info.pvid)
+		rx_ctx.rxmax += VLAN_HLEN;
+
 	/* enable 32bytes desc always */
 	rx_ctx.dsize = 1;
 
@@ -4133,34 +4136,6 @@ error_param:
 	return ret;
 }
 
-/**
- * i40e_vsi_has_vlans - True if VSI has configured VLANs
- * @vsi: pointer to the vsi
- *
- * Check if a VSI has configured any VLANs. False if we have a port VLAN or if
- * we have no configured VLANs. Do not call while holding the
- * mac_filter_hash_lock.
- */
-static bool i40e_vsi_has_vlans(struct i40e_vsi *vsi)
-{
-	bool have_vlans;
-
-	/* If we have a port VLAN, then the VSI cannot have any VLANs
-	 * configured, as all MAC/VLAN filters will be assigned to the PVID.
-	 */
-	if (vsi->info.pvid)
-		return false;
-
-	/* Since we don't have a PVID, we know that if the device is in VLAN
-	 * mode it must be because of a VLAN filter configured on this VSI.
-	 */
-	spin_lock_bh(&vsi->mac_filter_hash_lock);
-	have_vlans = i40e_is_vsi_in_vlan(vsi);
-	spin_unlock_bh(&vsi->mac_filter_hash_lock);
-
-	return have_vlans;
-}
-
 /**
  * i40e_ndo_set_vf_port_vlan
  * @netdev: network interface device structure
@@ -4217,19 +4192,9 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 		/* duplicate request, so just return success */
 		goto error_pvid;
 
-	if (i40e_vsi_has_vlans(vsi)) {
-		dev_err(&pf->pdev->dev,
-			"VF %d has already configured VLAN filters and the administrator is requesting a port VLAN override.\nPlease unload and reload the VF driver for this change to take effect.\n",
-			vf_id);
-		/* Administrator Error - knock the VF offline until he does
-		 * the right thing by reconfiguring his network correctly
-		 * and then reloading the VF driver.
-		 */
-		i40e_vc_disable_vf(vf);
-		/* During reset the VF got a new VSI, so refresh the pointer. */
-		vsi = pf->vsi[vf->lan_vsi_idx];
-	}
-
+	i40e_vc_disable_vf(vf);
+	/* During reset the VF got a new VSI, so refresh a pointer. */
+	vsi = pf->vsi[vf->lan_vsi_idx];
 	/* Locked once because multiple functions below iterate list */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-- 
2.33.0




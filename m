Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4652643A231
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhJYTqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237523AbhJYTnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E91B61139;
        Mon, 25 Oct 2021 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190682;
        bh=U0vi0MZ8f1QngSqRnmLm7ReHf9WqO2yIQKq40QVYdmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2xojGSAc4I66bD2BdXavOU4TGK/o8WPg1EiWNZD8MdohnRwunu0unNtetxHyITwZ
         KQ0Wy3yP0ocrLwop3d4Jd5GAAGYS0kZx6ob2KgmGhavXU+ZA993GzuL+HiB9h1bspt
         ZoqIzD32nqaOb3V++trR9CgZD7/se9CfZ5YV1OOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Jerzy Wiktor Jurkowski <jerzy.wiktor.jurkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 028/169] ice: Fix failure to re-add LAN/RDMA Tx queues
Date:   Mon, 25 Oct 2021 21:13:29 +0200
Message-Id: <20211025191021.452718548@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit ff7e93219442f5ac5b2cfd33e4fe4b7d5942f957 ]

Currently if the VSI is rebuilt/removed and the RDMA PF driver is active
the RDMA Tx queue scheduler node configuration will not be cleaned up.
This will cause the rebuild/re-add of the VSI to fail due to the
software structures not being correctly cleaned up for the VSI index.
Fix this by always calling ice_rm_vsi_rdma_cfg() for all VSI. If there
are no RDMA scheduler nodes created, then there is no harm in calling
ice_rm_vsi_rdma_cfg(). This change applies to all VSI types, so if
RDMA support is added for other VSI types they will also get this
change.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Jerzy Wiktor Jurkowski <jerzy.wiktor.jurkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c   |  9 +++++++++
 drivers/net/ethernet/intel/ice/ice_sched.c | 13 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_sched.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index dde9802c6c72..b718e196af2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2841,6 +2841,7 @@ void ice_napi_del(struct ice_vsi *vsi)
  */
 int ice_vsi_release(struct ice_vsi *vsi)
 {
+	enum ice_status err;
 	struct ice_pf *pf;
 
 	if (!vsi->back)
@@ -2912,6 +2913,10 @@ int ice_vsi_release(struct ice_vsi *vsi)
 
 	ice_fltr_remove_all(vsi);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
+	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
+	if (err)
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
+			vsi->vsi_num, err);
 	ice_vsi_delete(vsi);
 	ice_vsi_free_q_vectors(vsi);
 
@@ -3092,6 +3097,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	prev_num_q_vectors = ice_vsi_rebuild_get_coalesce(vsi, coalesce);
 
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
+	ret = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
+	if (ret)
+		dev_err(ice_pf_to_dev(vsi->back), "Failed to remove RDMA scheduler config for VSI %u, err %d\n",
+			vsi->vsi_num, ret);
 	ice_vsi_free_q_vectors(vsi);
 
 	/* SR-IOV determines needed MSIX resources all at once instead of per
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 9f07b6641705..2d9b10277186 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2070,6 +2070,19 @@ enum ice_status ice_rm_vsi_lan_cfg(struct ice_port_info *pi, u16 vsi_handle)
 	return ice_sched_rm_vsi_cfg(pi, vsi_handle, ICE_SCHED_NODE_OWNER_LAN);
 }
 
+/**
+ * ice_rm_vsi_rdma_cfg - remove VSI and its RDMA children nodes
+ * @pi: port information structure
+ * @vsi_handle: software VSI handle
+ *
+ * This function clears the VSI and its RDMA children nodes from scheduler tree
+ * for all TCs.
+ */
+enum ice_status ice_rm_vsi_rdma_cfg(struct ice_port_info *pi, u16 vsi_handle)
+{
+	return ice_sched_rm_vsi_cfg(pi, vsi_handle, ICE_SCHED_NODE_OWNER_RDMA);
+}
+
 /**
  * ice_get_agg_info - get the aggregator ID
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 9beef8f0ec76..fdf7a5882f07 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -89,6 +89,7 @@ enum ice_status
 ice_sched_cfg_vsi(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 maxqs,
 		  u8 owner, bool enable);
 enum ice_status ice_rm_vsi_lan_cfg(struct ice_port_info *pi, u16 vsi_handle);
+enum ice_status ice_rm_vsi_rdma_cfg(struct ice_port_info *pi, u16 vsi_handle);
 
 /* Tx scheduler rate limiter functions */
 enum ice_status
-- 
2.33.0




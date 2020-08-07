Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF50923F409
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgHGUz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:55:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:62789 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgHGUz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 16:55:27 -0400
IronPort-SDR: GeQdj0VJkmvdRMx2G29Cd9ULLdpDDZey2c4hAt0iBJcBV3lmqovBQosYafj4q2DO2cAtj3C+IH
 /kYQNaWs6jxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="133260788"
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="133260788"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
IronPort-SDR: K1PSrQI0ON2/ren+hZWcymvkRyG1opCs85ycdBdqCEk7QQz9eC5dCkqIlOD2k7ErQh0J8Hn1CK
 xOSgz9ybFiiA==
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="325878074"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     stable@vger.kernel.org
Cc:     Martyna Szapar <martyna.szapar@intel.com>,
        aleksandr.loktionov@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH stable 4.19 3/4] i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
Date:   Fri,  7 Aug 2020 13:55:16 -0700
Message-Id: <20200807205517.1740307-4-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
References: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martyna Szapar <martyna.szapar@intel.com>

[ Upstream commit 24474f2709af6729b9b1da1c5e160ab62e25e3a4 ]

Fixed possible memory leak in i40e_vc_add_cloud_filter function:
cfilter is being allocated and in some error conditions
the function returns without freeing the memory.

Fix of integer truncation from u16 (type of queue_id value) to u8
when calling i40e_vc_isvalid_queue_id function.

Fixes: e284fc280473b ("i40e: Add and delete cloud filter")
Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index b26e41acd993..c19da0ff888e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -181,7 +181,7 @@ static inline bool i40e_vc_isvalid_vsi_id(struct i40e_vf *vf, u16 vsi_id)
  * check for the valid queue id
  **/
 static inline bool i40e_vc_isvalid_queue_id(struct i40e_vf *vf, u16 vsi_id,
-					    u8 qid)
+					    u16 qid)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = i40e_find_vsi_from_id(pf, vsi_id);
@@ -3345,7 +3345,7 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	if (!vf->adq_enabled) {
@@ -3353,15 +3353,15 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 			 "VF %d: ADq is not enabled, can't apply cloud filter\n",
 			 vf->vf_id);
 		aq_ret = I40E_ERR_PARAM;
-		goto err;
+		goto err_out;
 	}
 
 	if (i40e_validate_cloud_filter(vf, vcf)) {
 		dev_info(&pf->pdev->dev,
 			 "VF %d: Invalid input/s, can't apply cloud filter\n",
 			 vf->vf_id);
-			aq_ret = I40E_ERR_PARAM;
-			goto err;
+		aq_ret = I40E_ERR_PARAM;
+		goto err_out;
 	}
 
 	cfilter = kzalloc(sizeof(*cfilter), GFP_KERNEL);
@@ -3422,13 +3422,17 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 			"VF %d: Failed to add cloud filter, err %s aq_err %s\n",
 			vf->vf_id, i40e_stat_str(&pf->hw, ret),
 			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
-		goto err;
+		goto err_free;
 	}
 
 	INIT_HLIST_NODE(&cfilter->cloud_node);
 	hlist_add_head(&cfilter->cloud_node, &vf->cloud_filter_list);
+	/* release the pointer passing it to the collection */
+	cfilter = NULL;
 	vf->num_cloud_filters++;
-err:
+err_free:
+	kfree(cfilter);
+err_out:
 	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ADD_CLOUD_FILTER,
 				       aq_ret);
 }
-- 
2.25.4


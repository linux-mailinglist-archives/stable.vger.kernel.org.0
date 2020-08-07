Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F78E23F408
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgHGUz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:55:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:62789 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgHGUz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 16:55:27 -0400
IronPort-SDR: A+EAqDOdF8PRdPNN26WCQhPErDmHynHjvjWvLaUOorf3CfZAZ1n3lwXfKFBvl4KN0J3lhR/NGK
 B/qeReXPOouA==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="133260789"
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="133260789"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
IronPort-SDR: YwP2sguFsUcx8LsqR+m5ixHThGkVO3a2WVEMjWZV6iW+1OeDEEdx5vQG7Cf1c/+QEwGMRo3c99
 lfzQC7kOdV3Q==
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="325878077"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     stable@vger.kernel.org
Cc:     Martyna Szapar <martyna.szapar@intel.com>,
        aleksandr.loktionov@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH stable 4.19 4/4] i40e: Memory leak in i40e_config_iwarp_qvlist
Date:   Fri,  7 Aug 2020 13:55:17 -0700
Message-Id: <20200807205517.1740307-5-jesse.brandeburg@intel.com>
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

[ Upstream commit 0b63644602cfcbac849f7ea49272a39e90fa95eb ]

Added freeing the old allocation of vf->qvlist_info in function
i40e_config_iwarp_qvlist before overwriting it with
the new allocation.

Fixes: e3219ce6a7754 ("i40e: Add support for client interface for IWARP driver")
Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index c19da0ff888e..bc4eda52372a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -441,6 +441,7 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	u32 v_idx, i, reg_idx, reg;
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
+	int ret = 0;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
 
@@ -449,16 +450,19 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
 			 qvlist_info->num_vectors,
 			 msix_vf);
-		goto err;
+		ret = -EINVAL;
+		goto err_out;
 	}
 
 	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));
+	kfree(vf->qvlist_info);
 	vf->qvlist_info = kzalloc(size, GFP_KERNEL);
-	if (!vf->qvlist_info)
-		return -ENOMEM;
-
+	if (!vf->qvlist_info) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
 	vf->qvlist_info->num_vectors = qvlist_info->num_vectors;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
@@ -469,8 +473,10 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 		v_idx = qv_info->v_idx;
 
 		/* Validate vector id belongs to this vf */
-		if (!i40e_vc_isvalid_vector_id(vf, v_idx))
-			goto err;
+		if (!i40e_vc_isvalid_vector_id(vf, v_idx)) {
+			ret = -EINVAL;
+			goto err_free;
+		}
 
 		vf->qvlist_info->qv_info[i] = *qv_info;
 
@@ -512,10 +518,11 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	}
 
 	return 0;
-err:
+err_free:
 	kfree(vf->qvlist_info);
 	vf->qvlist_info = NULL;
-	return -EINVAL;
+err_out:
+	return ret;
 }
 
 /**
-- 
2.25.4


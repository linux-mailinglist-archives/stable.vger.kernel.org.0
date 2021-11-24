Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0413B45C7E0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349016AbhKXOr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349953AbhKXOq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:46:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD3AA63367;
        Wed, 24 Nov 2021 13:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759200;
        bh=phX7E6ByjHq4DRsbksSXejsCwZ9Cu4cltff79SEwCCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9eVmWjCPgf9mROSGJsaybl03h8EIsJuDB2+cdfS85N+b6NqhQaurUBaJWgLn9PEW
         0h4GMD4DRjo9ixa3+lF71kQi996AfzF9tupk3tBUiulosg10PYMcN1IUX6BGdzUQZb
         2onkfikNcOFa7ScxVHwtXwf6UsF6Jy15ixhDgrZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/279] i40e: Fix warning message and call stack during rmmod i40e driver
Date:   Wed, 24 Nov 2021 12:57:32 +0100
Message-Id: <20211124115724.458840663@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

[ Upstream commit 3a3b311e3881172fc8e019b6508f04bc40c92d9d ]

Restore part of reset functionality used when reset is called
from the VF to reset itself. Without this fix warning message
is displayed when VF is being removed via sysfs.

Fix the crash of the VF during reset by ensuring
that the PF receives the reset message successfully.
Refactor code to use one function instead of two.

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 53 ++++++++-----------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2102db11972a7..80ae264c99ba0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -183,17 +183,18 @@ void i40e_vc_notify_vf_reset(struct i40e_vf *vf)
 /***********************misc routines*****************************/
 
 /**
- * i40e_vc_disable_vf
+ * i40e_vc_reset_vf
  * @vf: pointer to the VF info
- *
- * Disable the VF through a SW reset.
+ * @notify_vf: notify vf about reset or not
+ * Reset VF handler.
  **/
-static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
+static void i40e_vc_reset_vf(struct i40e_vf *vf, bool notify_vf)
 {
 	struct i40e_pf *pf = vf->pf;
 	int i;
 
-	i40e_vc_notify_vf_reset(vf);
+	if (notify_vf)
+		i40e_vc_notify_vf_reset(vf);
 
 	/* We want to ensure that an actual reset occurs initiated after this
 	 * function was called. However, we do not want to wait forever, so
@@ -211,9 +212,14 @@ static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
 		usleep_range(10000, 20000);
 	}
 
-	dev_warn(&vf->pf->pdev->dev,
-		 "Failed to initiate reset for VF %d after 200 milliseconds\n",
-		 vf->vf_id);
+	if (notify_vf)
+		dev_warn(&vf->pf->pdev->dev,
+			 "Failed to initiate reset for VF %d after 200 milliseconds\n",
+			 vf->vf_id);
+	else
+		dev_dbg(&vf->pf->pdev->dev,
+			"Failed to initiate reset for VF %d after 200 milliseconds\n",
+			vf->vf_id);
 }
 
 /**
@@ -2108,20 +2114,6 @@ err:
 	return ret;
 }
 
-/**
- * i40e_vc_reset_vf_msg
- * @vf: pointer to the VF info
- *
- * called from the VF to reset itself,
- * unlike other virtchnl messages, PF driver
- * doesn't send the response back to the VF
- **/
-static void i40e_vc_reset_vf_msg(struct i40e_vf *vf)
-{
-	if (test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states))
-		i40e_reset_vf(vf, false);
-}
-
 /**
  * i40e_vc_config_promiscuous_mode_msg
  * @vf: pointer to the VF info
@@ -2617,8 +2609,7 @@ static int i40e_vc_request_queues_msg(struct i40e_vf *vf, u8 *msg)
 	} else {
 		/* successful request */
 		vf->num_req_queues = req_pairs;
-		i40e_vc_notify_vf_reset(vf);
-		i40e_reset_vf(vf, false);
+		i40e_vc_reset_vf(vf, true);
 		return 0;
 	}
 
@@ -3813,8 +3804,7 @@ static int i40e_vc_add_qch_msg(struct i40e_vf *vf, u8 *msg)
 	vf->num_req_queues = 0;
 
 	/* reset the VF in order to allocate resources */
-	i40e_vc_notify_vf_reset(vf);
-	i40e_reset_vf(vf, false);
+	i40e_vc_reset_vf(vf, true);
 
 	return I40E_SUCCESS;
 
@@ -3854,8 +3844,7 @@ static int i40e_vc_del_qch_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	/* reset the VF in order to allocate resources */
-	i40e_vc_notify_vf_reset(vf);
-	i40e_reset_vf(vf, false);
+	i40e_vc_reset_vf(vf, true);
 
 	return I40E_SUCCESS;
 
@@ -3917,7 +3906,7 @@ int i40e_vc_process_vf_msg(struct i40e_pf *pf, s16 vf_id, u32 v_opcode,
 		i40e_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
-		i40e_vc_reset_vf_msg(vf);
+		i40e_vc_reset_vf(vf, false);
 		ret = 0;
 		break;
 	case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
@@ -4171,7 +4160,7 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	/* Force the VF interface down so it has to bring up with new MAC
 	 * address
 	 */
-	i40e_vc_disable_vf(vf);
+	i40e_vc_reset_vf(vf, true);
 	dev_info(&pf->pdev->dev, "Bring down and up the VF interface to make this change effective.\n");
 
 error_param:
@@ -4235,7 +4224,7 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 		/* duplicate request, so just return success */
 		goto error_pvid;
 
-	i40e_vc_disable_vf(vf);
+	i40e_vc_reset_vf(vf, true);
 	/* During reset the VF got a new VSI, so refresh a pointer. */
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	/* Locked once because multiple functions below iterate list */
@@ -4613,7 +4602,7 @@ int i40e_ndo_set_vf_trust(struct net_device *netdev, int vf_id, bool setting)
 		goto out;
 
 	vf->trusted = setting;
-	i40e_vc_disable_vf(vf);
+	i40e_vc_reset_vf(vf, true);
 	dev_info(&pf->pdev->dev, "VF %u is now %strusted\n",
 		 vf_id, setting ? "" : "un");
 
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B18447262C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbhLMJtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58640 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbhLMJpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:45:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47182B80CAB;
        Mon, 13 Dec 2021 09:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D646C341C8;
        Mon, 13 Dec 2021 09:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388707;
        bh=bztjTswxJT5eGorYXzAJA7orxtfYDGHDLs9l0Crruxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfNMm/U4Zmz9ssnQ1gpfx0KMMZJRRYYf/nITSzbqSeb4bH4GlYlKtI3D121kshtj8
         3kaHzSPJqHTIym2cWKqRnLjhv1c8C/eLNGxJwGXblpjkujn2GkkdAj6eUOZ/w/BdBE
         kOpI2+ztFH9KOcZViHR4BXF8DG/QrAZR/s9QR6l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 52/88] i40e: Fix failed opcode appearing if handling messages from VF
Date:   Mon, 13 Dec 2021 10:30:22 +0100
Message-Id: <20211213092935.058973306@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

commit 61125b8be85dfbc7e9c7fe1cc6c6d631ab603516 upstream.

Fix failed operation code appearing if handling messages from VF.
Implemented by waiting for VF appropriate state if request starts
handle while VF reset.
Without this patch the message handling request while VF is in
a reset state ends with error -5 (I40E_ERR_PARAM).

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   70 ++++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |    2 
 2 files changed, 50 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1805,6 +1805,32 @@ static int i40e_vc_send_resp_to_vf(struc
 }
 
 /**
+ * i40e_sync_vf_state
+ * @vf: pointer to the VF info
+ * @state: VF state
+ *
+ * Called from a VF message to synchronize the service with a potential
+ * VF reset state
+ **/
+static bool i40e_sync_vf_state(struct i40e_vf *vf, enum i40e_vf_states state)
+{
+	int i;
+
+	/* When handling some messages, it needs VF state to be set.
+	 * It is possible that this flag is cleared during VF reset,
+	 * so there is a need to wait until the end of the reset to
+	 * handle the request message correctly.
+	 */
+	for (i = 0; i < I40E_VF_STATE_WAIT_COUNT; i++) {
+		if (test_bit(state, &vf->vf_states))
+			return true;
+		usleep_range(10000, 20000);
+	}
+
+	return test_bit(state, &vf->vf_states);
+}
+
+/**
  * i40e_vc_get_version_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
@@ -1864,7 +1890,7 @@ static int i40e_vc_get_vf_resources_msg(
 	size_t len = 0;
 	int ret;
 
-	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_INIT)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -2019,7 +2045,7 @@ static int i40e_vc_config_promiscuous_mo
 	bool allmulti = false;
 	bool alluni = false;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err_out;
 	}
@@ -2107,7 +2133,7 @@ static int i40e_vc_config_queues_msg(str
 	struct i40e_vsi *vsi;
 	u16 num_qps_all = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2255,7 +2281,7 @@ static int i40e_vc_config_irq_map_msg(st
 	i40e_status aq_ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2427,7 +2453,7 @@ static int i40e_vc_disable_queues_msg(st
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2477,7 +2503,7 @@ static int i40e_vc_request_queues_msg(st
 	u8 cur_pairs = vf->num_queue_pairs;
 	struct i40e_pf *pf = vf->pf;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states))
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE))
 		return -EINVAL;
 
 	if (req_pairs > I40E_MAX_VF_QUEUES) {
@@ -2523,7 +2549,7 @@ static int i40e_vc_get_stats_msg(struct
 
 	memset(&stats, 0, sizeof(struct i40e_eth_stats));
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2632,7 +2658,7 @@ static int i40e_vc_add_mac_addr_msg(stru
 	i40e_status ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, al->vsi_id)) {
 		ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -2701,7 +2727,7 @@ static int i40e_vc_del_mac_addr_msg(stru
 	i40e_status ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, al->vsi_id)) {
 		ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -2840,7 +2866,7 @@ static int i40e_vc_remove_vlan_msg(struc
 	i40e_status aq_ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -2960,9 +2986,9 @@ static int i40e_vc_config_rss_key(struct
 	struct i40e_vsi *vsi = NULL;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vrk->vsi_id) ||
-	    (vrk->key_len != I40E_HKEY_ARRAY_SIZE)) {
+	    vrk->key_len != I40E_HKEY_ARRAY_SIZE) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -2991,9 +3017,9 @@ static int i40e_vc_config_rss_lut(struct
 	i40e_status aq_ret = 0;
 	u16 i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vrl->vsi_id) ||
-	    (vrl->lut_entries != I40E_VF_HLUT_ARRAY_SIZE)) {
+	    vrl->lut_entries != I40E_VF_HLUT_ARRAY_SIZE) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3026,7 +3052,7 @@ static int i40e_vc_get_rss_hena(struct i
 	i40e_status aq_ret = 0;
 	int len = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3062,7 +3088,7 @@ static int i40e_vc_set_rss_hena(struct i
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3087,7 +3113,7 @@ static int i40e_vc_enable_vlan_stripping
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3113,7 +3139,7 @@ static int i40e_vc_disable_vlan_strippin
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3340,7 +3366,7 @@ static int i40e_vc_del_cloud_filter(stru
 	i40e_status aq_ret = 0;
 	int i, ret;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3471,7 +3497,7 @@ static int i40e_vc_add_cloud_filter(stru
 	i40e_status aq_ret = 0;
 	int i, ret;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err_out;
 	}
@@ -3580,7 +3606,7 @@ static int i40e_vc_add_qch_msg(struct i4
 	i40e_status aq_ret = 0;
 	u64 speed = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3715,7 +3741,7 @@ static int i40e_vc_del_qch_msg(struct i4
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -19,6 +19,8 @@
 
 #define I40E_MAX_VF_PROMISC_FLAGS	3
 
+#define I40E_VF_STATE_WAIT_COUNT	20
+
 /* Various queue ctrls */
 enum i40e_queue_ctrl {
 	I40E_QUEUE_CTRL_UNKNOWN = 0,



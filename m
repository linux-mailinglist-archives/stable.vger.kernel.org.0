Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43C0472844
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbhLMKKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241920AbhLMKG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBD2C0A88FE;
        Mon, 13 Dec 2021 01:51:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9AE3CE0B20;
        Mon, 13 Dec 2021 09:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24101C00446;
        Mon, 13 Dec 2021 09:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389081;
        bh=RetHuZnqBfip0a4heVmZD3ylNy5LEbRJWddKXlVsMtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9sLWm/TtIIZiZB2u/xxoDaoXg7xdrD83oki0pxRWi977Xg0Yp3KEwWf/7ygw7W6+
         osTxXSLtA3ZqaAa3R9M+o1icPmAK19Vvi6xqzbwfTun/quzHMw4QRa5IoBD3XAffNX
         Z5UVIwbmP39dt4IOZFApa3Qh5hDHvHJI1MLAEYrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 084/132] i40e: Fix failed opcode appearing if handling messages from VF
Date:   Mon, 13 Dec 2021 10:30:25 +0100
Message-Id: <20211213092942.000577110@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -1896,6 +1896,32 @@ static int i40e_vc_send_resp_to_vf(struc
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
@@ -1955,7 +1981,7 @@ static int i40e_vc_get_vf_resources_msg(
 	size_t len = 0;
 	int ret;
 
-	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_INIT)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -2077,7 +2103,7 @@ static int i40e_vc_config_promiscuous_mo
 	bool allmulti = false;
 	bool alluni = false;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err_out;
 	}
@@ -2165,7 +2191,7 @@ static int i40e_vc_config_queues_msg(str
 	struct i40e_vsi *vsi;
 	u16 num_qps_all = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2314,7 +2340,7 @@ static int i40e_vc_config_irq_map_msg(st
 	i40e_status aq_ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2486,7 +2512,7 @@ static int i40e_vc_disable_queues_msg(st
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2536,7 +2562,7 @@ static int i40e_vc_request_queues_msg(st
 	u8 cur_pairs = vf->num_queue_pairs;
 	struct i40e_pf *pf = vf->pf;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states))
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE))
 		return -EINVAL;
 
 	if (req_pairs > I40E_MAX_VF_QUEUES) {
@@ -2581,7 +2607,7 @@ static int i40e_vc_get_stats_msg(struct
 
 	memset(&stats, 0, sizeof(struct i40e_eth_stats));
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2698,7 +2724,7 @@ static int i40e_vc_add_mac_addr_msg(stru
 	i40e_status ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, al->vsi_id)) {
 		ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -2770,7 +2796,7 @@ static int i40e_vc_del_mac_addr_msg(stru
 	i40e_status ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, al->vsi_id)) {
 		ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -2914,7 +2940,7 @@ static int i40e_vc_remove_vlan_msg(struc
 	i40e_status aq_ret = 0;
 	int i;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
@@ -3034,9 +3060,9 @@ static int i40e_vc_config_rss_key(struct
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
@@ -3065,9 +3091,9 @@ static int i40e_vc_config_rss_lut(struct
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
@@ -3100,7 +3126,7 @@ static int i40e_vc_get_rss_hena(struct i
 	i40e_status aq_ret = 0;
 	int len = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3136,7 +3162,7 @@ static int i40e_vc_set_rss_hena(struct i
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3161,7 +3187,7 @@ static int i40e_vc_enable_vlan_stripping
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3187,7 +3213,7 @@ static int i40e_vc_disable_vlan_strippin
 	i40e_status aq_ret = 0;
 	struct i40e_vsi *vsi;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3414,7 +3440,7 @@ static int i40e_vc_del_cloud_filter(stru
 	i40e_status aq_ret = 0;
 	int i, ret;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3545,7 +3571,7 @@ static int i40e_vc_add_cloud_filter(stru
 	i40e_status aq_ret = 0;
 	int i, ret;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err_out;
 	}
@@ -3654,7 +3680,7 @@ static int i40e_vc_add_qch_msg(struct i4
 	i40e_status aq_ret = 0;
 	u64 speed = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
@@ -3788,7 +3814,7 @@ static int i40e_vc_del_qch_msg(struct i4
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
+	if (!i40e_sync_vf_state(vf, I40E_VF_STATE_ACTIVE)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto err;
 	}
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -18,6 +18,8 @@
 
 #define I40E_MAX_VF_PROMISC_FLAGS	3
 
+#define I40E_VF_STATE_WAIT_COUNT	20
+
 /* Various queue ctrls */
 enum i40e_queue_ctrl {
 	I40E_QUEUE_CTRL_UNKNOWN = 0,



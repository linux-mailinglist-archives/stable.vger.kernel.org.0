Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE898487818
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347522AbiAGNUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:20:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43856 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347519AbiAGNUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:20:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0182B825F0
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1512AC36AE5;
        Fri,  7 Jan 2022 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641561621;
        bh=6OWsxFyUDUAdXGUAj3pUlTBxTr2vNIP3oowUYe9o8Ho=;
        h=Subject:To:Cc:From:Date:From;
        b=Ap7lQlkN3xWqgWC1/OgxhG5mCVW0sGEQiOUHpK3ZBHHfwdcZ8ysgLb5kHWBtpUl9G
         kfwlATVuslstCbNUza4dkgTTW8JkxDaJN+4d+2s5JhulXlIh9dYK1IKo+s9qwV9TNp
         uX4fAd/kxHqC1+8I+rdKFZEbq0TYFsRcRyihkZ4A=
Subject: FAILED: patch "[PATCH] i40e: Fix to not show opcode msg on unsuccessful VF MAC" failed to apply to 4.14-stable tree
To:     mateusz.palczewski@intel.com, aleksandr.loktionov@intel.com,
        anthony.l.nguyen@intel.com, grzegorzx.szczurek@intel.com,
        paul.m.stillwell.jr@intel.com, tony.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:20:16 +0100
Message-ID: <164156161658100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 01cbf50877e602e2376af89e4a51c30bc574c618 Mon Sep 17 00:00:00 2001
From: Mateusz Palczewski <mateusz.palczewski@intel.com>
Date: Wed, 3 Mar 2021 11:45:33 +0000
Subject: [PATCH] i40e: Fix to not show opcode msg on unsuccessful VF MAC
 change

Hide i40e opcode information sent during response to VF in case when
untrusted VF tried to change MAC on the VF interface.

This is implemented by adding an additional parameter 'hide' to the
response sent to VF function that hides the display of error
information, but forwards the error code to VF.

Previously it was not possible to send response with some error code
to VF without displaying opcode information.

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2ea4deb8fc44..048f1678ab8a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1877,17 +1877,19 @@ int i40e_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 /***********************virtual channel routines******************/
 
 /**
- * i40e_vc_send_msg_to_vf
+ * i40e_vc_send_msg_to_vf_ex
  * @vf: pointer to the VF info
  * @v_opcode: virtual channel opcode
  * @v_retval: virtual channel return value
  * @msg: pointer to the msg buffer
  * @msglen: msg length
+ * @is_quiet: true for not printing unsuccessful return values, false otherwise
  *
  * send msg to VF
  **/
-static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
-				  u32 v_retval, u8 *msg, u16 msglen)
+static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
+				     u32 v_retval, u8 *msg, u16 msglen,
+				     bool is_quiet)
 {
 	struct i40e_pf *pf;
 	struct i40e_hw *hw;
@@ -1903,7 +1905,7 @@ static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
 	/* single place to detect unsuccessful return values */
-	if (v_retval) {
+	if (v_retval && !is_quiet) {
 		vf->num_invalid_msgs++;
 		dev_info(&pf->pdev->dev, "VF %d failed opcode %d, retval: %d\n",
 			 vf->vf_id, v_opcode, v_retval);
@@ -1933,6 +1935,23 @@ static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
 	return 0;
 }
 
+/**
+ * i40e_vc_send_msg_to_vf
+ * @vf: pointer to the VF info
+ * @v_opcode: virtual channel opcode
+ * @v_retval: virtual channel return value
+ * @msg: pointer to the msg buffer
+ * @msglen: msg length
+ *
+ * send msg to VF
+ **/
+static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
+				  u32 v_retval, u8 *msg, u16 msglen)
+{
+	return i40e_vc_send_msg_to_vf_ex(vf, v_opcode, v_retval,
+					 msg, msglen, false);
+}
+
 /**
  * i40e_vc_send_resp_to_vf
  * @vf: pointer to the VF info
@@ -2695,6 +2714,7 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * i40e_check_vf_permission
  * @vf: pointer to the VF info
  * @al: MAC address list from virtchnl
+ * @is_quiet: set true for printing msg without opcode info, false otherwise
  *
  * Check that the given list of MAC addresses is allowed. Will return -EPERM
  * if any address in the list is not valid. Checks the following conditions:
@@ -2709,13 +2729,15 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * addresses might not be accurate.
  **/
 static inline int i40e_check_vf_permission(struct i40e_vf *vf,
-					   struct virtchnl_ether_addr_list *al)
+					   struct virtchnl_ether_addr_list *al,
+					   bool *is_quiet)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
 	int mac2add_cnt = 0;
 	int i;
 
+	*is_quiet = false;
 	for (i = 0; i < al->num_elements; i++) {
 		struct i40e_mac_filter *f;
 		u8 *addr = al->list[i].addr;
@@ -2739,6 +2761,7 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 		    !ether_addr_equal(addr, vf->default_lan_addr.addr)) {
 			dev_err(&pf->pdev->dev,
 				"VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
+			*is_quiet = true;
 			return -EPERM;
 		}
 
@@ -2775,6 +2798,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	    (struct virtchnl_ether_addr_list *)msg;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
+	bool is_quiet = false;
 	i40e_status ret = 0;
 	int i;
 
@@ -2791,7 +2815,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	 */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-	ret = i40e_check_vf_permission(vf, al);
+	ret = i40e_check_vf_permission(vf, al, &is_quiet);
 	if (ret) {
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
 		goto error_param;
@@ -2829,8 +2853,8 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				       ret);
+	return i40e_vc_send_msg_to_vf_ex(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				       ret, NULL, 0, is_quiet);
 }
 
 /**


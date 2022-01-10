Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98A8489254
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbiAJHl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbiAJHiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:38:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BE9C09B058;
        Sun,  9 Jan 2022 23:33:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95FDAB811E3;
        Mon, 10 Jan 2022 07:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6C3C36AED;
        Mon, 10 Jan 2022 07:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799980;
        bh=lDfrkpNjtoMRFV8osMw3gxZTOWP/QrK56n6S9WjjuXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOEpGawdBmLLzyjjoQVAfPQCkfGOy3qdSnLnQzKE3w8RmuglDRfiTMZEw++ubTtC7
         joGFXpebYpv7iR/bfZjL/IdWsLTU/5u8p5oKGkS3O+UhIKV4D89+H9eneK2EqcHEzP
         ypzgysbN1hvKbhN9I/55IY1YdsoMm2CO+HOdUIhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 07/72] i40e: Fix to not show opcode msg on unsuccessful VF MAC change
Date:   Mon, 10 Jan 2022 08:22:44 +0100
Message-Id: <20220110071821.758970107@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

commit 01cbf50877e602e2376af89e4a51c30bc574c618 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   40 ++++++++++++++++-----
 1 file changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1877,17 +1877,19 @@ sriov_configure_out:
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
@@ -1903,7 +1905,7 @@ static int i40e_vc_send_msg_to_vf(struct
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
 	/* single place to detect unsuccessful return values */
-	if (v_retval) {
+	if (v_retval && !is_quiet) {
 		vf->num_invalid_msgs++;
 		dev_info(&pf->pdev->dev, "VF %d failed opcode %d, retval: %d\n",
 			 vf->vf_id, v_opcode, v_retval);
@@ -1934,6 +1936,23 @@ static int i40e_vc_send_msg_to_vf(struct
 }
 
 /**
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
+/**
  * i40e_vc_send_resp_to_vf
  * @vf: pointer to the VF info
  * @opcode: operation code
@@ -2695,6 +2714,7 @@ error_param:
  * i40e_check_vf_permission
  * @vf: pointer to the VF info
  * @al: MAC address list from virtchnl
+ * @is_quiet: set true for printing msg without opcode info, false otherwise
  *
  * Check that the given list of MAC addresses is allowed. Will return -EPERM
  * if any address in the list is not valid. Checks the following conditions:
@@ -2709,13 +2729,15 @@ error_param:
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
@@ -2739,6 +2761,7 @@ static inline int i40e_check_vf_permissi
 		    !ether_addr_equal(addr, vf->default_lan_addr.addr)) {
 			dev_err(&pf->pdev->dev,
 				"VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
+			*is_quiet = true;
 			return -EPERM;
 		}
 
@@ -2775,6 +2798,7 @@ static int i40e_vc_add_mac_addr_msg(stru
 	    (struct virtchnl_ether_addr_list *)msg;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
+	bool is_quiet = false;
 	i40e_status ret = 0;
 	int i;
 
@@ -2791,7 +2815,7 @@ static int i40e_vc_add_mac_addr_msg(stru
 	 */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-	ret = i40e_check_vf_permission(vf, al);
+	ret = i40e_check_vf_permission(vf, al, &is_quiet);
 	if (ret) {
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
 		goto error_param;
@@ -2829,8 +2853,8 @@ static int i40e_vc_add_mac_addr_msg(stru
 
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				       ret);
+	return i40e_vc_send_msg_to_vf_ex(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				       ret, NULL, 0, is_quiet);
 }
 
 /**



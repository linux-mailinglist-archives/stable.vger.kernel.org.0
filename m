Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6C4D83D6
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiCNMVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242137AbiCNMSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7CE37AB8;
        Mon, 14 Mar 2022 05:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1393B60916;
        Mon, 14 Mar 2022 12:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C3CC340F6;
        Mon, 14 Mar 2022 12:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260018;
        bh=28SPUArqDgaK25r/9hWPvGSOJw/nk2nxaabMQ4/Rt7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCV9pdR210hwpt7TQ8IhCJ3rM/bAk9GFWzy4kPCaR32hOfKiH391gETD91cpFEk92
         tHm1HsAGkYzrCpLFS++O7UsCXkFF3ilboKKCez3UMJg+vzubE3kFb69AFjLqgWcKmX
         WUdanE62DHVibZ3VY1eThIAPukcjdFnbkJ9b8/eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 034/121] i40e: stop disabling VFs due to PF error responses
Date:   Mon, 14 Mar 2022 12:53:37 +0100
Message-Id: <20220314112745.081571920@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 5710ab79166504013f7c0ae6a57e7d2fd26e5c43 ]

The i40e_vc_send_msg_to_vf_ex (and its wrapper i40e_vc_send_msg_to_vf)
function has logic to detect "failure" responses sent to the VF. If a VF
is sent more than I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED, then the VF is
marked as disabled. In either case, a dev_info message is printed
stating that a VF opcode failed.

This logic originates from the early implementation of VF support in
commit 5c3c48ac6bf5 ("i40e: implement virtual device interface").

That commit did not go far enough. The "logic" for this behavior seems
to be that error responses somehow indicate a malicious VF. This is not
really true. The PF might be sending an error for any number of reasons
such as lacking resources, an unsupported operation, etc. This does not
indicate a malicious VF. We already have a separate robust malicious VF
detection which relies on hardware logic to detect and prevent a variety
of behaviors.

There is no justification for this behavior in the original
implementation. In fact, a later commit 18b7af57d9c1 ("i40e: Lower some
message levels") reduced the opcode failure message from a dev_err to a
dev_info. In addition, recent commit 01cbf50877e6 ("i40e: Fix to not
show opcode msg on unsuccessful VF MAC change") changed the logic to
allow quieting it for expected failures.

That commit prevented this logic from kicking in for specific
circumstances. This change did not go far enough. The behavior is not
documented nor is it part of any requirement for our products. Other
operating systems such as the FreeBSD implementation of our driver do
not include this logic.

It is clear this check does not make sense, and causes problems which
led to ugly workarounds.

Fix this by just removing the entire logic and the need for the
i40e_vc_send_msg_to_vf_ex function.

Fixes: 01cbf50877e6 ("i40e: Fix to not show opcode msg on unsuccessful VF MAC change")
Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  6 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 57 +++----------------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  5 --
 3 files changed, 9 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 1e57cc8c47d7..9db5001297c7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -742,10 +742,8 @@ static void i40e_dbg_dump_vf(struct i40e_pf *pf, int vf_id)
 		vsi = pf->vsi[vf->lan_vsi_idx];
 		dev_info(&pf->pdev->dev, "vf %2d: VSI id=%d, seid=%d, qps=%d\n",
 			 vf_id, vf->lan_vsi_id, vsi->seid, vf->num_queue_pairs);
-		dev_info(&pf->pdev->dev, "       num MDD=%lld, invalid msg=%lld, valid msg=%lld\n",
-			 vf->num_mdd_events,
-			 vf->num_invalid_msgs,
-			 vf->num_valid_msgs);
+		dev_info(&pf->pdev->dev, "       num MDD=%lld\n",
+			 vf->num_mdd_events);
 	} else {
 		dev_info(&pf->pdev->dev, "invalid VF id %d\n", vf_id);
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index c6f643e54c4f..babf8b7fa767 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1917,19 +1917,17 @@ int i40e_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 /***********************virtual channel routines******************/
 
 /**
- * i40e_vc_send_msg_to_vf_ex
+ * i40e_vc_send_msg_to_vf
  * @vf: pointer to the VF info
  * @v_opcode: virtual channel opcode
  * @v_retval: virtual channel return value
  * @msg: pointer to the msg buffer
  * @msglen: msg length
- * @is_quiet: true for not printing unsuccessful return values, false otherwise
  *
  * send msg to VF
  **/
-static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
-				     u32 v_retval, u8 *msg, u16 msglen,
-				     bool is_quiet)
+static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
+				  u32 v_retval, u8 *msg, u16 msglen)
 {
 	struct i40e_pf *pf;
 	struct i40e_hw *hw;
@@ -1944,25 +1942,6 @@ static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
 	hw = &pf->hw;
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
-	/* single place to detect unsuccessful return values */
-	if (v_retval && !is_quiet) {
-		vf->num_invalid_msgs++;
-		dev_info(&pf->pdev->dev, "VF %d failed opcode %d, retval: %d\n",
-			 vf->vf_id, v_opcode, v_retval);
-		if (vf->num_invalid_msgs >
-		    I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED) {
-			dev_err(&pf->pdev->dev,
-				"Number of invalid messages exceeded for VF %d\n",
-				vf->vf_id);
-			dev_err(&pf->pdev->dev, "Use PF Control I/F to enable the VF\n");
-			set_bit(I40E_VF_STATE_DISABLED, &vf->vf_states);
-		}
-	} else {
-		vf->num_valid_msgs++;
-		/* reset the invalid counter, if a valid message is received. */
-		vf->num_invalid_msgs = 0;
-	}
-
 	aq_ret = i40e_aq_send_msg_to_vf(hw, abs_vf_id,	v_opcode, v_retval,
 					msg, msglen, NULL);
 	if (aq_ret) {
@@ -1975,23 +1954,6 @@ static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
 	return 0;
 }
 
-/**
- * i40e_vc_send_msg_to_vf
- * @vf: pointer to the VF info
- * @v_opcode: virtual channel opcode
- * @v_retval: virtual channel return value
- * @msg: pointer to the msg buffer
- * @msglen: msg length
- *
- * send msg to VF
- **/
-static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
-				  u32 v_retval, u8 *msg, u16 msglen)
-{
-	return i40e_vc_send_msg_to_vf_ex(vf, v_opcode, v_retval,
-					 msg, msglen, false);
-}
-
 /**
  * i40e_vc_send_resp_to_vf
  * @vf: pointer to the VF info
@@ -2813,7 +2775,6 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * i40e_check_vf_permission
  * @vf: pointer to the VF info
  * @al: MAC address list from virtchnl
- * @is_quiet: set true for printing msg without opcode info, false otherwise
  *
  * Check that the given list of MAC addresses is allowed. Will return -EPERM
  * if any address in the list is not valid. Checks the following conditions:
@@ -2828,15 +2789,13 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * addresses might not be accurate.
  **/
 static inline int i40e_check_vf_permission(struct i40e_vf *vf,
-					   struct virtchnl_ether_addr_list *al,
-					   bool *is_quiet)
+					   struct virtchnl_ether_addr_list *al)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
 	int mac2add_cnt = 0;
 	int i;
 
-	*is_quiet = false;
 	for (i = 0; i < al->num_elements; i++) {
 		struct i40e_mac_filter *f;
 		u8 *addr = al->list[i].addr;
@@ -2860,7 +2819,6 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 		    !ether_addr_equal(addr, vf->default_lan_addr.addr)) {
 			dev_err(&pf->pdev->dev,
 				"VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
-			*is_quiet = true;
 			return -EPERM;
 		}
 
@@ -2897,7 +2855,6 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	    (struct virtchnl_ether_addr_list *)msg;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
-	bool is_quiet = false;
 	i40e_status ret = 0;
 	int i;
 
@@ -2914,7 +2871,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	 */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-	ret = i40e_check_vf_permission(vf, al, &is_quiet);
+	ret = i40e_check_vf_permission(vf, al);
 	if (ret) {
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
 		goto error_param;
@@ -2952,8 +2909,8 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_msg_to_vf_ex(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				       ret, NULL, 0, is_quiet);
+	return i40e_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				      ret, NULL, 0);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 03c42fd0fea1..a554d0a0b09b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -10,8 +10,6 @@
 
 #define I40E_VIRTCHNL_SUPPORTED_QTYPES 2
 
-#define I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED	10
-
 #define I40E_VLAN_PRIORITY_SHIFT	13
 #define I40E_VLAN_MASK			0xFFF
 #define I40E_PRIORITY_MASK		0xE000
@@ -92,9 +90,6 @@ struct i40e_vf {
 	u8 num_queue_pairs;	/* num of qps assigned to VF vsis */
 	u8 num_req_queues;	/* num of requested qps */
 	u64 num_mdd_events;	/* num of mdd events detected */
-	/* num of continuous malformed or invalid msgs detected */
-	u64 num_invalid_msgs;
-	u64 num_valid_msgs;	/* num of valid msgs detected */
 
 	unsigned long vf_caps;	/* vf's adv. capabilities */
 	unsigned long vf_states;	/* vf's runtime states */
-- 
2.34.1




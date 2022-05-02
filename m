Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AEA5176DF
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiEBSzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 14:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiEBSzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 14:55:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C3E6243
        for <stable@vger.kernel.org>; Mon,  2 May 2022 11:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD7366149C
        for <stable@vger.kernel.org>; Mon,  2 May 2022 18:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09298C385A4;
        Mon,  2 May 2022 18:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651517501;
        bh=Oy5BTleBDiRkwjDN1R9LfRn0lAyFRZ2vlpSQAguiQyk=;
        h=Subject:To:Cc:From:Date:From;
        b=A+nFcj5nI9btM4Cv6aGDol77oNGcTmdYLf8MLINUNQupqYY/fZDQUEfinPTjWdzO9
         uY7mwRjqwvn1z3KdPmsySfJeQ2hFBwMYtTmJ/cvp8n7f0d0FjUAh0lUPdJpiKzp5kc
         Q39eA3e66h6mXCOyAM3H1vGed8KeZVsDaCKBDCf0=
Subject: FAILED: patch "[PATCH] ice: Protect vf_state check by cfg_lock in" failed to apply to 5.15-stable tree
To:     ivecera@redhat.com, anthony.l.nguyen@intel.com, feliu@redhat.com,
        jacob.e.keller@intel.com, konrad0.jankowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 20:51:40 +0200
Message-ID: <1651517500245178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 77d64d285be5f8d427893e9c54425b1e4f5d9be7 Mon Sep 17 00:00:00 2001
From: Ivan Vecera <ivecera@redhat.com>
Date: Tue, 19 Apr 2022 16:22:21 +0200
Subject: [PATCH] ice: Protect vf_state check by cfg_lock in
 ice_vc_process_vf_msg()

Previous patch labelled "ice: Fix incorrect locking in
ice_vc_process_vf_msg()"  fixed an issue with ignored messages
sent by VF driver but a small race window still left.

Recently caught trace during 'ip link set ... vf 0 vlan ...' operation:

[ 7332.995625] ice 0000:3b:00.0: Clearing port VLAN on VF 0
[ 7333.001023] iavf 0000:3b:01.0: Reset indication received from the PF
[ 7333.007391] iavf 0000:3b:01.0: Scheduling reset task
[ 7333.059575] iavf 0000:3b:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 3
[ 7333.059626] ice 0000:3b:00.0: Invalid message from VF 0, opcode 3, len 4, error -1

Setting of VLAN for VF causes a reset of the affected VF using
ice_reset_vf() function that runs with cfg_lock taken:

1. ice_notify_vf_reset() informs IAVF driver that reset is needed and
   IAVF schedules its own reset procedure
2. Bit ICE_VF_STATE_DIS is set in vf->vf_state
3. Misc initialization steps
4. ice_sriov_post_vsi_rebuild() -> ice_vf_set_initialized() and that
   clears ICE_VF_STATE_DIS in vf->vf_state

Step 3 is mentioned race window because IAVF reset procedure runs in
parallel and one of its step is sending of VIRTCHNL_OP_GET_VF_RESOURCES
message (opcode==3). This message is handled in ice_vc_process_vf_msg()
and if it is received during the mentioned race window then it's
marked as invalid and error is returned to VF driver.

Protect vf_state check in ice_vc_process_vf_msg() by cfg_lock to avoid
this race condition.

Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
Tested-by: Fei Liu <feliu@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 5612c032f15a..b72606c9e6d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3625,6 +3625,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	/* Check if VF is disabled. */
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
 		err = -EPERM;
@@ -3648,19 +3650,14 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 				      NULL, 0);
 		dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
 			vf_id, v_opcode, msglen, err);
-		ice_put_vf(vf);
-		return;
+		goto finish;
 	}
 
-	mutex_lock(&vf->cfg_lock);
-
 	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
 		ice_vc_send_msg_to_vf(vf, v_opcode,
 				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
 				      0);
-		mutex_unlock(&vf->cfg_lock);
-		ice_put_vf(vf);
-		return;
+		goto finish;
 	}
 
 	switch (v_opcode) {
@@ -3773,6 +3770,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 			 vf_id, v_opcode, err);
 	}
 
+finish:
 	mutex_unlock(&vf->cfg_lock);
 	ice_put_vf(vf);
 }


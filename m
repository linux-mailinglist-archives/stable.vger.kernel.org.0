Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98B65176E4
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 20:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiEBS4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiEBS4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 14:56:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8861C60E4
        for <stable@vger.kernel.org>; Mon,  2 May 2022 11:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDA85B819C9
        for <stable@vger.kernel.org>; Mon,  2 May 2022 18:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630D8C385A4;
        Mon,  2 May 2022 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651517548;
        bh=ycLfy/1MJC55Ulu9zsSIFV4xjYLpPFq1mttr6NK0Y3Q=;
        h=Subject:To:Cc:From:Date:From;
        b=OFOyJbGIvaQzo9YxJmTW2ZFnKj6AbPzL4PUOnZlNGDc7XV9Uuo1j9dXwLcaY0c2oY
         hjxqJnUXDumByFdNUTT9iH2QlFXBUcTEqLfBvG5Xmr22bSbwSS6PXf/N+PzZoA/Yj6
         ot9kF+Yw512yF1ZX0ipKqxi/xN1y90Z1x/ObJ5Ag=
Subject: FAILED: patch "[PATCH] ice: Fix incorrect locking in ice_vc_process_vf_msg()" failed to apply to 5.15-stable tree
To:     ivecera@redhat.com, anthony.l.nguyen@intel.com,
        konrad0.jankowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 20:52:24 +0200
Message-ID: <16515175447262@kroah.com>
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

From aaf461af729b81dbb19ec33abe6da74702b352d2 Mon Sep 17 00:00:00 2001
From: Ivan Vecera <ivecera@redhat.com>
Date: Fri, 1 Apr 2022 12:40:52 +0200
Subject: [PATCH] ice: Fix incorrect locking in ice_vc_process_vf_msg()

Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
because message sent from VF is ignored and never processed.

Use mutex_lock() instead to fix the issue. It is safe because this
mutex is used to prevent races between VF related NDOs and
handlers processing request messages from VF and these handlers
are running in ice_service_task() context. Additionally move this
mutex lock prior ice_vc_is_opcode_allowed() call to avoid potential
races during allowlist access.

Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 69ff4b929772..5612c032f15a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -3642,14 +3642,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 			err = -EINVAL;
 	}
 
-	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
-		ice_vc_send_msg_to_vf(vf, v_opcode,
-				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
-				      0);
-		ice_put_vf(vf);
-		return;
-	}
-
 error_handler:
 	if (err) {
 		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
@@ -3660,12 +3652,13 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
-	/* VF is being configured in another context that triggers a VFR, so no
-	 * need to process this message
-	 */
-	if (!mutex_trylock(&vf->cfg_lock)) {
-		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
-			 vf->vf_id);
+	mutex_lock(&vf->cfg_lock);
+
+	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
+		ice_vc_send_msg_to_vf(vf, v_opcode,
+				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
+				      0);
+		mutex_unlock(&vf->cfg_lock);
 		ice_put_vf(vf);
 		return;
 	}


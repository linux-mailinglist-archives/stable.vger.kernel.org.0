Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6CB6B3DE5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjCJLed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCJLe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:34:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA5F10F85D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:34:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 645E9B82260
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16BBC433D2;
        Fri, 10 Mar 2023 11:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448060;
        bh=hwDAh5VC8f3nm0vdoL8U9JiXep+S6U4EBDHmbhcRFWc=;
        h=Subject:To:Cc:From:Date:From;
        b=vxXz+u9q5oFlc9t34VqNroMUnkyWrmJGtoQf8O+GUzdbMuCBxKSrUEpe/1tHaoYUf
         N4IgDQj/hAOKQAK7bX62UPq5wnRmoqt3u4SCo/08XPLRHIhwTtE18L0bIuB3IJuWGe
         VwRR0AczW4f9bospmqe4jMFvDFbpUEI27E3+IPXc=
Subject: FAILED: patch "[PATCH] drm/display/dp_mst: Fix down message handling after a packet" failed to apply to 4.19-stable tree
To:     imre.deak@intel.com, lyude@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:34:09 +0100
Message-ID: <1678448049194199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 1241aedb6b5c7a5a8ad73e5eb3a41cfe18a3e00e
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678448049194199@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

1241aedb6b5c ("drm/display/dp_mst: Fix down message handling after a packet reception error")
da68386d9edb ("drm: Rename dp/ to display/")
6c64ae228f08 ("Backmerge tag 'v5.17-rc6' into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1241aedb6b5c7a5a8ad73e5eb3a41cfe18a3e00e Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Wed, 14 Dec 2022 20:42:57 +0200
Subject: [PATCH] drm/display/dp_mst: Fix down message handling after a packet
 reception error

After an error during receiving a packet for a multi-packet DP MST
sideband message, the state tracking which packets have been received
already is not reset. This prevents the reception of subsequent down
messages (due to the pending message not yet completed with an
end-of-message-transfer packet).

Fix the above by resetting the reception state after a packet error.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221214184258.2869417-2-imre.deak@intel.com

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 90819fff2c9b..01350510244f 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3856,7 +3856,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_sideband_msg_rx *msg = &mgr->down_rep_recv;
 
 	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb))
-		goto out;
+		goto out_clear_reply;
 
 	/* Multi-packet message transmission, don't clear the reply */
 	if (!msg->have_eomt)


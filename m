Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954706B3DDB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCJLdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjCJLdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:33:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CF8F2089
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 412D26137B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323DAC4339B;
        Fri, 10 Mar 2023 11:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448020;
        bh=O7IIs2d6LAOeCQK1JnAl4x7jV7mH7h+p0oEV95z99Wc=;
        h=Subject:To:Cc:From:Date:From;
        b=KnoY8N8W9IxJFcsyqRr/PY5lWs7viof3T0FhFh66fjv1eR7rYm2ysaj5j83LRMgPV
         XL5hb59DPTfejYTyfmriieAMTTf7Ga8q3TKVaMThuyJVOlUv9aiwZLkvNiFAwACqkx
         5HpDk49KYreq7SktPL9HDBQujmo6UW1J2taueUAw=
Subject: FAILED: patch "[PATCH] drm/display/dp_mst: Fix down/up message handling after sink" failed to apply to 5.4-stable tree
To:     imre.deak@intel.com, lyude@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:33:37 +0100
Message-ID: <1678448017136169@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 1d082618bbf3b6755b8cc68c0a8122af2842d593
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678448017136169@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

1d082618bbf3 ("drm/display/dp_mst: Fix down/up message handling after sink disconnect")
da68386d9edb ("drm: Rename dp/ to display/")
6c64ae228f08 ("Backmerge tag 'v5.17-rc6' into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1d082618bbf3b6755b8cc68c0a8122af2842d593 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Wed, 14 Dec 2022 20:42:56 +0200
Subject: [PATCH] drm/display/dp_mst: Fix down/up message handling after sink
 disconnect

If the sink gets disconnected during receiving a multi-packet DP MST AUX
down-reply/up-request sideband message, the state keeping track of which
packets have been received already is not reset. This results in a failed
sanity check for the subsequent message packet received after a sink is
reconnected (due to the pending message not yet completed with an
end-of-message-transfer packet), indicated by the

"sideband msg set header failed"

error.

Fix the above by resetting the up/down message reception state after a
disconnect event.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221214184258.2869417-1-imre.deak@intel.com

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 51a46689cda7..90819fff2c9b 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3641,6 +3641,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
 		mgr->payload_id_table_cleared = false;
+
+		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
+		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
 	}
 
 out_unlock:


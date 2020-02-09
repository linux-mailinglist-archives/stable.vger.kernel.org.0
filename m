Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA73156A65
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgBINEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:04:13 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49337 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBINEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:04:12 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 01FB421B2F;
        Sun,  9 Feb 2020 08:04:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MW6gV6
        oSqBFdU+6SIxXXbjUR6K65Q7SH0wUch8tLryg=; b=khsvTzKflViA6HkhnoIR5U
        n3bLOOGhuUajJ8TCFipHz1H3mwKFi7bGlsp8DVzKuoDBb/g/4lKvQFi00xqBPifj
        sn013omVxc62YylVcN6trQXoiymdUaXVRe79reTa3Gn85m95OlaKH3iDR9v6mYRl
        RwmySQSZ5p4gyzi0agW5rnvjM5F2DVsBSYfziW6HnM40BjiwL4R8GldwX9+PHPRh
        7HjlJB7FYPf58Gry/Vrx6OhPkI4aVKrvMF8K3uMR/ohkpziZJbUsLSuNi8HPFBNu
        QwKHSPMQL0huFTBAhwG+NRAfycaEcpIQbi6ZR1RmK/JWIhW0z/ktYa5PXKRQ+Ghw
        ==
X-ME-Sender: <xms:SwNAXkkuA7DfyzreC70CPRwmwloiLadV4CkTsPdsrCueDNRwcIqrdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepfeekrdelke
    drfeejrddufeehnecuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SwNAXoFAYWfz_vA6Yak03WhiWXM7t27UrPiM0tYFTXiYUeNPSPl_cA>
    <xmx:SwNAXtpJ83r7hZdfdyTD8Vcif32_dthEXhyVUZ-uFHXwkM8Ov2fgnw>
    <xmx:SwNAXk5X5x27vQcrnM8gT1CnKd7X6QYw_uCJ0YbJEFb0_TuN2TanXg>
    <xmx:SwNAXk6woqX9V5YK7dTzuBcDmj-I6JKu0jey9O9276YLY9d8X6k2mw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2CDA30606FB;
        Sun,  9 Feb 2020 08:04:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/dp_mst: Remove VCPI while disabling topology mgr" failed to apply to 4.4-stable tree
To:     Wayne.Lin@amd.com, lyude@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:41:14 +0100
Message-ID: <158124847457183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64e62bdf04ab8529f45ed0a85122c703035dec3a Mon Sep 17 00:00:00 2001
From: Wayne Lin <Wayne.Lin@amd.com>
Date: Thu, 5 Dec 2019 17:00:43 +0800
Subject: [PATCH] drm/dp_mst: Remove VCPI while disabling topology mgr

[Why]

This patch is trying to address the issue observed when hotplug DP
daisy chain monitors.

e.g.
src-mstb-mstb-sst -> src (unplug) mstb-mstb-sst -> src-mstb-mstb-sst
(plug in again)

Once unplug a DP MST capable device, driver will call
drm_dp_mst_topology_mgr_set_mst() to disable MST. In this function,
it cleans data of topology manager while disabling mst_state. However,
it doesn't clean up the proposed_vcpis of topology manager.
If proposed_vcpi is not reset, once plug in MST daisy chain monitors
later, code will fail at checking port validation while trying to
allocate payloads.

When MST capable device is plugged in again and try to allocate
payloads by calling drm_dp_update_payload_part1(), this
function will iterate over all proposed virtual channels to see if
any proposed VCPI's num_slots is greater than 0. If any proposed
VCPI's num_slots is greater than 0 and the port which the
specific virtual channel directed to is not in the topology, code then
fails at the port validation. Since there are stale VCPI allocations
from the previous topology enablement in proposed_vcpi[], code will fail
at port validation and reurn EINVAL.

[How]

Clean up the data of stale proposed_vcpi[] and reset mgr->proposed_vcpis
to NULL while disabling mst in drm_dp_mst_topology_mgr_set_mst().

Changes since v1:
*Add on more details in commit message to describe the issue which the
patch is trying to fix

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
[added cc to stable]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191205090043.7580-1-Wayne.Lin@amd.com
Cc: <stable@vger.kernel.org> # v3.17+

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 87fc44895d83..1770754bcd4a 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3054,6 +3054,7 @@ static int drm_dp_get_vc_payload_bw(u8 dp_link_bw, u8  dp_link_count)
 int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool mst_state)
 {
 	int ret = 0;
+	int i = 0;
 	struct drm_dp_mst_branch *mstb = NULL;
 
 	mutex_lock(&mgr->lock);
@@ -3114,10 +3115,22 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
+		mutex_lock(&mgr->payload_lock);
 		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct drm_dp_payload));
 		mgr->payload_mask = 0;
 		set_bit(0, &mgr->payload_mask);
+		for (i = 0; i < mgr->max_payloads; i++) {
+			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
+
+			if (vcpi) {
+				vcpi->vcpi = 0;
+				vcpi->num_slots = 0;
+			}
+			mgr->proposed_vcpis[i] = NULL;
+		}
 		mgr->vcpi_mask = 0;
+		mutex_unlock(&mgr->payload_lock);
+
 		mgr->payload_id_table_cleared = false;
 	}
 


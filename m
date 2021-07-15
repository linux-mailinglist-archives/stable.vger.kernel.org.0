Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03283C9F2E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhGONQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237409AbhGONQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 09:16:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83F52613BB;
        Thu, 15 Jul 2021 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626354788;
        bh=+X0qgZ2FDqT/fMr8tleW5ZmzZcSrT1Shn3tA1MIpbh8=;
        h=Subject:To:Cc:From:Date:From;
        b=qvNkknObG9PTvbBq9JGmpr711tFlBADcO1YMsaHUbdfr/wsxmeQCm1YVrcx+j5ZQC
         fl+RpcWTBMCO1x48jLwgWAaWxiAaihU6ztZfYgMPSd7XDVdxic720pYGB0piod1xkl
         XueU4jiAr+TJ1IlwTxrDHDKgQSzqopfA7dJQYu3M=
Subject: FAILED: patch "[PATCH] drm/dp_mst: Do not set proposed vcpi directly" failed to apply to 5.10-stable tree
To:     Wayne.Lin@amd.com, lyude@redhat.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        stable@vger.kernel.org, tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 15:13:05 +0200
Message-ID: <1626354785182230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 35d3e8cb35e75450f87f87e3d314e2d418b6954b Mon Sep 17 00:00:00 2001
From: Wayne Lin <Wayne.Lin@amd.com>
Date: Wed, 16 Jun 2021 11:55:00 +0800
Subject: [PATCH] drm/dp_mst: Do not set proposed vcpi directly

[Why]
When we receive CSN message to notify one port is disconnected, we will
implicitly set its corresponding num_slots to 0. Later on, we will
eventually call drm_dp_update_payload_part1() to arrange down streams.

In drm_dp_update_payload_part1(), we iterate over all proposed_vcpis[]
to do the update. Not specific to a target sink only. For example, if we
light up 2 monitors, Monitor_A and Monitor_B, and then we unplug
Monitor_B. Later on, when we call drm_dp_update_payload_part1() to try
to update payload for Monitor_A, we'll also implicitly clean payload for
Monitor_B at the same time. And finally, when we try to call
drm_dp_update_payload_part1() to clean payload for Monitor_B, we will do
nothing at this time since payload for Monitor_B has been cleaned up
previously.

For StarTech 1to3 DP hub, it seems like if we didn't update DPCD payload
ID table then polling for "ACT Handled"(BIT_1 of DPCD 002C0h) will fail
and this polling will last for 3 seconds.

Therefore, guess the best way is we don't set the proposed_vcpi[]
diretly. Let user of these herlper functions to set the proposed_vcpi
directly.

[How]
1. Revert commit 7617e9621bf2 ("drm/dp_mst: clear time slots for ports
invalid")
2. Tackle the issue in previous commit by skipping those trasient
proposed VCPIs. These stale VCPIs shoulde be explicitly cleared by
user later on.

Changes since v1:
* Change debug macro to use drm_dbg_kms() instead
* Amend the commit message to add Fixed & Cc tags

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Fixes: 7617e9621bf2 ("drm/dp_mst: clear time slots for ports invalid")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210616035501.3776-2-Wayne.Lin@amd.com
Reviewed-by: Lyude Paul <lyude@redhat.com>

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 32b7f8983b94..b41b837db66d 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2501,7 +2501,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 {
 	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
 	struct drm_dp_mst_port *port;
-	int old_ddps, old_input, ret, i;
+	int old_ddps, ret;
 	u8 new_pdt;
 	bool new_mcs;
 	bool dowork = false, create_connector = false;
@@ -2533,7 +2533,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 	}
 
 	old_ddps = port->ddps;
-	old_input = port->input;
 	port->input = conn_stat->input_port;
 	port->ldps = conn_stat->legacy_device_plug_status;
 	port->ddps = conn_stat->displayport_device_plug_status;
@@ -2555,28 +2554,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
 		dowork = false;
 	}
 
-	if (!old_input && old_ddps != port->ddps && !port->ddps) {
-		for (i = 0; i < mgr->max_payloads; i++) {
-			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
-			struct drm_dp_mst_port *port_validated;
-
-			if (!vcpi)
-				continue;
-
-			port_validated =
-				container_of(vcpi, struct drm_dp_mst_port, vcpi);
-			port_validated =
-				drm_dp_mst_topology_get_port_validated(mgr, port_validated);
-			if (!port_validated) {
-				mutex_lock(&mgr->payload_lock);
-				vcpi->num_slots = 0;
-				mutex_unlock(&mgr->payload_lock);
-			} else {
-				drm_dp_mst_topology_put_port(port_validated);
-			}
-		}
-	}
-
 	if (port->connector)
 		drm_modeset_unlock(&mgr->base.lock);
 	else if (create_connector)
@@ -3410,8 +3387,15 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 				port = drm_dp_mst_topology_get_port_validated(
 				    mgr, port);
 				if (!port) {
-					mutex_unlock(&mgr->payload_lock);
-					return -EINVAL;
+					if (vcpi->num_slots == payload->num_slots) {
+						cur_slots += vcpi->num_slots;
+						payload->start_slot = req_payload.start_slot;
+						continue;
+					} else {
+						drm_dbg_kms("Fail:set payload to invalid sink");
+						mutex_unlock(&mgr->payload_lock);
+						return -EINVAL;
+					}
 				}
 				put_port = true;
 			}


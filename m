Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA533C9EA5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhGOMeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhGOMeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5995E61178;
        Thu, 15 Jul 2021 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626352285;
        bh=+8WklqRIPbMK19FjViu3eg+7qwGpJSy+13/U9X/Qr9g=;
        h=Subject:To:Cc:From:Date:From;
        b=GU4lDjpjrw0Pkt4FQpCKx/my6/grXg0DoPDELIS31mAqH2xNQ/kGApD9ZLaHsv15L
         uZZr17bEx9dQFE7j55o7xIWXJFfe3vTXLiP7cXlMwJeb44W9I9GZcjKN5GRZwjRKsV
         1thY9OFW5W6b5sddVmxCZ/RLSQa6KehtLZa3O4+w=
Subject: FAILED: patch "[PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale" failed to apply to 5.13-stable tree
To:     Wayne.Lin@amd.com, lyude@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 14:17:18 +0200
Message-ID: <16263514381332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3769e4c0af5b82c8ea21d037013cb9564dfaa51f Mon Sep 17 00:00:00 2001
From: Wayne Lin <Wayne.Lin@amd.com>
Date: Wed, 16 Jun 2021 11:55:01 +0800
Subject: [PATCH] drm/dp_mst: Avoid to mess up payload table by ports in stale
 topology

[Why]
After unplug/hotplug hub from the system, userspace might start to
clear stale payloads gradually. If we call drm_dp_mst_deallocate_vcpi()
to release stale VCPI of those ports which are not relating to current
topology, we have chane to wrongly clear active payload table entry for
current topology.

E.g.
We have allocated VCPI 1 in current payload table and we call
drm_dp_mst_deallocate_vcpi() to clean VCPI 1 in stale topology. In
drm_dp_mst_deallocate_vcpi(), it will call drm_dp_mst_put_payload_id()
tp put VCPI 1 and which means ID 1 is available again. Thereafter, if we
want to allocate a new payload stream, it will find ID 1 is available by
drm_dp_mst_assign_payload_id(). However, ID 1 is being used

[How]
Check target sink is relating to current topology or not before doing
any payload table update.
Searching upward to find the target sink's relevant root branch device.
If the found root branch device is not the same root of current
topology, don't update payload table.

Changes since v1:
* Change debug macro to use drm_dbg_kms() instead
* Amend the commit message to add Cc tag.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210616035501.3776-3-Wayne.Lin@amd.com
Reviewed-by: Lyude Paul <lyude@redhat.com>

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index b41b837db66d..9ac148efd9e4 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -94,6 +94,9 @@ static int drm_dp_mst_register_i2c_bus(struct drm_dp_mst_port *port);
 static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_mst_port *port);
 static void drm_dp_mst_kick_tx(struct drm_dp_mst_topology_mgr *mgr);
 
+static bool drm_dp_mst_port_downstream_of_branch(struct drm_dp_mst_port *port,
+						 struct drm_dp_mst_branch *branch);
+
 #define DBG_PREFIX "[dp_mst]"
 
 #define DP_STR(x) [DP_ ## x] = #x
@@ -3366,6 +3369,7 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i, j;
 	int cur_slots = 1;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3380,6 +3384,14 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 			port = container_of(vcpi, struct drm_dp_mst_port,
 					    vcpi);
 
+			mutex_lock(&mgr->lock);
+			skip = !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
+			mutex_unlock(&mgr->lock);
+
+			if (skip) {
+				drm_dbg_kms("Virtual channel %d is not in current topology\n", i);
+				continue;
+			}
 			/* Validated ports don't matter if we're releasing
 			 * VCPI
 			 */
@@ -3479,6 +3491,7 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_mst_port *port;
 	int i;
 	int ret = 0;
+	bool skip;
 
 	mutex_lock(&mgr->payload_lock);
 	for (i = 0; i < mgr->max_payloads; i++) {
@@ -3488,6 +3501,13 @@ int drm_dp_update_payload_part2(struct drm_dp_mst_topology_mgr *mgr)
 
 		port = container_of(mgr->proposed_vcpis[i], struct drm_dp_mst_port, vcpi);
 
+		mutex_lock(&mgr->lock);
+		skip = !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
+		mutex_unlock(&mgr->lock);
+
+		if (skip)
+			continue;
+
 		drm_dbg_kms(mgr->dev, "payload %d %d\n", i, mgr->payloads[i].payload_state);
 		if (mgr->payloads[i].payload_state == DP_PAYLOAD_LOCAL) {
 			ret = drm_dp_create_payload_step2(mgr, port, mgr->proposed_vcpis[i]->vcpi, &mgr->payloads[i]);
@@ -4574,9 +4594,18 @@ EXPORT_SYMBOL(drm_dp_mst_reset_vcpi_slots);
 void drm_dp_mst_deallocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
 				struct drm_dp_mst_port *port)
 {
+	bool skip;
+
 	if (!port->vcpi.vcpi)
 		return;
 
+	mutex_lock(&mgr->lock);
+	skip = !drm_dp_mst_port_downstream_of_branch(port, mgr->mst_primary);
+	mutex_unlock(&mgr->lock);
+
+	if (skip)
+		return;
+
 	drm_dp_mst_put_payload_id(mgr, port->vcpi.vcpi);
 	port->vcpi.num_slots = 0;
 	port->vcpi.pbn = 0;


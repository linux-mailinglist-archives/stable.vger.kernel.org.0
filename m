Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A356D8714
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 21:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbjDETl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 15:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbjDETlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 15:41:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7F5619C
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 12:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFkqxi9cwmdmiLVQhbVEbuoUKEoNfycqdyDItUUv9kRgBNmHvk4iZUiwCtB4T4xi7WmBtar4MOVNylGV3QqqpQKUxnPYSb5GcurMWECjVzFSTOxR3PVcnqur/4Ww0OXMmiOO+0FBWLk70iyJzuty6jzF2HJqpzeDTRxYlVA1vxV+rahgLHdjmNksItYRsSAHa7Pgboo/KdPR/dSc1aZ97VYiZPFXtFKEByfQifT6H0Bvnnqx9YT2KC6pMpicKLw5QniY0bwuP8yAnqcDRYbmbtIPWDQb4QJ/VDMWNFuz1RmPoCkq9FGS7m2h80r8yV4E+ULYP+aUAkQq2eogJpTs4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1/vkDfVspE0NMAS0D/FtmDsH+Ua4S8U0JEadsuMjlA=;
 b=SL+6S814PYSw1rGB7noS2sGlMEhbTuJThVU8gRCQ9ppSl/1xIHoSyehhaWuiVJeIYmfqqXsUgBwkodkxBFovZ610XOkEBFWgBobVYwV8omJ+EOw/Fir+EexYxt295UwQknPn3x3VrNcRlfz1vYFIHSTpGGsrpMKDgtFDrBbGKbbWZpCo+I6nnGIvAOVBgC05zdDMkT7TkT2Cze7516RbPdaI3xc1WLRyHL/EYywDy5CVtbt1yMbQun+WIKNMS4XUxD0bsjpO1QaYqNbyZaibjPmW1wX1yElG6sIEKea24I+GhQ0QGSuWsGXNKmvezF9Pp6dooW10Ya7yH94oH1KiUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1/vkDfVspE0NMAS0D/FtmDsH+Ua4S8U0JEadsuMjlA=;
 b=uETlWY0v4skZ2DtO3CZNbRJFimpxQRsnurBw+bivl+OTSvYg5Tf0YDuAJxcrlXUVJqKcfwoLNVlXOpt0HhKuRVBNZf9ZDdBlDq5nUvvTdjv3QhGP95CiFjD0i9aljmxGXxhz4CGdczJPvV0wjFnm0Ubbl8rICG4f3CYsmcGrMzY=
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by CH0PR12MB5090.namprd12.prod.outlook.com (2603:10b6:610:bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Wed, 5 Apr
 2023 19:37:19 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::96) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Wed, 5 Apr 2023 19:37:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.28 via Frontend Transport; Wed, 5 Apr 2023 19:37:19 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 5 Apr
 2023 14:37:18 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH 6.1.y 1/2] drm/display/dp_mst: Handle old/new payload states in drm_dp_remove_payload()
Date:   Wed, 5 Apr 2023 14:37:06 -0500
Message-ID: <20230405193707.8184-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230405193707.8184-1-mario.limonciello@amd.com>
References: <20230405193707.8184-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|CH0PR12MB5090:EE_
X-MS-Office365-Filtering-Correlation-Id: 52657a36-7784-4899-d65e-08db360d2b44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMVbGZXLo7bTgXJW/3U9KBjTBaxTGEA4qDpJOi7yd4nOm5kNEtt2Bs1T256c8p28nBY+EduBBhifYibsMUot6Ia5ZLhAsn6rJDuLbY6r9bhq5ymH5c8OnROlZvAlWY2cDlcnHy9Fk+gSJUXywPwmpHqBIkzeTBFERnOouJvRK5TC5/GYrZEt+t4UXRbb+YsqH9CeUEQdoZcaehXBHzCeyyuY+w5Rkfm0bV9gx/EIg8d968S6uD4SFUe0JNmw+PJw5OdHo2e4B0B+7H3bgbNj0jk9DZRszrJp6aeMf1m6ZEuTOxXX5UUE2iaSiL0Okfxnv2TiiKQeUZJtNiZFgCzNT6t23UhUglYA2NGLkT2l4vg5+l/wFoFQPa41E7tP6nwYUbGn/NQoesMdPBegJyAjfdZ27Bx+v8L3PEljkGtQTP2pMh9aochpXhpZdL0SqtSZS1WlbYomTH8bJ6nBAZeJFSl9tpvj+FX+kmYOJfxb5LUE3lbfiogEYPJCB+sDl3rRdADz/jGe9kiTi1gKk5A/L3kqC5lPtbbsAS6wo4EriCca2jExvEGlCCZQEOrBOaW7YsmKHWfWe8EYl4i7BswfSXnLFM01RpJrrq8oK0kbR+y+VHHXqmBSVM5UhrhorTJ5nArOvQceE8LefQLNTmc287I14tJzGTemNdsAuy0tWve4ciw6L2e4LzuKiUrrL/ve
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199021)(36840700001)(40470700004)(46966006)(83380400001)(40480700001)(5660300002)(426003)(82740400003)(336012)(70206006)(70586007)(8676002)(6916009)(8936002)(356005)(44832011)(81166007)(2616005)(66574015)(47076005)(41300700001)(7696005)(2906002)(478600001)(86362001)(36860700001)(40460700003)(186003)(316002)(36756003)(16526019)(82310400005)(6666004)(966005)(26005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 19:37:19.0994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52657a36-7784-4899-d65e-08db360d2b44
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5090
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

Atm, drm_dp_remove_payload() uses the same payload state to both get the
vc_start_slot required for the payload removal DPCD message and to
deduct time_slots from vc_start_slot of all payloads after the one being
removed.

The above isn't always correct, as vc_start_slot must be the up-to-date
version contained in the new payload state, but time_slots must be the
one used when the payload was previously added, contained in the old
payload state. The new payload's time_slots can change vs. the old one
if the current atomic commit changes the corresponding mode.

This patch let's drivers pass the old and new payload states to
drm_dp_remove_payload(), but keeps these the same for now in all drivers
not to change the behavior. A follow-up i915 patch will pass in that
driver the correct old and new states to the function.

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org # 6.1
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Lyude Paul <lyude@redhat.com>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230206114856.2665066-2-imre.deak@intel.com
(cherry picked from commit e761cc20946a0094df71cb31a565a6a0d03bd8be)
Hand modified for missing 8c7d980da9ba3eb67a1b40fd4b33bcf49397084b
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 26 ++++++++++---------
 drivers/gpu/drm/i915/display/intel_dp_mst.c   |  4 ++-
 drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
 include/drm/display/drm_dp_mst_helper.h       |  3 ++-
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 57454967617f..6bd7e4537014 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -206,7 +206,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
 	if (enable)
 		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
 	else
-		drm_dp_remove_payload(mst_mgr, mst_state, payload);
+		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
 
 	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index e77c674b37ca..38dab76ae69e 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3342,7 +3342,8 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
  * drm_dp_remove_payload() - Remove an MST payload
  * @mgr: Manager to use.
  * @mst_state: The MST atomic state
- * @payload: The payload to write
+ * @old_payload: The payload with its old state
+ * @new_payload: The payload to write
  *
  * Removes a payload from an MST topology if it was successfully assigned a start slot. Also updates
  * the starting time slots of all other payloads which would have been shifted towards the start of
@@ -3350,36 +3351,37 @@ EXPORT_SYMBOL(drm_dp_add_payload_part1);
  */
 void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 			   struct drm_dp_mst_topology_state *mst_state,
-			   struct drm_dp_mst_atomic_payload *payload)
+			   const struct drm_dp_mst_atomic_payload *old_payload,
+			   struct drm_dp_mst_atomic_payload *new_payload)
 {
 	struct drm_dp_mst_atomic_payload *pos;
 	bool send_remove = false;
 
 	/* We failed to make the payload, so nothing to do */
-	if (payload->vc_start_slot == -1)
+	if (new_payload->vc_start_slot == -1)
 		return;
 
 	mutex_lock(&mgr->lock);
-	send_remove = drm_dp_mst_port_downstream_of_branch(payload->port, mgr->mst_primary);
+	send_remove = drm_dp_mst_port_downstream_of_branch(new_payload->port, mgr->mst_primary);
 	mutex_unlock(&mgr->lock);
 
 	if (send_remove)
-		drm_dp_destroy_payload_step1(mgr, mst_state, payload);
+		drm_dp_destroy_payload_step1(mgr, mst_state, new_payload);
 	else
 		drm_dbg_kms(mgr->dev, "Payload for VCPI %d not in topology, not sending remove\n",
-			    payload->vcpi);
+			    new_payload->vcpi);
 
 	list_for_each_entry(pos, &mst_state->payloads, next) {
-		if (pos != payload && pos->vc_start_slot > payload->vc_start_slot)
-			pos->vc_start_slot -= payload->time_slots;
+		if (pos != new_payload && pos->vc_start_slot > new_payload->vc_start_slot)
+			pos->vc_start_slot -= old_payload->time_slots;
 	}
-	payload->vc_start_slot = -1;
+	new_payload->vc_start_slot = -1;
 
 	mgr->payload_count--;
-	mgr->next_start_slot -= payload->time_slots;
+	mgr->next_start_slot -= old_payload->time_slots;
 
-	if (payload->delete)
-		drm_dp_mst_put_port_malloc(payload->port);
+	if (new_payload->delete)
+		drm_dp_mst_put_port_malloc(new_payload->port);
 }
 EXPORT_SYMBOL(drm_dp_remove_payload);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 27c2098dd707..256afff75b0a 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -366,6 +366,8 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 		to_intel_connector(old_conn_state->connector);
 	struct drm_dp_mst_topology_state *mst_state =
 		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	struct drm_dp_mst_atomic_payload *payload =
+		drm_atomic_get_mst_payload_state(mst_state, connector->port);
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 
 	drm_dbg_kms(&i915->drm, "active links %d\n",
@@ -374,7 +376,7 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 	intel_hdcp_disable(intel_mst->connector);
 
 	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
-			      drm_atomic_get_mst_payload_state(mst_state, connector->port));
+			      payload, payload);
 
 	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
 }
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 33c97d510999..4f1bf1cb9e0c 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -996,7 +996,7 @@ nv50_msto_prepare(struct drm_atomic_state *state,
 
 	// TODO: Figure out if we want to do a better job of handling VCPI allocation failures here?
 	if (msto->disabled) {
-		drm_dp_remove_payload(mgr, mst_state, payload);
+		drm_dp_remove_payload(mgr, mst_state, payload, payload);
 	} else {
 		if (msto->enabled)
 			drm_dp_add_payload_part1(mgr, mst_state, payload);
diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
index 6c0c3dc3d3ac..32c764fb9cb5 100644
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -841,7 +841,8 @@ int drm_dp_add_payload_part2(struct drm_dp_mst_topology_mgr *mgr,
 			     struct drm_dp_mst_atomic_payload *payload);
 void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 			   struct drm_dp_mst_topology_state *mst_state,
-			   struct drm_dp_mst_atomic_payload *payload);
+			   const struct drm_dp_mst_atomic_payload *old_payload,
+			   struct drm_dp_mst_atomic_payload *new_payload);
 
 int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr);
 
-- 
2.34.1


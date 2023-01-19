Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32AA674775
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjASXwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjASXwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3AB9F3AA
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggITrqqGGJZ+7/I0iEOHP6uaZD5OlF6LOKO4UjZW7uk1OCt8xPacYyZlHO6hZmOoiYjUtMghZXmTl2tNRAvEj/wV+OPy+jTGAs8Dad7yV3OhR65igJMuh44obYUZqQujWojhtYRz7eOQqm60xpJUfUq1c9uCy0pRt125lXyr47g2NA62HQE2Kc/S5j48dDpJkQXKwsJuDuKR2UclR/M+dAAwdhsz7UJty9LhLbEiMIZBWgaOlCKHdqzZu6laycR1TrqIkhg2dXZT0lFzHEuzaYbkapKyv5Gh5ylp5MfSN/HY9gXPRtrPGcDvv60TA+JwTWoGSMXcJCpk2xWIgjBmqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EnHEJT84hEFbSWCmygOv0EQcgkfKjdzU/ie7ylxLYo=;
 b=G3iHfmbN9K7CELzRgKJMLXpNupmUAnoZHjigj5IWppshP+CoWSWMoBKcxqCt/lv53k6xDMiOQTTetIyDz2rfuEc7M2HyBiL/juYNpOvIqDU+DSJlqI6/rszzk3URMMhj9mZLZbd+y+Gue3xyWyDqoV1KLUf34HfEH1NdqihCGR6HKy5yNLcTsYlsNT13f5bGyC/ebR2Bzb35XQnGA5SfTbLmIVjcVZna3598k8yv3aB+I8/ElQVWyuNXBUvJU3JUt/vppehq91J7KCUd1dOBmOe5iSyovM8/VIhbjUckzbo4u/O3kBgTJ9hr7qmQlTUs+64D476lR+O06vqWBiepSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EnHEJT84hEFbSWCmygOv0EQcgkfKjdzU/ie7ylxLYo=;
 b=kdCxCgF5qXxsF+0UrrHTX8BmMEYCHNLEfMNeqD6gpIPgMG37M1tM4iEQALOIN3g8wokw+xIAL1oHInYUYBfuxg4pQHH6JmcLC1MR7eeYMsKXgwF3/ltY/VdCyUHe3fGt1/SBq2o4BtFFYOimkEg9W/btY/QHqZ2/t994+dR+cQw=
Received: from DS7PR03CA0211.namprd03.prod.outlook.com (2603:10b6:5:3ba::6) by
 BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 23:52:12 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::31) by DS7PR03CA0211.outlook.office365.com
 (2603:10b6:5:3ba::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 23:52:12 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:11 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 15:52:11 -0800
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:10 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 1/7] drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count assignments
Date:   Thu, 19 Jan 2023 18:51:54 -0500
Message-ID: <20230119235200.441386-2-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|BL1PR12MB5190:EE_
X-MS-Office365-Filtering-Correlation-Id: e87508d6-db49-47c0-b9d2-08dafa782f38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTHcCiv06tO86GXDzUGZPqQSjJ8XfwzXUZQ6ZsgU/wpmgwKLsk7DR1PC0UONZ9N8VuvT5MBEZB89grvCCXsstj3801dRWFj6hM2KX+7E1cXG3iz63ti/fTkl3BqkyCS2iQV6AjAIDqBtKzUhnvtHQqJ2nhUQESiFnaSelrHPwPzaknJ3wMjp7vtwKYputK/6GjV5tKntuVS4M02Dvbl2W5GXnxYTCOwxZHacq1OHtruBvsEVSmC6yifKpzJEqoB6zcvCndFerWvDcaVqCqfCVlCKN+V3iW21jsEUSJMvas/x0ezAQMh1AGNZKOPVIWR9zKDk89a1sFnl1wnWShiQtEm6cknqy9Wq8215ReeUArkBWlnSznhtASmAXS516wx08s16V87h3OFleFXqiaFrX2f1Lu4k2OnVB0EXGO40SfZjhHPEzFZb1XI6ZT69VAfd45TKqM2fNNN78ueEbVL6iJzcIvs92l23GSURizWQaNDkmAih+cmAOo+1PdvyxpXU04mb0ponsVSnhqPKSN0urUQYYCjMy5Ap/x4sZa8SFShNGwb6LjzQivfzRgYkHK2+h3WQl8g2lD9gL9Tdw99Z2RjD3X9kBvdaNiD34nLxnhgNGpH52RnflKhQaGVsrgDV7PT3Fn+znYpUiz5cWF6j83rAPTv1JqLVZfqbes6FvNJWemwwk2HL808GBxZabhAI
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(316002)(81166007)(82740400003)(5660300002)(54906003)(44832011)(4326008)(2616005)(1076003)(8936002)(426003)(41300700001)(36756003)(26005)(186003)(83380400001)(47076005)(70206006)(70586007)(8676002)(40460700003)(110136005)(6666004)(40480700001)(356005)(82310400005)(336012)(86362001)(2906002)(36860700001)(966005)(7696005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:12.0987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e87508d6-db49-47c0-b9d2-08dafa782f38
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

Looks like I made a pretty big mistake here without noticing: it seems when
I moved the assignments of mst_state->pbn_div I completely missed the fact
that the reason for us calling drm_dp_mst_update_slots() earlier was to
account for the fact that we need to call this function using info from the
root MST connector, instead of just trying to do this from each MST
encoder's atomic check function. Otherwise, we end up filling out all of
DC's link information with zeroes.

So, let's restore that and hopefully fix this DSC regression.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 24 +++++++++++++++++++
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   |  5 ----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 22aadbad58d3..4c5b8793b8af 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9643,6 +9643,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	struct drm_connector_state *old_con_state, *new_con_state;
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
+	struct drm_dp_mst_topology_mgr *mgr;
+	struct drm_dp_mst_topology_state *mst_state;
 	struct drm_plane *plane;
 	struct drm_plane_state *old_plane_state, *new_plane_state;
 	enum dc_status status;
@@ -9898,6 +9900,28 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		lock_and_validation_needed = true;
 	}
 
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	/* set the slot info for each mst_state based on the link encoding format */
+	for_each_new_mst_mgr_in_state(state, mgr, mst_state, i) {
+		struct amdgpu_dm_connector *aconnector;
+		struct drm_connector *connector;
+		struct drm_connector_list_iter iter;
+		u8 link_coding_cap;
+
+		drm_connector_list_iter_begin(dev, &iter);
+		drm_for_each_connector_iter(connector, &iter) {
+			if (connector->index == mst_state->mgr->conn_base_id) {
+				aconnector = to_amdgpu_dm_connector(connector);
+				link_coding_cap = dc_link_dp_mst_decide_link_encoding_format(aconnector->dc_link);
+				drm_dp_mst_update_slots(mst_state, link_coding_cap);
+
+				break;
+			}
+		}
+		drm_connector_list_iter_end(&iter);
+	}
+#endif
+
 	/**
 	 * Streams and planes are reset when there are changes that affect
 	 * bandwidth. Anything that affects bandwidth needs to go through
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 5fa9bab95038..e8d14ab0953a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -927,11 +927,6 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	if (IS_ERR(mst_state))
 		return PTR_ERR(mst_state);
 
-	mst_state->pbn_div = dm_mst_get_pbn_divider(dc_link);
-#if defined(CONFIG_DRM_AMD_DC_DCN)
-	drm_dp_mst_update_slots(mst_state, dc_link_dp_mst_decide_link_encoding_format(dc_link));
-#endif
-
 	/* Set up params */
 	for (i = 0; i < dc_state->stream_count; i++) {
 		struct dc_dsc_policy dsc_policy = {0};
-- 
2.39.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44DE67477F
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjASXwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjASXwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482AD9FDCD
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRSMBmmCx1oBDXD4Dia+sxNw729g/bdcVLsJHJvTDBZ420WFT9UP5xX5Xte8CxP6x8AyRZJgD4g3Y8rGq0yPU0Mr2+JxjoVBiBQ17NtXdPTYS4gDTCUe4J3Ra7hOPjcuzyGpEtt/mNPdKrbzItCN8CnEDGH31YihU4hdtGIqcCg5lXQy04bxg3zLEsU3IQt9DsJhD+2e4WBkILOqdlRJ1UKxYZfE9dMXs865aLuxjsWlP5Sm/v70xayeedQwJB+5Brd6AeLhc2MQwasp3dEfjSwXo2JMJEYdiGBW7lnI07u9hgAx2ML5WE5js8ney1H815cLPMzXxdJCqtFKSO9pkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VI3XBHBtbSU6uL6KTUl6iQmWzSvOSkyjsPioCxKmjO4=;
 b=Xn3JllaOXuwvCEdjozwadEps/fl3CDBt3CXIywSkJWgw0ygSpGtOPTn9uFHBv61QwgT8iQMjGlvhYnSgpz5iVjyMQEtk4Pvdccw6Bek1Vyy8bi8N4+JIAHXfdf34LmhKeSFaZcRouRv5HuprT7GtY+4zi9UgXgvBNIoTrWOWHo8p/WBPvjBHlO8cevsTUdQ9E9pWAz8dgS9ipbld8pEPKXFJatu168ZrbRf+H7lO8RxbC1ojiJNLk2WOiNJ2kLgxyYg/D0tnKN7eDtt6C43kuTbf5JyT2yssrTXHlkwNDpjRQ+JYhc6pbFS+9dEOTQXkr/+TB7jqrhzE/uD+EAqySQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI3XBHBtbSU6uL6KTUl6iQmWzSvOSkyjsPioCxKmjO4=;
 b=JLbxniuCowrWuSh9ETt550k8DhPzoTkyAz/tk4qumWsZzNvJqMIDSZBHRwvz4hUdjyrh2Ihi9qwK1ra7oSLhWBEKjunO8o4kz/5r1ESIy3VPcYLTk+oveuXfvxkGMG7lvbbC16nmRslGafX6y62NTFhotpgY3p6s8bMHzIcnJuo=
Received: from DM6PR08CA0063.namprd08.prod.outlook.com (2603:10b6:5:1e0::37)
 by PH7PR12MB6979.namprd12.prod.outlook.com (2603:10b6:510:1b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 23:52:22 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::61) by DM6PR08CA0063.outlook.office365.com
 (2603:10b6:5:1e0::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 23:52:22 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:17 -0600
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:16 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 6/7] drm/amdgpu/display/mst: adjust the naming of mst_port and port of aconnector
Date:   Thu, 19 Jan 2023 18:51:59 -0500
Message-ID: <20230119235200.441386-7-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|PH7PR12MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d12c25-988c-44de-673f-08dafa78355d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +B7z1R+Rwuh14foFZdZQ5OEBjDxUt2urSsD0W1+W/oWbqePt/uEbSPwJjTZHYJoaZZIQK1pE1BCSeQwu8FckGHoGXfgqjClaG8xjL9Udpwy8nZJ5wnnN4NyfbeoWrSbWrc8rr0FVEhHH7Uj9fPDuvm5hcmh0LwsUTa+g4OSxTmZ0+URsYAltenxYXOqfCLzPmSk69Ta9llXu5Lsr+F/4qI0mEMeFO8nQ+5vQs74JTcpbRblWNH0wT5xwVvgEklsk1PyGghf11VDFDpBYOPl/ECzdVTLOddGI42Prw9UQRSvuV7eTGHW1A+/P5GOAtE9FjZpmOaK8TZ2MgPeo30ft0HzYdhZAblauRr2yb/iz+oHKovBkVVT6ssUjUCzDzH9FxauyoD9PYxh1hIlTWhhjM+YCiHOCiVFUYlKPK3HPUMkfWBgRrwaWKBHKqKwim0eMnRR41RipjDHzRxlQExWQ7vWkDiryq4KovWCsl7aQc4hVlVVmu8QPU+mYvFRFzo2Kp6e+UMws7IZ9Mc4xHQbK5p6QH/vmCWza9Qgim2rlOhRaa70ApWFQ9bEWzdypmb5QucgSFD1lermym2Zpaf9nuRLvCzgm5QWNXa9RCTL+EjPZpeuGV1ZsjCEg17yBVUX+VfxkfTZe4z9qtQH4uxuvpZCVMsYU3+65IBkbCJ2zZ2TFLf3Bv+OXJSiQ+0KHlrtWFUkw+K5Hd35/9rJWeYBKcxyje2Fbdh8RmZ133N4QaRc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(86362001)(70586007)(30864003)(44832011)(70206006)(5660300002)(2906002)(8936002)(82740400003)(36860700001)(81166007)(316002)(40480700001)(6666004)(47076005)(110136005)(54906003)(7696005)(426003)(36756003)(478600001)(4326008)(356005)(336012)(82310400005)(41300700001)(8676002)(26005)(1076003)(186003)(40460700003)(83380400001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:22.3898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d12c25-988c-44de-673f-08dafa78355d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6979
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[why & how]
The term (i.e. port & mst_port) that we used to use in amdgpu is a bit
confusing. Rename them to mst_output_port & mst_root respectively.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h      |  4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 24 +++++-----
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c |  2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 16 +++----
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 19 ++++----
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 48 +++++++++----------
 7 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
index bf009de59710..c1ece3d2ea36 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h
@@ -551,8 +551,8 @@ struct amdgpu_mst_connector {
 
 	struct drm_dp_mst_topology_mgr mst_mgr;
 	struct amdgpu_dm_dp_aux dm_dp_aux;
-	struct drm_dp_mst_port *port;
-	struct amdgpu_connector *mst_port;
+	struct drm_dp_mst_port *mst_output_port;
+	struct amdgpu_connector *mst_root;
 	bool is_mst_connector;
 	struct amdgpu_encoder *mst_encoder;
 };
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4c5b8793b8af..291dea18c658 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2197,7 +2197,7 @@ static void s3_handle_mst(struct drm_device *dev, bool suspend)
 	drm_for_each_connector_iter(connector, &iter) {
 		aconnector = to_amdgpu_dm_connector(connector);
 		if (aconnector->dc_link->type != dc_connection_mst_branch ||
-		    aconnector->mst_port)
+		    aconnector->mst_root)
 			continue;
 
 		mgr = &aconnector->mst_mgr;
@@ -6582,11 +6582,11 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 	int clock, bpp = 0;
 	bool is_y420 = false;
 
-	if (!aconnector->port || !aconnector->dc_sink)
+	if (!aconnector->mst_output_port || !aconnector->dc_sink)
 		return 0;
 
-	mst_port = aconnector->port;
-	mst_mgr = &aconnector->mst_port->mst_mgr;
+	mst_port = aconnector->mst_output_port;
+	mst_mgr = &aconnector->mst_root->mst_mgr;
 
 	if (!crtc_state->connectors_changed && !crtc_state->mode_changed)
 		return 0;
@@ -6596,7 +6596,7 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 		return PTR_ERR(mst_state);
 
 	if (!mst_state->pbn_div)
-		mst_state->pbn_div = dm_mst_get_pbn_divider(aconnector->mst_port->dc_link);
+		mst_state->pbn_div = dm_mst_get_pbn_divider(aconnector->mst_root->dc_link);
 
 	if (!state->duplicated) {
 		int max_bpc = conn_state->max_requested_bpc;
@@ -6642,7 +6642,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 
 		aconnector = to_amdgpu_dm_connector(connector);
 
-		if (!aconnector->port)
+		if (!aconnector->mst_output_port)
 			continue;
 
 		if (!new_con_state || !new_con_state->crtc)
@@ -6682,7 +6682,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 			dm_conn_state->pbn = pbn;
 			dm_conn_state->vcpi_slots = slot_num;
 
-			ret = drm_dp_mst_atomic_enable_dsc(state, aconnector->port,
+			ret = drm_dp_mst_atomic_enable_dsc(state, aconnector->mst_output_port,
 							   dm_conn_state->pbn, false);
 			if (ret < 0)
 				return ret;
@@ -6690,7 +6690,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 			continue;
 		}
 
-		vcpi = drm_dp_mst_atomic_enable_dsc(state, aconnector->port, pbn, true);
+		vcpi = drm_dp_mst_atomic_enable_dsc(state, aconnector->mst_output_port, pbn, true);
 		if (vcpi < 0)
 			return vcpi;
 
@@ -7104,7 +7104,7 @@ void amdgpu_dm_connector_init_helper(struct amdgpu_display_manager *dm,
 				adev->mode_info.underscan_vborder_property,
 				0);
 
-	if (!aconnector->mst_port)
+	if (!aconnector->mst_root)
 		drm_connector_attach_max_bpc_property(&aconnector->base, 8, 16);
 
 	/* This defaults to the max in the range, but we want 8bpc for non-edp. */
@@ -7122,7 +7122,7 @@ void amdgpu_dm_connector_init_helper(struct amdgpu_display_manager *dm,
 	    connector_type == DRM_MODE_CONNECTOR_eDP) {
 		drm_connector_attach_hdr_output_metadata_property(&aconnector->base);
 
-		if (!aconnector->mst_port)
+		if (!aconnector->mst_root)
 			drm_connector_attach_vrr_capable_property(&aconnector->base);
 
 #ifdef CONFIG_DRM_AMD_DC_HDCP
@@ -9595,7 +9595,7 @@ static int add_affected_mst_dsc_crtcs(struct drm_atomic_state *state, struct drm
 			continue;
 
 		aconnector = to_amdgpu_dm_connector(connector);
-		if (!aconnector->port || !aconnector->mst_port)
+		if (!aconnector->mst_output_port || !aconnector->mst_root)
 			aconnector = NULL;
 		else
 			break;
@@ -9604,7 +9604,7 @@ static int add_affected_mst_dsc_crtcs(struct drm_atomic_state *state, struct drm
 	if (!aconnector)
 		return 0;
 
-	return drm_dp_mst_add_affected_dsc_crtcs(state, &aconnector->mst_port->mst_mgr);
+	return drm_dp_mst_add_affected_dsc_crtcs(state, &aconnector->mst_root->mst_mgr);
 }
 #endif
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index abbbb3813c1e..b440e2e0cfe0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -604,8 +604,8 @@ struct amdgpu_dm_connector {
 	/* DM only */
 	struct drm_dp_mst_topology_mgr mst_mgr;
 	struct amdgpu_dm_dp_aux dm_dp_aux;
-	struct drm_dp_mst_port *port;
-	struct amdgpu_dm_connector *mst_port;
+	struct drm_dp_mst_port *mst_output_port;
+	struct amdgpu_dm_connector *mst_root;
 	struct drm_dp_aux *dsc_aux;
 	/* TODO see if we can merge with ddc_bus or make a dm_connector */
 	struct amdgpu_i2c_adapter *i2c;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
index 8873ecada27c..27711743c22c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -344,7 +344,7 @@ int amdgpu_dm_crtc_set_crc_source(struct drm_crtc *crtc, const char *src_name)
 			goto cleanup;
 		}
 
-		aux = (aconn->port) ? &aconn->port->aux : &aconn->dm_dp_aux.aux;
+		aux = (aconn->mst_output_port) ? &aconn->mst_output_port->aux : &aconn->dm_dp_aux.aux;
 
 		if (!aux) {
 			DRM_DEBUG_DRIVER("No dp aux for amd connector\n");
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 704860e6ba84..40a95fc0e4f8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1193,7 +1193,7 @@ static int dp_dsc_fec_support_show(struct seq_file *m, void *data)
 			break;
 		}
 		dpcd_caps = aconnector->dc_link->dpcd_caps;
-		if (aconnector->port) {
+		if (aconnector->mst_output_port) {
 			/* aconnector sets dsc_aux during get_modes call
 			 * if MST connector has it means it can either
 			 * enable DSC on the sink device or on MST branch
@@ -1280,7 +1280,7 @@ static ssize_t trigger_hotplug(struct file *f, const char __user *buf,
 	mutex_lock(&aconnector->hpd_lock);
 
 	/* Don't support for mst end device*/
-	if (aconnector->mst_port) {
+	if (aconnector->mst_root) {
 		mutex_unlock(&aconnector->hpd_lock);
 		return -EINVAL;
 	}
@@ -2539,13 +2539,13 @@ static int dp_is_mst_connector_show(struct seq_file *m, void *unused)
 
 	if (aconnector->mst_mgr.mst_state) {
 		role = "root";
-	} else if (aconnector->mst_port &&
-		aconnector->mst_port->mst_mgr.mst_state) {
+	} else if (aconnector->mst_root &&
+		aconnector->mst_root->mst_mgr.mst_state) {
 
 		role = "end";
 
-		mgr = &aconnector->mst_port->mst_mgr;
-		port = aconnector->port;
+		mgr = &aconnector->mst_root->mst_mgr;
+		port = aconnector->mst_output_port;
 
 		drm_modeset_lock(&mgr->base.lock, NULL);
 		if (port->pdt == DP_PEER_DEVICE_MST_BRANCHING &&
@@ -3392,12 +3392,12 @@ static int trigger_hpd_mst_set(void *data, u64 val)
 			if (!aconnector->dc_link)
 				continue;
 
-			if (!aconnector->mst_port)
+			if (!aconnector->mst_root)
 				continue;
 
 			link = aconnector->dc_link;
 			dc_link_dp_receiver_power_ctrl(link, false);
-			drm_dp_mst_topology_mgr_set_mst(&aconnector->mst_port->mst_mgr, false);
+			drm_dp_mst_topology_mgr_set_mst(&aconnector->mst_root->mst_mgr, false);
 			link->mst_stream_alloc_table.stream_count = 0;
 			memset(link->mst_stream_alloc_table.stream_allocations, 0,
 					sizeof(link->mst_stream_alloc_table.stream_allocations));
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 5cff56bb8f56..7aff7eb13ea2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -195,14 +195,14 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
 	 * that blocks before commit guaranteeing that the state
 	 * is not gonna be swapped while still in use in commit tail */
 
-	if (!aconnector || !aconnector->mst_port)
+	if (!aconnector || !aconnector->mst_root)
 		return false;
 
-	mst_mgr = &aconnector->mst_port->mst_mgr;
+	mst_mgr = &aconnector->mst_root->mst_mgr;
 	mst_state = to_drm_dp_mst_topology_state(mst_mgr->base.state);
 
 	/* It's OK for this to fail */
-	payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->port);
+	payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->mst_output_port);
 	if (enable)
 		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
 	else
@@ -247,10 +247,10 @@ enum act_return_status dm_helpers_dp_mst_poll_for_allocation_change_trigger(
 
 	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
-	if (!aconnector || !aconnector->mst_port)
+	if (!aconnector || !aconnector->mst_root)
 		return ACT_FAILED;
 
-	mst_mgr = &aconnector->mst_port->mst_mgr;
+	mst_mgr = &aconnector->mst_root->mst_mgr;
 
 	if (!mst_mgr->mst_state)
 		return ACT_FAILED;
@@ -277,13 +277,14 @@ bool dm_helpers_dp_mst_send_payload_allocation(
 
 	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
-	if (!aconnector || !aconnector->mst_port)
+	if (!aconnector || !aconnector->mst_root)
 		return false;
 
-	mst_mgr = &aconnector->mst_port->mst_mgr;
+	mst_mgr = &aconnector->mst_root->mst_mgr;
 	mst_state = to_drm_dp_mst_topology_state(mst_mgr->base.state);
 
-	payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->port);
+	payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->mst_output_port);
+
 	if (!enable) {
 		set_flag = MST_CLEAR_ALLOCATED_PAYLOAD;
 		clr_flag = MST_ALLOCATE_NEW_PAYLOAD;
@@ -710,7 +711,7 @@ bool dm_helpers_dp_write_dsc_enable(
 				aconnector->dsc_aux, stream, enable_dsc);
 #endif
 
-		port = aconnector->port;
+		port = aconnector->mst_output_port;
 
 		if (enable) {
 			if (port->passthrough_aux) {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index e8d14ab0953a..bc94df02cb0b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -134,7 +134,7 @@ dm_dp_mst_connector_destroy(struct drm_connector *connector)
 	kfree(aconnector->edid);
 
 	drm_connector_cleanup(connector);
-	drm_dp_mst_put_port_malloc(aconnector->port);
+	drm_dp_mst_put_port_malloc(aconnector->mst_output_port);
 	kfree(aconnector);
 }
 
@@ -146,7 +146,7 @@ amdgpu_dm_mst_connector_late_register(struct drm_connector *connector)
 	int r;
 
 	r = drm_dp_mst_connector_late_register(connector,
-					       amdgpu_dm_connector->port);
+					       amdgpu_dm_connector->mst_output_port);
 	if (r < 0)
 		return r;
 
@@ -162,8 +162,8 @@ amdgpu_dm_mst_connector_early_unregister(struct drm_connector *connector)
 {
 	struct amdgpu_dm_connector *aconnector =
 		to_amdgpu_dm_connector(connector);
-	struct drm_dp_mst_port *port = aconnector->port;
-	struct amdgpu_dm_connector *root = aconnector->mst_port;
+	struct drm_dp_mst_port *port = aconnector->mst_output_port;
+	struct amdgpu_dm_connector *root = aconnector->mst_root;
 	struct dc_link *dc_link = aconnector->dc_link;
 	struct dc_sink *dc_sink = aconnector->dc_sink;
 
@@ -213,7 +213,7 @@ bool needs_dsc_aux_workaround(struct dc_link *link)
 static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnector)
 {
 	struct dc_sink *dc_sink = aconnector->dc_sink;
-	struct drm_dp_mst_port *port = aconnector->port;
+	struct drm_dp_mst_port *port = aconnector->mst_output_port;
 	u8 dsc_caps[16] = { 0 };
 	u8 dsc_branch_dec_caps_raw[3] = { 0 };	// DSC branch decoder caps 0xA0 ~ 0xA2
 	u8 *dsc_branch_dec_caps = NULL;
@@ -231,7 +231,7 @@ static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnecto
 	 */
 	if (!aconnector->dsc_aux && !port->parent->port_parent &&
 	    needs_dsc_aux_workaround(aconnector->dc_link))
-		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
+		aconnector->dsc_aux = &aconnector->mst_root->dm_dp_aux.aux;
 
 	if (!aconnector->dsc_aux)
 		return false;
@@ -281,7 +281,7 @@ static int dm_dp_mst_get_modes(struct drm_connector *connector)
 
 	if (!aconnector->edid) {
 		struct edid *edid;
-		edid = drm_dp_mst_get_edid(connector, &aconnector->mst_port->mst_mgr, aconnector->port);
+		edid = drm_dp_mst_get_edid(connector, &aconnector->mst_root->mst_mgr, aconnector->mst_output_port);
 
 		if (!edid) {
 			amdgpu_dm_set_mst_status(&aconnector->mst_status,
@@ -410,15 +410,15 @@ dm_dp_mst_detect(struct drm_connector *connector,
 		 struct drm_modeset_acquire_ctx *ctx, bool force)
 {
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
-	struct amdgpu_dm_connector *master = aconnector->mst_port;
-	struct drm_dp_mst_port *port = aconnector->port;
+	struct amdgpu_dm_connector *master = aconnector->mst_root;
+	struct drm_dp_mst_port *port = aconnector->mst_output_port;
 	int connection_status;
 
 	if (drm_connector_is_unregistered(connector))
 		return connector_status_disconnected;
 
 	connection_status = drm_dp_mst_detect_port(connector, ctx, &master->mst_mgr,
-							aconnector->port);
+							aconnector->mst_output_port);
 
 	if (port->pdt != DP_PEER_DEVICE_NONE && !port->dpcd_rev) {
 		uint8_t dpcd_rev;
@@ -475,8 +475,8 @@ static int dm_dp_mst_atomic_check(struct drm_connector *connector,
 				  struct drm_atomic_state *state)
 {
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
-	struct drm_dp_mst_topology_mgr *mst_mgr = &aconnector->mst_port->mst_mgr;
-	struct drm_dp_mst_port *mst_port = aconnector->port;
+	struct drm_dp_mst_topology_mgr *mst_mgr = &aconnector->mst_root->mst_mgr;
+	struct drm_dp_mst_port *mst_port = aconnector->mst_output_port;
 
 	return drm_dp_atomic_release_time_slots(state, mst_mgr, mst_port);
 }
@@ -538,8 +538,8 @@ dm_dp_add_mst_connector(struct drm_dp_mst_topology_mgr *mgr,
 		return NULL;
 
 	connector = &aconnector->base;
-	aconnector->port = port;
-	aconnector->mst_port = master;
+	aconnector->mst_output_port = port;
+	aconnector->mst_root = master;
 	amdgpu_dm_set_mst_status(&aconnector->mst_status,
 			MST_PROBE, true);
 
@@ -940,7 +940,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		if (!aconnector)
 			continue;
 
-		if (!aconnector->port)
+		if (!aconnector->mst_output_port)
 			continue;
 
 		stream->timing.flags.DSC = 0;
@@ -948,7 +948,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 		params[count].timing = &stream->timing;
 		params[count].sink = stream->sink;
 		params[count].aconnector = aconnector;
-		params[count].port = aconnector->port;
+		params[count].port = aconnector->mst_output_port;
 		params[count].clock_force_enable = aconnector->dsc_settings.dsc_force_enable;
 		if (params[count].clock_force_enable == DSC_CLK_FORCE_ENABLE)
 			debugfs_overwrite = true;
@@ -1157,7 +1157,7 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 
 		aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
-		if (!aconnector || !aconnector->dc_sink || !aconnector->port)
+		if (!aconnector || !aconnector->dc_sink || !aconnector->mst_output_port)
 			continue;
 
 		if (!aconnector->dc_sink->dsc_caps.dsc_dec_caps.is_dsc_supported)
@@ -1172,7 +1172,7 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
 			continue;
 
-		mst_mgr = aconnector->port->mgr;
+		mst_mgr = aconnector->mst_output_port->mgr;
 		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
 		if (ret != 0)
@@ -1218,7 +1218,7 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 
 		aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
 
-		if (!aconnector || !aconnector->dc_sink || !aconnector->port)
+		if (!aconnector || !aconnector->dc_sink || !aconnector->mst_output_port)
 			continue;
 
 		if (!aconnector->dc_sink->dsc_caps.dsc_dec_caps.is_dsc_supported)
@@ -1230,7 +1230,7 @@ static int pre_compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 		if (!is_dsc_need_re_compute(state, dc_state, stream->link))
 			continue;
 
-		mst_mgr = aconnector->port->mgr;
+		mst_mgr = aconnector->mst_output_port->mgr;
 		ret = compute_mst_dsc_configs_for_link(state, dc_state, stream->link, vars, mst_mgr,
 						       &link_vars_start_index);
 		if (ret != 0)
@@ -1445,8 +1445,8 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	 * with DSC enabled.
 	 */
 	if (is_dsc_common_config_possible(stream, &bw_range) &&
-	    aconnector->port->passthrough_aux) {
-		mst_mgr = aconnector->port->mgr;
+	    aconnector->mst_output_port->passthrough_aux) {
+		mst_mgr = aconnector->mst_output_port->mgr;
 		mutex_lock(&mst_mgr->lock);
 
 		cur_link_settings = stream->link->verified_link_cap;
@@ -1454,7 +1454,7 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 		upper_link_bw_in_kbps = dc_link_bandwidth_kbps(aconnector->dc_link,
 							       &cur_link_settings
 							       );
-		down_link_bw_in_kbps = kbps_from_pbn(aconnector->port->full_pbn);
+		down_link_bw_in_kbps = kbps_from_pbn(aconnector->mst_output_port->full_pbn);
 
 		/* pick the bottleneck */
 		end_to_end_bw_in_kbps = min(upper_link_bw_in_kbps,
@@ -1478,7 +1478,7 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 		bpp = convert_dc_color_depth_into_bpc(stream->timing.display_color_depth) * 3;
 		pbn = drm_dp_calc_pbn_mode(stream->timing.pix_clk_100hz / 10, bpp, false);
 
-		if (pbn > aconnector->port->full_pbn)
+		if (pbn > aconnector->mst_output_port->full_pbn)
 			return DC_FAIL_BANDWIDTH_VALIDATE;
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 	}
-- 
2.39.0


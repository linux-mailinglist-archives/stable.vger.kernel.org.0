Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2198B6E2AD1
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 21:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjDNT5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 15:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDNT5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 15:57:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE5E6A6F
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 12:56:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHQ3NGymFtI5IiXYTjXKd23qLglLxvbUKKFZkZbNhX2e3DYGrN8js3Mwv9R3dpb45lCugTVpYfRh+23S7c1tJe4oOtZlyFSXheuXynFiWgjCa1adNnWIoDU5KoTGpJHBzKmjPgf93HoB1Fm50gsuqx0blLJqt0CLv8fxEB/ZvC/e/qDwPU5c0ZpTncpXjBp3dm4SzwCUVUJq2Z5BMxQnVSI8sjG8dDW9hBiA8s/Wa90IwLU8VL3CpQY4R8e908CuU9+eWjBEVTZu9RKh8VLT61IZ1GBHxi/p0821vHErdnFfcWCrYdu3bEisli8MUHQQ+ueL0VFCkMOWNJgoGMMcCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzXxQWX1bP7mzqpaIuu6+Xqvx2NrnEb5fqvIAHWMEjo=;
 b=K11BdTrmYeK5xp5n4r7htOggm+z9DCVMoxqXQapgrDAmJOk5tuVIoQkBGuug/FhhgXrG9A499TB7pgh+0krdrU+iOwK/rlAtzsJqNFJSrQsmEhbBVGPyUOhiJDCK4XGS7Q5z3dnoH8VzDV+VoyO37Ng9DjX0QHYRfSl94MtDjM7bVMdPhoWWoueZ659pBQbx7zbn75zApvEV4+V1lFbsaneDvkNxfxhXVNFuUqSCsVacx4mVab356o+DDbxR7DDmr3+u1Gn/pJYb6qJWvDxzIPz7dU0oPRWkcfzL5u1jcgdK6MoAxqiFQuVc+BW9fx2LoaowHK5z5/bfBzzxoyPiPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzXxQWX1bP7mzqpaIuu6+Xqvx2NrnEb5fqvIAHWMEjo=;
 b=kwrlM4L9KviYaqXIyIjStwQBZFf+FuufbJpXOpXCR8IAq9My6st/BBRdHRRq6mYO47RJQUVcdQ6leXeFF/si4fHsIpWY+MhyEJzsXMCagMYp3z1TuR1F0PVvB0qk+mPfNJOzvOYftxHBGADL8yr2APjuTNCY1VMIQlmeomys1WE=
Received: from MW4PR04CA0160.namprd04.prod.outlook.com (2603:10b6:303:85::15)
 by MW3PR12MB4538.namprd12.prod.outlook.com (2603:10b6:303:55::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 19:56:48 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::26) by MW4PR04CA0160.outlook.office365.com
 (2603:10b6:303:85::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.32 via Frontend
 Transport; Fri, 14 Apr 2023 19:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.33 via Frontend Transport; Fri, 14 Apr 2023 19:56:47 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 14 Apr
 2023 14:56:46 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Veronika Schwan <veronika@pisquaredover6.de>, <Jerry.Zuo@amd.com>
Subject: [PATCH 6.2 6.1 1/1] drm/amd/display: Pass the right info to drm_dp_remove_payload
Date:   Fri, 14 Apr 2023 14:56:34 -0500
Message-ID: <20230414195634.1845-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230414195634.1845-1-mario.limonciello@amd.com>
References: <20230414195634.1845-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT056:EE_|MW3PR12MB4538:EE_
X-MS-Office365-Filtering-Correlation-Id: 49910602-86a6-406d-c6da-08db3d2261ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AzW3jho+an587VC0MsSkaOHPUxhAp44y+ba9c+sZm0fJpDVTRAtiiM9/ljYUDodIuc3Guhhh3DYAUaN9gFiyX/Nv423ksgF9DZd3cPiGj5OhoqDTDx4xDVQxr4j0Tj69qyPM4J6bXFLS8dXPdLDj6e/XxdUKg6Em2a1bawi6s4rHnLtlNo0rKTNM0mXygmSqW+KgzlX+19+fsKpUPgGCxfQ4XAK7dH2lO9Vh0bQvdt/GDeHCIWabp41XiFBoUv2w1n73LOrOscoUaNH6Bv5UF8NA8KeraL1t0PsuYzmBwnOHrh1indMOynNFWT8IS35A55/kAvI+nU0Qa5qn2FZtIHhT4V2CJ5Z0qxRLK7I1YHmn/nnLIch+KJ//QjAIEqMyKK3V3Ay7ujUDudtij1UNh9NdZuu6xKofAutktXZncvtWMHRM+el1RGD8oSRaFgKUajEUrQJdFFRM94FJI+K9VsaUPPgwUcO6aYt9bAB5YKz0rnDEm3HOC3as48a1SNlFZLlnY5LqXtAQS8qH8IM2G/ZWm9n5vy6Sk0QgXQX4Qzikh4OU2pJ33Su76cAE+ik25DsFpPcszDRmQSRGxlaAVnpXpUXcce94KWLCRA1r1nDrhhsh+YVOheg86fW6l6hKl6yGt598VOl54q7xR4ECSMwmErWYMmqTQ9Mic2rgkwn1rQ28falEN5gywVlda7UF2ZtNXf+1YkxLuy+6F7GrcaytL+xap3DNh7kmGLUHfQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199021)(40470700004)(36840700001)(46966006)(316002)(4326008)(6916009)(82740400003)(70206006)(70586007)(5660300002)(44832011)(2616005)(336012)(426003)(47076005)(82310400005)(7696005)(6666004)(36756003)(86362001)(41300700001)(40460700003)(54906003)(40480700001)(1076003)(186003)(26005)(16526019)(2906002)(8676002)(8936002)(83380400001)(36860700001)(478600001)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 19:56:47.8233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49910602-86a6-406d-c6da-08db3d2261ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4538
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[Why & How]
drm_dp_remove_payload() interface was changed. Correct amdgpu dm code
to pass the right parameter to the drm helper function.

Reviewed-by: Jerry Zuo <Jerry.Zuo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry-picked from b8ca445f550a9a079134f836466ddda3bfad6108)
[Hand modified due to missing f0127cb11299df80df45583b216e13f27c408545 which
 failed to apply due to missing 94dfeaa46925bb6b4d43645bbb6234e846dec257]
Reported-and-tested-by: Veronika Schwan <veronika@pisquaredover6.de>
Fixes: d7b5638bd337 ("drm/amd/display: Take FEC Overhead into Timeslot Calculation")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 57 ++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 657e7c7b59e9..43be27c8d2ff 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -175,6 +175,40 @@ void dm_helpers_dp_update_branch_info(
 	const struct dc_link *link)
 {}
 
+static void dm_helpers_construct_old_payload(
+			struct dc_link *link,
+			int pbn_per_slot,
+			struct drm_dp_mst_atomic_payload *new_payload,
+			struct drm_dp_mst_atomic_payload *old_payload)
+{
+	struct link_mst_stream_allocation_table current_link_table =
+									link->mst_stream_alloc_table;
+	struct link_mst_stream_allocation *dc_alloc;
+	int i;
+
+	*old_payload = *new_payload;
+
+	/* Set correct time_slots/PBN of old payload.
+	 * other fields (delete & dsc_enabled) in
+	 * struct drm_dp_mst_atomic_payload are don't care fields
+	 * while calling drm_dp_remove_payload()
+	 */
+	for (i = 0; i < current_link_table.stream_count; i++) {
+		dc_alloc =
+			&current_link_table.stream_allocations[i];
+
+		if (dc_alloc->vcp_id == new_payload->vcpi) {
+			old_payload->time_slots = dc_alloc->slot_count;
+			old_payload->pbn = dc_alloc->slot_count * pbn_per_slot;
+			break;
+		}
+	}
+
+	/* make sure there is an old payload*/
+	ASSERT(i != current_link_table.stream_count);
+
+}
+
 /*
  * Writes payload allocation table in immediate downstream device.
  */
@@ -186,7 +220,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
 {
 	struct amdgpu_dm_connector *aconnector;
 	struct drm_dp_mst_topology_state *mst_state;
-	struct drm_dp_mst_atomic_payload *payload;
+	struct drm_dp_mst_atomic_payload *target_payload, *new_payload, old_payload;
 	struct drm_dp_mst_topology_mgr *mst_mgr;
 
 	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
@@ -202,17 +236,26 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
 	mst_state = to_drm_dp_mst_topology_state(mst_mgr->base.state);
 
 	/* It's OK for this to fail */
-	payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->port);
-	if (enable)
-		drm_dp_add_payload_part1(mst_mgr, mst_state, payload);
-	else
-		drm_dp_remove_payload(mst_mgr, mst_state, payload, payload);
+	new_payload = drm_atomic_get_mst_payload_state(mst_state, aconnector->port);
+
+	if (enable) {
+		target_payload = new_payload;
+
+		drm_dp_add_payload_part1(mst_mgr, mst_state, new_payload);
+	} else {
+		/* construct old payload by VCPI*/
+		dm_helpers_construct_old_payload(stream->link, mst_state->pbn_div,
+						new_payload, &old_payload);
+		target_payload = &old_payload;
+
+		drm_dp_remove_payload(mst_mgr, mst_state, &old_payload, new_payload);
+	}
 
 	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
 	 * stream. AMD ASIC stream slot allocation should follow the same
 	 * sequence. copy DRM MST allocation to dc */
-	fill_dc_mst_payload_table_from_drm(stream->link, enable, payload, proposed_table);
+	fill_dc_mst_payload_table_from_drm(stream->link, enable, target_payload, proposed_table);
 
 	return true;
 }
-- 
2.34.1


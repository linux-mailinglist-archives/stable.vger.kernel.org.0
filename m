Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1DE674776
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjASXwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjASXwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9E99F3A1
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFB4eAoen9+RsT4/hB7r+SqKmqVoiq95GdLkj9rm9+ZSp45bN/uVYsznODvbsdV4Bh+z374X/SJ2CIdhDObhMIyVykG0Nt0E1EaZEOMYUmL7k8/Y2DN5NCyYsvUwYVUjnFy2B1JT6trkxHtH9HtfqiGU18C8Uey8zxgX+jKnMasesjx67lCCDbB34m2JRU0nbSPqh+Y/WF9jgyJTZs/ugNca0Ad7ANRHibGqSevd90xAEltSQSTqZskq+FmE8BYXLgpn+S+ihmlgVt0SkhNJxB5nLFVTgARPLwaab1mf4Gg2tiT6QUW7FGDvcu5H9/XIbVexYY0nXJpO1drUsC9ezg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoTb851I2qcWpjzki/BNc1wSpOxdnUcvbhcgbIciZu0=;
 b=oYVh2W3bfNWE2E2mf2O6tmpd66cSx3C1ML/ttv3PUqn3yCugiGbLRo4HVIlwgwaVQiVnRg2j3wHurELw1ygFvDZEocRop8nEBoK6xxcvJbmGX1E7of5uUrDqk89PsI7/cM8+tNXnnfs3VSrQtla6hbmxIfwJJ1svDU5RgRwn6iP5Y6k8zcs0I7spRXgpyxgJ1UrmOnGFeueGw9isH9z0xC9TlrrsaxvN1ZU4mwCA9dN+XN2SYOiErunUTIH7PSNpsmHOJrNTGQFqLyf5QMuzAqDbxwsg0DpqTCbWwx9tVurPrfVz5DZs8DjDM6n9D1JsvmErXcX/OUuu3TtpPJgHag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoTb851I2qcWpjzki/BNc1wSpOxdnUcvbhcgbIciZu0=;
 b=oXqvXDsiGezjL5uhF2eIfrMMUops3RinT+NQwo/MQVx0zgtW7g6vcOdotE3nq7BADaSfFroQlvvcbqokuc+buNBoxdPgEX8IxzZRBsRS6V4LR3Op1GuOyg+3WVwKh0t660ukEaTGPt19+EQezbXAFn6LAZmpkkyjtc8EF1Bk0Z8=
Received: from DM5PR08CA0031.namprd08.prod.outlook.com (2603:10b6:4:60::20) by
 CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24; Thu, 19 Jan 2023 23:52:13 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::8a) by DM5PR08CA0031.outlook.office365.com
 (2603:10b6:4:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 23:52:13 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:12 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 15:52:12 -0800
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:11 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 2/7] drm/amdgpu/display/mst: limit payload to be updated one by one
Date:   Thu, 19 Jan 2023 18:51:55 -0500
Message-ID: <20230119235200.441386-3-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 4abf48f9-3148-4733-e8c0-08dafa783002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MAhQqxP9rb8TFX0sxX6t1Pwh/7UZ/e4PpcYt3HikM5BOj8QRkmGKKqIStwNs22L1b6qAJKJ4h0maf4GlJVS1eYqMX0YrYtBww6RJ6Zk/15+Qkcdmh75/a9vas08VX4E7zprLaUucMRt9iBXpT7+BCci370vaz0HQNSj06giKqHNr15O4RbU86W+kxYL2gRzko7TqpR5Ny+wKuXH3j1U7plIu+Xi71LPhKya1UFuJZ9UUtNMHu2bl3EFNmo7JAtPcMKVpm6QK0DHvxrYieXm1ksICYdZZXhqQlgJwvYPPsOSOxZmT5+ghuEYSWjbCXu1pQ2C+kyU9nRole0PDuQzKq2p2DRyxopl3P8M4VfN54bfUDs/YFrFFS7Dei4TfixRHQEqJpZ71WyF8JLC8OdvjRZOPqUDTEF1DCKqkqYHqOhS6ch35q4pBC+ozq511AjK19rR8Gxnit/cZR/l6SStw8+VpMjBGoqzjW8oNAzSpSQbk2uOU5hFwmEJnlpEW625QCiasSna3YW91wEX5sCSTx1UDAD11ToKtXuM6E/tz+IB+YhozjFPeEKnmbtnXPnHs9PJXDrrDmpoHygLu8dJop5e6wQ4cy4/qzhOcNqQDwWa8+wEfbPJCd2x4q+80VMReOy0ViKr9c3yNRu/pTX8xh/t3mJ+4wahDyvL3J/qNeMr/2MVK6k8NSPo2+TSGcGZB
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(41300700001)(4326008)(6666004)(26005)(8676002)(70586007)(8936002)(70206006)(36756003)(82310400005)(336012)(2906002)(36860700001)(44832011)(40460700003)(5660300002)(15650500001)(110136005)(316002)(2616005)(54906003)(7696005)(40480700001)(86362001)(966005)(186003)(478600001)(356005)(81166007)(1076003)(83380400001)(82740400003)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:13.4081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abf48f9-3148-4733-e8c0-08dafa783002
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230
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

[Why]
amdgpu expects to update payload table for one stream one time
by calling dm_helpers_dp_mst_write_payload_allocation_table().
Currently, it get modified to try to update HW payload table
at once by referring mst_state.

[How]
This is just a quick workaround. Should find way to remove the
temporary struct dc_dp_mst_stream_allocation_table later if set
struct link_mst_stream_allocatio directly is possible.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 51 ++++++++++++++-----
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 6994c9a1ed85..5cff56bb8f56 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -120,23 +120,50 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 }
 
 static void
-fill_dc_mst_payload_table_from_drm(struct drm_dp_mst_topology_state *mst_state,
-				   struct amdgpu_dm_connector *aconnector,
+fill_dc_mst_payload_table_from_drm(struct dc_link *link,
+				   bool enable,
+				   struct drm_dp_mst_atomic_payload *target_payload,
 				   struct dc_dp_mst_stream_allocation_table *table)
 {
 	struct dc_dp_mst_stream_allocation_table new_table = { 0 };
 	struct dc_dp_mst_stream_allocation *sa;
-	struct drm_dp_mst_atomic_payload *payload;
+	struct link_mst_stream_allocation_table copy_of_link_table =
+										link->mst_stream_alloc_table;
+
+	int i;
+	int current_hw_table_stream_cnt = copy_of_link_table.stream_count;
+	struct link_mst_stream_allocation *dc_alloc;
+
+	/* TODO: refactor to set link->mst_stream_alloc_table directly if possible.*/
+	if (enable) {
+		dc_alloc =
+		&copy_of_link_table.stream_allocations[current_hw_table_stream_cnt];
+		dc_alloc->vcp_id = target_payload->vcpi;
+		dc_alloc->slot_count = target_payload->time_slots;
+	} else {
+		for (i = 0; i < copy_of_link_table.stream_count; i++) {
+			dc_alloc =
+			&copy_of_link_table.stream_allocations[i];
+
+			if (dc_alloc->vcp_id == target_payload->vcpi) {
+				dc_alloc->vcp_id = 0;
+				dc_alloc->slot_count = 0;
+				break;
+			}
+		}
+		ASSERT(i != copy_of_link_table.stream_count);
+	}
 
 	/* Fill payload info*/
-	list_for_each_entry(payload, &mst_state->payloads, next) {
-		if (payload->delete)
-			continue;
-
-		sa = &new_table.stream_allocations[new_table.stream_count];
-		sa->slot_count = payload->time_slots;
-		sa->vcp_id = payload->vcpi;
-		new_table.stream_count++;
+	for (i = 0; i < MAX_CONTROLLER_NUM; i++) {
+		dc_alloc =
+			&copy_of_link_table.stream_allocations[i];
+		if (dc_alloc->vcp_id > 0 && dc_alloc->slot_count > 0) {
+			sa = &new_table.stream_allocations[new_table.stream_count];
+			sa->slot_count = dc_alloc->slot_count;
+			sa->vcp_id = dc_alloc->vcp_id;
+			new_table.stream_count++;
+		}
 	}
 
 	/* Overwrite the old table */
@@ -185,7 +212,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
 	 * AUX message. The sequence is slot 1-63 allocated sequence for each
 	 * stream. AMD ASIC stream slot allocation should follow the same
 	 * sequence. copy DRM MST allocation to dc */
-	fill_dc_mst_payload_table_from_drm(mst_state, aconnector, proposed_table);
+	fill_dc_mst_payload_table_from_drm(stream->link, enable, payload, proposed_table);
 
 	return true;
 }
-- 
2.39.0


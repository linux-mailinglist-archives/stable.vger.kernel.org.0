Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96ABE674777
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjASXwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjASXwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:20 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E9DA1005
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5+c13edLQtsvnBx/hxDrjV0aXwRE49CohensobDiQokgoahA1f1MSr/KoCKsL1RJ+LHn2MB+mli5oHo5NKUCP5/bRaqyD8R88rJGwS7j6s8/vDstGpluk+htcPB5pBd9hb6ewfw7bTCdff+rC0eYVGsI+YL1E2xw9ZipsCHqGS4yjzA/F5rta+YyazinucXRos2SmxfEyP6wME/qzVxbJYO749LTw2VlD7SL2Px3had18NtRCVbCjm7LOw6bm+k2oXM2ay6cJSH3ukgoaXhwNpLBHwrNK3OkjXwWNJ8Le6mjTozs6ZYFvK9dEzdWkLW6qctJkc0r6xyi6DuG+3giQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONrlRNxDO+XMRT0Ad/4yn/vo4hAGZ+1DdAaA7eSMkGE=;
 b=m02CbbNpJ8/PKS5C52jjYy0mBnFYxJw1Pc5qEBk23c9H+iUuKTbHvlOi5RM8dz4BBDkniPhwMxP8+QkPyDSFZWC/IrC8Pd7JNcKd0JB5xuaDGj1d0xokIH4U10gnrpBDHDHZ5hWcPmoURU/7jD7tSEzgQXJiWW90vg9uWJVkvBSX7xNXeVe+grQ/njfY5E1twSoeSLUHnRANR8xe+YYbIGfWpf93ahAhcUBx7X508C3Pl7LzVq71IkgZaE0xHY1ZG6b1dpFt2kPLfTdizG8bfRyb3onilkE7IrO6IfwZ66+Xboz6zEJ2kXtOlguoDUV5lwkKtA2vKtmWeUG0Uyz77A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONrlRNxDO+XMRT0Ad/4yn/vo4hAGZ+1DdAaA7eSMkGE=;
 b=NJ7MkrZf1hAgeOYMftfVmK2VxccTqHug1tk/wB8OhqzWMqWHf5PYYIj4fCCZHJBc0cy3mAWLYM3JtN779pjiFSVV5jQ2UnaKBZ1oxd1SstbWho60TAvGx9s1zMhRojFFbrRr3NQT7BS6S80ZaOoynkDbje4iuS0BuHzzgXEoAFw=
Received: from DM6PR17CA0033.namprd17.prod.outlook.com (2603:10b6:5:1b3::46)
 by DM4PR12MB6063.namprd12.prod.outlook.com (2603:10b6:8:b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 23:52:16 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::9f) by DM6PR17CA0033.outlook.office365.com
 (2603:10b6:5:1b3::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 23:52:15 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:14 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 15:52:13 -0800
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:12 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 3/7] drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD
Date:   Thu, 19 Jan 2023 18:51:56 -0500
Message-ID: <20230119235200.441386-4-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|DM4PR12MB6063:EE_
X-MS-Office365-Filtering-Correlation-Id: cc102b94-0881-4796-505b-08dafa783186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zao/W9ua4apHrB0w3y+x85opIJqbUNHXBkv9lbW35JMH3dkVghPUlu/LrfXigdabxN1pAQDv+u5hanj3BGGoFFFN+ySplahgLhMmGBgHNAIjWBM54h8B1VWew7ol7wEGKhWPMX+9Td502x32lcWm0Ce06rakjiocaqyoqOyrn7bIEra9iRT4hQYwuX5/zRjHGgqHzyw1A2SegxBIuCKp7Wt1yg40nPPCKnlvUNdqNsHX6m39q0fWZMnzSxikOkFVD3Gj/q7uf8UCmWxSkHc/AZBbl7Yed2VC9Nx6Vhm/bHV1Vt7Mk59fBSaIJMP6pBF5eYP9M9HLukLSq4F56chjn19UcmWlxJ9wJISaZgfktjtOed76LIapA0On2f4Dq/9pmt0RTj874IVF2ziah0fByVbJMJSGwLN1rn7t8A6EZ0M+0YUeKCf9Q5wDLqVvZkuzXCjYP3kQSMm5FDFsBN5OWQ75TasgdETYxUnQkwJ7ZMwfkX7YVavEUKiX8vlUzuhvwG8/+u7VCNHp6GqGNchkyFxo4krmg/ooHAdz1VtaJ8q5BQjN1GxY0ZP4y13sSdP6pdb4krOueAC/9KOqDQnKnMPCn6pStVT4H+DCc2y2sMqKRTpX44mHzEzaqCOvsT9Ury0Zz7dznFw60DQkKHX1mBDXr6bFteRZkLB/CUT+h759IdoFR0EMW/DINPbbXUPP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199015)(36840700001)(46966006)(40470700004)(36756003)(83380400001)(8936002)(2616005)(41300700001)(110136005)(1076003)(336012)(316002)(47076005)(54906003)(426003)(70206006)(70586007)(4326008)(8676002)(356005)(86362001)(81166007)(82740400003)(82310400005)(44832011)(15650500001)(40460700003)(2906002)(5660300002)(40480700001)(36860700001)(966005)(478600001)(66899015)(186003)(7696005)(26005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:15.9470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc102b94-0881-4796-505b-08dafa783186
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6063
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

[Why & How]
Now the vc_start_slot is controlled at drm side. When we
service a long HPD, we still need to run
dm_helpers_dp_mst_write_payload_allocation_table() to update
drm mst_mgr's relevant variable. Otherwise, on the next plug-in,
payload will get assigned with a wrong start slot.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index d9e490eca10f..bf5a31e2be8a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3999,10 +3999,13 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 	struct fixed31_32 avg_time_slots_per_mtp = dc_fixpt_from_int(0);
 	int i;
 	bool mst_mode = (link->type == dc_connection_mst_branch);
+	/* adjust for drm changes*/
+	bool update_drm_mst_state = true;
 	const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
 	const struct dc_link_settings empty_link_settings = {0};
 	DC_LOGGER_INIT(link->ctx->logger);
 
+
 	/* deallocate_mst_payload is called before disable link. When mode or
 	 * disable/enable monitor, new stream is created which is not in link
 	 * stream[] yet. For this, payload is not allocated yet, so de-alloc
@@ -4018,7 +4021,7 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 				&empty_link_settings,
 				avg_time_slots_per_mtp);
 
-	if (mst_mode) {
+	if (mst_mode || update_drm_mst_state) {
 		/* when link is in mst mode, reply on mst manager to remove
 		 * payload
 		 */
@@ -4081,11 +4084,18 @@ static enum dc_status deallocate_mst_payload(struct pipe_ctx *pipe_ctx)
 			stream->ctx,
 			stream);
 
+		if (!update_drm_mst_state)
+			dm_helpers_dp_mst_send_payload_allocation(
+				stream->ctx,
+				stream,
+				false);
+	}
+
+	if (update_drm_mst_state)
 		dm_helpers_dp_mst_send_payload_allocation(
 			stream->ctx,
 			stream,
 			false);
-	}
 
 	return DC_OK;
 }
-- 
2.39.0


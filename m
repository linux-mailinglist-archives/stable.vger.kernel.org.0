Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4064C6C594D
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 23:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCVWJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 18:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjCVWJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 18:09:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F3B1ACF6
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 15:09:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=layoicItVUQIBPF7iGXHrNrFPuEKdEADKesJbusWsTgdRIzlc1/etH804PXjO6O8x2KCOc1iLvxcn9UrrchnKVOsIy7HfhG/mWEYW+BAnlCKyxxvjwqcAr2n36oBaZCZo0f4tYuaZR9ucfEV0+SQjGoOguf8a2a6cViFT9tkgQh27kJBFn4jYwXgd13mYervlboVZ4iHDsPwvEDgHAiDsmLO8r715p8dcsIDu+COxop955xPTqaBodoHhil1uXDVznwVtMcJehEZTTo2kFJeWaONdR1qIf/uE1J4SvEg0pvqYhlOkrUMAHKEYBxqhf6d/5Ul9GJ9ry6lwj1OpBp1Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ClEFQV9tdYjSNSUEXzi1GYp1MRju0jsEiMJ8ucwoD0=;
 b=IA/B7cBIM4wxN1A/RDMsjWOxplKKfbECHIZiRFx3spypuMklvA3MppuvG8Sa/ArE9hbVOCyaBLwytYR7W6lSzvIug0/W2nLHIjbRylcl3Y4LKm2LmML9yLVhC+Aqd8wYbHwNsDlXXBwZSPr2AFcP8AHpKpsml4dlUjxtUXPPeW+M6c7WzReIV2Jf9GS+zazuQNN5Hug3B9ZzRnCc0yYv1yRGD1yptkon4koMb6DIf1S4Bgth1ZUcwvrS3mLNLIp7B1XntMVdWe8XOLUCudy6hZxmVg/cetOM7NsZLFG2I+4XsYj6Wsxl34LGigXuju2R8aU+i+UYjuG4dvP9HiRegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ClEFQV9tdYjSNSUEXzi1GYp1MRju0jsEiMJ8ucwoD0=;
 b=JlMmBY0SWUGaeewxeqBvhTlZGpKB7YruC2A/132GD40/0llnjIke7jp+/ymRV83X9ksjBAyiPgIzifVdFiAIb4NzQbsLpoEOtpfxnh9eFlD3+TTj91EZk7Stam0j8pIrYAQqcsllrX3OkN1qajxgEun0rj9VGghvjs8M0uhBvXE=
Received: from MW2PR16CA0069.namprd16.prod.outlook.com (2603:10b6:907:1::46)
 by DM6PR12MB4250.namprd12.prod.outlook.com (2603:10b6:5:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 22:09:00 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::58) by MW2PR16CA0069.outlook.office365.com
 (2603:10b6:907:1::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 22:09:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 22:09:00 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 17:08:58 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Cruise Hung <Cruise.Hung@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Subject: [PATCH 6.2.y/6.1.y 1/1] drm/amd/display: Fix DP MST sinks removal issue
Date:   Wed, 22 Mar 2023 17:08:41 -0500
Message-ID: <20230322220841.898-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322220841.898-1-mario.limonciello@amd.com>
References: <20230322220841.898-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT047:EE_|DM6PR12MB4250:EE_
X-MS-Office365-Filtering-Correlation-Id: 823194dc-639a-4299-695a-08db2b220a3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WQ70hq3Qa9VgoPQ/wwKxGNKdpLw8529A//k0v0n4FqMy/FlxnSQQ7a5G5v7vFuroJEMVq4rSBNl4fb1he0OD9pX1RFsOViEjtJ+vncAVmuDGcVghu4oqqzZKpxNqHLWXaRxKopq04SZBrGSxzaLnXZYqoJG5SojsqBKG/9rQhtPB+gMSG5iqGzv/Os7vrYfFWAms37u3xcpFghaKDrzNKm9Zk4gcFOaG4ZTM4rxX1PViUcJG2zEDnOdTlodh1ejUWLvCdYokLqzi4oU5hyIosw5v0ZnoVSpsei5G0wydDcGPjTn9dYtBMJ5No8E2+apX9ttU3vZZZ+RtuXBdOb1R810UcXrZCG9YLt6kOHlhkn3JHw7L7ANbk2EdiSA8+dfAQqdKR6lscLcCGyl2fpDI8DwY9G9q7OkWrCHJc1hI8wyfs9JYWZ7ZAbO7v3XU4MATPivU2B0HuuSj9jthFQicPPamufr8rWV2+LZPt8ReGt4mUGopcgd+TyJNwmR9Lv3lc5V6Ko+Rbg/HgKyet3IdaKEsFUjssbARYrqrw4KGMnp3vNgRXSyNyDD1mkpQJGwAcUpnO+zdlaIjyfe0dJu00BsRVL/uLHFo4lvBZbb0FZ/KK1t9LaodBfYIxBQStTdhjcnoCqakFMXJMAIRWq39Di1WDWcztwf7NI5aV4b23Oa4zNSB0sO/hdELOCU3bCl/2BTqZP0L73pTYMQNQ+x3Z8NGyPVAYxACiXmGZDeXdtD83W2Qdzb+oCgRgYmyQGVL7CEXKsyUrJYDyxwyjhBNQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(54906003)(40460700003)(8936002)(44832011)(5660300002)(2906002)(82740400003)(356005)(81166007)(36860700001)(36756003)(7696005)(70206006)(478600001)(8676002)(6666004)(70586007)(4326008)(41300700001)(6916009)(40480700001)(336012)(82310400005)(426003)(47076005)(26005)(83380400001)(1076003)(2616005)(86362001)(16526019)(186003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 22:09:00.2042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 823194dc-639a-4299-695a-08db2b220a3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4250
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cruise Hung <Cruise.Hung@amd.com>

[Why]
In USB4 DP tunneling, it's possible to have this scenario that
the path becomes unavailable and CM tears down the path a little bit late.
So, in this case, the HPD is high but fails to read any DPCD register.
That causes the link connection type to be set to sst.
And not all sinks are removed behind the MST branch.

[How]
Restore the link connection type if it fails to read DPCD register.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Cruise Hung <Cruise.Hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cbd6c1b17d3b42b7935526a86ad5f66838767d03)
Modified for stable backport as a lot of the code in this file was moved
in 6.3 to drivers/gpu/drm/amd/display/dc/link/link_detection.c.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 754fc8634149..54656fcaa646 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1016,6 +1016,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 	struct dc_sink *prev_sink = NULL;
 	struct dpcd_caps prev_dpcd_caps;
 	enum dc_connection_type new_connection_type = dc_connection_none;
+	enum dc_connection_type pre_connection_type = link->type;
 	const uint32_t post_oui_delay = 30; // 30ms
 
 	DC_LOGGER_INIT(link->ctx->logger);
@@ -1118,6 +1119,8 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 			}
 
 			if (!detect_dp(link, &sink_caps, reason)) {
+				link->type = pre_connection_type;
+
 				if (prev_sink)
 					dc_sink_release(prev_sink);
 				return false;
@@ -1349,6 +1352,8 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 	bool is_delegated_to_mst_top_mgr = false;
 	enum dc_connection_type pre_link_type = link->type;
 
+	DC_LOGGER_INIT(link->ctx->logger);
+
 	is_local_sink_detect_success = detect_link_and_local_sink(link, reason);
 
 	if (is_local_sink_detect_success && link->local_sink)
@@ -1359,6 +1364,10 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 			link->dpcd_caps.is_mst_capable)
 		is_delegated_to_mst_top_mgr = discover_dp_mst_topology(link, reason);
 
+	DC_LOG_DC("%s: link_index=%d is_local_sink_detect_success=%d pre_link_type=%d link_type=%d\n", __func__,
+		 link->link_index, is_local_sink_detect_success, pre_link_type, link->type);
+
+
 	if (is_local_sink_detect_success &&
 			pre_link_type == dc_connection_mst_branch &&
 			link->type != dc_connection_mst_branch)
-- 
2.34.1


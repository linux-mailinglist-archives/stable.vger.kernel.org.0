Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF6B6B3AAE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 10:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCJJgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 04:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCJJgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 04:36:04 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200D3279BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 01:33:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKzOIOMTuVuJNHoS/JJN3ud9h5B67C8v2ASwFSAKOo5DbVKiWAgga3e4D2jQUGa+jpJPv2Lg1cil9qICaGPcCyuXYYHl3amh0QLhBsVCqFNjH4PQitlESgeIYiLLZmtjbjDyvC2lg+fJLkGUwsel1UmFf3uRGJJ7eoa9MOeev4WhOqF+/ub1TDP7PskVW/p5i/9rVBmU0Pg1Yj9VLBMD18gO1nNzZCrpoGsGg0JwmlLTyGWb1cmfqN1VIqM52wJpO08tqs8Sx6Xb8OwD2ajZI7hmD+5JiMQWRKB/8Q777/eOp9LOGKoaX/EwVApVNBV4dna/RMGd9cPBsYkQm1sBew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Prs2CHW8ffdzwlnpUU2/BEO8ZOrrYV/YIDBMyc8LgLI=;
 b=ldGHW7AzZ2jyvOuXiWGIBKcqcGvM1OY8BPooKXNmkVX741mDEU330BntFyK5CHpHkb7wIp8p/Y0eP+d7L+TdYK+D9P6IxIRk5LumaAvhscdpqvKSzZpk/IFcpf+zj+tP6gUcJNOgAnX3PZ87vAobLkYcAXzxF69P+DvgPd78tXB2IKFjKGjK6NVcrwv9r+gRIQkow17U6GwjLQ/WspTQy+CvmQRdPoeUyTcsTBh6RHEc1099rb/Ye+yf/X235TOXxNeg0Z4rkOlivtlPcio10EGBGWICLlcDJHcL/qyL+nU3JtuNkN1IcQhuuaB4eBJ7XZ9G91DGAHt8LLcwHi8o4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Prs2CHW8ffdzwlnpUU2/BEO8ZOrrYV/YIDBMyc8LgLI=;
 b=I74eNmus3VP5pPSGot/o7dGRmbow22VL5rcWb/msu2AO9uK6C/xJtrJRs2FKRckraYDUqNegANfdfkHgrne3TdGhHpV9GvckYzvp8OHB57yNbVdW166I6aY5cD5D/Jf37icaZ163KXdu6f/XcqfALNw5VFJ+Rw5J8K6EbwjXxmo=
Received: from CY5PR19CA0129.namprd19.prod.outlook.com (2603:10b6:930:64::27)
 by DS7PR12MB8322.namprd12.prod.outlook.com (2603:10b6:8:ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:32:55 +0000
Received: from CY4PEPF0000C97D.namprd02.prod.outlook.com
 (2603:10b6:930:64:cafe::be) by CY5PR19CA0129.outlook.office365.com
 (2603:10b6:930:64::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 09:32:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C97D.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Fri, 10 Mar 2023 09:32:54 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 03:32:49 -0600
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Cruise Hung <Cruise.Hung@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>
Subject: [PATCH 12/19] drm/amd/display: Fix DP MST sinks removal issue
Date:   Fri, 10 Mar 2023 04:31:10 -0500
Message-ID: <20230310093117.3030-13-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310093117.3030-1-qingqing.zhuo@amd.com>
References: <20230310093117.3030-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97D:EE_|DS7PR12MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: e4ac38eb-9f64-4999-d21e-08db214a6d74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dW56tg6L6UDZqHjoP3htPkxIs102MVm6Kr5Ks7DTgPtEelZyFLsKOo22vji4oZco2L6pGR18prTxtQsnW+0QaMhzw6ZhtcWJHUnhym541qy134lRKm1EE1FvwvnwUfSwph182qYyi/e12qjunYD3LBRtDy+k6LkLkRzFvJFqtFd0ZLneGC1pL+ij57YIL4dArOZknpM2eMG6JgJqevbNF2SmVz7tqbZRlZ7g37elgL79MX/MCx6fEuTmORxJeLjCW7UzbT4vQE6dDTn6aeek+HhAXTPdzDE62IDmgAAE941qxcH3OoS+EIm30BZAMj6BFFsKkroZIvFv65BYktAQbPeMmt9Rde3D3PNKd1lOOgOafufeQd+qHygSIYSuMbOuh6omp6K82G7wO5qk+I1SG1GjqFbay4+rtZ5dDDWiFcscJSsOQSctjFW9iOA3w6FenU/mh8Yiat7fNFiAT5Z7tXH6zwHl42kIEFYGL7wC1yLuLLfAMdh6gqqI68b/vOdqEppB5yOsH/b5AIpgiV+BL/koIDIzSITjECbWXAuqgXSfqRkUJoVKhuLRRr+IUGtFtkBZnG8v2zdfI52tMIDxr8o+TbERBpM2bv6Oinoy8ZUzvHEdCcPfSZrucaNrGO+ESwQDVyFgCbR+u4nGpS7Sji0739zFhIPeRMBj9j9P977zehbxuMpINDoeoa10P9zF6aWKmw5HFKXnZPr9VxFkFekztpd+UgbDeCGmOpDYi/c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(82310400005)(36756003)(82740400003)(36860700001)(6666004)(47076005)(83380400001)(426003)(478600001)(40480700001)(54906003)(81166007)(356005)(316002)(336012)(2616005)(40460700003)(26005)(186003)(16526019)(1076003)(2906002)(70586007)(5660300002)(44832011)(70206006)(8676002)(8936002)(6916009)(41300700001)(4326008)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:32:54.9163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ac38eb-9f64-4999-d21e-08db214a6d74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/gpu/drm/amd/display/dc/link/link_detection.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_detection.c b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
index 13e5222249ec..fee71ebdfc73 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -853,6 +853,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 	struct dc_sink *prev_sink = NULL;
 	struct dpcd_caps prev_dpcd_caps;
 	enum dc_connection_type new_connection_type = dc_connection_none;
+	enum dc_connection_type pre_connection_type = link->type;
 	const uint32_t post_oui_delay = 30; // 30ms
 
 	DC_LOGGER_INIT(link->ctx->logger);
@@ -955,6 +956,8 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 			}
 
 			if (!detect_dp(link, &sink_caps, reason)) {
+				link->type = pre_connection_type;
+
 				if (prev_sink)
 					dc_sink_release(prev_sink);
 				return false;
@@ -1236,11 +1239,16 @@ bool link_detect(struct dc_link *link, enum dc_detect_reason reason)
 	bool is_delegated_to_mst_top_mgr = false;
 	enum dc_connection_type pre_link_type = link->type;
 
+	DC_LOGGER_INIT(link->ctx->logger);
+
 	is_local_sink_detect_success = detect_link_and_local_sink(link, reason);
 
 	if (is_local_sink_detect_success && link->local_sink)
 		verify_link_capability(link, link->local_sink, reason);
 
+	DC_LOG_DC("%s: link_index=%d is_local_sink_detect_success=%d pre_link_type=%d link_type=%d\n", __func__,
+				link->link_index, is_local_sink_detect_success, pre_link_type, link->type);
+
 	if (is_local_sink_detect_success && link->local_sink &&
 			dc_is_dp_signal(link->local_sink->sink_signal) &&
 			link->dpcd_caps.is_mst_capable)
-- 
2.34.1


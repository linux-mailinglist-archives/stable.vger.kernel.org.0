Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342EB6B3AAC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 10:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjCJJgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 04:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCJJf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 04:35:59 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A47F28B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 01:33:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3QnLzW1pZcpebRsCSYOffx+2qJS3azkCrC/gjTnJRbz18WzZOyP96WQ9x37NIA/buzB0gWS+XM4UbNTNdhIhYurlw5Dl49cJkC9y7RahpZD+NsAWFwMxkSJ0ML0XE6583/mvbpxKTz82ElajSSZT1iOE1sdXoqmaZ0Q+9NDdJRuGFEbKvWYqLIEQ7WWOvcmsPwsUu1kVwMJPrMDY+XeRxHsByKmCLDLqdcC5PQeulCHdMb079WsLBen5/2lavZ47oP48XGCARPWdHBz1FDF7o+DFBf0ePefCCymKgn822eq6JPFSi+j4dt9E1p3xWD7WV39SkrrBZVYUu48ry0lWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jem25+Tjac+e4rY0kdEx9IBH0+CbNlcbN5uUyBf3MtQ=;
 b=Jgq1iOOfbQKewdmsLI6reCeZp19DZgp0g1zAXT3sPGl2j51MFTG8QVExz09VP8mVJh8/r8ntnpztsDSL7Z+VQDuk399rgQ3BjSbWRZ5G+BbBGvsFPnwd55vsVsMjlSxpWYJdGuesAneWsK0LO1jkiIeSdTQ00iGcnlsLJR7aD6uWL13M7cQ9g/xDEG0Sid7ikSipJ7ALJfJqY1CjaQL2VzrGAiZC+AtnxuRbj8KQ+BqxbzRXN1nTT4gzLqyBNgKpUsmVeLL/kOodTqwc76etS6oFnNtniuSBSJoA13h9LW7M2hI34YJAKCExciFj48TZozHIME2kAOylmNqd3kTp7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jem25+Tjac+e4rY0kdEx9IBH0+CbNlcbN5uUyBf3MtQ=;
 b=2h7G4/WS6pN82RVFNRdkPfU1Ch10QpDVLMGMrFNvz8Zymho+nNR3U6VD/mknIKsV6cJKod+hxd7iSn4Ptw2RhcHqUCE4R2YzZd+DfUEuj9b2hraVZUvsdq6NAZWI5VnZVHjfDsOc0QSWAccoHxZTt61SoxrmS2oYZhuXhR0peg4=
Received: from CY8PR10CA0048.namprd10.prod.outlook.com (2603:10b6:930:4b::14)
 by DM8PR12MB5462.namprd12.prod.outlook.com (2603:10b6:8:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:32:38 +0000
Received: from CY4PEPF0000C978.namprd02.prod.outlook.com
 (2603:10b6:930:4b:cafe::f3) by CY8PR10CA0048.outlook.office365.com
 (2603:10b6:930:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 09:32:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C978.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.12 via Frontend Transport; Fri, 10 Mar 2023 09:32:37 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 03:32:31 -0600
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>
Subject: [PATCH 09/19] drm/amd/display: Take FEC Overhead into Timeslot Calculation
Date:   Fri, 10 Mar 2023 04:31:07 -0500
Message-ID: <20230310093117.3030-10-qingqing.zhuo@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C978:EE_|DM8PR12MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: 31a1d94b-2c6a-4aea-958c-08db214a632a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LX0aZNHw3Fw13voCO73j7myKQhHfV61puk0lVwgEY+W96UFkmjmcKizQaD7O3b081kPy2W2eo0t8y3U2gIMtIiOJesukVhAFmgBobdhYl9tymI7rbugaxfWNt96i6JJNeyfVlwf5/Xo5leVs/5Eo6vy+vpzdNv2ExxRdUzjGY9z5lt9WkqAwcjVAIKw48jSLC2VBkU9dNZukxISjYF6+DWtB+G3iSBIDQ0Pqs3MSRR4Nuua5G8n2/4nsJZUWl1jFuk+n4DTGcFRN14o6/f2zdPe0ygKfuSmOmO6QgqLmELU/XKrETQLLUO0D6dG8m+jLmJc9JdXs6pA9+rIaAFFqPJ3GB1HS0okmpcaMiKuNYp/P+qVe5OMfUf4SpojS0H1nJT8lFwDnSALG/cnW0emtlPzW6ILl3ocxeYyp5CGUmyjtD7szR4v8dOpPpmyiWH/Cxv2ispRt184CGGYwfY+G3akkLSp0EKi5qSQf0LaejepZSRIeSQJY5DfpGsmIeKS4HgTVpv8i6UDVNalS7HsxPoHxPw070hn3h1DjyYzyy28YQC2z7TrvDNL22ocKSUwgEpMUtUaMiqP8l01UgElP+5b3epYMhp2w6aoGcwiTpd2P248Q+5BEq+Jfpe4siPOkTLPtkuTA6RWejssm0bQX+nVJDCJj50ehvxXy5z1exhlhEro92oSHmBic10jPAfWLQhEMvWU+iRGTN2rUbmMRYPpgBYzvt4cN4VQLhEX8sc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199018)(40470700004)(46966006)(36840700001)(36860700001)(82740400003)(186003)(36756003)(41300700001)(478600001)(54906003)(356005)(86362001)(316002)(81166007)(82310400005)(83380400001)(26005)(6666004)(426003)(40460700003)(16526019)(336012)(2616005)(2906002)(1076003)(70206006)(44832011)(8676002)(8936002)(70586007)(5660300002)(47076005)(6916009)(4326008)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:32:37.6995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a1d94b-2c6a-4aea-958c-08db214a632a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C978.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

8b/10b encoding needs to add 3% fec overhead into the pbn.
In the Synapcis Cascaded MST hub, the first stage MST branch device
needs the information to determine the timeslot count for the
second stage MST branch device. Missing this overhead will leads to
insufficient timeslot allocation.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
---
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 32 ++++++++++++++-----
 .../display/amdgpu_dm/amdgpu_dm_mst_types.h   |  3 ++
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9241d48e9d98..6378352346c8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -670,12 +670,25 @@ struct dsc_mst_fairness_params {
 	struct amdgpu_dm_connector *aconnector;
 };
 
-static int kbps_to_peak_pbn(int kbps)
+static uint16_t get_fec_overhead_multiplier(struct dc_link *dc_link)
+{
+	u8 link_coding_cap;
+	uint16_t fec_overhead_multiplier_x1000 = PBN_FEC_OVERHEAD_MULTIPLIER_8B_10B;
+
+	link_coding_cap = dc_link_dp_mst_decide_link_encoding_format(dc_link);
+	if (link_coding_cap == DP_128b_132b_ENCODING)
+		fec_overhead_multiplier_x1000 = PBN_FEC_OVERHEAD_MULTIPLIER_128B_132B;
+
+	return fec_overhead_multiplier_x1000;
+}
+
+static int kbps_to_peak_pbn(int kbps, uint16_t fec_overhead_multiplier_x1000)
 {
 	u64 peak_kbps = kbps;
 
 	peak_kbps *= 1006;
-	peak_kbps = div_u64(peak_kbps, 1000);
+	peak_kbps *= fec_overhead_multiplier_x1000;
+	peak_kbps = div_u64(peak_kbps, 1000 * 1000);
 	return (int) DIV64_U64_ROUND_UP(peak_kbps * 64, (54 * 8 * 1000));
 }
 
@@ -773,11 +786,12 @@ static int increase_dsc_bpp(struct drm_atomic_state *state,
 	int link_timeslots_used;
 	int fair_pbn_alloc;
 	int ret = 0;
+	uint16_t fec_overhead_multiplier_x1000 = get_fec_overhead_multiplier(dc_link);
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled) {
 			initial_slack[i] =
-			kbps_to_peak_pbn(params[i].bw_range.max_kbps) - vars[i + k].pbn;
+			kbps_to_peak_pbn(params[i].bw_range.max_kbps, fec_overhead_multiplier_x1000) - vars[i + k].pbn;
 			bpp_increased[i] = false;
 			remaining_to_increase += 1;
 		} else {
@@ -873,6 +887,7 @@ static int try_disable_dsc(struct drm_atomic_state *state,
 	int next_index;
 	int remaining_to_try = 0;
 	int ret;
+	uint16_t fec_overhead_multiplier_x1000 = get_fec_overhead_multiplier(dc_link);
 
 	for (i = 0; i < count; i++) {
 		if (vars[i + k].dsc_enabled
@@ -902,7 +917,7 @@ static int try_disable_dsc(struct drm_atomic_state *state,
 		if (next_index == -1)
 			break;
 
-		vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps);
+		vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.stream_kbps, fec_overhead_multiplier_x1000);
 		ret = drm_dp_atomic_find_time_slots(state,
 						    params[next_index].port->mgr,
 						    params[next_index].port,
@@ -915,7 +930,7 @@ static int try_disable_dsc(struct drm_atomic_state *state,
 			vars[next_index].dsc_enabled = false;
 			vars[next_index].bpp_x16 = 0;
 		} else {
-			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps);
+			vars[next_index].pbn = kbps_to_peak_pbn(params[next_index].bw_range.max_kbps, fec_overhead_multiplier_x1000);
 			ret = drm_dp_atomic_find_time_slots(state,
 							    params[next_index].port->mgr,
 							    params[next_index].port,
@@ -944,6 +959,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	int count = 0;
 	int i, k, ret;
 	bool debugfs_overwrite = false;
+	uint16_t fec_overhead_multiplier_x1000 = get_fec_overhead_multiplier(dc_link);
 
 	memset(params, 0, sizeof(params));
 
@@ -1005,7 +1021,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	/* Try no compression */
 	for (i = 0; i < count; i++) {
 		vars[i + k].aconnector = params[i].aconnector;
-		vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
+		vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps, fec_overhead_multiplier_x1000);
 		vars[i + k].dsc_enabled = false;
 		vars[i + k].bpp_x16 = 0;
 		ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr, params[i].port,
@@ -1024,7 +1040,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 	/* Try max compression */
 	for (i = 0; i < count; i++) {
 		if (params[i].compression_possible && params[i].clock_force_enable != DSC_CLK_FORCE_DISABLE) {
-			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.min_kbps);
+			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.min_kbps, fec_overhead_multiplier_x1000);
 			vars[i + k].dsc_enabled = true;
 			vars[i + k].bpp_x16 = params[i].bw_range.min_target_bpp_x16;
 			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
@@ -1032,7 +1048,7 @@ static int compute_mst_dsc_configs_for_link(struct drm_atomic_state *state,
 			if (ret < 0)
 				return ret;
 		} else {
-			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps);
+			vars[i + k].pbn = kbps_to_peak_pbn(params[i].bw_range.stream_kbps, fec_overhead_multiplier_x1000);
 			vars[i + k].dsc_enabled = false;
 			vars[i + k].bpp_x16 = 0;
 			ret = drm_dp_atomic_find_time_slots(state, params[i].port->mgr,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index 0b5750202e73..1e4ede1e57ab 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -46,6 +46,9 @@
 #define SYNAPTICS_CASCADED_HUB_ID  0x5A
 #define IS_SYNAPTICS_CASCADED_PANAMERA(devName, data) ((IS_SYNAPTICS_PANAMERA(devName) && ((int)data[2] == SYNAPTICS_CASCADED_HUB_ID)) ? 1 : 0)
 
+#define PBN_FEC_OVERHEAD_MULTIPLIER_8B_10B	1031
+#define PBN_FEC_OVERHEAD_MULTIPLIER_128B_132B	1000
+
 struct amdgpu_display_manager;
 struct amdgpu_dm_connector;
 
-- 
2.34.1


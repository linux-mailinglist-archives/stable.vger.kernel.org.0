Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95796EA02F
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 01:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjDTXua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 19:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTXu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 19:50:29 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA3610E9
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 16:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClF1ujGN17XJRRqrAdfacvL7ayYjDDbvS4IA0Yb5kc7zk6DflDu8X8uSdBJcOtddzyODCjkzhwfLEz5kYifKpn3jidCqKjDhk8/7zuggPz8rxL9vhH363I1uxnUQm9RitYqI65m6igofpWh7u/CpevlsdSY7caGyKYGAa+fdTm4cAT1TpZ1pbHbFlOgcO98tAfVIgMbPqrVYda9YAX60Rg0yrLKij1sNVXxrnT2b7UkkQ9IeGJoDM/WizZIXTcseF3LBlcLL2M7rXcYgwWrrWC0LAi5HENetJMd9KZRB4MQkXlAhonF9SXKPcvxfrVFlxqkEdEwMOUzFjqp31aF1fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4aMKTJJUInnjLHT5hHqWMdpGywaagL+lzy0w2Pj+JM=;
 b=SAS5vNzMPmhjwDyIc0KXl1OsAUWmvT8h4bBsFPk4zWmZ8LTPcoAupjuHtW2WHhxFRAHYxrz5sTpmhrCzzu/vaxwMTJ8qED79H6v7GBt1fy6IxFyk2ZICez+3SW/U54MsDBktDFigHQGWZ1gXXjvbEAcDoqwXgcGN3IEmZijg/Gxu8mF6Al6jJiS4rMwstZV+zIXZJ5aVEwp43BRXMSBYyEjQgOLq74+pYEg/MiAt/y6HviJjy5AW47U69ZGzSkA7zyMB5dj9sp6G5PcCyfmLKYfKedf3rKbkJMsamYWNxex8UNc6KLZtllfqGthuxVGVrnZKEjtV1nhg68uEH8ffqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4aMKTJJUInnjLHT5hHqWMdpGywaagL+lzy0w2Pj+JM=;
 b=auuaUAR1hymM14okGsMIOfDFED3qS6a8ykNbl9zPKLO1wfTcWXpt4fp3ydlz87OmSAM8G58RFcIY4xHTSkzY+MratJy8WsUbrwsF+Ad2PCxHsgVnu83viGXUYg6vMSM4gKAPd5IENhVwXk2O723fYjezQgc66OpuxSAxQ2jL11s=
Received: from DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41)
 by DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 23:50:22 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::c0) by DM6PR02CA0100.outlook.office365.com
 (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.24 via Frontend
 Transport; Thu, 20 Apr 2023 23:50:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.25 via Frontend Transport; Thu, 20 Apr 2023 23:50:22 +0000
Received: from smtp.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 20 Apr
 2023 18:50:19 -0500
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>,
        <stable@vger.kernel.org>, Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Subject: [PATCH 08/21] drm/amd/display: Limit DCN32 8 channel or less parts to DPM1 for FPO
Date:   Thu, 20 Apr 2023 17:49:38 -0600
Message-ID: <20230420234951.1772270-9-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
References: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT021:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: 519f6b55-536f-49cd-4fb1-08db41fa0134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06/bqFT3IKpPF+w3i3NO3FVoORi9SQIcMJic4DhB9iELx59qrS1382T8GI/dbIRIrn4EiM1HtP/1YMe/Zbl6pRYj1gN1s8PtkPBIM30MRfXLnlJ3vU4GMGyCbaFpqh1mNOF9MeSdnPUBrNqGatJuxY6LHFQ4jwl8h1qxIXV4LZWZHQnnV6e+g352P63h9wYTpYSbYKpN9dulJdunXmm+E7E6NbwUqMbAjovaeBFTY0pRtanTTIHWtBcMz4vFPj20tt8YZTXMUQWCPPdO3JfO8rre8JOobdqVUNCAwT3JSrBqtGPxV1q9P+4bOY4i2qq6sugqNMTrevjb8b1CBv5hvSJOJtO5dcHjU4D9oh2fCHHFfkblhsbPbRtc9DobrqUcIh94CXDDNtznnJnRONCcQoZ1UnwzFHlzRDrQ1kttA5hm9Go83nChImb9nJ6wpD5oi246l2kviS8r6gTjNA4YqATU9t6h2iFcf+iTtJzk6c6/KgMDxrogodXAjN6L1TVwU3gpFEwdU0IFH3VkfUrI7S2nc+Bvzo29dZf8CPF4He0e9SEknhFwb4UaNN61D/5qDguWCMhWjT0hSBWSYVSff2Kb8wr2WmRSVLhdhaqGEHFAyf0zpqcW0cJIYw/OiiGqG6IXCkCh+DKMw6VTaNVd4kcTX3P+oE/YKpSNGMMlVNUqQ6Re5WQq1hcZRczolRrqcWd4Efr/ifzRB6sQUumyb286xOZ5KeSa7RswA+7aS1U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199021)(46966006)(40470700004)(36840700001)(83380400001)(47076005)(336012)(26005)(2616005)(426003)(36860700001)(1076003)(478600001)(6666004)(54906003)(82310400005)(4326008)(70206006)(70586007)(6916009)(316002)(86362001)(8676002)(36756003)(41300700001)(8936002)(5660300002)(186003)(16526019)(356005)(82740400003)(40460700003)(81166007)(2906002)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 23:50:22.0110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 519f6b55-536f-49cd-4fb1-08db41fa0134
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <Alvin.Lee2@amd.com>

- Due to hardware related QoS issues, we need to limit certain
  SKUs with less memory channels to DPM1 and above.
- At DPM0 + workload running, the urgent return latency can
  exceed 15us (the expected maximum is 4us) which results in underflow

Cc: stable@vger.kernel.org
Reviewed-by: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
---
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c |  2 ++
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  | 15 +++++++++++++++
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h  |  2 ++
 3 files changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 4f8286ae699b..0085ea78ea31 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1888,6 +1888,8 @@ bool dcn32_validate_bandwidth(struct dc *dc,
 
 	dc->res_pool->funcs->calculate_wm_and_dlg(dc, context, pipes, pipe_cnt, vlevel);
 
+	dcn32_override_min_req_memclk(dc, context);
+
 	BW_VAL_TRACE_END_WATERMARKS();
 
 	goto validate_out;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index b8a2518faecc..ed7ea4c42412 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2887,3 +2887,18 @@ void dcn32_set_clock_limits(const struct _vcs_dpi_soc_bounding_box_st *soc_bb)
 	dc_assert_fp_enabled();
 	dcn3_2_soc.clock_limits[0].dcfclk_mhz = 1200.0;
 }
+
+void dcn32_override_min_req_memclk(struct dc *dc, struct dc_state *context)
+{
+	// WA: restrict FPO and SubVP to use first non-strobe mode (DCN32 BW issue)
+	if ((context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching || dcn32_subvp_in_use(dc, context)) &&
+			dc->dml.soc.num_chans <= 8) {
+		int num_mclk_levels = dc->clk_mgr->bw_params->clk_table.num_entries_per_clk.num_memclk_levels;
+
+		if (context->bw_ctx.dml.vba.DRAMSpeed <= dc->clk_mgr->bw_params->clk_table.entries[0].memclk_mhz * 16 &&
+				num_mclk_levels > 1) {
+			context->bw_ctx.dml.vba.DRAMSpeed = dc->clk_mgr->bw_params->clk_table.entries[1].memclk_mhz * 16;
+			context->bw_ctx.bw.dcn.clk.dramclk_khz = context->bw_ctx.dml.vba.DRAMSpeed * 1000 / 16;
+		}
+	}
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
index dcf512cd3072..a4206b71d650 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h
@@ -80,6 +80,8 @@ void dcn32_assign_fpo_vactive_candidate(struct dc *dc, const struct dc_state *co
 
 bool dcn32_find_vactive_pipe(struct dc *dc, const struct dc_state *context, uint32_t vactive_margin_req);
 
+void dcn32_override_min_req_memclk(struct dc *dc, struct dc_state *context);
+
 void dcn32_set_clock_limits(const struct _vcs_dpi_soc_bounding_box_st *soc_bb);
 
 #endif
-- 
2.39.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEA66B9D36
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCNRmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCNRmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:42:04 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5762930EB1
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 10:42:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cweHpoYRGDCdS4kQM6K8EaRFBt1i+06pfPJVrxCN5+u7ax3rEFzV2nkWJWNFwsiXBs3ThRYSjJAOgHZteFAEC8zVEkTXKs3/wbXv2444OrsuGCxEFBYFUQ7GvXM3aD0hrzaUOG20ox0+MSq7ePxuSvpjqjj1IvSH6pTqgCI47kQ+OmwAhNsiZLLfs76LMlnsbMPYDYxyTeO55b9rBcTzlOtm4wIKErRTfxoiMLCiVM29HBuoHVvlnnENEIEYfIpj8Buh0CfZr1NOeJMzDqgv7mGRVnPuTZEQZLLW5C/AErYUNckSl3vc1+E1g9yM2UWlH6UkI5Ms1zHDkyh8EPBScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqTC/maiFcNV/kZgIvcjAqdXSmxTFJNGdy3CdGRRINQ=;
 b=nTJVFW+xTQBoJ/70+i/wdQZMu6OL8snTcvLZ0Pi0kOhl0h80wf+asIk3VEmGUen/7NHoGpfBVagCEl6xxv7i0JY7pcyM/VpSLG1D3+hIUioXF3P/zogGCgO5aO0SCs/qrx9B5V3iv8D19waFlyqRWNE99j40CY7md6X6uLmuQ76jiRNdGe9UG4wCRaI/Xt1KbPpyh4yMPqbKEd/D3zXnBQLjNhMM1OMH9Dd7awU5XoX+kvCCm5ZNgC7fqRBBAqY/rNaMFa+72LwITy3dPk9UiHspQC0J2IdMcfPRPNHqGYbGjkYl3U0qbSYlH49r4x5x/PDnUurH/Q1Cey7iWYQq/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqTC/maiFcNV/kZgIvcjAqdXSmxTFJNGdy3CdGRRINQ=;
 b=Z1E+p/8t1voULF0fWqzj75BfHLrf70Lc1oNXA4a1z/1Zm5JToTvQmQ8I1YHkKCM3h8m1R1nErUt6eNjJDxrSoa6W1kgHYbiPZunWRD7RGpwJf7yPFyiy/2tDc+sfy6iRlDRswysPOI6qfraa5s04kMoWpdrkmgX6ZsJJ+wa9h2w=
Received: from DM6PR03CA0079.namprd03.prod.outlook.com (2603:10b6:5:333::12)
 by PH7PR12MB7915.namprd12.prod.outlook.com (2603:10b6:510:27c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 17:41:58 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::f7) by DM6PR03CA0079.outlook.office365.com
 (2603:10b6:5:333::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:41:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6199.11 via Frontend Transport; Tue, 14 Mar 2023 17:41:58 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:41:57 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     Alvin Lee <Alvin.Lee2@amd.com>,
        Daniel Wheeler <Daniel.Wheeler@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Subject: [PATCH 1/2] drm/amd/display: Allow subvp on vactive pipes that are 2560x1440@60
Date:   Tue, 14 Mar 2023 13:41:39 -0400
Message-ID: <20230314174140.505833-2-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174140.505833-1-alexander.deucher@amd.com>
References: <20230314174140.505833-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|PH7PR12MB7915:EE_
X-MS-Office365-Filtering-Correlation-Id: 764c856d-edeb-4d63-1b40-08db24b36945
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVdtnchQlLuvy2CMzBDvnFFe4dQHW2bNzIkBAuSo0yYZCcGJpTbuogixx+DnY+tOhUBIyg6MKWbIDzy31cB2dRr8KaUDb/74mfWpVgTtgGL1PXJlxRI2TV4Ge2GEyTP9CgbasDLyWLhhxYgHPKvHq0G0D9QeCYYjipg7mcZpSjD85XLpIlVo2mUnNBTmosJdNvNSN5v/sQYb5XinwqDMv1iW+7VhpQIN1LyJMUhzckNdbvy3FRisjtKO/94KB1x2LeemhoR/jQZzG1CZd5ysHA7hYT79Z6SG4gk50XGLEHuvAC/LNqxYE2WKAJ0dnD73VrQmxI74vXzUE+PIjb6E9FX/gIHoECa5gR5LWEH8v3EE0cLXwBx509fSZIX1YUihgtqDo9l/Smy7f1BO+/n/YI3rPEaJzE7PvVbnmkc2bsqFGugMOyGWTzpJMjDRo/TU65k4AZbIJ74HH48JMFC6pA97kQ3LUoc8GF2yqf8p0omBTQrzd0QJejzZOMa+sFwD6ufO0mHH/2i3B8J40yKMAec4NJLItLilMjUMaAtFkSAyTTJnWKZX1VwnISgx1qOEbgAHyq7ppZGqBbMeJ3T33reIH/Cbi2rID+J4DTnu17Ba6fWlZ9dZ6K89HoejmKyFsrve/mY4Lr+i91PgGrYTm2Ys6nXw/Lys6xRcf3tbafy2lHZHHnhqprMHtelLgxmi+Zg5aMalgFuESXJ72ccaEY1XckXTF08bPPYy4ew2ImghmmWTFAAIwds2S0MR/voZEwLhyXg3kgsVSuhiOGy3UQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199018)(40470700004)(36840700001)(46966006)(4326008)(110136005)(54906003)(316002)(70586007)(41300700001)(36860700001)(356005)(70206006)(83380400001)(8936002)(82310400005)(478600001)(426003)(47076005)(5660300002)(336012)(86362001)(8676002)(2616005)(40460700003)(16526019)(7696005)(186003)(40480700001)(6666004)(26005)(36756003)(82740400003)(1076003)(81166007)(2906002)(36900700001)(44824005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:41:58.6158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 764c856d-edeb-4d63-1b40-08db24b36945
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7915
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <Alvin.Lee2@amd.com>

Enable subvp on specifically 1440p@60hz displays even though it can
switch in vactive.

Tested-by: Daniel Wheeler <Daniel.Wheeler@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2ebd1036209c2e7b61e6bc6e5bee4b67c1684ac6)
Cc: stable@vger.kernel.org # 6.1.x
---
 .../drm/amd/display/dc/dcn32/dcn32_resource.h |  2 ++
 .../drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  | 31 ++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
index f76120e67c16..cf7633fab098 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -142,6 +142,8 @@ void dcn32_restore_mall_state(struct dc *dc,
 		struct dc_state *context,
 		struct mall_temp_config *temp_config);
 
+bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 04cc96e70098..91a3839bc297 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -676,7 +676,9 @@ static bool dcn32_assign_subvp_pipe(struct dc *dc,
 		 */
 		if (pipe->plane_state && !pipe->top_pipe &&
 				pipe->stream->mall_stream_config.type == SUBVP_NONE && refresh_rate < 120 && !pipe->plane_state->address.tmz_surface &&
-				vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] <= 0) {
+				(vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] <= 0 ||
+				(vba->ActiveDRAMClockChangeLatencyMarginPerState[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]] > 0 &&
+						dcn32_allow_subvp_with_active_margin(pipe)))) {
 			while (pipe) {
 				num_pipes++;
 				pipe = pipe->bottom_pipe;
@@ -2558,3 +2560,30 @@ void dcn32_zero_pipe_dcc_fraction(display_e2e_pipe_params_st *pipes,
 	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;
 	pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_chroma = 0;
 }
+
+bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe)
+{
+	bool allow = false;
+	uint32_t refresh_rate = 0;
+
+	/* Allow subvp on displays that have active margin for 2560x1440@60hz displays
+	 * only for now. There must be no scaling as well.
+	 *
+	 * For now we only enable on 2560x1440@60hz displays to enable 4K60 + 1440p60 configs
+	 * for p-state switching.
+	 */
+	if (pipe->stream && pipe->plane_state) {
+		refresh_rate = (pipe->stream->timing.pix_clk_100hz * 100 +
+						pipe->stream->timing.v_total * pipe->stream->timing.h_total - 1)
+						/ (double)(pipe->stream->timing.v_total * pipe->stream->timing.h_total);
+		if (pipe->stream->timing.v_addressable == 1440 &&
+				pipe->stream->timing.h_addressable == 2560 &&
+				refresh_rate >= 55 && refresh_rate <= 65 &&
+				pipe->plane_state->src_rect.height == 1440 &&
+				pipe->plane_state->src_rect.width == 2560 &&
+				pipe->plane_state->dst_rect.height == 1440 &&
+				pipe->plane_state->dst_rect.width == 2560)
+			allow = true;
+	}
+	return allow;
+}
-- 
2.39.2


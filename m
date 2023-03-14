Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AF96B9D37
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCNRmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCNRmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:42:06 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCDC2CC52
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 10:42:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtefikOTuaGAsBg1jNHikm3OLmGbFqnKHqMMC0eoeAQENgEXfPUTM6W7rhMuu+qjyuCopqGLadQGT4CmzEfDK7YP/YTtPbOhJzCbg735SQ8/t+o/kDrG95xeeof2A/a9xCLAFn1Esf61NAk9hnPBSutKpKlyonh56pc7oMVJLElzyZ2xXVdSEtoNcLmM5DvzRC4p5fVybAip7FkcJuGplCMoVqjZcZeXrbq4PHTTwMdZsrXnn/VaMEifqbLk9mr6PT2QRAtHXCZRvUtU99Zwlmnv5BuEAcyO0ismY0wPTlS8dYTvDC4LVoSp+UnEYOpiBeryFvHgiveyUFlGdrB26w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiLntmzeYDDTzNlbbI9LkZ7jUtKCF0ROz+Ryt5ZzoO8=;
 b=VsSHJOLbKyIQrv4eBQFEop4N8yOvKtZbwygJQaf/4HiBsaOeUuUK9ky7Bfh9z6WV2MkB0g3vobbHm6qQUBhUFhmNXod8MKc0YF4sPwK6/9TzTv33Aour3MegypL5Z6XpUQDacgrCvIXOFe8c6HV1MlN9071Q3vX+/y0PHcbK4G7E1+5oF9LtXw+rJ9207d6AUmUu5Y64U7Byr7czOqdJl0Cc0fkjCEEIONQygUTxn7J53N2F+gIjIm4siuddOB2FuaK12/U1g0QgqnZ/eCq2bTK/zArBcyk/naclMhRy2CnYeTNmIsjmzCkavWj6QBEN0Dnhw5AnIGIJVaXQODyEdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiLntmzeYDDTzNlbbI9LkZ7jUtKCF0ROz+Ryt5ZzoO8=;
 b=DzsmvNg+W+pdZiy6Kkmblg6BifK4sMwzbgG7zmLqFXO5a+uxBIdyMcTeCdDKRZVBuNsR2RZUE//W+FezJy1wXHFxznI7DWeXvdM/Nnjx1P9vd3MgsW+1SmcGH7PED5ITfxYS0PeqLaEGsqLI95I0olLqCbuytgmovJcbWKYcnNo=
Received: from DM6PR17CA0030.namprd17.prod.outlook.com (2603:10b6:5:1b3::43)
 by DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 17:42:01 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::ed) by DM6PR17CA0030.outlook.office365.com
 (2603:10b6:5:1b3::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:42:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6199.11 via Frontend Transport; Tue, 14 Mar 2023 17:42:01 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:41:58 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     Samson Tam <Samson.Tam@amd.com>,
        Nevenko Stupar <Nevenko.Stupar@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Subject: [PATCH 2/2] drm/amd/display: adjust MALL size available for DCN32 and DCN321
Date:   Tue, 14 Mar 2023 13:41:40 -0400
Message-ID: <20230314174140.505833-3-alexander.deucher@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: 17b1c4a6-24e6-416d-d669-08db24b36b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYOSeJ7TY7DzhrTDl/ACSN0gppWKTj7jqBABHRT2sXTUHoZ1hKXfp4EiIdhbn9YBzTiKBh1NmaHgDoEwkjdmJTNVKhuqbEv3wOUp6ezpc6mD+0of6qFxKzTq872MuvR8RuA7WMuLTqEj8LoMu535omLQJFf8/Z47Ylar/y8IRzGpgOHKSCCf8ah5Eq01zE0yT1vuD1zbwBrTS2OVoRn+wPFZKEJiDi8UK0Ue5EY/+hu8an6C3k8j9Tnc1rBgfdEkrDiU/d9T1YbF2+jsjoa55pCCtOcj36pEVzFzSLsr0vRTeRTcT1IHupAfzWKcmO7eqxVRT8sRVkiViBCAdWFwt5aShZgvIa/xHNWBRPPUYx9qjGHBG2RKiHei9EY6ysWmWJ4Vf+O++JQgzugho2RttTCDMwYWAdxSLaVDot73KjhlSMYSfslT+QdyiHQMSYkK9Z2phrqWo0Yy3OI5D6/xNzYROH8yMnnBktSRGnsDYaJetCQZSbVuuHbgNuqYfNs5sBIAQ8OHfjvKYBU+ZTAthNtrdkO2KyNrvDB+K412eorFcW6S38hMlc/+NjusTlvHkx8w359F2nWmdh8EhFCeykZ6csfa9gLPs+Fj1ahRz4LGuvAtCMKcvWPTrtJACwB4VjS/j4HZTpiJRO3RyAGeEWQOXz88VRELxzB2aRKNS884xvju38M/0703Pt0Cy/yoHwbxVdcYuFdWNBAgLiKzUpQLuMu/kBDOXzqe6itr72c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(5660300002)(40460700003)(36756003)(83380400001)(186003)(47076005)(478600001)(82310400005)(16526019)(426003)(1076003)(6666004)(26005)(7696005)(2616005)(336012)(40480700001)(356005)(8676002)(70586007)(41300700001)(70206006)(4326008)(8936002)(316002)(110136005)(54906003)(86362001)(36860700001)(81166007)(82740400003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:42:01.8581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b1c4a6-24e6-416d-d669-08db24b36b33
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samson Tam <Samson.Tam@amd.com>

[Why]
MALL size available can vary for different SKUs.
Use num_chans read from VBIOS to determine the available MALL size we can use

[How]
Define max_chans for DCN32 and DCN321.
If num_chans is max_chans, then return max_chans as we can access the
 entire MALL space.
Otherwise, define avail_chans as the number of available channels we are
 allowed instead.
Return corresponding number of channels back and use this to calculate
 available MALL size.

Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 235fef6c7fd341026eee90cc546e6e8ff8b2c315)
Cc: stable@vger.kernel.org # 6.1.x
---
 .../drm/amd/display/dc/dcn32/dcn32_resource.c | 62 ++++++++++++++++++-
 .../drm/amd/display/dc/dcn32/dcn32_resource.h |  2 +
 .../amd/display/dc/dcn321/dcn321_resource.c   |  9 ++-
 .../drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  |  5 +-
 .../amd/display/dc/dml/dcn321/dcn321_fpu.c    |  5 +-
 5 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 9919c39f7ea0..d70c64a9fcb2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2109,13 +2109,19 @@ static bool dcn32_resource_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.dmdata_alloc_size = 2048;
-	dc->caps.mall_size_per_mem_channel = 0;
+	dc->caps.mall_size_per_mem_channel = 4;
 	dc->caps.mall_size_total = 0;
 	dc->caps.cursor_cache_size = dc->caps.max_cursor_size * dc->caps.max_cursor_size * 8;
 
 	dc->caps.cache_line_size = 64;
 	dc->caps.cache_num_ways = 16;
-	dc->caps.max_cab_allocation_bytes = 67108864; // 64MB = 1024 * 1024 * 64
+
+	/* Calculate the available MALL space */
+	dc->caps.max_cab_allocation_bytes = dcn32_calc_num_avail_chans_for_mall(
+		dc, dc->ctx->dc_bios->vram_info.num_chans) *
+		dc->caps.mall_size_per_mem_channel * 1024 * 1024;
+	dc->caps.mall_size_total = dc->caps.max_cab_allocation_bytes;
+
 	dc->caps.subvp_fw_processing_delay_us = 15;
 	dc->caps.subvp_prefetch_end_to_mall_start_us = 15;
 	dc->caps.subvp_swath_height_margin_lines = 16;
@@ -2545,3 +2551,55 @@ struct pipe_ctx *dcn32_acquire_idle_pipe_for_head_pipe_in_layer(
 
 	return idle_pipe;
 }
+
+unsigned int dcn32_calc_num_avail_chans_for_mall(struct dc *dc, int num_chans)
+{
+	/*
+	 * DCN32 and DCN321 SKUs may have different sizes for MALL
+	 *  but we may not be able to access all the MALL space.
+	 *  If the num_chans is power of 2, then we can access all
+	 *  of the available MALL space.  Otherwise, we can only
+	 *  access:
+	 *
+	 *  max_cab_size_in_bytes = total_cache_size_in_bytes *
+	 *    ((2^floor(log2(num_chans)))/num_chans)
+	 *
+	 * Calculating the MALL sizes for all available SKUs, we
+	 *  have come up with the follow simplified check.
+	 * - we have max_chans which provides the max MALL size.
+	 *  Each chans supports 4MB of MALL so:
+	 *
+	 *  total_cache_size_in_bytes = max_chans * 4 MB
+	 *
+	 * - we have avail_chans which shows the number of channels
+	 *  we can use if we can't access the entire MALL space.
+	 *  It is generally half of max_chans
+	 * - so we use the following checks:
+	 *
+	 *   if (num_chans == max_chans), return max_chans
+	 *   if (num_chans < max_chans), return avail_chans
+	 *
+	 * - exception is GC_11_0_0 where we can't access max_chans,
+	 *  so we define max_avail_chans as the maximum available
+	 *  MALL space
+	 *
+	 */
+	int gc_11_0_0_max_chans = 48;
+	int gc_11_0_0_max_avail_chans = 32;
+	int gc_11_0_0_avail_chans = 16;
+	int gc_11_0_3_max_chans = 16;
+	int gc_11_0_3_avail_chans = 8;
+	int gc_11_0_2_max_chans = 8;
+	int gc_11_0_2_avail_chans = 4;
+
+	if (ASICREV_IS_GC_11_0_0(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_0_max_chans) ?
+			gc_11_0_0_max_avail_chans : gc_11_0_0_avail_chans;
+	} else if (ASICREV_IS_GC_11_0_2(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_2_max_chans) ?
+			gc_11_0_2_max_chans : gc_11_0_2_avail_chans;
+	} else { // if (ASICREV_IS_GC_11_0_3(dc->ctx->asic_id.hw_internal_rev)) {
+		return (num_chans == gc_11_0_3_max_chans) ?
+			gc_11_0_3_max_chans : gc_11_0_3_avail_chans;
+	}
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
index cf7633fab098..615244a1f95d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -144,6 +144,8 @@ void dcn32_restore_mall_state(struct dc *dc,
 
 bool dcn32_allow_subvp_with_active_margin(struct pipe_ctx *pipe);
 
+unsigned int dcn32_calc_num_avail_chans_for_mall(struct dc *dc, int num_chans);
+
 /* definitions for run time init of reg offsets */
 
 /* CLK SRC */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index 6292ac515d1a..d320e21680da 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1697,11 +1697,18 @@ static bool dcn321_resource_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.dmdata_alloc_size = 2048;
-	dc->caps.mall_size_per_mem_channel = 0;
+	dc->caps.mall_size_per_mem_channel = 4;
 	dc->caps.mall_size_total = 0;
 	dc->caps.cursor_cache_size = dc->caps.max_cursor_size * dc->caps.max_cursor_size * 8;
 	dc->caps.cache_line_size = 64;
 	dc->caps.cache_num_ways = 16;
+
+	/* Calculate the available MALL space */
+	dc->caps.max_cab_allocation_bytes = dcn32_calc_num_avail_chans_for_mall(
+		dc, dc->ctx->dc_bios->vram_info.num_chans) *
+		dc->caps.mall_size_per_mem_channel * 1024 * 1024;
+	dc->caps.mall_size_total = dc->caps.max_cab_allocation_bytes;
+
 	dc->caps.max_cab_allocation_bytes = 33554432; // 32MB = 1024 * 1024 * 32
 	dc->caps.subvp_fw_processing_delay_us = 15;
 	dc->caps.subvp_prefetch_end_to_mall_start_us = 15;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 91a3839bc297..e22b4b3880af 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2381,8 +2381,11 @@ void dcn32_update_bw_bounding_box_fpu(struct dc *dc, struct clk_bw_params *bw_pa
 		}
 
 		/* Override from VBIOS for num_chan */
-		if (dc->ctx->dc_bios->vram_info.num_chans)
+		if (dc->ctx->dc_bios->vram_info.num_chans) {
 			dcn3_2_soc.num_chans = dc->ctx->dc_bios->vram_info.num_chans;
+			dcn3_2_soc.mall_allocated_for_dcn_mbytes = (double)(dcn32_calc_num_avail_chans_for_mall(dc,
+				dc->ctx->dc_bios->vram_info.num_chans) * dc->caps.mall_size_per_mem_channel);
+		}
 
 		if (dc->ctx->dc_bios->vram_info.dram_channel_width_bytes)
 			dcn3_2_soc.dram_channel_width_bytes = dc->ctx->dc_bios->vram_info.dram_channel_width_bytes;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
index 0ea406145c1d..b80cef70fa60 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -534,8 +534,11 @@ void dcn321_update_bw_bounding_box_fpu(struct dc *dc, struct clk_bw_params *bw_p
 		}
 
 		/* Override from VBIOS for num_chan */
-		if (dc->ctx->dc_bios->vram_info.num_chans)
+		if (dc->ctx->dc_bios->vram_info.num_chans) {
 			dcn3_21_soc.num_chans = dc->ctx->dc_bios->vram_info.num_chans;
+			dcn3_21_soc.mall_allocated_for_dcn_mbytes = (double)(dcn32_calc_num_avail_chans_for_mall(dc,
+				dc->ctx->dc_bios->vram_info.num_chans) * dc->caps.mall_size_per_mem_channel);
+		}
 
 		if (dc->ctx->dc_bios->vram_info.dram_channel_width_bytes)
 			dcn3_21_soc.dram_channel_width_bytes = dc->ctx->dc_bios->vram_info.dram_channel_width_bytes;
-- 
2.39.2


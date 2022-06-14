Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BFF54A483
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352389AbiFNCI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352375AbiFNCHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2AB344DB;
        Mon, 13 Jun 2022 19:06:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E448E60AEC;
        Tue, 14 Jun 2022 02:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E00C341C0;
        Tue, 14 Jun 2022 02:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172370;
        bh=3mpdSMCJjajiV5VEiE9vIiCO7N/1lGCy+G1fSo0Qe5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7VCrVmjGVDjFLXR7+a5gmrrNzvwJJFb23rOv4MZkjWsLIiZb5A4e1ft/lrUNdnsL
         TYgd+Y1otamu7IhgyhpQCrh20E5TAdObKkebVkF0y9hfyBL0SAuatQfyXRwmIfLd0G
         uz3FoYk3vtqhm6xlHdkcG4jWwJim3GEv/P8OJCteMuKCFTh+fKcTYeuuJnmbZ/o/To
         qtNjFGW6Cpc8IKjSYdIqOKOcgHgYXG4cfXJhINy/qMlJvq8zkClOw4vrX10RnlmnEh
         QaAUMusBYFVtHXd5Q2bF7Oe/c3UhxykghEul9mQixfzsv5Nnrutwlfsle1uQvJ5UlO
         cZ3W3SPTU6BlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Hung, Cruise" <Cruise.Hung@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 04/43] drm/amd/display: Fix DMUB outbox trace in S4 (#4465)
Date:   Mon, 13 Jun 2022 22:05:23 -0400
Message-Id: <20220614020602.1098943-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020602.1098943-1-sashal@kernel.org>
References: <20220614020602.1098943-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Hung, Cruise" <Cruise.Hung@amd.com>

[ Upstream commit 6ecf9773a5030aa4932096754bacff20e1b944b8 ]

[Why]
DMUB Outbox0 read/write pointer not sync after resumed from S4.
And that caused old traces were sent to outbox.

[How]
Disable DMUB Outbox0 interrupt
and clear DMUB Outbox0 read/write pointer when resumes from S4.
And then enable Outbox0 interrupt before starts DMCUB.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Cruise Hung <Cruise.Hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c | 61 +++++++++----------
 .../gpu/drm/amd/display/dmub/src/dmub_dcn31.c |  2 +
 2 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
index ea4f8e06b07c..036cf4ebd9c8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
@@ -464,12 +464,10 @@ void dccg31_set_physymclk(
 /* Controls the generation of pixel valid for OTG in (OTG -> HPO case) */
 static void dccg31_set_dtbclk_dto(
 		struct dccg *dccg,
-		int dtbclk_inst,
-		int req_dtbclk_khz,
-		int num_odm_segments,
-		const struct dc_crtc_timing *timing)
+		struct dtbclk_dto_params *params)
 {
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
+	int req_dtbclk_khz = params->pixclk_khz;
 	uint32_t dtbdto_div;
 
 	/* Mode	                DTBDTO Rate       DTBCLK_DTO<x>_DIV Register
@@ -480,57 +478,56 @@ static void dccg31_set_dtbclk_dto(
 	 * DSC native 4:2:2     pixel rate/2      4
 	 * Other modes          pixel rate        8
 	 */
-	if (num_odm_segments == 4) {
+	if (params->num_odm_segments == 4) {
 		dtbdto_div = 2;
-		req_dtbclk_khz = req_dtbclk_khz / 4;
-	} else if ((num_odm_segments == 2) ||
-			(timing->pixel_encoding == PIXEL_ENCODING_YCBCR420) ||
-			(timing->flags.DSC && timing->pixel_encoding == PIXEL_ENCODING_YCBCR422
-					&& !timing->dsc_cfg.ycbcr422_simple)) {
+		req_dtbclk_khz = params->pixclk_khz / 4;
+	} else if ((params->num_odm_segments == 2) ||
+			(params->timing->pixel_encoding == PIXEL_ENCODING_YCBCR420) ||
+			(params->timing->flags.DSC && params->timing->pixel_encoding == PIXEL_ENCODING_YCBCR422
+					&& !params->timing->dsc_cfg.ycbcr422_simple)) {
 		dtbdto_div = 4;
-		req_dtbclk_khz = req_dtbclk_khz / 2;
+		req_dtbclk_khz = params->pixclk_khz / 2;
 	} else
 		dtbdto_div = 8;
 
-	if (dccg->ref_dtbclk_khz && req_dtbclk_khz) {
+	if (params->ref_dtbclk_khz && req_dtbclk_khz) {
 		uint32_t modulo, phase;
 
 		// phase / modulo = dtbclk / dtbclk ref
-		modulo = dccg->ref_dtbclk_khz * 1000;
-		phase = div_u64((((unsigned long long)modulo * req_dtbclk_khz) + dccg->ref_dtbclk_khz - 1),
-			dccg->ref_dtbclk_khz);
+		modulo = params->ref_dtbclk_khz * 1000;
+		phase = div_u64((((unsigned long long)modulo * req_dtbclk_khz) + params->ref_dtbclk_khz - 1),
+				params->ref_dtbclk_khz);
 
-		REG_UPDATE(OTG_PIXEL_RATE_CNTL[dtbclk_inst],
-				DTBCLK_DTO_DIV[dtbclk_inst], dtbdto_div);
+		REG_UPDATE(OTG_PIXEL_RATE_CNTL[params->otg_inst],
+				DTBCLK_DTO_DIV[params->otg_inst], dtbdto_div);
 
-		REG_WRITE(DTBCLK_DTO_MODULO[dtbclk_inst], modulo);
-		REG_WRITE(DTBCLK_DTO_PHASE[dtbclk_inst], phase);
+		REG_WRITE(DTBCLK_DTO_MODULO[params->otg_inst], modulo);
+		REG_WRITE(DTBCLK_DTO_PHASE[params->otg_inst], phase);
 
-		REG_UPDATE(OTG_PIXEL_RATE_CNTL[dtbclk_inst],
-				DTBCLK_DTO_ENABLE[dtbclk_inst], 1);
+		REG_UPDATE(OTG_PIXEL_RATE_CNTL[params->otg_inst],
+				DTBCLK_DTO_ENABLE[params->otg_inst], 1);
 
-		REG_WAIT(OTG_PIXEL_RATE_CNTL[dtbclk_inst],
-				DTBCLKDTO_ENABLE_STATUS[dtbclk_inst], 1,
+		REG_WAIT(OTG_PIXEL_RATE_CNTL[params->otg_inst],
+				DTBCLKDTO_ENABLE_STATUS[params->otg_inst], 1,
 				1, 100);
 
 		/* The recommended programming sequence to enable DTBCLK DTO to generate
 		 * valid pixel HPO DPSTREAM ENCODER, specifies that DTO source select should
 		 * be set only after DTO is enabled
 		 */
-		REG_UPDATE(OTG_PIXEL_RATE_CNTL[dtbclk_inst],
-				PIPE_DTO_SRC_SEL[dtbclk_inst], 1);
-
-		dccg->dtbclk_khz[dtbclk_inst] = req_dtbclk_khz;
+		REG_UPDATE(OTG_PIXEL_RATE_CNTL[params->otg_inst],
+				PIPE_DTO_SRC_SEL[params->otg_inst], 1);
 	} else {
-		REG_UPDATE_3(OTG_PIXEL_RATE_CNTL[dtbclk_inst],
-				DTBCLK_DTO_ENABLE[dtbclk_inst], 0,
-				PIPE_DTO_SRC_SEL[dtbclk_inst], 0,
-				DTBCLK_DTO_DIV[dtbclk_inst], dtbdto_div);
+		REG_UPDATE_3(OTG_PIXEL_RATE_CNTL[params->otg_inst],
+				DTBCLK_DTO_ENABLE[params->otg_inst], 0,
+				PIPE_DTO_SRC_SEL[params->otg_inst], 0,
+				DTBCLK_DTO_DIV[params->otg_inst], dtbdto_div);
 
 		REG_WRITE(DTBCLK_DTO_MODULO[dtbclk_inst], 0);
 		REG_WRITE(DTBCLK_DTO_PHASE[dtbclk_inst], 0);
 
-		dccg->dtbclk_khz[dtbclk_inst] = 0;
+		REG_WRITE(DTBCLK_DTO_MODULO[params->otg_inst], 0);
+		REG_WRITE(DTBCLK_DTO_PHASE[params->otg_inst], 0);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c
index fa0569174aec..3aa676303661 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c
@@ -125,6 +125,8 @@ void dmub_dcn31_reset(struct dmub_srv *dmub)
 	REG_WRITE(DMCUB_INBOX1_WPTR, 0);
 	REG_WRITE(DMCUB_OUTBOX1_RPTR, 0);
 	REG_WRITE(DMCUB_OUTBOX1_WPTR, 0);
+	REG_WRITE(DMCUB_OUTBOX0_RPTR, 0);
+	REG_WRITE(DMCUB_OUTBOX0_WPTR, 0);
 	REG_WRITE(DMCUB_SCRATCH0, 0);
 
 	/* Clear the GPINT command manually so we don't send anything during boot. */
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED52604658
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiJSNIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiJSNH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:07:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B263E1FCF9;
        Wed, 19 Oct 2022 05:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 207D2B822E6;
        Wed, 19 Oct 2022 08:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB58C433B5;
        Wed, 19 Oct 2022 08:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169218;
        bh=1w++Q8iRRmqW0MQniOVcUitS0gFwZ1zF0XoxIC59Ds8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7YSyptQLZu8VBse4TfQ85GTpSatms6480pcS10LRerVRDotvbht4OFydOLgz8+i1
         9KInWMj4GJuaRf8dKcw8CanFBkbyZMxGNR9JWGSz2FFnV+Ueh5Pmc+6tSBLeLj2dnD
         Ef6N8wcGFmMCPpu3hfGLUQlrgBWuRRmSOMtzZzUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 191/862] drm/amd/display: Update PMFW z-state interface for DCN314
Date:   Wed, 19 Oct 2022 10:24:38 +0200
Message-Id: <20221019083258.417875595@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 4f5bdde386d3b8e9317df5562950e1b4fa177599 upstream.

[Why]
Request from PMFW to change the messaging format to specify whether we
support z-state via individual bits.

[How]
Update the args we pass in the support message.

Fixes: d5c6909e7460 ("drm/amd/display: Add DCN314 clock manager")
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c |   11 +++--------
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c    |    3 ++-
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c
@@ -339,29 +339,24 @@ void dcn314_smu_set_zstate_support(struc
 	if (!clk_mgr->smu_present)
 		return;
 
-	if (!clk_mgr->base.ctx->dc->debug.enable_z9_disable_interface &&
-			(support == DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY))
-		support = DCN_ZSTATE_SUPPORT_DISALLOW;
-
-
 	// Arg[15:0] = 8/9/0 for Z8/Z9/disallow -> existing bits
 	// Arg[16] = Disallow Z9 -> new bit
 	switch (support) {
 
 	case DCN_ZSTATE_SUPPORT_ALLOW:
 		msg_id = VBIOSSMC_MSG_AllowZstatesEntry;
-		param = 9;
+		param = (1 << 10) | (1 << 9) | (1 << 8);
 		break;
 
 	case DCN_ZSTATE_SUPPORT_DISALLOW:
 		msg_id = VBIOSSMC_MSG_AllowZstatesEntry;
-		param = 8;
+		param = 0;
 		break;
 
 
 	case DCN_ZSTATE_SUPPORT_ALLOW_Z10_ONLY:
 		msg_id = VBIOSSMC_MSG_AllowZstatesEntry;
-		param = 0x00010008;
+		param = (1 << 10);
 		break;
 
 	default: //DCN_ZSTATE_SUPPORT_UNKNOWN
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -881,7 +881,8 @@ static const struct dc_plane_cap plane_c
 };
 
 static const struct dc_debug_options debug_defaults_drv = {
-	.disable_z10 = true, /*hw not support it*/
+	.disable_z10 = false,
+	.enable_z9_disable_interface = true,
 	.disable_dmcu = true,
 	.force_abm_enable = false,
 	.timing_trace = false,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5B44ABCCC
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387122AbiBGLjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385967AbiBGLdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2710AC043181;
        Mon,  7 Feb 2022 03:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1FE8B8111C;
        Mon,  7 Feb 2022 11:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26FEC004E1;
        Mon,  7 Feb 2022 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233589;
        bh=45tOOHDrjTYStgkC+9Zc7z5T7IhQblOXUrM1/Oiv+8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ni7sS6sNoeweGTWwLpr2YI0+Zb3VRj+d+Mgxezjih31L9++P6XrrWPLh+uK6EjY+d
         3vkIZ46fRmBTDGDwxXQ48xE6VuMb80oGCRftB0fdxgCB4V6JC6ftARpX8Y0bq9R2Pa
         ztBeRzJ7qSP0TfrrVz+z2LNH/+JJp7jcMm9zbYt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Stylon Wang <stylon.wang@amd.com>,
        Paul Hsieh <paul.hsieh@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 027/126] drm/amd/display: watermark latencies is not enough on DCN31
Date:   Mon,  7 Feb 2022 12:05:58 +0100
Message-Id: <20220207103805.085322616@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Hsieh <paul.hsieh@amd.com>

commit f5fa54f45ab41cbb1f99b1208f49554132ffb207 upstream.

[Why]
The original latencies were causing underflow in some modes.
Resolution: 2880x1620@60p when HDR enable

[How]
1. Replace with the up-to-date watermark values based on new measurments
2. Correct the ddr_wm_table name to DDR5 on DCN31

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c |   20 +++++------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -329,38 +329,38 @@ static struct clk_bw_params dcn31_bw_par
 
 };
 
-static struct wm_table ddr4_wm_table = {
+static struct wm_table ddr5_wm_table = {
 	.entries = {
 		{
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 6.09,
-			.sr_enter_plus_exit_time_us = 7.14,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 9,
+			.sr_enter_plus_exit_time_us = 11,
 			.valid = true,
 		},
 	}
@@ -688,7 +688,7 @@ void dcn31_clk_mgr_construct(
 		if (ctx->dc_bios->integrated_info->memory_type == LpDdr5MemType) {
 			dcn31_bw_params.wm_table = lpddr5_wm_table;
 		} else {
-			dcn31_bw_params.wm_table = ddr4_wm_table;
+			dcn31_bw_params.wm_table = ddr5_wm_table;
 		}
 		/* Saved clocks configured at boot for debug purposes */
 		 dcn31_dump_clk_registers(&clk_mgr->base.base.boot_snapshot, &clk_mgr->base.base, &log_info);



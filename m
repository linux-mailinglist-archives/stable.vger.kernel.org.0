Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1986280AD
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbiKNNIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbiKNNIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6622AE0D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CE9BB80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C09BC433D6;
        Mon, 14 Nov 2022 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431277;
        bh=sCilEwS1Brfc/MjLw9VWTOvvX+htV0bZQQaOE7ILxNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAl3YUIlLvklaoI51gvkyQ1w93QqobXy+ecDb+XvX6JwrS2boQK1wRqrilUhpgXbm
         7Q3Al46pEZsrnnYD4mOadBVVKaf1aXu24IN/7F1yQ1kZPA4Cc/kh5dtk2x/qTouWRn
         kjHm4BWJInp1Bu+l0zNUeDLY5Le8xKcxNYBP/zis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun Lei <Jun.Lei@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 139/190] drm/amd/display: Update SR watermarks for DCN314
Date:   Mon, 14 Nov 2022 13:46:03 +0100
Message-Id: <20221114124504.881752074@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 632d06985235d988c9d7e6eec8fa655be0761fd0 upstream.

[Why & How]
New values requested by hardware after fine-tuning.
Update for all memory types.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c |   32 +++++-----
 drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c         |    4 -
 2 files changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
@@ -356,32 +356,32 @@ static struct wm_table ddr5_wm_table = {
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 9,
-			.sr_enter_plus_exit_time_us = 11,
+			.sr_exit_time_us = 12.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 9,
-			.sr_enter_plus_exit_time_us = 11,
+			.sr_exit_time_us = 12.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 9,
-			.sr_enter_plus_exit_time_us = 11,
+			.sr_exit_time_us = 12.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 9,
-			.sr_enter_plus_exit_time_us = 11,
+			.sr_exit_time_us = 12.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 	}
@@ -393,32 +393,32 @@ static struct wm_table lpddr5_wm_table =
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 11.5,
-			.sr_enter_plus_exit_time_us = 14.5,
+			.sr_exit_time_us = 16.5,
+			.sr_enter_plus_exit_time_us = 18.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 11.5,
-			.sr_enter_plus_exit_time_us = 14.5,
+			.sr_exit_time_us = 16.5,
+			.sr_enter_plus_exit_time_us = 18.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 11.5,
-			.sr_enter_plus_exit_time_us = 14.5,
+			.sr_exit_time_us = 16.5,
+			.sr_enter_plus_exit_time_us = 18.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 11.5,
-			.sr_enter_plus_exit_time_us = 14.5,
+			.sr_exit_time_us = 16.5,
+			.sr_enter_plus_exit_time_us = 18.5,
 			.valid = true,
 		},
 	}
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
@@ -146,8 +146,8 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 		},
 	},
 	.num_states = 5,
-	.sr_exit_time_us = 9.0,
-	.sr_enter_plus_exit_time_us = 11.0,
+	.sr_exit_time_us = 16.5,
+	.sr_enter_plus_exit_time_us = 18.5,
 	.sr_exit_z8_time_us = 442.0,
 	.sr_enter_plus_exit_z8_time_us = 560.0,
 	.writeback_latency_us = 12.0,



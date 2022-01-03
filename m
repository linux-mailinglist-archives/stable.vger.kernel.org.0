Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E470D48338C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiACOiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiACOgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:36:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEAEC0617A1;
        Mon,  3 Jan 2022 06:33:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CD33610B1;
        Mon,  3 Jan 2022 14:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FA6C36AF0;
        Mon,  3 Jan 2022 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220400;
        bh=+9ns34Li/KaFaleKeoV9zquOLbxHaSWUhrkvSbps2ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8tWrKaWJ96ARhdOF5x2Frkg6Z0jTBIpRRzUKxpItPzTVTIi6vvykpIryr6Rio3UE
         F/53SE4RvViT248zvYcRfTIak6dM0z3BQnO1RQCVflBKKcn7/vx5l6bAfcb1T0wrda
         L0knadEHnlUZ2UlDNR2g0ZXnDATMvNVUQoSJpF3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Angus Wang <angus.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 57/73] drm/amd/display: Changed pipe split policy to allow for multi-display pipe split
Date:   Mon,  3 Jan 2022 15:24:18 +0100
Message-Id: <20220103142058.762278116@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angus Wang <angus.wang@amd.com>

commit ee2698cf79cc759a397c61086c758d4cc85938bf upstream.

[WHY]
Current implementation of pipe split policy prevents pipe split with
multiple displays connected, which caused the MCLK speed to be stuck at
max

[HOW]
Changed the pipe split policies so that pipe split is allowed for
multi-display configurations

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1522
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1709
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1655
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1403

Note this is a backport of this commit from amdgpu drm-next for 5.16.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Angus Wang <angus.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c   |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c   |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c   |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c   |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1067,7 +1067,7 @@ static const struct dc_debug_options deb
 		.timing_trace = false,
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
-		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
+		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -874,7 +874,7 @@ static const struct dc_debug_options deb
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
 		.min_disp_clk_khz = 100000,
-		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
+		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -840,7 +840,7 @@ static const struct dc_debug_options deb
 	.timing_trace = false,
 	.clock_trace = true,
 	.disable_pplib_clock_request = true,
-	.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
+	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 	.force_single_disp_pipe_split = false,
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -863,7 +863,7 @@ static const struct dc_debug_options deb
 	.disable_clock_gate = true,
 	.disable_pplib_clock_request = true,
 	.disable_pplib_wm_range = true,
-	.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
+	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 	.force_single_disp_pipe_split = false,
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
--- a/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
@@ -211,7 +211,7 @@ static const struct dc_debug_options deb
 		.timing_trace = false,
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
-		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
+		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,
--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -193,7 +193,7 @@ static const struct dc_debug_options deb
 		.timing_trace = false,
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
-		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
+		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -923,7 +923,7 @@ static const struct dc_debug_options deb
 	.timing_trace = false,
 	.clock_trace = true,
 	.disable_pplib_clock_request = false,
-	.pipe_split_policy = MPC_SPLIT_AVOID,
+	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 	.force_single_disp_pipe_split = false,
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,



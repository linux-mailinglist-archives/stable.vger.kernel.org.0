Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124984A8E5F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354414AbiBCUgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:36:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38830 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354724AbiBCUeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:34:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6090761AE9;
        Thu,  3 Feb 2022 20:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE76EC340E8;
        Thu,  3 Feb 2022 20:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920446;
        bh=a9hRDb8jeBX3+CfUzzLMVZKn6WHEX5RbBWJPBjc8rVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfBFJaeeNIQKoD9lPLKdLafhvCD5hnTT2D0F/VyKx8BE15WYyqKFz/UaPrafUPaWg
         TtXz3qHSGaKvwZKsECNK1JepnMDnEVEdmgDbTAPUH+GnGePfqrB9FB/r5r/iu0jwu1
         +RupkGb+lt26wswf5QQ0wjaNkIrqzr7XQA3CSicnXP22HXtJzHSmt01PgMRVGJVf7k
         Fp+wKVohN0J80RTX5mO4sEbo5sVsvQ8iPhdkTHzVnv3l79d2kUI7VbXumnT28RPTeW
         W1qlJJbpwTgkJnPzBjc9W3Y9JArfMzqZ/NC5Vwey8wm4BxMQQ49kOh2VsN1+OSi4o8
         bAUJxUdAD+Zbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhan Liu <zhan.liu@amd.com>, Charlene Liu <charlene.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nikola.cornij@amd.com, Dmytro.Laktyushkin@amd.com,
        Charlene.Liu@amd.com, angus.wang@amd.com, Qingqing.Zhuo@amd.com,
        charles.sun@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 35/41] drm/amd/display: Correct MPC split policy for DCN301
Date:   Thu,  3 Feb 2022 15:32:39 -0500
Message-Id: <20220203203245.3007-35-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhan Liu <zhan.liu@amd.com>

[ Upstream commit ac46d93235074a6c5d280d35771c23fd8620e7d9 ]

[Why]
DCN301 has seamless boot enabled. With MPC split enabled
at the same time, system will hang.

[How]
Revert MPC split policy back to "MPC_SPLIT_AVOID". Since we have
ODM combine enabled on DCN301, pipe split is not necessary here.

Signed-off-by: Zhan Liu <zhan.liu@amd.com>
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 9e2f18a0c9483..26ebe00a55f67 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -863,7 +863,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.disable_clock_gate = true,
 	.disable_pplib_clock_request = true,
 	.disable_pplib_wm_range = true,
-	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+	.pipe_split_policy = MPC_SPLIT_AVOID,
 	.force_single_disp_pipe_split = false,
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
-- 
2.34.1


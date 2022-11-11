Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E46625088
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiKKCg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiKKCgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC3C6A6A5;
        Thu, 10 Nov 2022 18:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EFEA6199B;
        Fri, 11 Nov 2022 02:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D558FC433D7;
        Fri, 11 Nov 2022 02:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134084;
        bh=xoSLsihZiT1ArA1txjFg65HFkeQ/l8/kgQEA+n7cWCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWlnTUeMZ74YbaUdTc7dT4JCAFzZ9lLap96huzT+txyTZfbv7XwzTYhtE9pRcYQZe
         jhxUkp3ZIZ7cj+k7Q1wONr9l9uOG2s0/rzfGs+GbG794NrmWeX6Yzy+sZEcd0LRSuW
         nEf3HI7hcX7iKv1OmyF2swUngRYOG9nxVstDh7dD7sQK55t3ntEjZfZEpqj8ChZvCJ
         pmQDnvHoQUT6KUrg5XI9VuojPHbxslAeYtWH+pmQi1/l7z6QEFdwNpW3wxMfXx3+kh
         3eDii1icHO+o4rvJWkkzlGV40ahiXTnmkTmw8mZ6wDPriGdZodLI/KfKpewvQzbRez
         xRdSIO7hrDnpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Shen <george.shen@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, aurabindo.pillai@amd.com, nathan@kernel.org,
        jun.lei@amd.com, mairacanal@riseup.net, Samson.Tam@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 23/30] drm/amd/display: Use forced DSC bpp in DML
Date:   Thu, 10 Nov 2022 21:33:31 -0500
Message-Id: <20221111023340.227279-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Shen <george.shen@amd.com>

[ Upstream commit ab007e5db5d3b8b8975c7eec69992ff38fe2a46c ]

[Why]
DSC config is calculated separately from DML calculations.
DML should use these separately calculated DSC params. The issue is
that the calculated bpp is not properly propagated into DML.

[How]
Correctly used forced_bpp value in DML.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 52525833a99b..6704465fe5b6 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -1627,7 +1627,7 @@ static void mode_support_configuration(struct vba_vars_st *v,
 				&& !mode_lib->vba.MSOOrODMSplitWithNonDPLink
 				&& !mode_lib->vba.NotEnoughLanesForMSO
 				&& mode_lib->vba.LinkCapacitySupport[i] == true && !mode_lib->vba.P2IWith420
-				&& !mode_lib->vba.DSCOnlyIfNecessaryWithBPP
+				//&& !mode_lib->vba.DSCOnlyIfNecessaryWithBPP
 				&& !mode_lib->vba.DSC422NativeNotSupported
 				&& !mode_lib->vba.MPCCombineMethodIncompatible
 				&& mode_lib->vba.ODMCombine2To1SupportCheckOK[i] == true
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
index 503e7d984ff0..cb34ac0af349 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
@@ -624,7 +624,7 @@ static void fetch_pipe_params(struct display_mode_lib *mode_lib)
 		mode_lib->vba.skip_dio_check[mode_lib->vba.NumberOfActivePlanes] =
 				dout->is_virtual;
 
-		if (!dout->dsc_enable)
+		if (dout->dsc_enable)
 			mode_lib->vba.ForcedOutputLinkBPP[mode_lib->vba.NumberOfActivePlanes] = dout->output_bpp;
 		else
 			mode_lib->vba.ForcedOutputLinkBPP[mode_lib->vba.NumberOfActivePlanes] = 0.0;
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935166357BA
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbiKWJoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238127AbiKWJoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:44:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193A256D6D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD914B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29AAC433D6;
        Wed, 23 Nov 2022 09:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196517;
        bh=xoSLsihZiT1ArA1txjFg65HFkeQ/l8/kgQEA+n7cWCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjnMcH3uFgHpszegfUSpQcvlpAksyXs2Oy02MOiAF+sP79xBaxKPyzrPfStqoZ/LV
         1EjJHcclUk3BMQFi8bikpecLU5RPjti33JhGlDn154lEhF7ad+jfnEX8sTf+mj1Tk1
         uUJ4JM/nixxzCp45ZcAUIRkjuDSAXp+EoXiREJYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        George Shen <george.shen@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 054/314] drm/amd/display: Use forced DSC bpp in DML
Date:   Wed, 23 Nov 2022 09:48:19 +0100
Message-Id: <20221123084627.948487632@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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




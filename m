Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B38F5A0692
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiHYBmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiHYBmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F799C526;
        Wed, 24 Aug 2022 18:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF1461A28;
        Thu, 25 Aug 2022 01:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4639C433D7;
        Thu, 25 Aug 2022 01:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391525;
        bh=GAU6auQnSBbeCmtNXr4ktFzRC9D15yCJgrdq7WfNEMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzC+HhYbjhoNjLNDTGcln0to5Uqo7rskAdCUtVTDocc4f9NQjE5d+h6fTZJlAmp/h
         Q7JIcn0Bj0jDgI8FTeV+nyg9yhJ7xuuL8vF3hyRvSCfDkOHFzX3ceGvNq9XwGoJSz6
         RyfiwLNC8NW2YC+01lQIJxi0YkyBt+RxWoHVcU7k8IxsUi8IYHvzGMOPPIFhkZ/PNG
         a8Mf56UlPYhSTPabTaqllQVsrxqPtTlFX4pH4aUVQxq3DbxBSsQNVyEwYmjPHY9cDK
         7eGPTu/pzMtVvoL2HAYBsYFBu0Y9LpyjfmC+bhwYVnC44TnYe7Pi6M6QLPbJF2WGHr
         iVGwahM3lsjug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alvin Lee <alvin.lee2@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Aric.Cyr@amd.com, bas@basnieuwenhuizen.nl,
        joshua@froggi.es, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 02/11] drm/amd/display: For stereo keep "FLIP_ANY_FRAME"
Date:   Wed, 24 Aug 2022 21:38:23 -0400
Message-Id: <20220825013836.23205-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013836.23205-1-sashal@kernel.org>
References: <20220825013836.23205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 84ef99c728079dfd21d6bc70b4c3e4af20602b3c ]

[Description]
Observed in stereomode that programming FLIP_LEFT_EYE
can cause hangs. Keep FLIP_ANY_FRAME in stereo mode so
the surface flip can take place before left or right eye

Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
index af462fe4260d..b0fd8859bd2f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
@@ -86,7 +86,7 @@ bool hubp3_program_surface_flip_and_addr(
 			VMID, address->vmid);
 
 	if (address->type == PLN_ADDR_TYPE_GRPH_STEREO) {
-		REG_UPDATE(DCSURF_FLIP_CONTROL, SURFACE_FLIP_MODE_FOR_STEREOSYNC, 0x1);
+		REG_UPDATE(DCSURF_FLIP_CONTROL, SURFACE_FLIP_MODE_FOR_STEREOSYNC, 0);
 		REG_UPDATE(DCSURF_FLIP_CONTROL, SURFACE_FLIP_IN_STEREOSYNC, 0x1);
 
 	} else {
-- 
2.35.1


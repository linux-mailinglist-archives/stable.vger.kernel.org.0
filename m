Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A076309BF
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiKSCRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiKSCRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:17:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C9B74611;
        Fri, 18 Nov 2022 18:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C0D7B82679;
        Sat, 19 Nov 2022 02:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91E7C433B5;
        Sat, 19 Nov 2022 02:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824013;
        bh=NiKLtqhaTw1063gZHnyeVIvxhhTA/uGYOR5TfGK61Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7h0EQzLq2SeT5O7Xgq7p3OmnmrzFaNy/Xf+yiy1F0soaqEbbwejLzwPuxg9kY5uk
         8+FzObKaEhp+9gqPyl5sfeRyCA57iYWkfF4yB821u+8L/6JeHorhNq6q/vWjtcHiFg
         Z3jyIJp745sukZCZSm/IO/IJ6GFXLPMo1F7PpynxbPrA+AzNTGRPn1nGDAdhypuuBk
         agEK3ee98PBoEjb8XSq+pQW596CkO6cO0xEl6elxZ2RIhqHShZS00d1ng71T3cBIh9
         LpLHtvKWAOM+IVfi86qpXIjYuM+2Vq3rOhG9A9AduwC0vdPHjh79bClyzKSsH3xHoS
         rQsWJUCbqs66A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamza Mahfooz <hamza.mahfooz@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        nicholas.kazlauskas@amd.com, aurabindo.pillai@amd.com,
        roman.li@amd.com, Jerry.Zuo@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 40/44] drm/amd/display: only fill dirty rectangles when PSR is enabled
Date:   Fri, 18 Nov 2022 21:11:20 -0500
Message-Id: <20221119021124.1773699-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
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

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 675d84621a24490e1de3d59a4992a17fa9ff92b5 ]

Currently, we are calling fill_dc_dirty_rects() even if PSR isn't
supported by the relevant link in amdgpu_dm_commit_planes(), this is
undesirable especially because when drm.debug is enabled we are printing
messages in fill_dc_dirty_rects() that are only useful for debugging PSR
(and confusing otherwise). So, we can instead limit the filling of dirty
rectangles to only when PSR is enabled.

Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3be70848b202..aaf7e4b22ed0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7639,9 +7639,10 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 		bundle->surface_updates[planes_count].plane_info =
 			&bundle->plane_infos[planes_count];
 
-		fill_dc_dirty_rects(plane, old_plane_state, new_plane_state,
-				    new_crtc_state,
-				    &bundle->flip_addrs[planes_count]);
+		if (acrtc_state->stream->link->psr_settings.psr_feature_enabled)
+			fill_dc_dirty_rects(plane, old_plane_state,
+					    new_plane_state, new_crtc_state,
+					    &bundle->flip_addrs[planes_count]);
 
 		/*
 		 * Only allow immediate flips for fast updates that don't
-- 
2.35.1


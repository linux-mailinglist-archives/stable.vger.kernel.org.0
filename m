Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AB063DF2D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiK3Sow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiK3So0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50992E9DF
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 510CEB81CAB
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9782C433C1;
        Wed, 30 Nov 2022 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833857;
        bh=uAuaX12jyM+FLkMcL8Ao4lWfF6KRnsXjUrxcbY6L/g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frtNVl+oPDzcxJrJ4iIDCbjGqR+QUSU27uVy7y6HDvQS+I84vJDg2wRJKinmgBrrh
         CaplFrWN6cLDTKYHTY/QQqblYYY+gEWlNdnloLP+50HkFXw1UQXfLNuYsoVFPL9/o2
         lW8TuRof3qltOnNlrC9prG7a/FDcm00TU0PO/G2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Leo Li <sunpeng.li@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 039/289] drm/amd/display: only fill dirty rectangles when PSR is enabled
Date:   Wed, 30 Nov 2022 19:20:24 +0100
Message-Id: <20221130180545.018048290@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
index 7f8eb09b0b7c..9ce100e315c5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7650,9 +7650,10 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
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




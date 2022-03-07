Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56144CF789
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbiCGJq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241052AbiCGJlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0909A6D952;
        Mon,  7 Mar 2022 01:39:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 712A6CE0EA0;
        Mon,  7 Mar 2022 09:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351A9C340E9;
        Mon,  7 Mar 2022 09:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645975;
        bh=UCPDdBc0WVD3RBg0+FDOGg5k3at7tdAwOx+sSeviBEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ng2JHgAqR42Z41TQjZIqKHVjYPPDWuQh53QYNJZrnfxel6weOMtuzL3WO3Z9nTXaZ
         PLsnJjWFVpQMMt8AfEkFpzVSfgZM/8HQFu2FrVqGKlJTfc+6RxgbV/GEoZbLp96bSF
         k4Okar2rCVWLsuB6yeZXva+ak0PMfJ4KiG8yjQ40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/262] drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled
Date:   Mon,  7 Mar 2022 10:17:20 +0100
Message-Id: <20220307091705.182446530@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 70897848730470cc477d5d89e6222c0f6a9ac173 ]

[Why]
PSR currently relies on the kernel's delayed vblank on/off mechanism
as an implicit bufferring mechanism to prevent excessive entry/exit.

Without this delay the user experience is impacted since it can take
a few frames to enter/exit.

[How]
Only allow vblank disable immediate for DC when psr is not supported.

Leave a TODO indicating that this support should be extended in the
future to delay independent of the vblank interrupt.

Fixes: 92020e81ddbeac ("drm/amdgpu/display: set vblank_disable_immediate for DC")

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 5ae9b8133d6da..76967adc51606 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1279,9 +1279,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	adev_to_drm(adev)->mode_config.cursor_width = adev->dm.dc->caps.max_cursor_size;
 	adev_to_drm(adev)->mode_config.cursor_height = adev->dm.dc->caps.max_cursor_size;
 
-	/* Disable vblank IRQs aggressively for power-saving */
-	adev_to_drm(adev)->vblank_disable_immediate = true;
-
 	if (drm_vblank_init(adev_to_drm(adev), adev->dm.display_indexes_num)) {
 		DRM_ERROR(
 		"amdgpu: failed to initialize sw for display support.\n");
@@ -3866,6 +3863,14 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 	}
 
+	/*
+	 * Disable vblank IRQs aggressively for power-saving.
+	 *
+	 * TODO: Fix vblank control helpers to delay PSR entry to allow this when PSR
+	 * is also supported.
+	 */
+	adev_to_drm(adev)->vblank_disable_immediate = !psr_feature_enabled;
+
 	/* Software is initialized. Now we can register interrupt handlers. */
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
-- 
2.34.1




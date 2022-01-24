Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3F3497C9A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 11:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiAXKBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 05:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiAXKBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 05:01:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3408C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 02:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7966DB80EE0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 10:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81512C340E1;
        Mon, 24 Jan 2022 10:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643018496;
        bh=Nzfz+rVkyM5eb1q2uBJgbmMrNrDMmX9gfn2DxBuQk1g=;
        h=Subject:To:Cc:From:Date:From;
        b=et5cGuWpnn85ND7bItqe8A425eDsAL/UVPqDetyHFKEDQSrLJ4cCrruL+93cJnVNY
         eaSoBgFuXrwk5B2iHMqPWJ9RqPBYKAsKGTsasFhGgVWHz7Hd3upXVQNDm4v/oS5yey
         zFaEtI5Tg3smDTlW3qk9lBsQYCsoeOpUCfga595g=
Subject: FAILED: patch "[PATCH] drm/amdgpu/display: Only set vblank_disable_immediate when" failed to apply to 5.10-stable tree
To:     nicholas.kazlauskas@amd.com, alexander.deucher@amd.com,
        harry.wentland@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 11:01:33 +0100
Message-ID: <16430184932340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 70897848730470cc477d5d89e6222c0f6a9ac173 Mon Sep 17 00:00:00 2001
From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Date: Tue, 30 Nov 2021 09:32:33 -0500
Subject: [PATCH] drm/amdgpu/display: Only set vblank_disable_immediate when
 PSR is not enabled

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

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 05e4a0952a2b..4b76eb14a111 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1599,9 +1599,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	adev_to_drm(adev)->mode_config.cursor_width = adev->dm.dc->caps.max_cursor_size;
 	adev_to_drm(adev)->mode_config.cursor_height = adev->dm.dc->caps.max_cursor_size;
 
-	/* Disable vblank IRQs aggressively for power-saving */
-	adev_to_drm(adev)->vblank_disable_immediate = true;
-
 	if (drm_vblank_init(adev_to_drm(adev), adev->dm.display_indexes_num)) {
 		DRM_ERROR(
 		"amdgpu: failed to initialize sw for display support.\n");
@@ -4264,6 +4261,14 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
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


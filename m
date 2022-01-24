Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13C49A5D7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371165AbiAYAHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363445AbiAXXoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:44:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A77DC0BD117;
        Mon, 24 Jan 2022 13:39:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E73B8105C;
        Mon, 24 Jan 2022 21:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36E4C340E4;
        Mon, 24 Jan 2022 21:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060357;
        bh=Tw+KMUhqIdOfNxHiKbccYBjOLfhTZO6kFMaB64mcMAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqJIAN/6zzHF7gJSRrB67gVZimiKfE6tw6o5JChZzKH+VUDOsMKtyutwCDUOYMase
         /XwKmB2vX8Ld9N4xWfPMnYvBhZckjoIW9gcnxDIK/JyHHSX2TmPGftN6WK72JcPnk8
         QQoWYH9BYFbqIHaZ+9CaCA28jraUkTpKj9cPfBok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: [PATCH 5.16 0904/1039] drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled
Date:   Mon, 24 Jan 2022 19:44:53 +0100
Message-Id: <20220124184155.680939976@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 70897848730470cc477d5d89e6222c0f6a9ac173 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1598,9 +1598,6 @@ static int amdgpu_dm_init(struct amdgpu_
 	adev_to_drm(adev)->mode_config.cursor_width = adev->dm.dc->caps.max_cursor_size;
 	adev_to_drm(adev)->mode_config.cursor_height = adev->dm.dc->caps.max_cursor_size;
 
-	/* Disable vblank IRQs aggressively for power-saving */
-	adev_to_drm(adev)->vblank_disable_immediate = true;
-
 	if (drm_vblank_init(adev_to_drm(adev), adev->dm.display_indexes_num)) {
 		DRM_ERROR(
 		"amdgpu: failed to initialize sw for display support.\n");
@@ -4285,6 +4282,14 @@ static int amdgpu_dm_initialize_drm_devi
 
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



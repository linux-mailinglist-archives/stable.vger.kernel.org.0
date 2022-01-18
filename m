Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E871849182F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345550AbiARCoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50402 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347519AbiARClc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B661BB81235;
        Tue, 18 Jan 2022 02:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B871CC36AEB;
        Tue, 18 Jan 2022 02:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473689;
        bh=ZE5dsaoNj8qyo4ImDQroynSx3KZtWAsOjL0c8M5iZPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grLHJfSDiAyQ8iH48U8OF4hksVkKdmpn9ep9nn8joLskVj4tdgIq9Sg9AXBGU72Gv
         vUhNkALhW8OpqkQTdVdfwfWEk/kNkSwUdgoU3fFBNldx9+ckKK1dGaLQr+b6WvWSfY
         K+JRJDukdZDsuYhTHsORqXasf9o5BFkybgWn2oZK8+UtYtPz3TKiFO8axGcTw/4g/N
         y0J5UhOGkDg7ufaa4VfmuseurLszBww5dl6W5m+u8rWOtQvWEfm7/vXA2Ymo8OHgTm
         OVNgzFgdzBgtKTMvx+d6QHi5xI1qvi2TiE7E5bSlZjDCGDrbKntGVaWjeDtPxzUNm5
         w7B6zdllDznGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        Felix.Kuehling@amd.com, Emily.Deng@amd.com, tzimmermann@suse.de,
        andrey.grodzovsky@amd.com, Philip.Yang@amd.com, Yong.Zhao@amd.com,
        Hawking.Zhang@amd.com, nicholas.kazlauskas@amd.com,
        qingqing.zhuo@amd.com, Anson.Jacob@amd.com, shenshih@amd.com,
        aurabindo.pillai@amd.com, nikola.cornij@amd.com, Wayne.Lin@amd.com,
        Roman.Li@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 023/116] drm/amdgpu/display: set vblank_disable_immediate for DC
Date:   Mon, 17 Jan 2022 21:38:34 -0500
Message-Id: <20220118024007.1950576-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 92020e81ddbeac351ea4a19bcf01743f32b9c800 ]

Disable vblanks immediately to save power.  I think this was
missed when we merged DC support.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1781
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c           | 1 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 2f70fdd6104f2..582055136cdbf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -267,7 +267,6 @@ int amdgpu_irq_init(struct amdgpu_device *adev)
 	if (!amdgpu_device_has_dc_support(adev)) {
 		if (!adev->enable_virtual_display)
 			/* Disable vblank IRQs aggressively for power-saving */
-			/* XXX: can this be enabled for DC? */
 			adev_to_drm(adev)->vblank_disable_immediate = true;
 
 		r = drm_vblank_init(adev_to_drm(adev), adev->mode_info.num_crtc);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a5b6f36fe1d72..6c8f141103da4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1069,6 +1069,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	adev_to_drm(adev)->mode_config.cursor_width = adev->dm.dc->caps.max_cursor_size;
 	adev_to_drm(adev)->mode_config.cursor_height = adev->dm.dc->caps.max_cursor_size;
 
+	/* Disable vblank IRQs aggressively for power-saving */
+	adev_to_drm(adev)->vblank_disable_immediate = true;
+
 	if (drm_vblank_init(adev_to_drm(adev), adev->dm.display_indexes_num)) {
 		DRM_ERROR(
 		"amdgpu: failed to initialize sw for display support.\n");
-- 
2.34.1


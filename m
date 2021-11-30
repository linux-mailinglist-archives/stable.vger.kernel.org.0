Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEF14637EC
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243155AbhK3O5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243337AbhK3OzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:55:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F41C061746;
        Tue, 30 Nov 2021 06:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2736B81A21;
        Tue, 30 Nov 2021 14:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19525C53FD1;
        Tue, 30 Nov 2021 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283806;
        bh=OIkdmRSsVUKR8QOVFJnATvdtYexQpe8SKvvWQq2QRgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zgomx9Z3j2I1edYU5xWFghu7Spxjnts02eZLf4Y8Z8yRll9P3opbXwYL3Ypqo0zTq
         /vbDI6PnMHmrGy/+qgJT2rSRsMnUKaeY9/BBKmua4QsZaTZwCrBki1UbrbzoK4rFi7
         /nTYSecrKQREORp9anyjwFmKVHp0nF5436X+9owYFn+c6VaFKdntxAer7Lig3/Ptu3
         L6Q0l/H1jMCuZDSI9eEvRT7VjlcagFA4ieBp22UhWoC0YTe+J7FuHca0oJ7uXqG5KN
         JJgdCEg8/dJgRNzFsQAHDdWlMZoxP3C3AVJuzvOFOQnJ1oh1+Dhd1CpOUjGNd99Cw9
         p5MOnwsgUKiOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        tiantao6@hisilicon.com, Hawking.Zhang@amd.com,
        andrey.grodzovsky@amd.com, nicholas.kazlauskas@amd.com,
        Anson.Jacob@amd.com, qingqing.zhuo@amd.com, contact@emersion.fr,
        aurabindo.pillai@amd.com, shenshih@amd.com, nikola.cornij@amd.com,
        Wayne.Lin@amd.com, Roman.Li@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 60/68] drm/amd/display: update bios scratch when setting backlight
Date:   Tue, 30 Nov 2021 09:46:56 -0500
Message-Id: <20211130144707.944580-60-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 692cd92e66ee10597676530573a495dc1d3bec6a ]

Update the bios scratch register when updating the backlight
level.  Some platforms apparently read this scratch register
and do additional operations in their hotkey handlers.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1518
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c      | 12 ++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h      |  2 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 96b7bb13a2dd9..12a6b1c99c93e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1569,6 +1569,18 @@ void amdgpu_atombios_scratch_regs_engine_hung(struct amdgpu_device *adev,
 	WREG32(adev->bios_scratch_reg_offset + 3, tmp);
 }
 
+void amdgpu_atombios_scratch_regs_set_backlight_level(struct amdgpu_device *adev,
+						      u32 backlight_level)
+{
+	u32 tmp = RREG32(adev->bios_scratch_reg_offset + 2);
+
+	tmp &= ~ATOM_S2_CURRENT_BL_LEVEL_MASK;
+	tmp |= (backlight_level << ATOM_S2_CURRENT_BL_LEVEL_SHIFT) &
+		ATOM_S2_CURRENT_BL_LEVEL_MASK;
+
+	WREG32(adev->bios_scratch_reg_offset + 2, tmp);
+}
+
 bool amdgpu_atombios_scratch_need_asic_init(struct amdgpu_device *adev)
 {
 	u32 tmp = RREG32(adev->bios_scratch_reg_offset + 7);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h
index 8cc0222dba191..27e74b1fc260a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h
@@ -185,6 +185,8 @@ bool amdgpu_atombios_has_gpu_virtualization_table(struct amdgpu_device *adev);
 void amdgpu_atombios_scratch_regs_lock(struct amdgpu_device *adev, bool lock);
 void amdgpu_atombios_scratch_regs_engine_hung(struct amdgpu_device *adev,
 					      bool hung);
+void amdgpu_atombios_scratch_regs_set_backlight_level(struct amdgpu_device *adev,
+						      u32 backlight_level);
 bool amdgpu_atombios_scratch_need_asic_init(struct amdgpu_device *adev);
 
 void amdgpu_atombios_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 084491afe5405..ea36f0fa59a9e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -50,6 +50,7 @@
 #include <drm/drm_hdcp.h>
 #endif
 #include "amdgpu_pm.h"
+#include "amdgpu_atombios.h"
 
 #include "amd_shared.h"
 #include "amdgpu_dm_irq.h"
@@ -3528,6 +3529,9 @@ static int amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
 	caps = dm->backlight_caps[bl_idx];
 
 	dm->brightness[bl_idx] = user_brightness;
+	/* update scratch register */
+	if (bl_idx == 0)
+		amdgpu_atombios_scratch_regs_set_backlight_level(dm->adev, dm->brightness[bl_idx]);
 	brightness = convert_brightness_from_user(&caps, dm->brightness[bl_idx]);
 	link = (struct dc_link *)dm->backlight_link[bl_idx];
 
-- 
2.33.0


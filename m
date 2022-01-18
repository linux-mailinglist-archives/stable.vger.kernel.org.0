Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0984914E0
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244759AbiARCZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245233AbiARCXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF5FC061783;
        Mon, 17 Jan 2022 18:23:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96D2BB8122C;
        Tue, 18 Jan 2022 02:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B8AC36AEF;
        Tue, 18 Jan 2022 02:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472590;
        bh=hJKdXQWfWwBSSe/OAz93I6pyit1rwGkzkVXJHlxjV9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9sInTcSnZ5ubonUSFLlj/MzF9cPoFAb2cp/nBMZzSii7wW3MZwZIXVZP1PKjj9cf
         yDRdqmXBee7v419Iq31jhQkljGkxOXx6LJyUeSvhD9tnGoHu8YkWKlqtBr6aH1sTVm
         R1xlomMO6sqByFoS2gs10c4iaHcu4/qS9Av4Iw27On6T74dzrO6p5FNzmMg6bkXMIp
         hJBucgDKxMnl1FUtWHDqN2lYiRZCM/q4bwt13C9T9UYifbBae8peAwwLBwS4ao0Etp
         CjD47hlMbsh5XPVYjt2UQ//VI3By5EvJpSy2CG4wvPfBaHtu6kiKw80B6IWf+orPlX
         ux7mBD6ynHW2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        Felix.Kuehling@amd.com, lijo.lazar@amd.com, Emily.Deng@amd.com,
        Philip.Yang@amd.com, tzimmermann@suse.de,
        andrey.grodzovsky@amd.com, isabbasso@riseup.net, Yong.Zhao@amd.com,
        Hawking.Zhang@amd.com, nicholas.kazlauskas@amd.com,
        qingqing.zhuo@amd.com, Anson.Jacob@amd.com, shenshih@amd.com,
        aurabindo.pillai@amd.com, nikola.cornij@amd.com, Wayne.Lin@amd.com,
        Roman.Li@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 061/217] drm/amdgpu/display: set vblank_disable_immediate for DC
Date:   Mon, 17 Jan 2022 21:17:04 -0500
Message-Id: <20220118021940.1942199-61-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index cc2e0c9cfe0a1..4f3c62adccbde 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -333,7 +333,6 @@ int amdgpu_irq_init(struct amdgpu_device *adev)
 	if (!amdgpu_device_has_dc_support(adev)) {
 		if (!adev->enable_virtual_display)
 			/* Disable vblank IRQs aggressively for power-saving */
-			/* XXX: can this be enabled for DC? */
 			adev_to_drm(adev)->vblank_disable_immediate = true;
 
 		r = drm_vblank_init(adev_to_drm(adev), adev->mode_info.num_crtc);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e727f1dd2a9a7..e08ac474e9d59 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1597,6 +1597,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
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


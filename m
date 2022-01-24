Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998B74995A2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351882AbiAXUx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391836AbiAXUtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:49:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61B2C0418B9;
        Mon, 24 Jan 2022 11:58:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4531960B43;
        Mon, 24 Jan 2022 19:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00072C340E5;
        Mon, 24 Jan 2022 19:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054280;
        bh=ZE5dsaoNj8qyo4ImDQroynSx3KZtWAsOjL0c8M5iZPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMdgDaIKbnnTIrd72oCszDgviZSXmgi1pkCoMAjlqWY83I2sPA7BM+PXal60MZ2yK
         efQcfDE6xdjRdo7OyIff6OL2koWWL6cU+qPEfmC435z/+wqB6jcWKcxQoZWXb0Q4od
         fsYLObr/1Pc7tQWYIeFB02Ii+1Yhdm83EMA04654=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/563] drm/amdgpu/display: set vblank_disable_immediate for DC
Date:   Mon, 24 Jan 2022 19:41:25 +0100
Message-Id: <20220124184035.505523349@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




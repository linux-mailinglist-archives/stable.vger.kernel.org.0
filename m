Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602AF499C00
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574146AbiAXV6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576146AbiAXVxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:53:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCF2C0C0904;
        Mon, 24 Jan 2022 12:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B7561546;
        Mon, 24 Jan 2022 20:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55528C340E7;
        Mon, 24 Jan 2022 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056470;
        bh=V7/JdFZkaZtZGU6MdNaGyFFwHH6I5LEbMplix7arxqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LX1QMzw6BYdG6lzua5ZGYJEHM4GFEMM8MM5XqvIMI8drk+HCy3ORDpa8Ao6gpNk1O
         UXvkCAqifqWNaEwhczt9pN9cMiBGhkfpwoeATJzW34JldjKeHhljVeju48SQxWpSp+
         ypaMK2mHD7aY/SReFRjUV/Okii+GeZ1L2zWDUsss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 495/846] drm/amdgpu/display: set vblank_disable_immediate for DC
Date:   Mon, 24 Jan 2022 19:40:12 +0100
Message-Id: <20220124184118.084070642@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 2fbaf6f869bfb..16556ae892d4a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1279,6 +1279,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
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




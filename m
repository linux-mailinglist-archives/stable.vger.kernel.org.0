Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F353475EBE
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245662AbhLORYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245610AbhLORXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EECC06175A;
        Wed, 15 Dec 2021 09:23:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71CDAB82049;
        Wed, 15 Dec 2021 17:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55E7C36AE0;
        Wed, 15 Dec 2021 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589018;
        bh=Zc58ANuGV3Msy+hzdE+4mS7KhdoGskyBSFCTOULUVgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ubop8DaGJPe1EWCLxGfxw4WxxrC4PUpXEpF7ilXYF0Xo/S4mwxMRMALYIynxTM7t6
         kby3+PxV/CEihsFdCQcJg628EGXmlUhdddAwWoFcQAVaqJZSWYblGUuXX61HpH8Teo
         oMSsFzyRIUfBt57KsNDjaK+8KuavoSKtaR05/Y+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Flora Cui <flora.cui@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <aleander.deucher@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/42] drm/amdgpu: check atomic flag to differeniate with legacy path
Date:   Wed, 15 Dec 2021 18:21:15 +0100
Message-Id: <20211215172027.824498952@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Flora Cui <flora.cui@amd.com>

[ Upstream commit 1053b9c948e614473819a1a5bcaff6d44e680dcf ]

since vkms support atomic KMS interface

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Acked-by: Alex Deucher <aleander.deucher@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 96ca42bcfdbf9..1545884dc703e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3854,7 +3854,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 	/* disable all interrupts */
 	amdgpu_irq_disable_all(adev);
 	if (adev->mode_info.mode_config_initialized){
-		if (!amdgpu_device_has_dc_support(adev))
+		if (!drm_drv_uses_atomic_modeset(adev_to_drm(adev)))
 			drm_helper_force_disable_all(adev_to_drm(adev));
 		else
 			drm_atomic_helper_shutdown(adev_to_drm(adev));
@@ -5130,7 +5130,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 			drm_sched_start(&ring->sched, !tmp_adev->asic_reset_res);
 		}
 
-		if (!amdgpu_device_has_dc_support(tmp_adev) && !job_signaled) {
+		if (!drm_drv_uses_atomic_modeset(adev_to_drm(tmp_adev)) && !job_signaled) {
 			drm_helper_resume_force_mode(adev_to_drm(tmp_adev));
 		}
 
-- 
2.33.0




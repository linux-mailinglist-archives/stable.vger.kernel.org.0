Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED5E4835AF
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiACR3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:29:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59718 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiACR3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:29:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AD0F6119A;
        Mon,  3 Jan 2022 17:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2737C36AED;
        Mon,  3 Jan 2022 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230977;
        bh=ercU/zPjE+qgGYkcruaixbCOilrPd7eJ6OYUzgN8e5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oz2fjc4+QDu/RmzMblChCOCA3TqJ5IThYUnYAXmEAIfAD+tz1/VNzZ8goHi0YILgU
         O5YnWNg9ouzp8nXb+z0nAe8UBcEo/uEHdQjnKmhPBPSUAuZfBzCXgRdHXyFyAnSopF
         HQDLbaZ4QTbqqY/82AHwuvQRVwwL+wX5J7zGptvIehPMaf53QvaYGLQUT1vThNU6QV
         /4GvdojqqGsYPcTh3mID1ESUQiVaxQlKYMF9svvInaszCgGprnsCwZ9Ogvt5Mg9bwD
         jIinw3kbNiwM2VdKWbNxE34FthIInByR9DIF+IC4y/DbC88hT+w8N1NwfD3xoXRu2x
         6fHKDYHjdhJfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, ray.huang@amd.com,
        andrey.grodzovsky@amd.com, tzimmermann@suse.de,
        shaoyun.liu@amd.com, aurabindo.pillai@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 11/16] drm/amdgpu: put SMU into proper state on runpm suspending for BOCO capable platform
Date:   Mon,  3 Jan 2022 12:28:44 -0500
Message-Id: <20220103172849.1612731-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 7be3be2b027c12e84833b3dc9597d3bb7e4c5464 ]

By setting mp1_state as PP_MP1_STATE_UNLOAD, MP1 will do some proper cleanups and
put itself into a state ready for PNP. That can workaround some random resuming
failure observed on BOCO capable platforms.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index ada083fbc052b..6e682bf8c2d6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1578,12 +1578,27 @@ static int amdgpu_pmops_runtime_suspend(struct device *dev)
 	if (amdgpu_device_supports_px(drm_dev))
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 
+	/*
+	 * By setting mp1_state as PP_MP1_STATE_UNLOAD, MP1 will do some
+	 * proper cleanups and put itself into a state ready for PNP. That
+	 * can address some random resuming failure observed on BOCO capable
+	 * platforms.
+	 * TODO: this may be also needed for PX capable platform.
+	 */
+	if (amdgpu_device_supports_boco(drm_dev))
+		adev->mp1_state = PP_MP1_STATE_UNLOAD;
+
 	ret = amdgpu_device_suspend(drm_dev, false);
 	if (ret) {
 		adev->in_runpm = false;
+		if (amdgpu_device_supports_boco(drm_dev))
+			adev->mp1_state = PP_MP1_STATE_NONE;
 		return ret;
 	}
 
+	if (amdgpu_device_supports_boco(drm_dev))
+		adev->mp1_state = PP_MP1_STATE_NONE;
+
 	if (amdgpu_device_supports_px(drm_dev)) {
 		/* Only need to handle PCI state in the driver for ATPX
 		 * PCI core handles it for _PR3.
-- 
2.34.1


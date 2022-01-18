Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EB7491873
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbiARCqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347934AbiARCna (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A1FC06135F;
        Mon, 17 Jan 2022 18:37:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4268B811CF;
        Tue, 18 Jan 2022 02:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153E8C36AE3;
        Tue, 18 Jan 2022 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473450;
        bh=LSCFijlqwDVH3dQEdv7hVOW/AfBT0FrxVmDG8/uNt/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGpJz0F5FZTcld4v89CCiHmtg8fNx4IYGUl/BzGahDGp2jm/0rbXxjtXWXO8UIZYz
         COuLszTnsMl5OZZIcWLUbNt9Gd5Firxbi45uOGeU160/qst7YCvPnXbLUmBK8CMWCj
         ai1C3cfBQwy8tn0aZfgoePwIdCPbapW+dqnic88GlmX4rc3I+mmKwc44VLIznRjHd8
         j6q9cGVGX5+5PQJVTZknqOuYr96z++YW8A8hbqeGlnL83oFVtNJYmsvArizBmDmY4r
         fT3yR2Ik2hkmlrPqU0pQX8qYD/tA7toAI/V3mna6wWCAh9sqPibi6s8Rt6Rd/rYrhv
         O9wdrjJBGuT0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, ray.huang@amd.com, Felix.Kuehling@amd.com,
        Yuliang.Shi@amd.com, PengJu.Zhou@amd.com, Philip.Yang@amd.com,
        Jack.Gui@amd.com, Xiaomeng.Hou@amd.com, aaron.liu@amd.com,
        victor.skvortsov@amd.com, John.Clements@amd.com, Oak.Zeng@amd.com,
        alex.sierra@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 120/188] drm/amd/amdgpu: fix gmc bo pin count leak in SRIOV
Date:   Mon, 17 Jan 2022 21:30:44 -0500
Message-Id: <20220118023152.1948105-120-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingwen Chen <Jingwen.Chen2@amd.com>

[ Upstream commit 948e7ce01413b71395723aaf846015062aea3a43 ]

[Why]
gmc bo will be pinned during loading amdgpu and reset in SRIOV while
only unpinned in unload amdgpu

[How]
add amdgpu_in_reset and sriov judgement to skip pin bo

v2: fix wrong judgement

Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Reviewed-by: Horace Chen <horace.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c | 4 ++++
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index e47104a1f5596..3c01be6610144 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -1021,10 +1021,14 @@ static int gmc_v10_0_gart_enable(struct amdgpu_device *adev)
 		return -EINVAL;
 	}
 
+	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev))
+		goto skip_pin_bo;
+
 	r = amdgpu_gart_table_vram_pin(adev);
 	if (r)
 		return r;
 
+skip_pin_bo:
 	r = adev->gfxhub.funcs->gart_enable(adev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 5551359d5dfdc..b5d93247237b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1708,10 +1708,14 @@ static int gmc_v9_0_gart_enable(struct amdgpu_device *adev)
 		return -EINVAL;
 	}
 
+	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev))
+		goto skip_pin_bo;
+
 	r = amdgpu_gart_table_vram_pin(adev);
 	if (r)
 		return r;
 
+skip_pin_bo:
 	r = adev->gfxhub.funcs->gart_enable(adev);
 	if (r)
 		return r;
-- 
2.34.1


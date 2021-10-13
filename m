Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B881242B138
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhJMA5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236540AbhJMA5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40BEC6101B;
        Wed, 13 Oct 2021 00:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086506;
        bh=nPUBG676J9Znr9W6jp04IEWLym/zHZkvaMHVdXTr7+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoRjlU7bx8rXaDzPed8hQ5eEbKPzcZp+WkL0NDx2L/lER3O1bwTCBJBYQN6gmTycL
         GfalS/wtOQGmQFSlyR0Bqg3h4u7v+UHmD2rFOlX9+2Juoy5hFX3wMeKhBXZcWjvdcU
         q3Vtwi7PbFHeW5KJIVG+FiMrzziWYGBbOLPPI0F93t7/CMYSAoNuBXNg1l03VuKK+J
         2nddiGsr1ASskBXKQcYu06J+A3BdP6Qpp7gtEIpU9LdzKupwRYxtN98+tH6Sft9gz3
         +l+GA2J5lZYDILvBZmdWYGkhRU5kvZazHtQqws9yIzBlluyC1hwMutDCT968xuEaR1
         keKAbVDOOB4zQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zhang <yifan1.zhang@amd.com>, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        evan.quan@amd.com, Hawking.Zhang@amd.com, ray.huang@amd.com,
        shaoyun.liu@amd.com, andrey.grodzovsky@amd.com,
        Jack.Zhang1@amd.com, lijo.lazar@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 09/17] drm/amdgpu: init iommu after amdkfd device init
Date:   Tue, 12 Oct 2021 20:54:33 -0400
Message-Id: <20211013005441.699846-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 714d9e4574d54596973ee3b0624ee4a16264d700 ]

This patch is to fix clinfo failure in Raven/Picasso:

Number of platforms: 1
  Platform Profile: FULL_PROFILE
  Platform Version: OpenCL 2.2 AMD-APP (3364.0)
  Platform Name: AMD Accelerated Parallel Processing
  Platform Vendor: Advanced Micro Devices, Inc.
  Platform Extensions: cl_khr_icd cl_amd_event_callback

  Platform Name: AMD Accelerated Parallel Processing Number of devices: 0

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Tested-by: James Zhu <James.Zhu@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d3247a5cceb4..580db14fd722 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2342,10 +2342,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (r)
 		goto init_failed;
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -2384,6 +2380,10 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (!adev->gmc.xgmi.pending_reset)
 		amdgpu_amdkfd_device_init(adev);
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:
-- 
2.33.0


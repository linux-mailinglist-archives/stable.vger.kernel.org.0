Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431A92F3118
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403884AbhALM5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403837AbhALM5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA1023333;
        Tue, 12 Jan 2021 12:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456190;
        bh=Y0s+VaqXDL8DvN9FddpkCa98zsrkK/PYMkRYZ9XQmC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9D8yXXLC1WGl9HYMiyKmu6zc3X5XmKfMOD+ozH7/HTiyII1uP//ST6o/5XxJAR0m
         BbcjQqtsisAnGdwX8azRVdxAhmEfF4x1xUg1R1bkmubiI+U81oOXbi4xlRGHET4JlM
         ha5Lr9b7kwQ4rs+U4exNzPDijbQmrwjrKMWDN9A4a2cIm+EGyNg0CiSFkcyzkHeCWl
         jJyB4sWQ2m3LS7IGpalFPmic2EDI9WWAnbnQWT5+/livYkK1unPEdA3RSzAgcMlFwU
         +AiNLGQy8DZE7r+96cjncfsfdOjeWK9gpwhLcxnDnIpGdJu2NtN/WnaWclAjnSYsCK
         JzxuN07nK5YSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Li <Dennis.Li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 42/51] drm/amdgpu: fix a GPU hang issue when remove device
Date:   Tue, 12 Jan 2021 07:55:24 -0500
Message-Id: <20210112125534.70280-42-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Li <Dennis.Li@amd.com>

[ Upstream commit 88e21af1b3f887d217f2fb14fc7e7d3cd87ebf57 ]

When GFXOFF is enabled and GPU is idle, driver will fail to access some
registers. Therefore change to disable power gating before all access
registers with MMIO.

Dmesg log is as following:
amdgpu 0000:03:00.0: amdgpu: amdgpu: finishing device.
amdgpu: cp queue pipe 4 queue 0 preemption failed
amdgpu 0000:03:00.0: amdgpu: failed to write reg 2890 wait reg 28a2
amdgpu 0000:03:00.0: amdgpu: failed to write reg 1a6f4 wait reg 1a706
amdgpu 0000:03:00.0: amdgpu: failed to write reg 2890 wait reg 28a2
amdgpu 0000:03:00.0: amdgpu: failed to write reg 1a6f4 wait reg 1a706

Signed-off-by: Dennis Li <Dennis.Li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 026789b466db9..30c9d60c9b515 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2524,11 +2524,11 @@ static int amdgpu_device_ip_fini(struct amdgpu_device *adev)
 	if (adev->gmc.xgmi.num_physical_nodes > 1)
 		amdgpu_xgmi_remove_device(adev);
 
-	amdgpu_amdkfd_device_fini(adev);
-
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
+	amdgpu_amdkfd_device_fini(adev);
+
 	/* need to disable SMC first */
 	for (i = 0; i < adev->num_ip_blocks; i++) {
 		if (!adev->ip_blocks[i].status.hw)
-- 
2.27.0


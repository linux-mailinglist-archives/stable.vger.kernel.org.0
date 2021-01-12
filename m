Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7F62F30B0
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbhALNJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404205AbhALM6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6311A23136;
        Tue, 12 Jan 2021 12:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456238;
        bh=KVEfEUWOLEQmT7+CQxXQJ3XRAZoF8/ksCh1myHnPp1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNq/x0gx3q5FhtdvXASqolw4zJEHmNR+uWzL1cH+3BUjubDh8ZXr+JZRKWFOta1SN
         S8nN5SaMjJpy82EI1xPQ1gSu4hE2JJIkZ9oMJOqo9pS4aTUUFGi7dY+0X3YrMgSdIH
         /+OVjJzWSDKcUsSAZvt2WZLsVmlj3pjXv+y8bD4HlN68gxEYjWkzpdI69v034C0Kr0
         FLKti5sJx2UnRVjp5ux+9GmejxvbFHGhtPglncrf5wc/d5QY4o4nlBGHmQx3VtfbNy
         lPnDEaVHLOp+Rt0Q+XzLS4E/gpKcG7aSCm9IrAL5OFkD4sPaSZWpTZjjHGXaJIY5hA
         uuWlYF93VTHuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Li <Dennis.Li@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 24/28] drm/amdgpu: fix a GPU hang issue when remove device
Date:   Tue, 12 Jan 2021 07:56:40 -0500
Message-Id: <20210112125645.70739-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
index 29141bff4b572..3b3fc9a426e91 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2057,11 +2057,11 @@ static int amdgpu_device_ip_fini(struct amdgpu_device *adev)
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBDF3F548C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhHXAze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233897AbhHXAzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3921E6141B;
        Tue, 24 Aug 2021 00:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766458;
        bh=mSWfygBrAcGHiHALaFXdKb5REgofNVKcLCC4LuP8yU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuxrFJV4/tInBcFQRFGzFXU0b6OiD9qYsvy8vFjvHiPJ8Ih/9rZfSKI8IQGd+tm85
         dzvMAoiUQqudrTSKqDtI7HOJcSQ2OTwzW+76OxAMedMvJwujzcUMPtwLbVnTZVPAQJ
         eqT8L+jd4bL4NErMOGzjWdTgdKek4ZralAzlt9LFG8WzphUVmHXtaVtYYYr6Ik7ess
         +dMB4HHTNR+xuB8NisRlpL8FMLupfCGmojmmP0TwrI8qx9qWnR76wQiQjW+WI8IB+y
         loGVt2X5vjlRMLw80B5TLki7eSUJx7LXdO218PS9yByaSKvHPU1AG2zzXaksgKN26E
         z5MS+wofOMN5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 16/26] drm/amd/pm: change the workload type for some cards
Date:   Mon, 23 Aug 2021 20:53:46 -0400
Message-Id: <20210824005356.630888-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 93c5701b00d50d192ce2247cb10d6c0b3fe25cd8 ]

change the workload type for some cards as it is needed.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index f5a32654cde7..cc6f19a48dea 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5123,6 +5123,13 @@ static int vega10_get_power_profile_mode(struct pp_hwmgr *hwmgr, char *buf)
 	return size;
 }
 
+static bool vega10_get_power_profile_mode_quirks(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = hwmgr->adev;
+
+	return (adev->pdev->device == 0x6860);
+}
+
 static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, uint32_t size)
 {
 	struct vega10_hwmgr *data = hwmgr->backend;
@@ -5159,9 +5166,15 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 	}
 
 out:
-	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
+	if (vega10_get_power_profile_mode_quirks(hwmgr))
+		smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
 						1 << power_profile_mode,
 						NULL);
+	else
+		smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
+						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
+						NULL);
+
 	hwmgr->power_profile_mode = power_profile_mode;
 
 	return 0;
-- 
2.30.2


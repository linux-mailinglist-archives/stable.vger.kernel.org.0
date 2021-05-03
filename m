Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B29371A4B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhECQj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231840AbhECQiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8620661132;
        Mon,  3 May 2021 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059794;
        bh=GXgwS477ZFIFyxILoCsoeJjdFko0lrRngwkhvWY9Pss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alHoFfLq9+Iwmmi6bsyvvGQEHo5gy1Un6HJ16eZfoP4AJAgpMe1MMXAHR71n2V5Hq
         DVe+AFEdW+DElOEyzSO41owrfv0tYyYIaWFXXpfKg/dJXyjYQXmD0K17mS0B9cvOPw
         48dtawpYHrkHvDn8XFwS0lRIH9JKBUo/LRzsRsH6uQ9+qD7XcmuGGnIbx9I/7KVY6i
         y++LfzD9TqOm0uGeq8X2Shj0OcAiXHPlF5bLbw9HJpFwXP0II6NxvXBqltyjYzW4eJ
         AOSOG5ExWxNzX4bdXHcoZ3cSdesbZ6YXYSTVkrACsg6q1MStf0JL07sBAMGrU+Nan0
         ejsaUzGP13mbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shaoyunl <shaoyun.liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 052/134] drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f
Date:   Mon,  3 May 2021 12:33:51 -0400
Message-Id: <20210503163513.2851510-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: shaoyunl <shaoyun.liu@amd.com>

[ Upstream commit c8941550aa66b2a90f4b32c45d59e8571e33336e ]

This recent change introduce SDMA interrupt info printing with irq->process function.
These functions do not require a set function to enable/disable the irq

Signed-off-by: shaoyunl <shaoyun.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index afbbec82a289..9be945d8e72f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -535,7 +535,7 @@ void amdgpu_irq_gpu_reset_resume_helper(struct amdgpu_device *adev)
 		for (j = 0; j < AMDGPU_MAX_IRQ_SRC_ID; ++j) {
 			struct amdgpu_irq_src *src = adev->irq.client[i].sources[j];
 
-			if (!src)
+			if (!src || !src->funcs || !src->funcs->set)
 				continue;
 			for (k = 0; k < src->num_types; k++)
 				amdgpu_irq_update(adev, src, k);
-- 
2.30.2


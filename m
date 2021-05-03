Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A036371C87
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhECQxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232199AbhECQvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E0761931;
        Mon,  3 May 2021 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060090;
        bh=DMPfJLhMJ1dY0RoG7NKxrjmH+LGy7NrejNLEePArhVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uu8UJ7lkVImHfNMdaiCpHo2vu0hLi97xjvYdGWrc1Is4b8sGLJMvJsaZT3ckjfi0N
         hB+evXIQ6VHFWkv1TP81lVmw1I6zX+Ymu96IiZdw+YccOxajTtEqGWMiqh0UGY5x9v
         a+Tk6spmGOsuTajLRPUAlBll6O7Kkwo1mxp5i2s+b04FPNJSvnbcCi2JUrxYXmue71
         FeMmc2eeowcMSlwp+qR/Uc63F1lJ7m3dk8sVC4tj0/ZI0l/sh/kJ74UxJ7d0R3Pxtb
         zp0EmoEwAHgu2Q3hF1RDbI5t+3ayhl2OPXbxuVJgkGb9E8x2rCsUuJgi1lhvtMm55C
         QpO1hztNrQa4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shaoyunl <shaoyun.liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 14/35] drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f
Date:   Mon,  3 May 2021 12:40:48 -0400
Message-Id: <20210503164109.2853838-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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
index 1abf5b5bac9e..18402a6ba8fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -447,7 +447,7 @@ void amdgpu_irq_gpu_reset_resume_helper(struct amdgpu_device *adev)
 		for (j = 0; j < AMDGPU_MAX_IRQ_SRC_ID; ++j) {
 			struct amdgpu_irq_src *src = adev->irq.client[i].sources[j];
 
-			if (!src)
+			if (!src || !src->funcs || !src->funcs->set)
 				continue;
 			for (k = 0; k < src->num_types; k++)
 				amdgpu_irq_update(adev, src, k);
-- 
2.30.2


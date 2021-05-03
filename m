Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E482371B50
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhECQpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232750AbhECQmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EBD0613D8;
        Mon,  3 May 2021 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059887;
        bh=oNXefUNI6BSL8PDpVsrn6TLhE4EQ2tji/ziN2mPER+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6cXIugnUpMEufLVOSO4FcwB/8fOi4h3CfDR8Kxo11/jElPOxHBY4Tk50YhthCnej
         r+v3SUSDxnyxA/pTqCRNSM5tQCyysG5aLq5sk4kXndHaOMpSSts7J0SZTLOmqmaA6M
         qo6Ga4B3VgkUZFTQzlo1mrRpT5aIlb8pb/cKM8jCpLd58LJ85Dog4ptY/+F1bXuuo0
         kW0tQ7Ge5P/TgXVs3MoZalEC0jzOvEeaVVlr9OOpE/FEjPXgX/ZEEsCR2rf0FaPkKv
         gGjdRlwyFeVkhYrwx8Ci/lQ2m1rXc0edBW6MkmOi4Z34iRCoznGl5vfy+DNEvR77Q1
         2LCFazeyonvKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shaoyunl <shaoyun.liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 044/115] drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f
Date:   Mon,  3 May 2021 12:35:48 -0400
Message-Id: <20210503163700.2852194-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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
index bea57e8e793f..b535f7c6c61b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -534,7 +534,7 @@ void amdgpu_irq_gpu_reset_resume_helper(struct amdgpu_device *adev)
 		for (j = 0; j < AMDGPU_MAX_IRQ_SRC_ID; ++j) {
 			struct amdgpu_irq_src *src = adev->irq.client[i].sources[j];
 
-			if (!src)
+			if (!src || !src->funcs || !src->funcs->set)
 				continue;
 			for (k = 0; k < src->num_types; k++)
 				amdgpu_irq_update(adev, src, k);
-- 
2.30.2


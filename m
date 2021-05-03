Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13E4371CEA
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhECQ52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234810AbhECQy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6771B6194A;
        Mon,  3 May 2021 16:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060144;
        bh=7phCiXG70k8Vy5fS7iCF8xyE7KMcVO3FDONY75Fz7D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UD5IfwFmGf4CRNQd5YarEq+e1sdP3opGi3TUuMthCGiDg13YYvaSXlFZIM0A/2dmq
         XbkCkhzQlWwhFPeVyaHCnsKSQEReKaYVZX0zr4bu0UuuaTVi/XvMTMZYboneaHGRpE
         rxjShqZcNuTWv7Xu1agiRpbyaVvBXjtw8Gbk/nXMrdEswRNr2POO8nPnmEkV/kIq5c
         Q6xvSjQ6eZuyaNR7T+RLnlUcsR/FPbHhZUNjJ9xqjnNuRqXYP0bEnISy0UGukHKqEc
         pg1X7NTE7g+suYJVUVNDQQxboXGlJwVCfIoUsgJcnDZsBJF/FrgNtkdLGTYT8xc8eo
         NZYwqwOyY3UOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shaoyunl <shaoyun.liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 13/31] drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f
Date:   Mon,  3 May 2021 12:41:46 -0400
Message-Id: <20210503164204.2854178-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
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
index 538e5f27d120..fb9361590754 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -437,7 +437,7 @@ void amdgpu_irq_gpu_reset_resume_helper(struct amdgpu_device *adev)
 		for (j = 0; j < AMDGPU_MAX_IRQ_SRC_ID; ++j) {
 			struct amdgpu_irq_src *src = adev->irq.client[i].sources[j];
 
-			if (!src)
+			if (!src || !src->funcs || !src->funcs->set)
 				continue;
 			for (k = 0; k < src->num_types; k++)
 				amdgpu_irq_update(adev, src, k);
-- 
2.30.2


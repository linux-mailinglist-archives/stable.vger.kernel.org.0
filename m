Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71E233E426
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhCQA6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhCQA5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A21B64FDF;
        Wed, 17 Mar 2021 00:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942664;
        bh=6tv68FGLqvBJOuuHzZh4lgqMBl8erwIjzi2VaN4TVs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyqF5KDzS9lIbBCon3gSLGDQ5hglL6pwUSZpEqoDMIXjeLVMnhnMv92c6W8L8yxJF
         XMH/2zlAp37U/qslVQjU2E9A/7aC7WTXcvVnrwnMJl0tFAzNjsNRlU2ju5LQ1u+N45
         tnUTBYdNIxA1yB+/bM5N31IDQPFjiWj2mqTldbUIHdYXSh1xkyQDtd6DMdAxEF/CrX
         K0DuF5mWyeIEY8yd57b+QRNXEhGR51HDL54CkW9+F0unu312XRyIqp1O4OEVk+Dls5
         SLnzlxNVL6v6tAXROIxNxxaiXCWjEgRm1wI8hEmk3P4mSZ19VasprKZ/KMFxISmeQz
         0MYG9x9sbP90w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 41/54] drm/amdgpu: fb BO should be ttm_bo_type_device
Date:   Tue, 16 Mar 2021 20:56:40 -0400
Message-Id: <20210317005654.724862-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit 521f04f9e3ffc73ef96c776035f8a0a31b4cdd81 ]

FB BO should not be ttm_bo_type_kernel type and
amdgpufb_create_pinned_object() pins the FB BO anyway.

Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index e2c2eb45a793..1ea8af48ae2f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -146,7 +146,7 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 	size = mode_cmd->pitches[0] * height;
 	aligned_size = ALIGN(size, PAGE_SIZE);
 	ret = amdgpu_gem_object_create(adev, aligned_size, 0, domain, flags,
-				       ttm_bo_type_kernel, NULL, &gobj);
+				       ttm_bo_type_device, NULL, &gobj);
 	if (ret) {
 		pr_err("failed to allocate framebuffer (%d)\n", aligned_size);
 		return -ENOMEM;
-- 
2.30.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F8934C7F4
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhC2IS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232764AbhC2IST (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2407F61932;
        Mon, 29 Mar 2021 08:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005892;
        bh=6tv68FGLqvBJOuuHzZh4lgqMBl8erwIjzi2VaN4TVs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf357h9+n2nXrPTTTI8Ka6NzHQNq13LZPC3ynqtH1G2xU5x0BcX5oUn+sXmo19QxA
         1ne1CmyTFZKUuJcXFeAB34o4DNAwjYViii8H0TBrY+bCS408ePFELqkAVKEIdYNqBZ
         tp1EQmbwnBsaYE1sYO94poJTXXREzerOzoF8Rg4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/221] drm/amdgpu: fb BO should be ttm_bo_type_device
Date:   Mon, 29 Mar 2021 09:56:14 +0200
Message-Id: <20210329075630.615559768@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




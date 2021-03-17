Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24EC33E3AD
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhCQA5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230465AbhCQA4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE5E64FA7;
        Wed, 17 Mar 2021 00:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942594;
        bh=M3KYt+TlfZnvsm8VNCnDn0ffL3wX6K17cGMUOCTW83g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEv5JllwrbL/PJKLPq0SlOo8SCsCkCh3c7qgRFd0N5830VCe+JTVypH9vrwd1pZ5I
         AFN+wShdlMTFjB6k5v1lBCD4MwlgJZ/aAA/+JB3uxPOfezxFh5kIY/1qvp/pH0dRUF
         txczbJSgX5uHozTyoZHJ6TLX6U+7EtCwpsqj5Nkndo5nRxEgYQo0X47oAugAU0UytO
         H61yOf7i4gq4+7X+RUAhdR9a8dQzpJ0Epv5xLn1YLZeEl5KS/N1msXGIUn2TQud7PP
         Llwsv+4GlHxB/3P4FRWp7/R7F5pjA8MlIJp4YRqOJr8HjmeAurglG/Dn96wIFSzfQt
         iY5+fED2q1Cvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 47/61] drm/amdgpu: fb BO should be ttm_bo_type_device
Date:   Tue, 16 Mar 2021 20:55:21 -0400
Message-Id: <20210317005536.724046-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index 0bf7d36c6686..5b716404eee1 100644
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


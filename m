Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F811197B3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfLJVes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730094AbfLJVer (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B91207FF;
        Tue, 10 Dec 2019 21:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013686;
        bh=b/KjiDjETamHW9Y/8FNozm/dGxjife84uORnLJ/QAO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u405EaP1BZTq8noYYF8BaS8zTwV42211rlTiRHlfmyEt2mUf8xd4eWv+y+w/Cf3hd
         CRDqY441KJpIMNd4WLzpBIwtmBliv61QDz9a0V1OxFS7eEm6IVhr6jQKGUCWtyQAl8
         mH9zNFSRfZs0xfcS8KGdVC/C6Q9yPMIzVMhoVc1c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 119/177] drm/amdgpu: fix potential double drop fence reference
Date:   Tue, 10 Dec 2019 16:31:23 -0500
Message-Id: <20191210213221.11921-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 946ab8db6953535a3a88c957db8328beacdfed9d ]

The object fence is not set to NULL after its reference is dropped. As a
result, its reference may be dropped again if error occurs after that,
which may lead to a use after free bug. To avoid the issue, fence is
explicitly set to NULL after dropping its reference.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
index 8904e62dca7ae..41d3142ef3cf0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_test.c
@@ -138,6 +138,7 @@ static void amdgpu_do_test_moves(struct amdgpu_device *adev)
 		}
 
 		dma_fence_put(fence);
+		fence = NULL;
 
 		r = amdgpu_bo_kmap(vram_obj, &vram_map);
 		if (r) {
@@ -183,6 +184,7 @@ static void amdgpu_do_test_moves(struct amdgpu_device *adev)
 		}
 
 		dma_fence_put(fence);
+		fence = NULL;
 
 		r = amdgpu_bo_kmap(gtt_obj[i], &gtt_map);
 		if (r) {
-- 
2.20.1


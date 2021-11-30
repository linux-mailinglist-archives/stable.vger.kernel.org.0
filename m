Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117224637DA
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhK3O4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242722AbhK3Oyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A213AC0619DF;
        Tue, 30 Nov 2021 06:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4870EB81A25;
        Tue, 30 Nov 2021 14:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3169C53FC7;
        Tue, 30 Nov 2021 14:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283779;
        bh=UWaPvN5oZyn4yvPCKhSxfQUZAcXLn6ZBTjeLOgP5BQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aF8i41X2dMXw3T2J1ufEf37t8yQ/qSdeUerzrfCBT6KVbCBztyFSGaTxuFfHSHPKZ
         360379Ms0GjdzJNJ0wkqRXhaO4CnJDokRu/Vyp1flrxe3YI3YKMYebVaJkHGPD7Tse
         aaC60pv2nVeU0yhUlDOrco13TU4HcN754Vq5btjCtXYCpBtAvt+AaPQD+Azc4xPYs4
         0DlXMnKQVAjbFW6zGACbyTXFlkOqG2twAE5OFAwa4nfXVY3rnbDUG1fPuDXOhvaH4W
         Z6Asua+2r8Uq+ckBxq7vks6sRKPuwiLpTIO3pV5C8NSa5b2rGDKUrIKpTh8X6gsy45
         pHYctUSmoeqQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 56/68] drm/amdgpu: Fix double free of dmabuf
Date:   Tue, 30 Nov 2021 09:46:52 -0500
Message-Id: <20211130144707.944580-56-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit 4eb6bb649fe041472ddd00f94870c0b86ef49d34 ]

amdgpu_amdkfd_gpuvm_free_memory_of_gpu drop dmabuf reference increased in
amdgpu_gem_prime_export.
amdgpu_bo_destroy drop dmabuf reference increased in
amdgpu_gem_prime_import.

So remove this extra dma_buf_put to avoid double free.

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Tested-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index cdf46bd0d8d5b..3862470c7f1eb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -644,12 +644,6 @@ kfd_mem_attach_dmabuf(struct amdgpu_device *adev, struct kgd_mem *mem,
 	if (IS_ERR(gobj))
 		return PTR_ERR(gobj);
 
-	/* Import takes an extra reference on the dmabuf. Drop it now to
-	 * avoid leaking it. We only need the one reference in
-	 * kgd_mem->dmabuf.
-	 */
-	dma_buf_put(mem->dmabuf);
-
 	*bo = gem_to_amdgpu_bo(gobj);
 	(*bo)->flags |= AMDGPU_GEM_CREATE_PREEMPTIBLE;
 	(*bo)->parent = amdgpu_bo_ref(mem->bo);
-- 
2.33.0


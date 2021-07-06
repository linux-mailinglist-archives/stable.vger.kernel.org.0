Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F983BD134
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhGFLij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236538AbhGFLfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F3361D3F;
        Tue,  6 Jul 2021 11:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570621;
        bh=QY8pEEkS5Zjx/I8JGlZYIXkWO2XqkalzvJBoNKtlX48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ru05MAC4BUgKv/NrDpf6c5dCDlzAso0tupwoAWgpi3xL2sBKIIRVfKgAQEGHkP2Cm
         a9V1JzUCWyBrFA/eLZ477TpFJbJBqbcrpEjntKJFg73AGlmxsbgddIgHhVNFXppYId
         AK+6GW2xxIClUXDW0Lxx+hPIXjU6XEUkHtgQV22poCe/Z75rjxhfY6wN4axdeI4oq3
         um6hKLVvgLh04aHEXFv1txNRfaTc2eg4GQXI5vdGGbetq2bNIlatD3zSZ5ehRjylP0
         hjQrYOmReDjedlddfbeQGfS7QWyb+1pK468PWpzEOMuqShopfnfn6cq2NyPiaGEdxL
         +C35xBb7ATeFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 075/137] drm/amdkfd: use allowed domain for vmbo validation
Date:   Tue,  6 Jul 2021 07:21:01 -0400
Message-Id: <20210706112203.2062605-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit bc05716d4fdd065013633602c5960a2bf1511b9c ]

Fixes handling when page tables are in system memory.

v3: remove struct amdgpu_vm_parser.
v2: remove unwanted variable.
    change amdgpu_amdkfd_validate instead of amdgpu_amdkfd_bo_validate.

Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 21 ++++---------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 5da487b64a66..26f8a2138377 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -48,12 +48,6 @@ static struct {
 	spinlock_t mem_limit_lock;
 } kfd_mem_limit;
 
-/* Struct used for amdgpu_amdkfd_bo_validate */
-struct amdgpu_vm_parser {
-	uint32_t        domain;
-	bool            wait;
-};
-
 static const char * const domain_bit_to_string[] = {
 		"CPU",
 		"GTT",
@@ -337,11 +331,9 @@ static int amdgpu_amdkfd_bo_validate(struct amdgpu_bo *bo, uint32_t domain,
 	return ret;
 }
 
-static int amdgpu_amdkfd_validate(void *param, struct amdgpu_bo *bo)
+static int amdgpu_amdkfd_validate_vm_bo(void *_unused, struct amdgpu_bo *bo)
 {
-	struct amdgpu_vm_parser *p = param;
-
-	return amdgpu_amdkfd_bo_validate(bo, p->domain, p->wait);
+	return amdgpu_amdkfd_bo_validate(bo, bo->allowed_domains, false);
 }
 
 /* vm_validate_pt_pd_bos - Validate page table and directory BOs
@@ -355,20 +347,15 @@ static int vm_validate_pt_pd_bos(struct amdgpu_vm *vm)
 {
 	struct amdgpu_bo *pd = vm->root.base.bo;
 	struct amdgpu_device *adev = amdgpu_ttm_adev(pd->tbo.bdev);
-	struct amdgpu_vm_parser param;
 	int ret;
 
-	param.domain = AMDGPU_GEM_DOMAIN_VRAM;
-	param.wait = false;
-
-	ret = amdgpu_vm_validate_pt_bos(adev, vm, amdgpu_amdkfd_validate,
-					&param);
+	ret = amdgpu_vm_validate_pt_bos(adev, vm, amdgpu_amdkfd_validate_vm_bo, NULL);
 	if (ret) {
 		pr_err("failed to validate PT BOs\n");
 		return ret;
 	}
 
-	ret = amdgpu_amdkfd_validate(&param, pd);
+	ret = amdgpu_amdkfd_validate_vm_bo(NULL, pd);
 	if (ret) {
 		pr_err("failed to validate PD\n");
 		return ret;
-- 
2.30.2


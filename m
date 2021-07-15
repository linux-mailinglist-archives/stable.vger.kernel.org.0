Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626C83CAA4A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbhGOTMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243865AbhGOTKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17DE613ED;
        Thu, 15 Jul 2021 19:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376019;
        bh=8UCjUJXA1kDEPzF5QxBKUvj3rBGngKFUqSYqj9bQQd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ic+Qgb5oke8igluXu9g6qczraP+6xMOyi1lG8igB4zj+IhycjtqRvJLMCceqDl7aj
         EKAzIBRsvPiYVVX4DCUisPx7m8mY5OV/u/XzB3tLnZlTTAR13uZnTXbzLhYRFsVaEu
         9Ve9ypmt2wTacUvCSE8I7S0MHbfQuoNEYt7V8Nzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 092/266] drm/amdkfd: use allowed domain for vmbo validation
Date:   Thu, 15 Jul 2021 20:37:27 +0200
Message-Id: <20210715182630.390479387@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7d4118c8128a..5e69b5b50a19 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -50,12 +50,6 @@ static struct {
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
@@ -346,11 +340,9 @@ validate_fail:
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
@@ -364,20 +356,15 @@ static int vm_validate_pt_pd_bos(struct amdgpu_vm *vm)
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80282795CA
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbfG2TqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390098AbfG2TqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB9B21655;
        Mon, 29 Jul 2019 19:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429569;
        bh=MvNMOkezmcVB2765TDn/hRcjd4x9ipr+ymUwktuan7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYHxO5pLXu+jF4PbAihcWeNFcZHK37rvDYZbX69KoN+22fET0dkPDb6uI809engP4
         JcWoyLwKD5bO+DsOY16LTP6N34zpm3rN2rCkgc7T5BFS+YGxVgrVMaRdd3umyCRcNH
         VaLA+5QBetwx1MZeQMYHCchMHtiF4KvBhDvadHms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 025/215] drm/amdgpu: Reserve shared fence for eviction fence
Date:   Mon, 29 Jul 2019 21:20:21 +0200
Message-Id: <20190729190744.332250061@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dd68722c427d5b33420dce0ed0c44b4881e0a416 ]

Need to reserve space for the shared eviction fence when initializing
a KFD VM.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index a6e5184d436c..4b192e0ce92f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -896,6 +896,9 @@ static int init_kfd_vm(struct amdgpu_vm *vm, void **process_info,
 				  AMDGPU_FENCE_OWNER_KFD, false);
 	if (ret)
 		goto wait_pd_fail;
+	ret = reservation_object_reserve_shared(vm->root.base.bo->tbo.resv, 1);
+	if (ret)
+		goto reserve_shared_fail;
 	amdgpu_bo_fence(vm->root.base.bo,
 			&vm->process_info->eviction_fence->base, true);
 	amdgpu_bo_unreserve(vm->root.base.bo);
@@ -909,6 +912,7 @@ static int init_kfd_vm(struct amdgpu_vm *vm, void **process_info,
 
 	return 0;
 
+reserve_shared_fail:
 wait_pd_fail:
 validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.base.bo);
-- 
2.20.1




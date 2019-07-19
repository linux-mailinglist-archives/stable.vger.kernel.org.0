Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974AE6D9D6
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfGSD5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbfGSD5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA35A2082E;
        Fri, 19 Jul 2019 03:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508667;
        bh=zXuf2nbZCij5MP1OdNwHCR3+fO1/OY+Y4ixkT1Yzb0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lpa+A5PqUfVvmpRc4eJAQOjonsdRWvvlVWHry1X3/Sup3s+4qc0FKU4/iMfbZF1q3
         fv1tGprY4O5IgRmWjabC/TIJeAd9/4/MX0xW16lvwTg+B1OpGyKtzN4HtrjahTLOab
         TJCvr3Jj8MK8oOeGr1v8cy23OYpvr7JKzEMeKpnM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 023/171] drm/amdgpu: Reserve shared fence for eviction fence
Date:   Thu, 18 Jul 2019 23:54:14 -0400
Message-Id: <20190719035643.14300-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

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


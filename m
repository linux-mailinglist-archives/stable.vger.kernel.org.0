Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2A138326B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbhEQOrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241649AbhEQOpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AEAE61964;
        Mon, 17 May 2021 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261278;
        bh=Uw6l+ucBO4R4GPZUsWaXESYE7KgniFrGMIuiXeM1AwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rShet6tie92pN3vMu3oKpRkhdQs5rsSg2OmLXNxKysHoYVAyTbMoAp8RbtNNhnr+h
         ymtx4VMPEZtiQivVZcm4NQJWRWoZ6M9MXInwC7CyAysXO07So0ijF2hS96/kEDMrNv
         Y03Trhng175rK1U8YxA12usOqQEybNbLt9sno0JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinzhou Su <Jinzhou.Su@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 094/329] drm/amdgpu: Add mem sync flag for IB allocated by SA
Date:   Mon, 17 May 2021 16:00:05 +0200
Message-Id: <20210517140305.300156973@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinzhou Su <Jinzhou.Su@amd.com>

[ Upstream commit 5c88e3b86a88f14efa0a3ddd28641c6ff49fb9c4 ]

The buffer of SA bo will be used by many cases. So it's better
to invalidate the cache of indirect buffer allocated by SA before
commit the IB.

Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
index 024d0a563a65..f41764cee690 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -77,6 +77,8 @@ int amdgpu_ib_get(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		}
 
 		ib->ptr = amdgpu_sa_bo_cpu_addr(ib->sa_bo);
+		/* flush the cache before commit the IB */
+		ib->flags = AMDGPU_IB_FLAG_EMIT_MEM_SYNC;
 
 		if (!vm)
 			ib->gpu_addr = amdgpu_sa_bo_gpu_addr(ib->sa_bo);
-- 
2.30.2




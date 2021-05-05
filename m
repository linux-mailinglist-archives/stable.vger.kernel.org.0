Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEDC3741A4
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhEEQkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234972AbhEEQiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:38:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 733AF61464;
        Wed,  5 May 2021 16:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232422;
        bh=DiHdd7yDzIyuLxlC1zOMaexv0xacGPCFgIoI9D78zEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJSCZBwcINN5pLPZHOL0t7udHzeIbc4GzVMdQOrJ9OmFRmP4XkIK1rwCnX4AX3JIT
         AVFjtst9oaXqUfnPVPK0d5WDwv5hcM4R/TP+vV9zCGJM66NIVlIQ6K07f+eRfhcbXS
         4er5fwNZkswBCLZfCvkTyegwSgqoAMYKtkNLCWJ8UqBrvl25rHn6N1Ot94FTZVOz1D
         /vW1dh3CFJc0KQ2mIdhgf4AuVJM8grGK7LjjAdQIccr6z8ykh0LKMJ2Ceu5GTgP/Jk
         /AqEvu3N0Ezwj4weIJUT4gKI7Ju6/VXa6coAbMFMBS2d6TKJ/HpuiAG6S2rCABDxgH
         esq79UrPvDX4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jinzhou Su <Jinzhou.Su@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 097/116] drm/amdgpu: Add mem sync flag for IB allocated by SA
Date:   Wed,  5 May 2021 12:31:05 -0400
Message-Id: <20210505163125.3460440-97-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7645223ea0ef..97c11aa47ad0 100644
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


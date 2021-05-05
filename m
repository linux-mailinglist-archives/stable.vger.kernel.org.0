Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1820D374473
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhEEQ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234702AbhEEQxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0025A615FF;
        Wed,  5 May 2021 16:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232709;
        bh=gYSpMSpcemkS+AZtk7k2jROkybl1/SgYrbZvQokyg7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZpf38lq/JMshitSOPAglShb7u8Dmi6IPH1q/GyrViG+qknPcRCfPie4jlr9ACzOR
         CSV1lYuA7LqVEW3wR87weRiKazsLMeNXSeKiHNz0GXb0+yNZQQMtbdXS34PE2+n13L
         6t4bcAbduXJvsbbCsXTYV6yNtfwX+kTTT325DmhraW0sRt2UCakfq6XLVvHFHOcnCO
         lclPNc9Ao3PLxZBriqccTANIO8L6i/rpYAivQOpni0ZP9wAFjcQ0nqbG8CARG+6/Cs
         KYxnzcOA7rRYADPx8tI5gIMhI3Mv0fgTz8TMU29LUyJBXs6T/v7tw2ar/nAGa4DKuW
         H/g0TMWgb2E/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jinzhou Su <Jinzhou.Su@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 68/85] drm/amdgpu: Add mem sync flag for IB allocated by SA
Date:   Wed,  5 May 2021 12:36:31 -0400
Message-Id: <20210505163648.3462507-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 2f53fa0ae9a6..28f20f0b722f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -75,6 +75,8 @@ int amdgpu_ib_get(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		}
 
 		ib->ptr = amdgpu_sa_bo_cpu_addr(ib->sa_bo);
+		/* flush the cache before commit the IB */
+		ib->flags = AMDGPU_IB_FLAG_EMIT_MEM_SYNC;
 
 		if (!vm)
 			ib->gpu_addr = amdgpu_sa_bo_gpu_addr(ib->sa_bo);
-- 
2.30.2


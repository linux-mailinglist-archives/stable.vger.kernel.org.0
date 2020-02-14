Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E7015EA51
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392328AbgBNRMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:12:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403833AbgBNQNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671C8246BC;
        Fri, 14 Feb 2020 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696782;
        bh=ClEDbmbI3v0sG4VJ6KX0ZBm8yRrAE1PhvgMQRlleNyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dl9/60YFr7iHHmCI2+U1qCmMpdszqb1S3mrKkggY67BB9M9wPBYbLms/YOpkcOh4m
         ffRP+CdJgR4EGPmvC2VfJ4TIqxB0j0hk6LJXUyj0DfcdircZKslcdXUaoX27XPrvf5
         0jNxf5jNr1/Hxmb1ifrgu7jdusZAE0INU+E1gtCA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 058/252] drm/amdgpu: remove set but not used variable 'mc_shared_chmap'
Date:   Fri, 14 Feb 2020 11:08:33 -0500
Message-Id: <20200214161147.15842-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

[ Upstream commit e98042db2cb8d0b728cd76e05b9c2e1c84b7f72b ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c: In function
‘gfx_v8_0_gpu_early_init’:
drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c:1713:6: warning: variable
‘mc_shared_chmap’ set but not used [-Wunused-but-set-variable]

Fixes: 0bde3a95eaa9 ("drm/amdgpu: split gfx8 gpu init into sw and hw parts")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index e1cb7fa89e4d6..75bc59d0ad371 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1783,7 +1783,7 @@ static int gfx_v8_0_do_edc_gpr_workarounds(struct amdgpu_device *adev)
 static int gfx_v8_0_gpu_early_init(struct amdgpu_device *adev)
 {
 	u32 gb_addr_config;
-	u32 mc_shared_chmap, mc_arb_ramcfg;
+	u32 mc_arb_ramcfg;
 	u32 dimm00_addr_map, dimm01_addr_map, dimm10_addr_map, dimm11_addr_map;
 	u32 tmp;
 	int ret;
@@ -1923,7 +1923,6 @@ static int gfx_v8_0_gpu_early_init(struct amdgpu_device *adev)
 		break;
 	}
 
-	mc_shared_chmap = RREG32(mmMC_SHARED_CHMAP);
 	adev->gfx.config.mc_arb_ramcfg = RREG32(mmMC_ARB_RAMCFG);
 	mc_arb_ramcfg = adev->gfx.config.mc_arb_ramcfg;
 
-- 
2.20.1


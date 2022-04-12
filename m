Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5154FCA53
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbiDLAvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244444AbiDLAvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D710932997;
        Mon, 11 Apr 2022 17:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E67A617D9;
        Tue, 12 Apr 2022 00:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF30C385A3;
        Tue, 12 Apr 2022 00:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724439;
        bh=RO4VURSzGblH2Wzjw1WVHexM3Ohq0iWaMKap2YwaHcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tN2CycUF+CEiAYh1RMBtmduCzWy3mT4e605OHoHsK6y9S+1vtqMY4jSkv/xeExUDO
         rhvC+z1cJ19e+jklCTK57kKQSZh+3Ts4LJTpmZ1xFyZ6LbCfo1Hv1o+jBdMAXFbZFD
         +sQfKaMmVwgvLWE3zISF8HpI32ICOTIZjuQq4dWa8k4VqQCSeH9DDy6KWfbVgbza6A
         FcZaVXb0KTtzu8TIBaHRRlrWJ7d/pMjNK7mq4fIwE9HT4nWZjl2heK/9INKamajarb
         G5TLRoNE/yLatVTAIvJZE0i0XlprJw3AB8KEYSU3b8Yi8rKOsV1R6HNKqS7krSYKW6
         UC0CADNip4AMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, andrey.grodzovsky@amd.com,
        guchun.chen@amd.com, kevin1.wang@amd.com, lang.yu@amd.com,
        tao.zhou1@amd.com, YiPeng.Chai@amd.com, ray.huang@amd.com,
        Yuliang.Shi@amd.com, Jack.Gui@amd.com, PengJu.Zhou@amd.com,
        victor.skvortsov@amd.com, Xiaojian.Du@amd.com,
        lee.jones@linaro.org, nirmoy.das@amd.com, evan.quan@amd.com,
        Felix.Kuehling@amd.com, zhouzongmin@kylinos.cn,
        Hawking.Zhang@amd.com, john.clements@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 05/41] drm/amdgpu/gmc: use PCI BARs for APUs in passthrough
Date:   Mon, 11 Apr 2022 20:46:17 -0400
Message-Id: <20220412004656.350101-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit b818a5d374542ccec73dcfe578a081574029820e ]

If the GPU is passed through to a guest VM, use the PCI
BAR for CPU FB access rather than the physical address of
carve out.  The physical address is not valid in a guest.

v2: Fix HDP handing as suggested by Michel

Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++--
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c     | 2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c      | 5 +++--
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c      | 2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c      | 2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 33026b3eafd2..2f2ae26a8068 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5625,7 +5625,7 @@ void amdgpu_device_flush_hdp(struct amdgpu_device *adev,
 		struct amdgpu_ring *ring)
 {
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU)
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev))
 		return;
 #endif
 	if (adev->gmc.xgmi.connected_to_cpu)
@@ -5641,7 +5641,7 @@ void amdgpu_device_invalidate_hdp(struct amdgpu_device *adev,
 		struct amdgpu_ring *ring)
 {
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU)
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev))
 		return;
 #endif
 	if (adev->gmc.xgmi.connected_to_cpu)
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index 3c01be661014..93a4da4284ed 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -788,7 +788,7 @@ static int gmc_v10_0_mc_init(struct amdgpu_device *adev)
 	adev->gmc.aper_size = pci_resource_len(adev->pdev, 0);
 
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU) {
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev)) {
 		adev->gmc.aper_base = adev->gfxhub.funcs->get_mc_fb_offset(adev);
 		adev->gmc.aper_size = adev->gmc.real_vram_size;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
index 0a50fdaced7e..63c47f61d0df 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c
@@ -381,8 +381,9 @@ static int gmc_v7_0_mc_init(struct amdgpu_device *adev)
 	adev->gmc.aper_size = pci_resource_len(adev->pdev, 0);
 
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU &&
-	    adev->gmc.real_vram_size > adev->gmc.aper_size) {
+	if ((adev->flags & AMD_IS_APU) &&
+	    adev->gmc.real_vram_size > adev->gmc.aper_size &&
+	    !amdgpu_passthrough(adev)) {
 		adev->gmc.aper_base = ((u64)RREG32(mmMC_VM_FB_OFFSET)) << 22;
 		adev->gmc.aper_size = adev->gmc.real_vram_size;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
index 63b890f1e8af..bef9610084f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c
@@ -581,7 +581,7 @@ static int gmc_v8_0_mc_init(struct amdgpu_device *adev)
 	adev->gmc.aper_size = pci_resource_len(adev->pdev, 0);
 
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU) {
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev)) {
 		adev->gmc.aper_base = ((u64)RREG32(mmMC_VM_FB_OFFSET)) << 22;
 		adev->gmc.aper_size = adev->gmc.real_vram_size;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 6dc16ccf6c81..0e731016921b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1387,7 +1387,7 @@ static int gmc_v9_0_mc_init(struct amdgpu_device *adev)
 	 */
 
 	/* check whether both host-gpu and gpu-gpu xgmi links exist */
-	if ((adev->flags & AMD_IS_APU) ||
+	if (((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev)) ||
 	    (adev->gmc.xgmi.supported &&
 	     adev->gmc.xgmi.connected_to_cpu)) {
 		adev->gmc.aper_base =
-- 
2.35.1


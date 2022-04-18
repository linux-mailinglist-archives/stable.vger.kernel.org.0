Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A39450511E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiDRMb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbiDRMa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:30:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C6C26D2;
        Mon, 18 Apr 2022 05:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7363B80EC1;
        Mon, 18 Apr 2022 12:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49696C385A7;
        Mon, 18 Apr 2022 12:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284622;
        bh=fDD8IhH9m96y6dBr8zEZRwcTHy7HPF8YLEDIQKohlcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2N1ThTbpq8Sg4GZoWXXOeVikoKIu945gZQzAghg2092L3sfFZpHP+RMX7dnKkzcn
         egs593Pv8eB9nEm+4vZdsm+Dpmv+FELpwIhgv35gE8rPbgM8TFlG0Jp5RFPo2/IvE+
         JZ1tlXWb/txyas0UPiud7WUM4kBljxjG0xTPrTSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 134/219] drm/amdgpu/gmc: use PCI BARs for APUs in passthrough
Date:   Mon, 18 Apr 2022 14:11:43 +0200
Message-Id: <20220418121210.645214144@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b87dca6d09fa..052816f0efed 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5678,7 +5678,7 @@ void amdgpu_device_flush_hdp(struct amdgpu_device *adev,
 		struct amdgpu_ring *ring)
 {
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU)
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev))
 		return;
 #endif
 	if (adev->gmc.xgmi.connected_to_cpu)
@@ -5694,7 +5694,7 @@ void amdgpu_device_invalidate_hdp(struct amdgpu_device *adev,
 		struct amdgpu_ring *ring)
 {
 #ifdef CONFIG_X86_64
-	if (adev->flags & AMD_IS_APU)
+	if ((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev))
 		return;
 #endif
 	if (adev->gmc.xgmi.connected_to_cpu)
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index a2f8ed0e6a64..f1b794d5d87d 100644
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
index ab8adbff9e2d..5206e2da334a 100644
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
index 054733838292..d07d36786836 100644
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
index 34ee75cf7954..2fb24178eaef 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1420,7 +1420,7 @@ static int gmc_v9_0_mc_init(struct amdgpu_device *adev)
 	 */
 
 	/* check whether both host-gpu and gpu-gpu xgmi links exist */
-	if ((adev->flags & AMD_IS_APU) ||
+	if (((adev->flags & AMD_IS_APU) && !amdgpu_passthrough(adev)) ||
 	    (adev->gmc.xgmi.supported &&
 	     adev->gmc.xgmi.connected_to_cpu)) {
 		adev->gmc.aper_base =
-- 
2.35.1




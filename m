Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8017B4637DB
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbhK3O4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243195AbhK3Oyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9116C0619DE;
        Tue, 30 Nov 2021 06:49:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99FAAB81A25;
        Tue, 30 Nov 2021 14:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9D5C53FC1;
        Tue, 30 Nov 2021 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283777;
        bh=OINmIwLjzfaWH3AJFIWj9OZPWSOxdgeyzNsMBEnduME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PY8uEYMM7bcQ+ElYvbRFCi3Clt+Pm4OiuY+KbNCJ9aAhblufj9BhyMghvT8XphuLm
         0Qp3oYoR9gvkWGIXjIR6Ea3StJXIHDaB3hNqVWWCNvhAb5hZ7Erhkca+khtQhafAWM
         EplMTjW/VXmkMjaPz9pNliRSuvgEGaLG9DsdGTr2klHOvdbNs8xrDkF3iaF/1jnsa1
         S9NIvpzhyPcWlXzGC3Lzu3CaX664eW9f0c3VDDQbksvyTYUxoi8zFD+wiUn4PfZERW
         9fhEZTcui4RkL3hj2F3INc/yxPd/43Zdcn/8BdpGd+d7EA0Or7zWi3Ti58wa+DoZDO
         N+WER+0l61AYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Bokun Zhang <bokun.zhang@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        evan.quan@amd.com, Likun.Gao@amd.com, Hawking.Zhang@amd.com,
        ChengZhe.Liu@amd.com, kenneth.feng@amd.com, ray.huang@amd.com,
        aaron.liu@amd.com, john.clements@amd.com, le.ma@amd.com,
        James.Zhu@amd.com, candice.li@amd.com, tao.zhou1@amd.com,
        Jack.Gui@amd.com, veerabadhran.gopalakrishnan@amd.com,
        leo.liu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 55/68] drm/amdgpu: Fix MMIO HDP flush on SRIOV
Date:   Tue, 30 Nov 2021 09:46:51 -0500
Message-Id: <20211130144707.944580-55-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit d3a21f7e353dc8d6939383578f3bd45b4ae3a946 ]

Disable HDP register remapping on SRIOV and set rmmio_remap.reg_offset
to the fixed address of the VF register for hdp_v*_flush_hdp.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: Bokun Zhang <bokun.zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c | 4 ++++
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c | 4 ++++
 drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c | 4 +++-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c | 4 ++++
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 4 +++-
 drivers/gpu/drm/amd/amdgpu/nv.c        | 8 +++++---
 drivers/gpu/drm/amd/amdgpu/soc15.c     | 8 +++++---
 7 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
index b184b656b9b6b..a76b5e47e7cbe 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -328,6 +328,10 @@ static void nbio_v2_3_init_registers(struct amdgpu_device *adev)
 
 	if (def != data)
 		WREG32_PCIE(smnPCIE_CONFIG_CNTL, data);
+
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
+			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 #define NAVI10_PCIE__LC_L0S_INACTIVITY_DEFAULT		0x00000000 // off by default, no gains over L1
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
index 0d2d629e2d6a2..4bbacf1be25a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
@@ -276,6 +276,10 @@ static void nbio_v6_1_init_registers(struct amdgpu_device *adev)
 
 	if (def != data)
 		WREG32_PCIE(smnPCIE_CI_CNTL, data);
+
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
+			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
index 3c00666a13e16..37a4039fdfc53 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
@@ -273,7 +273,9 @@ const struct nbio_hdp_flush_reg nbio_v7_0_hdp_flush_reg = {
 
 static void nbio_v7_0_init_registers(struct amdgpu_device *adev)
 {
-
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset =
+			SOC15_REG_OFFSET(NBIO, 0, mmHDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_0_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
index 8f2a315e7c73c..3444332ea1104 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
@@ -371,6 +371,10 @@ static void nbio_v7_2_init_registers(struct amdgpu_device *adev)
 		if (def != data)
 			WREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regPCIE_CONFIG_CNTL), data);
 	}
+
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
+			regBIF_BX_PF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_2_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index f50045cebd44c..9b3f64971a321 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -344,7 +344,9 @@ const struct nbio_hdp_flush_reg nbio_v7_4_hdp_flush_reg = {
 
 static void nbio_v7_4_init_registers(struct amdgpu_device *adev)
 {
-
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
+			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index 01efda4398e56..b739166b242a7 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -1034,8 +1034,10 @@ static int nv_common_early_init(void *handle)
 #define MMIO_REG_HOLE_OFFSET (0x80000 - PAGE_SIZE)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	adev->rmmio_remap.reg_offset = MMIO_REG_HOLE_OFFSET;
-	adev->rmmio_remap.bus_addr = adev->rmmio_base + MMIO_REG_HOLE_OFFSET;
+	if (!amdgpu_sriov_vf(adev)) {
+		adev->rmmio_remap.reg_offset = MMIO_REG_HOLE_OFFSET;
+		adev->rmmio_remap.bus_addr = adev->rmmio_base + MMIO_REG_HOLE_OFFSET;
+	}
 	adev->smc_rreg = NULL;
 	adev->smc_wreg = NULL;
 	adev->pcie_rreg = &nv_pcie_rreg;
@@ -1333,7 +1335,7 @@ static int nv_common_hw_init(void *handle)
 	 * for the purpose of expose those registers
 	 * to process space
 	 */
-	if (adev->nbio.funcs->remap_hdp_registers)
+	if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
 		adev->nbio.funcs->remap_hdp_registers(adev);
 	/* enable the doorbell aperture */
 	nv_enable_doorbell_aperture(adev, true);
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 0fc97c364fd76..a3361cd68411a 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1136,8 +1136,10 @@ static int soc15_common_early_init(void *handle)
 #define MMIO_REG_HOLE_OFFSET (0x80000 - PAGE_SIZE)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	adev->rmmio_remap.reg_offset = MMIO_REG_HOLE_OFFSET;
-	adev->rmmio_remap.bus_addr = adev->rmmio_base + MMIO_REG_HOLE_OFFSET;
+	if (!amdgpu_sriov_vf(adev)) {
+		adev->rmmio_remap.reg_offset = MMIO_REG_HOLE_OFFSET;
+		adev->rmmio_remap.bus_addr = adev->rmmio_base + MMIO_REG_HOLE_OFFSET;
+	}
 	adev->smc_rreg = NULL;
 	adev->smc_wreg = NULL;
 	adev->pcie_rreg = &soc15_pcie_rreg;
@@ -1446,7 +1448,7 @@ static int soc15_common_hw_init(void *handle)
 	 * for the purpose of expose those registers
 	 * to process space
 	 */
-	if (adev->nbio.funcs->remap_hdp_registers)
+	if (adev->nbio.funcs->remap_hdp_registers && !amdgpu_sriov_vf(adev))
 		adev->nbio.funcs->remap_hdp_registers(adev);
 
 	/* enable the doorbell aperture */
-- 
2.33.0


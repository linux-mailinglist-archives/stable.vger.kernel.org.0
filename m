Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F348621563
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiKHOLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbiKHOLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17895862EF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B76F6157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A011BC433C1;
        Tue,  8 Nov 2022 14:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916666;
        bh=3odNfFTxhlSI2oqPWmgqSTu/8N7j/fMmlaKxX+8l4aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erDzYN4XDu6tpluYMKs3wbwKkevGM4KuzZIFbHrW/1x1VCEnNKQsCDag20C3z/lMP
         JVOqEORVUXvJOszyuz3RSCElBneH0maHnFaVNiCZlXJi28jMHx8B2sHlqXNbQE2Zzg
         wM9pVxIDgMed+yWBNnxQ0iRbapcqQaDJGLtcBw/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yifan Zha <Yifan.Zha@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 087/197] drm/amdgpu: Program GC registers through RLCG interface in gfx_v11/gmc_v11
Date:   Tue,  8 Nov 2022 14:38:45 +0100
Message-Id: <20221108133358.796309912@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zha <Yifan.Zha@amd.com>

[ Upstream commit 97a3d6090f5c2a165dc88bda05c1dcf9f08bf886 ]

[Why]
L1 blocks most of GC registers accessing by MMIO.

[How]
Use RLCG interface to program GC registers under SRIOV VF in full access time.

Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c         |  2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c         | 18 +++++++++++-------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
index 0b0a72ca5695..7e80caa05060 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
@@ -111,7 +111,7 @@ static int init_interrupts_v11(struct amdgpu_device *adev, uint32_t pipe_id)
 
 	lock_srbm(adev, mec, pipe, 0, 0);
 
-	WREG32(SOC15_REG_OFFSET(GC, 0, regCPC_INT_CNTL),
+	WREG32_SOC15(GC, 0, regCPC_INT_CNTL,
 		CP_INT_CNTL_RING0__TIME_STAMP_INT_ENABLE_MASK |
 		CP_INT_CNTL_RING0__OPCODE_ERROR_INT_ENABLE_MASK);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index daf8ba8235cd..03775e0a8100 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1729,7 +1729,7 @@ static void gfx_v11_0_init_compute_vmid(struct amdgpu_device *adev)
 		WREG32_SOC15(GC, 0, regSH_MEM_BASES, sh_mem_bases);
 
 		/* Enable trap for each kfd vmid. */
-		data = RREG32(SOC15_REG_OFFSET(GC, 0, regSPI_GDBG_PER_VMID_CNTL));
+		data = RREG32_SOC15(GC, 0, regSPI_GDBG_PER_VMID_CNTL);
 		data = REG_SET_FIELD(data, SPI_GDBG_PER_VMID_CNTL, TRAP_EN, 1);
 	}
 	soc21_grbm_select(adev, 0, 0, 0, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
index 1471bfb9ae38..2475fdbe8010 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -185,6 +185,10 @@ static void gmc_v11_0_flush_vm_hub(struct amdgpu_device *adev, uint32_t vmid,
 	/* Use register 17 for GART */
 	const unsigned eng = 17;
 	unsigned int i;
+	unsigned char hub_ip = 0;
+
+	hub_ip = (vmhub == AMDGPU_GFXHUB_0) ?
+		   GC_HWIP : MMHUB_HWIP;
 
 	spin_lock(&adev->gmc.invalidate_lock);
 	/*
@@ -198,8 +202,8 @@ static void gmc_v11_0_flush_vm_hub(struct amdgpu_device *adev, uint32_t vmid,
 	if (use_semaphore) {
 		for (i = 0; i < adev->usec_timeout; i++) {
 			/* a read return value of 1 means semaphore acuqire */
-			tmp = RREG32_NO_KIQ(hub->vm_inv_eng0_sem +
-					    hub->eng_distance * eng);
+			tmp = RREG32_RLC_NO_KIQ(hub->vm_inv_eng0_sem +
+					    hub->eng_distance * eng, hub_ip);
 			if (tmp & 0x1)
 				break;
 			udelay(1);
@@ -209,12 +213,12 @@ static void gmc_v11_0_flush_vm_hub(struct amdgpu_device *adev, uint32_t vmid,
 			DRM_ERROR("Timeout waiting for sem acquire in VM flush!\n");
 	}
 
-	WREG32_NO_KIQ(hub->vm_inv_eng0_req + hub->eng_distance * eng, inv_req);
+	WREG32_RLC_NO_KIQ(hub->vm_inv_eng0_req + hub->eng_distance * eng, inv_req, hub_ip);
 
 	/* Wait for ACK with a delay.*/
 	for (i = 0; i < adev->usec_timeout; i++) {
-		tmp = RREG32_NO_KIQ(hub->vm_inv_eng0_ack +
-				    hub->eng_distance * eng);
+		tmp = RREG32_RLC_NO_KIQ(hub->vm_inv_eng0_ack +
+				    hub->eng_distance * eng, hub_ip);
 		tmp &= 1 << vmid;
 		if (tmp)
 			break;
@@ -228,8 +232,8 @@ static void gmc_v11_0_flush_vm_hub(struct amdgpu_device *adev, uint32_t vmid,
 		 * add semaphore release after invalidation,
 		 * write with 0 means semaphore release
 		 */
-		WREG32_NO_KIQ(hub->vm_inv_eng0_sem +
-			      hub->eng_distance * eng, 0);
+		WREG32_RLC_NO_KIQ(hub->vm_inv_eng0_sem +
+			      hub->eng_distance * eng, 0, hub_ip);
 
 	/* Issue additional private vm invalidation to MMHUB */
 	if ((vmhub != AMDGPU_GFXHUB_0) &&
-- 
2.35.1




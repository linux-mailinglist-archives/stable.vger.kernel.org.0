Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0F3371A29
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhECQi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhECQh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFC30613D8;
        Mon,  3 May 2021 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059786;
        bh=Vd1HgjghEDtwEry470TixI2MTVg9CAJYBAjQx2k8iOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h32bVU+4DG6RTFB87YOMZKF7Gvm0VzdQYVCcJmuj5fhGSPg6asyae5CHAhI3E99Vs
         dzBjfzjyb+KEj7u8RjfsOjsVXU5PfqfB6KqSuII9Ryi0meSNTOl5mDyqecMm5hsbX2
         HN0Neyp/7xAMaOQnFko6Vo6dhMYuCtfBen7t4N5dfICWH79ZcJyYl76qkd9pqvTNvv
         PBrKDBzatBFXCIKewWWpZ4OMNpQUKpXes0M9GVx39IBjbrnVBWucgXTH2tJbUc0dcq
         ves13YX2Sir0jP32WRbvFXVxBJmiISNnsCUT2Q59CzD6MZvDldTHtpv8FChur0Hz+0
         RDbMy8dIC47Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 047/134] drm/amdgpu: enable retry fault wptr overflow
Date:   Mon,  3 May 2021 12:33:46 -0400
Message-Id: <20210503163513.2851510-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit b672cb1eee59efe6ca5bb2a2ce90060a22860558 ]

If xnack is on, VM retry fault interrupt send to IH ring1, and ring1
will be full quickly. IH cannot receive other interrupts, this causes
deadlock if migrating buffer using sdma and waiting for sdma done while
handling retry fault.

Remove VMC from IH storm client, enable ring1 write pointer overflow,
then IH will drop retry fault interrupts and be able to receive other
interrupts while driver is handling retry fault.

IH ring1 write pointer doesn't writeback to memory by IH, and ring1
write pointer recorded by self-irq is not updated, so always read
the latest ring1 write pointer from register.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c | 32 +++++++++-----------------
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c | 32 +++++++++-----------------
 2 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
index 88626d83e07b..ca8efa5c6978 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
@@ -220,10 +220,8 @@ static int vega10_ih_enable_ring(struct amdgpu_device *adev,
 	tmp = vega10_ih_rb_cntl(ih, tmp);
 	if (ih == &adev->irq.ih)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RPTR_REARM, !!adev->irq.msi_enabled);
-	if (ih == &adev->irq.ih1) {
-		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_ENABLE, 0);
+	if (ih == &adev->irq.ih1)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_FULL_DRAIN_ENABLE, 1);
-	}
 	if (amdgpu_sriov_vf(adev)) {
 		if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp)) {
 			dev_err(adev->dev, "PSP program IH_RB_CNTL failed!\n");
@@ -265,7 +263,6 @@ static int vega10_ih_irq_init(struct amdgpu_device *adev)
 	u32 ih_chicken;
 	int ret;
 	int i;
-	u32 tmp;
 
 	/* disable irqs */
 	ret = vega10_ih_toggle_interrupts(adev, false);
@@ -291,15 +288,6 @@ static int vega10_ih_irq_init(struct amdgpu_device *adev)
 		}
 	}
 
-	tmp = RREG32_SOC15(OSSSYS, 0, mmIH_STORM_CLIENT_LIST_CNTL);
-	tmp = REG_SET_FIELD(tmp, IH_STORM_CLIENT_LIST_CNTL,
-			    CLIENT18_IS_STORM_CLIENT, 1);
-	WREG32_SOC15(OSSSYS, 0, mmIH_STORM_CLIENT_LIST_CNTL, tmp);
-
-	tmp = RREG32_SOC15(OSSSYS, 0, mmIH_INT_FLOOD_CNTL);
-	tmp = REG_SET_FIELD(tmp, IH_INT_FLOOD_CNTL, FLOOD_CNTL_ENABLE, 1);
-	WREG32_SOC15(OSSSYS, 0, mmIH_INT_FLOOD_CNTL, tmp);
-
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */
@@ -345,11 +333,17 @@ static u32 vega10_ih_get_wptr(struct amdgpu_device *adev,
 	u32 wptr, tmp;
 	struct amdgpu_ih_regs *ih_regs;
 
-	wptr = le32_to_cpu(*ih->wptr_cpu);
-	ih_regs = &ih->ih_regs;
+	if (ih == &adev->irq.ih) {
+		/* Only ring0 supports writeback. On other rings fall back
+		 * to register-based code with overflow checking below.
+		 */
+		wptr = le32_to_cpu(*ih->wptr_cpu);
 
-	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
-		goto out;
+		if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+			goto out;
+	}
+
+	ih_regs = &ih->ih_regs;
 
 	/* Double check that the overflow wasn't already cleared. */
 	wptr = RREG32_NO_KIQ(ih_regs->ih_rb_wptr);
@@ -440,15 +434,11 @@ static int vega10_ih_self_irq(struct amdgpu_device *adev,
 			      struct amdgpu_irq_src *source,
 			      struct amdgpu_iv_entry *entry)
 {
-	uint32_t wptr = cpu_to_le32(entry->src_data[0]);
-
 	switch (entry->ring_id) {
 	case 1:
-		*adev->irq.ih1.wptr_cpu = wptr;
 		schedule_work(&adev->irq.ih1_work);
 		break;
 	case 2:
-		*adev->irq.ih2.wptr_cpu = wptr;
 		schedule_work(&adev->irq.ih2_work);
 		break;
 	default: break;
diff --git a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
index 5a3c867d5881..75b06e1964ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -220,10 +220,8 @@ static int vega20_ih_enable_ring(struct amdgpu_device *adev,
 	tmp = vega20_ih_rb_cntl(ih, tmp);
 	if (ih == &adev->irq.ih)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RPTR_REARM, !!adev->irq.msi_enabled);
-	if (ih == &adev->irq.ih1) {
-		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_ENABLE, 0);
+	if (ih == &adev->irq.ih1)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_FULL_DRAIN_ENABLE, 1);
-	}
 	if (amdgpu_sriov_vf(adev)) {
 		if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp)) {
 			dev_err(adev->dev, "PSP program IH_RB_CNTL failed!\n");
@@ -297,7 +295,6 @@ static int vega20_ih_irq_init(struct amdgpu_device *adev)
 	u32 ih_chicken;
 	int ret;
 	int i;
-	u32 tmp;
 
 	/* disable irqs */
 	ret = vega20_ih_toggle_interrupts(adev, false);
@@ -326,15 +323,6 @@ static int vega20_ih_irq_init(struct amdgpu_device *adev)
 		}
 	}
 
-	tmp = RREG32_SOC15(OSSSYS, 0, mmIH_STORM_CLIENT_LIST_CNTL);
-	tmp = REG_SET_FIELD(tmp, IH_STORM_CLIENT_LIST_CNTL,
-			    CLIENT18_IS_STORM_CLIENT, 1);
-	WREG32_SOC15(OSSSYS, 0, mmIH_STORM_CLIENT_LIST_CNTL, tmp);
-
-	tmp = RREG32_SOC15(OSSSYS, 0, mmIH_INT_FLOOD_CNTL);
-	tmp = REG_SET_FIELD(tmp, IH_INT_FLOOD_CNTL, FLOOD_CNTL_ENABLE, 1);
-	WREG32_SOC15(OSSSYS, 0, mmIH_INT_FLOOD_CNTL, tmp);
-
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */
@@ -380,11 +368,17 @@ static u32 vega20_ih_get_wptr(struct amdgpu_device *adev,
 	u32 wptr, tmp;
 	struct amdgpu_ih_regs *ih_regs;
 
-	wptr = le32_to_cpu(*ih->wptr_cpu);
-	ih_regs = &ih->ih_regs;
+	if (ih == &adev->irq.ih) {
+		/* Only ring0 supports writeback. On other rings fall back
+		 * to register-based code with overflow checking below.
+		 */
+		wptr = le32_to_cpu(*ih->wptr_cpu);
 
-	if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
-		goto out;
+		if (!REG_GET_FIELD(wptr, IH_RB_WPTR, RB_OVERFLOW))
+			goto out;
+	}
+
+	ih_regs = &ih->ih_regs;
 
 	/* Double check that the overflow wasn't already cleared. */
 	wptr = RREG32_NO_KIQ(ih_regs->ih_rb_wptr);
@@ -476,15 +470,11 @@ static int vega20_ih_self_irq(struct amdgpu_device *adev,
 			      struct amdgpu_irq_src *source,
 			      struct amdgpu_iv_entry *entry)
 {
-	uint32_t wptr = cpu_to_le32(entry->src_data[0]);
-
 	switch (entry->ring_id) {
 	case 1:
-		*adev->irq.ih1.wptr_cpu = wptr;
 		schedule_work(&adev->irq.ih1_work);
 		break;
 	case 2:
-		*adev->irq.ih2.wptr_cpu = wptr;
 		schedule_work(&adev->irq.ih2_work);
 		break;
 	default: break;
-- 
2.30.2


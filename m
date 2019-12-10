Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99B2119678
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLJV1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:27:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbfLJVZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA4521D7D;
        Tue, 10 Dec 2019 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013124;
        bh=YyPzPT3aJVPf7MSddQdNvkX3fuIxyFCU9WurLQdBgRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ims8hFC10XSfU4AOwHQHYXKyDwM/w9zt2fAB0IG8wJ6DuedKit/SKGpXd2NrPNdd3
         9Xrdi0oUh2gox0abTFIgMxwbrObKYm2E2OmUqzYVhTzunVzl4pQYCbrUEVlWEj5+Wo
         hesumOoRaQh3+uV3P1WjHHvNrn0lU/T/9v8ms0dc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Zhang <Jack.Zhang1@amd.com>, Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 010/292] drm/amdgpu/sriov: add ring_stop before ring_create in psp v11 code
Date:   Tue, 10 Dec 2019 16:20:29 -0500
Message-Id: <20191210212511.11392-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Zhang <Jack.Zhang1@amd.com>

[ Upstream commit 51c0f58e9f6af3a387d14608033e6796a7ad90ee ]

psp  v11 code missed ring stop in ring create function(VMR)
while psp v3.1 code had the code. This will cause VM destroy1
fail and psp ring create fail.

For SIOV-VF, ring_stop should not be deleted in ring_create
function.

Signed-off-by: Jack Zhang <Jack.Zhang1@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c | 61 ++++++++++++++------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index 41b72588adcf5..68774524e58bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -373,6 +373,34 @@ static bool psp_v11_0_support_vmr_ring(struct psp_context *psp)
 	return false;
 }
 
+static int psp_v11_0_ring_stop(struct psp_context *psp,
+			      enum psp_ring_type ring_type)
+{
+	int ret = 0;
+	struct amdgpu_device *adev = psp->adev;
+
+	/* Write the ring destroy command*/
+	if (psp_v11_0_support_vmr_ring(psp))
+		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_101,
+				     GFX_CTRL_CMD_ID_DESTROY_GPCOM_RING);
+	else
+		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_64,
+				     GFX_CTRL_CMD_ID_DESTROY_RINGS);
+
+	/* there might be handshake issue with hardware which needs delay */
+	mdelay(20);
+
+	/* Wait for response flag (bit 31) */
+	if (psp_v11_0_support_vmr_ring(psp))
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
+	else
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
+
+	return ret;
+}
+
 static int psp_v11_0_ring_create(struct psp_context *psp,
 				enum psp_ring_type ring_type)
 {
@@ -382,6 +410,12 @@ static int psp_v11_0_ring_create(struct psp_context *psp,
 	struct amdgpu_device *adev = psp->adev;
 
 	if (psp_v11_0_support_vmr_ring(psp)) {
+		ret = psp_v11_0_ring_stop(psp, ring_type);
+		if (ret) {
+			DRM_ERROR("psp_v11_0_ring_stop_sriov failed!\n");
+			return ret;
+		}
+
 		/* Write low address of the ring to C2PMSG_102 */
 		psp_ring_reg = lower_32_bits(ring->ring_mem_mc_addr);
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_102, psp_ring_reg);
@@ -426,33 +460,6 @@ static int psp_v11_0_ring_create(struct psp_context *psp,
 	return ret;
 }
 
-static int psp_v11_0_ring_stop(struct psp_context *psp,
-			      enum psp_ring_type ring_type)
-{
-	int ret = 0;
-	struct amdgpu_device *adev = psp->adev;
-
-	/* Write the ring destroy command*/
-	if (psp_v11_0_support_vmr_ring(psp))
-		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_101,
-				     GFX_CTRL_CMD_ID_DESTROY_GPCOM_RING);
-	else
-		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_64,
-				     GFX_CTRL_CMD_ID_DESTROY_RINGS);
-
-	/* there might be handshake issue with hardware which needs delay */
-	mdelay(20);
-
-	/* Wait for response flag (bit 31) */
-	if (psp_v11_0_support_vmr_ring(psp))
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-				   0x80000000, 0x80000000, false);
-	else
-		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-				   0x80000000, 0x80000000, false);
-
-	return ret;
-}
 
 static int psp_v11_0_ring_destroy(struct psp_context *psp,
 				 enum psp_ring_type ring_type)
-- 
2.20.1


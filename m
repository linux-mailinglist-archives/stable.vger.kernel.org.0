Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A6412C78D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfL2Rnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730515AbfL2Rng (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93DBF206A4;
        Sun, 29 Dec 2019 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641416;
        bh=GK0FX52DVvojoAlPdOEo5GgMAzRbExsRiZMwVHqEfTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPKAWmNQQuw8uRAy3oeGYNorWxsGgRZxnuxGLXWvdpvrgIBb9od6T+GmaVy2WJeZR
         ktPj+K6jw0woqAGLWjyN6uIk3e6M2ymncDbOk+a1brBbZVrnMzLQmCP56/eKpNNUcc
         xSjidpKtJGDiECMiPlyoHq/rve59svITgzxqAuEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Zhang <Jack.Zhang1@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/434] drm/amdgpu/sriov: add ring_stop before ring_create in psp v11 code
Date:   Sun, 29 Dec 2019 18:21:48 +0100
Message-Id: <20191229172705.541439371@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 10166104b8a3..d483684db95b 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -398,6 +398,34 @@ static bool psp_v11_0_support_vmr_ring(struct psp_context *psp)
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
@@ -407,6 +435,12 @@ static int psp_v11_0_ring_create(struct psp_context *psp,
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
@@ -451,33 +485,6 @@ static int psp_v11_0_ring_create(struct psp_context *psp,
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




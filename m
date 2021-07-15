Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3973CAAF4
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbhGOTQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244586AbhGOTO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CF7E61405;
        Thu, 15 Jul 2021 19:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376243;
        bh=StkZ6aujY2PeZQgeVK7jPZd5eGIXph8XcoWYZQJF4bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mwa1j/6CnuA1txeoyCsl1mBVDSp7NZQbTgMyp8qL1AOcBSUv3OIyQ95CvxN3xdxKE
         CHacT2S8DdJmQ90BMySWwKFq8mPDReP3iDzjO0JoSQquwZJr/0JtM60PKClCX103Ub
         iO3a9f3g0SoIYNcxG8E+UeOfwv1MRk8XjDTTlciU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 188/266] drm/amdgpu: fix NAK-G generation during PCI-e link width switch
Date:   Thu, 15 Jul 2021 20:39:03 +0200
Message-Id: <20210715182644.320727411@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 5a5da8ae9546031e43efd4fa5aa8baa481e83dfb upstream.

A lot of NAK-G being generated when link widht switching is happening.
WA for this issue is to program the SPC to 4 symbols per clock during
bootup when the native PCIE width is x4.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_nbio.h |    1 +
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c   |   28 ++++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/nv.c          |    3 +++
 3 files changed, 32 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_nbio.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_nbio.h
@@ -93,6 +93,7 @@ struct amdgpu_nbio_funcs {
 	void (*enable_aspm)(struct amdgpu_device *adev,
 			    bool enable);
 	void (*program_aspm)(struct amdgpu_device *adev);
+	void (*apply_lc_spc_mode_wa)(struct amdgpu_device *adev);
 };
 
 struct amdgpu_nbio {
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -51,6 +51,8 @@
 #define mmBIF_MMSCH1_DOORBELL_RANGE		0x01d8
 #define mmBIF_MMSCH1_DOORBELL_RANGE_BASE_IDX	2
 
+#define smnPCIE_LC_LINK_WIDTH_CNTL		0x11140288
+
 static void nbio_v2_3_remap_hdp_registers(struct amdgpu_device *adev)
 {
 	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
@@ -463,6 +465,31 @@ static void nbio_v2_3_program_aspm(struc
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
 }
 
+static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
+{
+	uint32_t reg_data = 0;
+	uint32_t link_width = 0;
+
+	if (!((adev->asic_type >= CHIP_NAVI10) &&
+	     (adev->asic_type <= CHIP_NAVI12)))
+		return;
+
+	reg_data = RREG32_PCIE(smnPCIE_LC_LINK_WIDTH_CNTL);
+	link_width = (reg_data & PCIE_LC_LINK_WIDTH_CNTL__LC_LINK_WIDTH_RD_MASK)
+		>> PCIE_LC_LINK_WIDTH_CNTL__LC_LINK_WIDTH_RD__SHIFT;
+
+	/*
+	 * Program PCIE_LC_CNTL6.LC_SPC_MODE_8GT to 0x2 (4 symbols per clock data)
+	 * if link_width is 0x3 (x4)
+	 */
+	if (0x3 == link_width) {
+		reg_data = RREG32_PCIE(smnPCIE_LC_CNTL6);
+		reg_data &= ~PCIE_LC_CNTL6__LC_SPC_MODE_8GT_MASK;
+		reg_data |= (0x2 << PCIE_LC_CNTL6__LC_SPC_MODE_8GT__SHIFT);
+		WREG32_PCIE(smnPCIE_LC_CNTL6, reg_data);
+	}
+}
+
 const struct amdgpu_nbio_funcs nbio_v2_3_funcs = {
 	.get_hdp_flush_req_offset = nbio_v2_3_get_hdp_flush_req_offset,
 	.get_hdp_flush_done_offset = nbio_v2_3_get_hdp_flush_done_offset,
@@ -484,4 +511,5 @@ const struct amdgpu_nbio_funcs nbio_v2_3
 	.remap_hdp_registers = nbio_v2_3_remap_hdp_registers,
 	.enable_aspm = nbio_v2_3_enable_aspm,
 	.program_aspm =  nbio_v2_3_program_aspm,
+	.apply_lc_spc_mode_wa = nbio_v2_3_apply_lc_spc_mode_wa,
 };
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -1194,6 +1194,9 @@ static int nv_common_hw_init(void *handl
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	if (adev->nbio.funcs->apply_lc_spc_mode_wa)
+		adev->nbio.funcs->apply_lc_spc_mode_wa(adev);
+
 	/* enable pcie gen2/3 link */
 	nv_pcie_gen3_enable(adev);
 	/* enable aspm */



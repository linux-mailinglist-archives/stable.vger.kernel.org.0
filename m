Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D0317803F
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbgCCRzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:55:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732742AbgCCRzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:55:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1919206D5;
        Tue,  3 Mar 2020 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258137;
        bh=99bDwe3Dy2ePQwM5mto3jIgDPSXdQSgXvaU+TnOOvXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMdLFtefzyjtAeHrlNORY5du4td+pqpZBlbhb4nIbvgi8mtwlm3CRDrF8Zydb0BIm
         vnhJO40WzksBNSQqyiTGt8r5PgORn2zaWuXlaLDlmdyBJZeRNITbyUJxlDeXcMAVEG
         X9WTK9/sz9UAB+/VhCSsExbhiSZl5Kbxnen4dTBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Shirish S <shirish.s@amd.com>
Subject: [PATCH 5.4 084/152] amdgpu/gmc_v9: save/restore sdpif regs during S3
Date:   Tue,  3 Mar 2020 18:43:02 +0100
Message-Id: <20200303174312.099859449@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <shirish.s@amd.com>

commit a3ed353cf8015ba84a0407a5dc3ffee038166ab0 upstream.

fixes S3 issue with IOMMU + S/G  enabled @ 64M VRAM.

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Shirish S <shirish.s@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h                    |    1 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                      |   37 ++++++++++++-
 drivers/gpu/drm/amd/include/asic_reg/dce/dce_12_0_offset.h |    2 
 3 files changed, 39 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h
@@ -157,6 +157,7 @@ struct amdgpu_gmc {
 	uint32_t                srbm_soft_reset;
 	bool			prt_warning;
 	uint64_t		stolen_size;
+	uint32_t		sdpif_register;
 	/* apertures */
 	u64			shared_aperture_start;
 	u64			shared_aperture_end;
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1383,6 +1383,19 @@ static void gmc_v9_0_init_golden_registe
 }
 
 /**
+ * gmc_v9_0_restore_registers - restores regs
+ *
+ * @adev: amdgpu_device pointer
+ *
+ * This restores register values, saved at suspend.
+ */
+static void gmc_v9_0_restore_registers(struct amdgpu_device *adev)
+{
+	if (adev->asic_type == CHIP_RAVEN)
+		WREG32(mmDCHUBBUB_SDPIF_MMIO_CNTRL_0, adev->gmc.sdpif_register);
+}
+
+/**
  * gmc_v9_0_gart_enable - gart enable
  *
  * @adev: amdgpu_device pointer
@@ -1479,6 +1492,20 @@ static int gmc_v9_0_hw_init(void *handle
 }
 
 /**
+ * gmc_v9_0_save_registers - saves regs
+ *
+ * @adev: amdgpu_device pointer
+ *
+ * This saves potential register values that should be
+ * restored upon resume
+ */
+static void gmc_v9_0_save_registers(struct amdgpu_device *adev)
+{
+	if (adev->asic_type == CHIP_RAVEN)
+		adev->gmc.sdpif_register = RREG32(mmDCHUBBUB_SDPIF_MMIO_CNTRL_0);
+}
+
+/**
  * gmc_v9_0_gart_disable - gart disable
  *
  * @adev: amdgpu_device pointer
@@ -1514,9 +1541,16 @@ static int gmc_v9_0_hw_fini(void *handle
 
 static int gmc_v9_0_suspend(void *handle)
 {
+	int r;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	return gmc_v9_0_hw_fini(adev);
+	r = gmc_v9_0_hw_fini(adev);
+	if (r)
+		return r;
+
+	gmc_v9_0_save_registers(adev);
+
+	return 0;
 }
 
 static int gmc_v9_0_resume(void *handle)
@@ -1524,6 +1558,7 @@ static int gmc_v9_0_resume(void *handle)
 	int r;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	gmc_v9_0_restore_registers(adev);
 	r = gmc_v9_0_hw_init(adev);
 	if (r)
 		return r;
--- a/drivers/gpu/drm/amd/include/asic_reg/dce/dce_12_0_offset.h
+++ b/drivers/gpu/drm/amd/include/asic_reg/dce/dce_12_0_offset.h
@@ -7376,6 +7376,8 @@
 #define mmCRTC4_CRTC_DRR_CONTROL                                                                       0x0f3e
 #define mmCRTC4_CRTC_DRR_CONTROL_BASE_IDX                                                              2
 
+#define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0                                                                  0x395d
+#define mmDCHUBBUB_SDPIF_MMIO_CNTRL_0_BASE_IDX                                                         2
 
 // addressBlock: dce_dc_fmt4_dispdec
 // base address: 0x2000



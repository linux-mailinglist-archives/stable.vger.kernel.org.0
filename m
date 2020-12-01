Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF832C9C1E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390413AbgLAJPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390398AbgLAJPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:15:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC5AE221FF;
        Tue,  1 Dec 2020 09:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814057;
        bh=MlYFzvrcym5z0JHifhqu2N67SRDCBJuqTg8gcfW8wHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcQtw4kGA6cPAG6zwjDs3JVAPE6OJ+ZSInkCsDrUItf2XMFYt2qAwBE+ShQc8D3fP
         /6FHGc5uK5r36HDaXdviQtafCTBvCYmCm6K/QHQ8vxLSduC/tthDRQymMMm699ZNdl
         NB3YKxe3KPUCzSDtqORG1koT8yF89JWEI2whkvps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 152/152] drm/amdgpu: add rlc iram and dram firmware support
Date:   Tue,  1 Dec 2020 09:54:27 +0100
Message-Id: <20201201084731.761045636@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

commit 843c7eb2f7571aa092a8ea010c80e8d94c197f67 upstream.

Support to load RLC iram and dram ucode when RLC firmware struct use v2.2

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c   |    6 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h   |    4 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c |   10 +++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h |   11 ++++++++
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c    |   39 +++++++++++++++++++++++++-----
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h   |    4 +--
 6 files changed, 66 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1571,6 +1571,12 @@ static int psp_get_fw_type(struct amdgpu
 	case AMDGPU_UCODE_ID_RLC_RESTORE_LIST_SRM_MEM:
 		*type = GFX_FW_TYPE_RLC_RESTORE_LIST_SRM_MEM;
 		break;
+	case AMDGPU_UCODE_ID_RLC_IRAM:
+		*type = GFX_FW_TYPE_RLC_IRAM;
+		break;
+	case AMDGPU_UCODE_ID_RLC_DRAM:
+		*type = GFX_FW_TYPE_RLC_DRAM_BOOT;
+		break;
 	case AMDGPU_UCODE_ID_SMC:
 		*type = GFX_FW_TYPE_SMU;
 		break;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h
@@ -168,12 +168,16 @@ struct amdgpu_rlc {
 	u32 save_restore_list_cntl_size_bytes;
 	u32 save_restore_list_gpm_size_bytes;
 	u32 save_restore_list_srm_size_bytes;
+	u32 rlc_iram_ucode_size_bytes;
+	u32 rlc_dram_ucode_size_bytes;
 
 	u32 *register_list_format;
 	u32 *register_restore;
 	u8 *save_restore_list_cntl;
 	u8 *save_restore_list_gpm;
 	u8 *save_restore_list_srm;
+	u8 *rlc_iram_ucode;
+	u8 *rlc_dram_ucode;
 
 	bool is_rlc_v2_1;
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
@@ -500,6 +500,8 @@ static int amdgpu_ucode_init_single_fw(s
 	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL &&
 	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_RESTORE_LIST_GPM_MEM &&
 	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_RESTORE_LIST_SRM_MEM &&
+	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_IRAM &&
+	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_DRAM &&
 		 ucode->ucode_id != AMDGPU_UCODE_ID_DMCU_ERAM &&
 		 ucode->ucode_id != AMDGPU_UCODE_ID_DMCU_INTV &&
 		 ucode->ucode_id != AMDGPU_UCODE_ID_DMCUB)) {
@@ -556,6 +558,14 @@ static int amdgpu_ucode_init_single_fw(s
 		ucode->ucode_size = adev->gfx.rlc.save_restore_list_srm_size_bytes;
 		memcpy(ucode->kaddr, adev->gfx.rlc.save_restore_list_srm,
 		       ucode->ucode_size);
+	} else if (ucode->ucode_id == AMDGPU_UCODE_ID_RLC_IRAM) {
+		ucode->ucode_size = adev->gfx.rlc.rlc_iram_ucode_size_bytes;
+		memcpy(ucode->kaddr, adev->gfx.rlc.rlc_iram_ucode,
+		       ucode->ucode_size);
+	} else if (ucode->ucode_id == AMDGPU_UCODE_ID_RLC_DRAM) {
+		ucode->ucode_size = adev->gfx.rlc.rlc_dram_ucode_size_bytes;
+		memcpy(ucode->kaddr, adev->gfx.rlc.rlc_dram_ucode,
+		       ucode->ucode_size);
 	} else if (ucode->ucode_id == AMDGPU_UCODE_ID_CP_MES) {
 		ucode->ucode_size = le32_to_cpu(mes_hdr->mes_ucode_size_bytes);
 		memcpy(ucode->kaddr, (void *)((uint8_t *)adev->mes.fw->data +
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
@@ -221,6 +221,15 @@ struct rlc_firmware_header_v2_1 {
 	uint32_t save_restore_list_srm_offset_bytes;
 };
 
+/* version_major=2, version_minor=1 */
+struct rlc_firmware_header_v2_2 {
+	struct rlc_firmware_header_v2_1 v2_1;
+	uint32_t rlc_iram_ucode_size_bytes;
+	uint32_t rlc_iram_ucode_offset_bytes;
+	uint32_t rlc_dram_ucode_size_bytes;
+	uint32_t rlc_dram_ucode_offset_bytes;
+};
+
 /* version_major=1, version_minor=0 */
 struct sdma_firmware_header_v1_0 {
 	struct common_firmware_header header;
@@ -338,6 +347,8 @@ enum AMDGPU_UCODE_ID {
 	AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL,
 	AMDGPU_UCODE_ID_RLC_RESTORE_LIST_GPM_MEM,
 	AMDGPU_UCODE_ID_RLC_RESTORE_LIST_SRM_MEM,
+	AMDGPU_UCODE_ID_RLC_IRAM,
+	AMDGPU_UCODE_ID_RLC_DRAM,
 	AMDGPU_UCODE_ID_RLC_G,
 	AMDGPU_UCODE_ID_STORAGE,
 	AMDGPU_UCODE_ID_SMC,
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3596,6 +3596,17 @@ static void gfx_v10_0_init_rlc_ext_micro
 			le32_to_cpu(rlc_hdr->reg_list_format_direct_reg_list_length);
 }
 
+static void gfx_v10_0_init_rlc_iram_dram_microcode(struct amdgpu_device *adev)
+{
+	const struct rlc_firmware_header_v2_2 *rlc_hdr;
+
+	rlc_hdr = (const struct rlc_firmware_header_v2_2 *)adev->gfx.rlc_fw->data;
+	adev->gfx.rlc.rlc_iram_ucode_size_bytes = le32_to_cpu(rlc_hdr->rlc_iram_ucode_size_bytes);
+	adev->gfx.rlc.rlc_iram_ucode = (u8 *)rlc_hdr + le32_to_cpu(rlc_hdr->rlc_iram_ucode_offset_bytes);
+	adev->gfx.rlc.rlc_dram_ucode_size_bytes = le32_to_cpu(rlc_hdr->rlc_dram_ucode_size_bytes);
+	adev->gfx.rlc.rlc_dram_ucode = (u8 *)rlc_hdr + le32_to_cpu(rlc_hdr->rlc_dram_ucode_offset_bytes);
+}
+
 static bool gfx_v10_0_navi10_gfxoff_should_enable(struct amdgpu_device *adev)
 {
 	bool ret = false;
@@ -3711,8 +3722,6 @@ static int gfx_v10_0_init_microcode(stru
 		rlc_hdr = (const struct rlc_firmware_header_v2_0 *)adev->gfx.rlc_fw->data;
 		version_major = le16_to_cpu(rlc_hdr->header.header_version_major);
 		version_minor = le16_to_cpu(rlc_hdr->header.header_version_minor);
-		if (version_major == 2 && version_minor == 1)
-			adev->gfx.rlc.is_rlc_v2_1 = true;
 
 		adev->gfx.rlc_fw_version = le32_to_cpu(rlc_hdr->header.ucode_version);
 		adev->gfx.rlc_feature_version = le32_to_cpu(rlc_hdr->ucode_feature_version);
@@ -3754,8 +3763,12 @@ static int gfx_v10_0_init_microcode(stru
 		for (i = 0 ; i < (rlc_hdr->reg_list_size_bytes >> 2); i++)
 			adev->gfx.rlc.register_restore[i] = le32_to_cpu(tmp[i]);
 
-		if (adev->gfx.rlc.is_rlc_v2_1)
-			gfx_v10_0_init_rlc_ext_microcode(adev);
+		if (version_major == 2) {
+			if (version_minor >= 1)
+				gfx_v10_0_init_rlc_ext_microcode(adev);
+			if (version_minor == 2)
+				gfx_v10_0_init_rlc_iram_dram_microcode(adev);
+		}
 	}
 
 	snprintf(fw_name, sizeof(fw_name), "amdgpu/%s_mec%s.bin", chip_name, wks);
@@ -3816,8 +3829,7 @@ static int gfx_v10_0_init_microcode(stru
 			adev->firmware.fw_size +=
 				ALIGN(le32_to_cpu(header->ucode_size_bytes), PAGE_SIZE);
 		}
-		if (adev->gfx.rlc.is_rlc_v2_1 &&
-		    adev->gfx.rlc.save_restore_list_cntl_size_bytes &&
+		if (adev->gfx.rlc.save_restore_list_cntl_size_bytes &&
 		    adev->gfx.rlc.save_restore_list_gpm_size_bytes &&
 		    adev->gfx.rlc.save_restore_list_srm_size_bytes) {
 			info = &adev->firmware.ucode[AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL];
@@ -3837,6 +3849,21 @@ static int gfx_v10_0_init_microcode(stru
 			info->fw = adev->gfx.rlc_fw;
 			adev->firmware.fw_size +=
 				ALIGN(adev->gfx.rlc.save_restore_list_srm_size_bytes, PAGE_SIZE);
+
+			if (adev->gfx.rlc.rlc_iram_ucode_size_bytes &&
+			    adev->gfx.rlc.rlc_dram_ucode_size_bytes) {
+				info = &adev->firmware.ucode[AMDGPU_UCODE_ID_RLC_IRAM];
+				info->ucode_id = AMDGPU_UCODE_ID_RLC_IRAM;
+				info->fw = adev->gfx.rlc_fw;
+				adev->firmware.fw_size +=
+					ALIGN(adev->gfx.rlc.rlc_iram_ucode_size_bytes, PAGE_SIZE);
+
+				info = &adev->firmware.ucode[AMDGPU_UCODE_ID_RLC_DRAM];
+				info->ucode_id = AMDGPU_UCODE_ID_RLC_DRAM;
+				info->fw = adev->gfx.rlc_fw;
+				adev->firmware.fw_size +=
+					ALIGN(adev->gfx.rlc.rlc_dram_ucode_size_bytes, PAGE_SIZE);
+			}
 		}
 
 		info = &adev->firmware.ucode[AMDGPU_UCODE_ID_CP_MEC1];
--- a/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h
+++ b/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h
@@ -214,7 +214,7 @@ enum psp_gfx_fw_type {
 	GFX_FW_TYPE_UVD1        = 23,   /* UVD1                     VG-20   */
 	GFX_FW_TYPE_TOC         = 24,   /* TOC                      NV-10   */
 	GFX_FW_TYPE_RLC_P                           = 25,   /* RLC P                    NV      */
-	GFX_FW_TYPE_RLX6                            = 26,   /* RLX6                     NV      */
+	GFX_FW_TYPE_RLC_IRAM                        = 26,   /* RLC_IRAM                 NV      */
 	GFX_FW_TYPE_GLOBAL_TAP_DELAYS               = 27,   /* GLOBAL TAP DELAYS        NV      */
 	GFX_FW_TYPE_SE0_TAP_DELAYS                  = 28,   /* SE0 TAP DELAYS           NV      */
 	GFX_FW_TYPE_SE1_TAP_DELAYS                  = 29,   /* SE1 TAP DELAYS           NV      */
@@ -236,7 +236,7 @@ enum psp_gfx_fw_type {
 	GFX_FW_TYPE_ACCUM_CTRL_RAM                  = 45,   /* ACCUM CTRL RAM           NV      */
 	GFX_FW_TYPE_RLCP_CAM                        = 46,   /* RLCP CAM                 NV      */
 	GFX_FW_TYPE_RLC_SPP_CAM_EXT                 = 47,   /* RLC SPP CAM EXT          NV      */
-	GFX_FW_TYPE_RLX6_DRAM_BOOT                  = 48,   /* RLX6 DRAM BOOT           NV      */
+	GFX_FW_TYPE_RLC_DRAM_BOOT                   = 48,   /* RLC DRAM BOOT            NV      */
 	GFX_FW_TYPE_VCN0_RAM                        = 49,   /* VCN_RAM                  NV + RN */
 	GFX_FW_TYPE_VCN1_RAM                        = 50,   /* VCN_RAM                  NV + RN */
 	GFX_FW_TYPE_DMUB                            = 51,   /* DMUB                          RN */



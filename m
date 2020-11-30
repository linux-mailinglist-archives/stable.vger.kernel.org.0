Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B642E2C8A94
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgK3ROC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgK3ROB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 12:14:01 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC69EC0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:13:21 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id ec16so5966979qvb.0
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qzbYXU7DOeuV2NEmx5zgHAX7AlP7HkSprOb4ZpoKMn8=;
        b=dR4Lqmi5lmvnJSE6IqhxARBZgdyJUhC8zHQCrWzAllGEFWw61TaRvi+cuxY2bDC1J+
         zmMfbSCQGRLB5PPGwEK6O/YYXl8uZ5nA+8WHyTcVHb9xisAQ60fo4NJPj58ENMX7qZeO
         5HIxkEStvvY1r2yh2IOgq8zI9vNZbN5JEWBt8gTjA0TzSy1JoBICq3nx3EXSASPp3ryr
         v5mIl8Z5Ae5G/BMn6TRa9mcFxQErWz5KqQ+z8gdu5loYO4OPkC82/yhnGgy5c6snB9by
         9NJYjCcB+THDkuJDsh2ozDMK1Sx5PadaEta1zR+l5nqjZmf7/0Y5V4No8itXrCDO4Dqs
         I7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qzbYXU7DOeuV2NEmx5zgHAX7AlP7HkSprOb4ZpoKMn8=;
        b=IKVN9WEWRNkXoBAR0IaOqTOOoAhlE56S15N0xqPF2OYQ+NJwl+TpbkHm+NmRHNYgL6
         8K+VOlrJxhulKbdLhW2Bdb+m7YUjaRinIE/VAIzzaxeCispR4vXVcJx8dBpBJ+N0qAQF
         wl8x2oiSf8oxyXJ2wbMWyZoMT3vkPnvQCVWWlal+yYfQPig3hrQbmEQ8PO26T0o66aD5
         dkOPpviDQ5PqxQPd4k3NpINs2Onm8QJrAWIfVcRi2Ee7f+nqH3nc2Lp6HkIgHmjM97HX
         7+FIJUepIx87DHFVKUSYFIEES+q/1aNv42Z7eym3R6FQZmpTw8Y0jdAd4NMDpou2HNHM
         No+g==
X-Gm-Message-State: AOAM532OHqmU8Ysii/tGia1haeLXDMfXDhBElYW1x9aHcJWiK/T2hAUo
        6GMSZ1prKyPGTD5r1qcENkBE2TffwlA=
X-Google-Smtp-Source: ABdhPJysQTdH0bpMr8Vayk4ttKTkxMIoLwYRXGvnfzxrYQlN5yjwo/TzWWHRc46kPc6bb3Xb4yUKmw==
X-Received: by 2002:ad4:44ef:: with SMTP id p15mr23963807qvt.37.1606756400606;
        Mon, 30 Nov 2020 09:13:20 -0800 (PST)
Received: from localhost.localdomain ([192.161.78.5])
        by smtp.gmail.com with ESMTPSA id j63sm15599217qke.67.2020.11.30.09.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 09:13:20 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] drm/amdgpu: add rlc iram and dram firmware support
Date:   Mon, 30 Nov 2020 12:13:12 -0500
Message-Id: <20201130171312.275603-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

Support to load RLC iram and dram ucode when RLC firmware struct use v2.2

Cherry pick the fix from 5.10 (commit 843c7eb2f7571aa092a8ea010c80e8d94c197f67).
This fixes GPU hangs with sienna cichlid boards on 5.9.x.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 843c7eb2f7571aa092a8ea010c80e8d94c197f67)
Cc: stable@vger.kernel.org # 5.9.x
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c   |  6 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h   |  4 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c | 10 ++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h | 11 +++++++
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c    | 39 +++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h   |  4 +--
 6 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 7c787ec598f1..d5e95e4ea5bd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1571,6 +1571,12 @@ static int psp_get_fw_type(struct amdgpu_firmware_info *ucode,
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h
index 60bb3e8b3118..aeaaae713c59 100644
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
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
index 183743c5fb7b..c3cc2e8b2406 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
@@ -500,6 +500,8 @@ static int amdgpu_ucode_init_single_fw(struct amdgpu_device *adev,
 	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL &&
 	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_RESTORE_LIST_GPM_MEM &&
 	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_RESTORE_LIST_SRM_MEM &&
+	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_IRAM &&
+	     ucode->ucode_id != AMDGPU_UCODE_ID_RLC_DRAM &&
 		 ucode->ucode_id != AMDGPU_UCODE_ID_DMCU_ERAM &&
 		 ucode->ucode_id != AMDGPU_UCODE_ID_DMCU_INTV &&
 		 ucode->ucode_id != AMDGPU_UCODE_ID_DMCUB)) {
@@ -556,6 +558,14 @@ static int amdgpu_ucode_init_single_fw(struct amdgpu_device *adev,
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h
index 12a8bc8fca0b..97c78d91fc2f 100644
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
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 3a2af95f2bf0..ed9842960008 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3594,6 +3594,17 @@ static void gfx_v10_0_init_rlc_ext_microcode(struct amdgpu_device *adev)
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
@@ -3709,8 +3720,6 @@ static int gfx_v10_0_init_microcode(struct amdgpu_device *adev)
 		rlc_hdr = (const struct rlc_firmware_header_v2_0 *)adev->gfx.rlc_fw->data;
 		version_major = le16_to_cpu(rlc_hdr->header.header_version_major);
 		version_minor = le16_to_cpu(rlc_hdr->header.header_version_minor);
-		if (version_major == 2 && version_minor == 1)
-			adev->gfx.rlc.is_rlc_v2_1 = true;
 
 		adev->gfx.rlc_fw_version = le32_to_cpu(rlc_hdr->header.ucode_version);
 		adev->gfx.rlc_feature_version = le32_to_cpu(rlc_hdr->ucode_feature_version);
@@ -3752,8 +3761,12 @@ static int gfx_v10_0_init_microcode(struct amdgpu_device *adev)
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
@@ -3814,8 +3827,7 @@ static int gfx_v10_0_init_microcode(struct amdgpu_device *adev)
 			adev->firmware.fw_size +=
 				ALIGN(le32_to_cpu(header->ucode_size_bytes), PAGE_SIZE);
 		}
-		if (adev->gfx.rlc.is_rlc_v2_1 &&
-		    adev->gfx.rlc.save_restore_list_cntl_size_bytes &&
+		if (adev->gfx.rlc.save_restore_list_cntl_size_bytes &&
 		    adev->gfx.rlc.save_restore_list_gpm_size_bytes &&
 		    adev->gfx.rlc.save_restore_list_srm_size_bytes) {
 			info = &adev->firmware.ucode[AMDGPU_UCODE_ID_RLC_RESTORE_LIST_CNTL];
@@ -3835,6 +3847,21 @@ static int gfx_v10_0_init_microcode(struct amdgpu_device *adev)
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
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h b/drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h
index cbc04a5c0fe1..baf994627b0d 100644
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
-- 
2.25.4


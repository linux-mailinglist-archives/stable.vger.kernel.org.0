Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C61E2A5273
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgKCUuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbgKCUuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71065223FD;
        Tue,  3 Nov 2020 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436607;
        bh=M0M5L6jJ7oOzGCUFckIiq9vKoBHSwpZUBUI8pFnHi+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ef5e8uDuoKXZj80R7X/ZSASuB6RJA/JpV/bC9NJ/Ou/cYyoubuK+CN7u5iiyeflD7
         HiejUIpB0dLNhO8L4L6yscqZVtxViXnmD1u8AXXeHeJ4I/4S+e9hkwayIrUHMdinjt
         uiHxfMSTe0HVfxB/MoUtbynkNm3PDY0E3NOvu9TA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 324/391] drm/amdgpu: add function to program pbb mode for sienna cichlid
Date:   Tue,  3 Nov 2020 21:36:15 +0100
Message-Id: <20201103203408.988145335@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

commit 274c240c760ed4647ddae1f1b994e0dd3f71cbb1 upstream.

Add function for sienna_cichlid to force PBB workload mode to zero by
checking whether there have SE been harvested.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |   62 +++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -112,6 +112,22 @@
 #define mmCP_HYP_ME_UCODE_DATA			0x5817
 #define mmCP_HYP_ME_UCODE_DATA_BASE_IDX		1
 
+//CC_GC_SA_UNIT_DISABLE
+#define mmCC_GC_SA_UNIT_DISABLE                 0x0fe9
+#define mmCC_GC_SA_UNIT_DISABLE_BASE_IDX        0
+#define CC_GC_SA_UNIT_DISABLE__SA_DISABLE__SHIFT	0x8
+#define CC_GC_SA_UNIT_DISABLE__SA_DISABLE_MASK		0x0000FF00L
+//GC_USER_SA_UNIT_DISABLE
+#define mmGC_USER_SA_UNIT_DISABLE               0x0fea
+#define mmGC_USER_SA_UNIT_DISABLE_BASE_IDX      0
+#define GC_USER_SA_UNIT_DISABLE__SA_DISABLE__SHIFT	0x8
+#define GC_USER_SA_UNIT_DISABLE__SA_DISABLE_MASK	0x0000FF00L
+//PA_SC_ENHANCE_3
+#define mmPA_SC_ENHANCE_3                       0x1085
+#define mmPA_SC_ENHANCE_3_BASE_IDX              0
+#define PA_SC_ENHANCE_3__FORCE_PBB_WORKLOAD_MODE_TO_ZERO__SHIFT 0x3
+#define PA_SC_ENHANCE_3__FORCE_PBB_WORKLOAD_MODE_TO_ZERO_MASK   0x00000008L
+
 MODULE_FIRMWARE("amdgpu/navi10_ce.bin");
 MODULE_FIRMWARE("amdgpu/navi10_pfp.bin");
 MODULE_FIRMWARE("amdgpu/navi10_me.bin");
@@ -3189,6 +3205,8 @@ static int gfx_v10_0_wait_for_rlc_autolo
 static void gfx_v10_0_ring_emit_ce_meta(struct amdgpu_ring *ring, bool resume);
 static void gfx_v10_0_ring_emit_de_meta(struct amdgpu_ring *ring, bool resume);
 static void gfx_v10_0_ring_emit_frame_cntl(struct amdgpu_ring *ring, bool start, bool secure);
+static u32 gfx_v10_3_get_disabled_sa(struct amdgpu_device *adev);
+static void gfx_v10_3_program_pbb_mode(struct amdgpu_device *adev);
 
 static void gfx10_kiq_set_resources(struct amdgpu_ring *kiq_ring, uint64_t queue_mask)
 {
@@ -6929,6 +6947,9 @@ static int gfx_v10_0_hw_init(void *handl
 	if (r)
 		return r;
 
+	if (adev->asic_type == CHIP_SIENNA_CICHLID)
+		gfx_v10_3_program_pbb_mode(adev);
+
 	return r;
 }
 
@@ -8774,6 +8795,47 @@ static int gfx_v10_0_get_cu_info(struct
 	return 0;
 }
 
+static u32 gfx_v10_3_get_disabled_sa(struct amdgpu_device *adev)
+{
+	uint32_t efuse_setting, vbios_setting, disabled_sa, max_sa_mask;
+
+	efuse_setting = RREG32_SOC15(GC, 0, mmCC_GC_SA_UNIT_DISABLE);
+	efuse_setting &= CC_GC_SA_UNIT_DISABLE__SA_DISABLE_MASK;
+	efuse_setting >>= CC_GC_SA_UNIT_DISABLE__SA_DISABLE__SHIFT;
+
+	vbios_setting = RREG32_SOC15(GC, 0, mmGC_USER_SA_UNIT_DISABLE);
+	vbios_setting &= GC_USER_SA_UNIT_DISABLE__SA_DISABLE_MASK;
+	vbios_setting >>= GC_USER_SA_UNIT_DISABLE__SA_DISABLE__SHIFT;
+
+	max_sa_mask = amdgpu_gfx_create_bitmask(adev->gfx.config.max_sh_per_se *
+						adev->gfx.config.max_shader_engines);
+	disabled_sa = efuse_setting | vbios_setting;
+	disabled_sa &= max_sa_mask;
+
+	return disabled_sa;
+}
+
+static void gfx_v10_3_program_pbb_mode(struct amdgpu_device *adev)
+{
+	uint32_t max_sa_per_se, max_sa_per_se_mask, max_shader_engines;
+	uint32_t disabled_sa_mask, se_index, disabled_sa_per_se;
+
+	disabled_sa_mask = gfx_v10_3_get_disabled_sa(adev);
+
+	max_sa_per_se = adev->gfx.config.max_sh_per_se;
+	max_sa_per_se_mask = (1 << max_sa_per_se) - 1;
+	max_shader_engines = adev->gfx.config.max_shader_engines;
+
+	for (se_index = 0; max_shader_engines > se_index; se_index++) {
+		disabled_sa_per_se = disabled_sa_mask >> (se_index * max_sa_per_se);
+		disabled_sa_per_se &= max_sa_per_se_mask;
+		if (disabled_sa_per_se == max_sa_per_se_mask) {
+			WREG32_FIELD15(GC, 0, PA_SC_ENHANCE_3, FORCE_PBB_WORKLOAD_MODE_TO_ZERO, 1);
+			break;
+		}
+	}
+}
+
 const struct amdgpu_ip_block_version gfx_v10_0_ip_block =
 {
 	.type = AMD_IP_BLOCK_TYPE_GFX,



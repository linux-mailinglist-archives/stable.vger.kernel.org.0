Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6497C2A4B79
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgKCQ3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCQ3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:19 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6506AC0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:19 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id p12so4677493qtp.7
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X4XLnXqLe8VVRDp3ArnV+Ys5x9DbZpqiGSfOxKKlJBc=;
        b=VeIKe7ZPhzB0q0J/U2MunPll3a5yOeEYmho/FZZ4e2U7aVKsFWBksDqxzlovxcH+Az
         IpK4gnTYY647p7t7f6iux1+YNz5y+mOPFshCeaEUPt00OmJs3JB+8nEYYM3753i8HjpH
         J182nhMvvdFfL3fHqQEECVNin57PcNzZ8jY/GOBZVGjJqm4MNNEY7ThGINmjIRLdkzqf
         uJeEXP3hTj8SD6gvYBJQ6U9AqZG3JUQG+cd2vGUOFqYpQrZiOCYlJkY1BSGI0TVa02Uu
         DiZjySZ5sc1HttJhQNcbJgsBXukgYCUYF5iaffY7ygSRYbMqh7hQeF1ZdlKjGqwcqeW9
         q/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4XLnXqLe8VVRDp3ArnV+Ys5x9DbZpqiGSfOxKKlJBc=;
        b=Qx5jeur455dR7U/03YgJQfb5Q1ybJ4AJurgFyT+yQTBUXLJ6+Sx5BjQkRrUB8pg2am
         bJ06A3A24ZEuEL0dIeJ1PMzNyM4z9UMI41jj9y5beNiylBqxXcjSK3gnLOSXbRTphiUQ
         YJTnIv1BKepd+CG2UfA587ZRpGQ0/SWItdaIrUliGbokkxAGn0f1ClcCddHuxOeW32s+
         vDHS1IdeL5EpQFZBoMWoShLcJayo0z1Wvupp9dO88V3meEE7kziH3mdFr97X03NhWCLk
         lsY5VKi+cj8x2UTOr+1ZJdE+/jbM6Uo/nrklraJbjsYqOjVkwjtCujp5IqgeoPdwbgtu
         KesA==
X-Gm-Message-State: AOAM532F0+v26CQIfIxAApYsEubdbBmroHUiDkkYsPXEMbSQdbmAZ8Yl
        c1uM7ip5Xza4DY8uazq65VKcX9eaJfc=
X-Google-Smtp-Source: ABdhPJzzwFkRsv/G0Y2VwtBKkL10bfQV39jH9ujTchhJshjnZkqXYlNOTgQZCuVnqAUsWQe685yd9w==
X-Received: by 2002:ac8:728b:: with SMTP id v11mr19633106qto.373.1604420958431;
        Tue, 03 Nov 2020 08:29:18 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:17 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5/7] drm/amdgpu: add function to program pbb mode for sienna cichlid
Date:   Tue,  3 Nov 2020 11:29:01 -0500
Message-Id: <20201103162903.687752-7-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

Add function for sienna_cichlid to force PBB workload mode to zero by
checking whether there have SE been harvested.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
(cherry picked from commit 274c240c760ed4647ddae1f1b994e0dd3f71cbb1)
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 62 ++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index f73ce9721233..b1cb7bf5dd10 100644
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
@@ -3188,6 +3204,8 @@ static int gfx_v10_0_wait_for_rlc_autoload_complete(struct amdgpu_device *adev);
 static void gfx_v10_0_ring_emit_ce_meta(struct amdgpu_ring *ring, bool resume);
 static void gfx_v10_0_ring_emit_de_meta(struct amdgpu_ring *ring, bool resume);
 static void gfx_v10_0_ring_emit_frame_cntl(struct amdgpu_ring *ring, bool start, bool secure);
+static u32 gfx_v10_3_get_disabled_sa(struct amdgpu_device *adev);
+static void gfx_v10_3_program_pbb_mode(struct amdgpu_device *adev);
 
 static void gfx10_kiq_set_resources(struct amdgpu_ring *kiq_ring, uint64_t queue_mask)
 {
@@ -6928,6 +6946,9 @@ static int gfx_v10_0_hw_init(void *handle)
 	if (r)
 		return r;
 
+	if (adev->asic_type == CHIP_SIENNA_CICHLID)
+		gfx_v10_3_program_pbb_mode(adev);
+
 	return r;
 }
 
@@ -8773,6 +8794,47 @@ static int gfx_v10_0_get_cu_info(struct amdgpu_device *adev,
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
-- 
2.25.4


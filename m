Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9508462710
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhK2XA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbhK2XAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57355C14327A;
        Mon, 29 Nov 2021 10:33:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DFFBCE140F;
        Mon, 29 Nov 2021 18:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0977FC53FAD;
        Mon, 29 Nov 2021 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210801;
        bh=rgIbLQdqvRjM1rZ+jiORAqqJhH76nQZkDiV/jxBzgF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNytONijIx/yrWs0JOevde/Mz5myNRtxFhYg73lL361z0/pk4rDs/GBDszYfCXHAm
         /GacnORvJ2Xo7Qd3NPLoZm3JOKqfbfQbS/FeVLbcqmJlUEidYphCxyCpxnjwVp8eKj
         Bx8coKWvabdVyfYhxPG/Czm218ASNhkON1nb5RNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 121/121] drm/amdgpu/gfx9: switch to golden tsc registers for renoir+
Date:   Mon, 29 Nov 2021 19:19:12 +0100
Message-Id: <20211129181715.729243065@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 53af98c091bc42fd9ec64cfabc40da4e5f3aae93 upstream.

Renoir and newer gfx9 APUs have new TSC register that is
not part of the gfxoff tile, so it can be read without
needing to disable gfx off.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   46 +++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -137,6 +137,11 @@ MODULE_FIRMWARE("amdgpu/green_sardine_rl
 #define mmTCP_CHAN_STEER_5_ARCT								0x0b0c
 #define mmTCP_CHAN_STEER_5_ARCT_BASE_IDX							0
 
+#define mmGOLDEN_TSC_COUNT_UPPER_Renoir                0x0025
+#define mmGOLDEN_TSC_COUNT_UPPER_Renoir_BASE_IDX       1
+#define mmGOLDEN_TSC_COUNT_LOWER_Renoir                0x0026
+#define mmGOLDEN_TSC_COUNT_LOWER_Renoir_BASE_IDX       1
+
 enum ta_ras_gfx_subblock {
 	/*CPC*/
 	TA_RAS_BLOCK__GFX_CPC_INDEX_START = 0,
@@ -4147,19 +4152,38 @@ failed_kiq_read:
 
 static uint64_t gfx_v9_0_get_gpu_clock_counter(struct amdgpu_device *adev)
 {
-	uint64_t clock;
+	uint64_t clock, clock_lo, clock_hi, hi_check;
 
-	amdgpu_gfx_off_ctrl(adev, false);
-	mutex_lock(&adev->gfx.gpu_clock_mutex);
-	if (adev->asic_type == CHIP_VEGA10 && amdgpu_sriov_runtime(adev)) {
-		clock = gfx_v9_0_kiq_read_clock(adev);
-	} else {
-		WREG32_SOC15(GC, 0, mmRLC_CAPTURE_GPU_CLOCK_COUNT, 1);
-		clock = (uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_LSB) |
-			((uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_MSB) << 32ULL);
+	switch (adev->asic_type) {
+	case CHIP_RENOIR:
+		preempt_disable();
+		clock_hi = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Renoir);
+		clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Renoir);
+		hi_check = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Renoir);
+		/* The SMUIO TSC clock frequency is 100MHz, which sets 32-bit carry over
+		 * roughly every 42 seconds.
+		 */
+		if (hi_check != clock_hi) {
+			clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Renoir);
+			clock_hi = hi_check;
+		}
+		preempt_enable();
+		clock = clock_lo | (clock_hi << 32ULL);
+		break;
+	default:
+		amdgpu_gfx_off_ctrl(adev, false);
+		mutex_lock(&adev->gfx.gpu_clock_mutex);
+		if (adev->asic_type == CHIP_VEGA10 && amdgpu_sriov_runtime(adev)) {
+			clock = gfx_v9_0_kiq_read_clock(adev);
+		} else {
+			WREG32_SOC15(GC, 0, mmRLC_CAPTURE_GPU_CLOCK_COUNT, 1);
+			clock = (uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_LSB) |
+				((uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_MSB) << 32ULL);
+		}
+		mutex_unlock(&adev->gfx.gpu_clock_mutex);
+		amdgpu_gfx_off_ctrl(adev, true);
+		break;
 	}
-	mutex_unlock(&adev->gfx.gpu_clock_mutex);
-	amdgpu_gfx_off_ctrl(adev, true);
 	return clock;
 }
 



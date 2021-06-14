Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7F3A645C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhFNLYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233337AbhFNLV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F7C661998;
        Mon, 14 Jun 2021 10:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667935;
        bh=xHxi8JEqYzTa0aIIAmiVy3nLuOuZIKFDrcdC6K0KCJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U21q2dQY2/GZ/KPqmYwiCNMw598KiN9dEU+IlwOVHV7c/k3ilUnVkoIlrslsiDM4C
         eXtSRJvNybXfA5hDYhOvNi2EJXYncvMQPvt1YCDWsrHNbgeTMCU2/YjQvrM0LjdVFC
         k+8QKD7z0d+68NKEd6otWoOZgkFNcPing2ymZHp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.12 131/173] drm/msm/a6xx: update/fix CP_PROTECT initialization
Date:   Mon, 14 Jun 2021 12:27:43 +0200
Message-Id: <20210614102702.528912352@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

commit 408434036958699a7f50ddec984f7ba33e11a8f5 upstream.

Update CP_PROTECT register programming based on downstream.

A6XX_PROTECT_RW is renamed to A6XX_PROTECT_NORDWR to make things aligned
and also be more clear about what it does.

Note that this required switching to use the CP_ALWAYS_ON_COUNTER as the
GMU counter is not accessible from the cmdstream.  Which also means
using the CPU counter for the msm_gpu_submit_flush() tracepoint (as
catapult depends on being able to compare this to the start/end values
captured in cmdstream).  This may need to be revisited when IFPC is
enabled.

Also, compared to downstream, this opens up CP_PERFCTR_CP_SEL as the
userspace performance tooling (fdperf and pps-producer) expect to be
able to configure the CP counters.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20210513171431.18632-5-jonathan@marek.ca
[switch to CP_ALWAYS_ON_COUNTER, open up CP_PERFCNTR_CP_SEL, and spiff
 up commit msg]
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |  151 +++++++++++++++++++++++++---------
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h |    2 
 2 files changed, 113 insertions(+), 40 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -157,7 +157,7 @@ static void a6xx_submit(struct msm_gpu *
 	 * GPU registers so we need to add 0x1a800 to the register value on A630
 	 * to get the right value from PM4.
 	 */
-	get_stats_counter(ring, REG_A6XX_GMU_ALWAYS_ON_COUNTER_L + 0x1a800,
+	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_COUNTER_LO,
 		rbmemptr_stats(ring, index, alwayson_start));
 
 	/* Invalidate CCU depth and color */
@@ -187,7 +187,7 @@ static void a6xx_submit(struct msm_gpu *
 
 	get_stats_counter(ring, REG_A6XX_RBBM_PERFCTR_CP_0_LO,
 		rbmemptr_stats(ring, index, cpcycles_end));
-	get_stats_counter(ring, REG_A6XX_GMU_ALWAYS_ON_COUNTER_L + 0x1a800,
+	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_COUNTER_LO,
 		rbmemptr_stats(ring, index, alwayson_end));
 
 	/* Write the fence to the scratch register */
@@ -206,8 +206,8 @@ static void a6xx_submit(struct msm_gpu *
 	OUT_RING(ring, submit->seqno);
 
 	trace_msm_gpu_submit_flush(submit,
-		gmu_read64(&a6xx_gpu->gmu, REG_A6XX_GMU_ALWAYS_ON_COUNTER_L,
-			REG_A6XX_GMU_ALWAYS_ON_COUNTER_H));
+		gpu_read64(gpu, REG_A6XX_CP_ALWAYS_ON_COUNTER_LO,
+			REG_A6XX_CP_ALWAYS_ON_COUNTER_HI));
 
 	a6xx_flush(gpu, ring);
 }
@@ -462,6 +462,113 @@ static void a6xx_set_hwcg(struct msm_gpu
 	gpu_write(gpu, REG_A6XX_RBBM_CLOCK_CNTL, state ? clock_cntl_on : 0);
 }
 
+/* For a615, a616, a618, A619, a630, a640 and a680 */
+static const u32 a6xx_protect[] = {
+	A6XX_PROTECT_RDONLY(0x00000, 0x04ff),
+	A6XX_PROTECT_RDONLY(0x00501, 0x0005),
+	A6XX_PROTECT_RDONLY(0x0050b, 0x02f4),
+	A6XX_PROTECT_NORDWR(0x0050e, 0x0000),
+	A6XX_PROTECT_NORDWR(0x00510, 0x0000),
+	A6XX_PROTECT_NORDWR(0x00534, 0x0000),
+	A6XX_PROTECT_NORDWR(0x00800, 0x0082),
+	A6XX_PROTECT_NORDWR(0x008a0, 0x0008),
+	A6XX_PROTECT_NORDWR(0x008ab, 0x0024),
+	A6XX_PROTECT_RDONLY(0x008de, 0x00ae),
+	A6XX_PROTECT_NORDWR(0x00900, 0x004d),
+	A6XX_PROTECT_NORDWR(0x0098d, 0x0272),
+	A6XX_PROTECT_NORDWR(0x00e00, 0x0001),
+	A6XX_PROTECT_NORDWR(0x00e03, 0x000c),
+	A6XX_PROTECT_NORDWR(0x03c00, 0x00c3),
+	A6XX_PROTECT_RDONLY(0x03cc4, 0x1fff),
+	A6XX_PROTECT_NORDWR(0x08630, 0x01cf),
+	A6XX_PROTECT_NORDWR(0x08e00, 0x0000),
+	A6XX_PROTECT_NORDWR(0x08e08, 0x0000),
+	A6XX_PROTECT_NORDWR(0x08e50, 0x001f),
+	A6XX_PROTECT_NORDWR(0x09624, 0x01db),
+	A6XX_PROTECT_NORDWR(0x09e70, 0x0001),
+	A6XX_PROTECT_NORDWR(0x09e78, 0x0187),
+	A6XX_PROTECT_NORDWR(0x0a630, 0x01cf),
+	A6XX_PROTECT_NORDWR(0x0ae02, 0x0000),
+	A6XX_PROTECT_NORDWR(0x0ae50, 0x032f),
+	A6XX_PROTECT_NORDWR(0x0b604, 0x0000),
+	A6XX_PROTECT_NORDWR(0x0be02, 0x0001),
+	A6XX_PROTECT_NORDWR(0x0be20, 0x17df),
+	A6XX_PROTECT_NORDWR(0x0f000, 0x0bff),
+	A6XX_PROTECT_RDONLY(0x0fc00, 0x1fff),
+	A6XX_PROTECT_NORDWR(0x11c00, 0x0000), /* note: infinite range */
+};
+
+/* These are for a620 and a650 */
+static const u32 a650_protect[] = {
+	A6XX_PROTECT_RDONLY(0x00000, 0x04ff),
+	A6XX_PROTECT_RDONLY(0x00501, 0x0005),
+	A6XX_PROTECT_RDONLY(0x0050b, 0x02f4),
+	A6XX_PROTECT_NORDWR(0x0050e, 0x0000),
+	A6XX_PROTECT_NORDWR(0x00510, 0x0000),
+	A6XX_PROTECT_NORDWR(0x00534, 0x0000),
+	A6XX_PROTECT_NORDWR(0x00800, 0x0082),
+	A6XX_PROTECT_NORDWR(0x008a0, 0x0008),
+	A6XX_PROTECT_NORDWR(0x008ab, 0x0024),
+	A6XX_PROTECT_RDONLY(0x008de, 0x00ae),
+	A6XX_PROTECT_NORDWR(0x00900, 0x004d),
+	A6XX_PROTECT_NORDWR(0x0098d, 0x0272),
+	A6XX_PROTECT_NORDWR(0x00e00, 0x0001),
+	A6XX_PROTECT_NORDWR(0x00e03, 0x000c),
+	A6XX_PROTECT_NORDWR(0x03c00, 0x00c3),
+	A6XX_PROTECT_RDONLY(0x03cc4, 0x1fff),
+	A6XX_PROTECT_NORDWR(0x08630, 0x01cf),
+	A6XX_PROTECT_NORDWR(0x08e00, 0x0000),
+	A6XX_PROTECT_NORDWR(0x08e08, 0x0000),
+	A6XX_PROTECT_NORDWR(0x08e50, 0x001f),
+	A6XX_PROTECT_NORDWR(0x08e80, 0x027f),
+	A6XX_PROTECT_NORDWR(0x09624, 0x01db),
+	A6XX_PROTECT_NORDWR(0x09e60, 0x0011),
+	A6XX_PROTECT_NORDWR(0x09e78, 0x0187),
+	A6XX_PROTECT_NORDWR(0x0a630, 0x01cf),
+	A6XX_PROTECT_NORDWR(0x0ae02, 0x0000),
+	A6XX_PROTECT_NORDWR(0x0ae50, 0x032f),
+	A6XX_PROTECT_NORDWR(0x0b604, 0x0000),
+	A6XX_PROTECT_NORDWR(0x0b608, 0x0007),
+	A6XX_PROTECT_NORDWR(0x0be02, 0x0001),
+	A6XX_PROTECT_NORDWR(0x0be20, 0x17df),
+	A6XX_PROTECT_NORDWR(0x0f000, 0x0bff),
+	A6XX_PROTECT_RDONLY(0x0fc00, 0x1fff),
+	A6XX_PROTECT_NORDWR(0x18400, 0x1fff),
+	A6XX_PROTECT_NORDWR(0x1a800, 0x1fff),
+	A6XX_PROTECT_NORDWR(0x1f400, 0x0443),
+	A6XX_PROTECT_RDONLY(0x1f844, 0x007b),
+	A6XX_PROTECT_NORDWR(0x1f887, 0x001b),
+	A6XX_PROTECT_NORDWR(0x1f8c0, 0x0000), /* note: infinite range */
+};
+
+static void a6xx_set_cp_protect(struct msm_gpu *gpu)
+{
+	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	const u32 *regs = a6xx_protect;
+	unsigned i, count = ARRAY_SIZE(a6xx_protect), count_max = 32;
+
+	BUILD_BUG_ON(ARRAY_SIZE(a6xx_protect) > 32);
+	BUILD_BUG_ON(ARRAY_SIZE(a650_protect) > 48);
+
+	if (adreno_is_a650(adreno_gpu)) {
+		regs = a650_protect;
+		count = ARRAY_SIZE(a650_protect);
+		count_max = 48;
+	}
+
+	/*
+	 * Enable access protection to privileged registers, fault on an access
+	 * protect violation and select the last span to protect from the start
+	 * address all the way to the end of the register address space
+	 */
+	gpu_write(gpu, REG_A6XX_CP_PROTECT_CNTL, BIT(0) | BIT(1) | BIT(3));
+
+	for (i = 0; i < count - 1; i++)
+		gpu_write(gpu, REG_A6XX_CP_PROTECT(i), regs[i]);
+	/* last CP_PROTECT to have "infinite" length on the last entry */
+	gpu_write(gpu, REG_A6XX_CP_PROTECT(count_max - 1), regs[i]);
+}
+
 static void a6xx_set_ubwc_config(struct msm_gpu *gpu)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
@@ -776,41 +883,7 @@ static int a6xx_hw_init(struct msm_gpu *
 	}
 
 	/* Protect registers from the CP */
-	gpu_write(gpu, REG_A6XX_CP_PROTECT_CNTL, 0x00000003);
-
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(0),
-		A6XX_PROTECT_RDONLY(0x600, 0x51));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(1), A6XX_PROTECT_RW(0xae50, 0x2));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(2), A6XX_PROTECT_RW(0x9624, 0x13));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(3), A6XX_PROTECT_RW(0x8630, 0x8));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(4), A6XX_PROTECT_RW(0x9e70, 0x1));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(5), A6XX_PROTECT_RW(0x9e78, 0x187));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(6), A6XX_PROTECT_RW(0xf000, 0x810));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(7),
-		A6XX_PROTECT_RDONLY(0xfc00, 0x3));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(8), A6XX_PROTECT_RW(0x50e, 0x0));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(9), A6XX_PROTECT_RDONLY(0x50f, 0x0));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(10), A6XX_PROTECT_RW(0x510, 0x0));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(11),
-		A6XX_PROTECT_RDONLY(0x0, 0x4f9));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(12),
-		A6XX_PROTECT_RDONLY(0x501, 0xa));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(13),
-		A6XX_PROTECT_RDONLY(0x511, 0x44));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(14), A6XX_PROTECT_RW(0xe00, 0xe));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(15), A6XX_PROTECT_RW(0x8e00, 0x0));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(16), A6XX_PROTECT_RW(0x8e50, 0xf));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(17), A6XX_PROTECT_RW(0xbe02, 0x0));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(18),
-		A6XX_PROTECT_RW(0xbe20, 0x11f3));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(19), A6XX_PROTECT_RW(0x800, 0x82));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(20), A6XX_PROTECT_RW(0x8a0, 0x8));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(21), A6XX_PROTECT_RW(0x8ab, 0x19));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(22), A6XX_PROTECT_RW(0x900, 0x4d));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(23), A6XX_PROTECT_RW(0x98d, 0x76));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(24),
-			A6XX_PROTECT_RDONLY(0x980, 0x4));
-	gpu_write(gpu, REG_A6XX_CP_PROTECT(25), A6XX_PROTECT_RW(0xa630, 0x0));
+	a6xx_set_cp_protect(gpu);
 
 	/* Enable expanded apriv for targets that support it */
 	if (gpu->hw_apriv) {
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
@@ -44,7 +44,7 @@ struct a6xx_gpu {
  * REG_CP_PROTECT_REG(n) - this will block both reads and writes for _len
  * registers starting at _reg.
  */
-#define A6XX_PROTECT_RW(_reg, _len) \
+#define A6XX_PROTECT_NORDWR(_reg, _len) \
 	((1 << 31) | \
 	(((_len) & 0x3FFF) << 18) | ((_reg) & 0x3FFFF))
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079F026B5AD
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgIOXtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgIOOcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40C5E222C2;
        Tue, 15 Sep 2020 14:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179836;
        bh=h6r8NFBBbm945KO1c9CosYTgXjjM/qum3IfRrUdzCSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iA4XUxYorGSmEBlsoGJqQXUHCewFXMWt3NOTU5L9JfvvsVFFsh+B7D+9HFdlMBkE4
         JZ7ycxdzUJDJrRICnwpthRsPgnSy0a80CvROVn/Xe4CS7BIRwLWqZKmWI18z9iJsm+
         VMSBlSk6tOdGSP3Nve5SFhXcsz+uGWeuxLgQLnG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/132] drm/msm/a6xx: update a6xx_hw_init for A640 and A650
Date:   Tue, 15 Sep 2020 16:13:52 +0200
Message-Id: <20200915140650.616772685@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 24e6938ec604b7dc0306c972c1aa029ff03bb36a ]

Adreno 640 and 650 GPUs need some registers set differently.

Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx.xml.h | 14 +++++++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 55 ++++++++++++++++++++++-----
 2 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx.xml.h b/drivers/gpu/drm/msm/adreno/a6xx.xml.h
index f44553ec31935..9121aceb0f97c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx.xml.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx.xml.h
@@ -1047,6 +1047,8 @@ enum a6xx_tex_type {
 
 #define REG_A6XX_CP_MISC_CNTL					0x00000840
 
+#define REG_A6XX_CP_APRIV_CNTL					0x00000844
+
 #define REG_A6XX_CP_ROQ_THRESHOLDS_1				0x000008c1
 
 #define REG_A6XX_CP_ROQ_THRESHOLDS_2				0x000008c2
@@ -1764,6 +1766,8 @@ static inline uint32_t A6XX_CP_PROTECT_REG_MASK_LEN(uint32_t val)
 
 #define REG_A6XX_RBBM_VBIF_CLIENT_QOS_CNTL			0x00000010
 
+#define REG_A6XX_RBBM_GBIF_CLIENT_QOS_CNTL			0x00000011
+
 #define REG_A6XX_RBBM_INTERFACE_HANG_INT_CNTL			0x0000001f
 
 #define REG_A6XX_RBBM_INT_CLEAR_CMD				0x00000037
@@ -2418,6 +2422,16 @@ static inline uint32_t A6XX_UCHE_CLIENT_PF_PERFSEL(uint32_t val)
 
 #define REG_A6XX_TPL1_NC_MODE_CNTL				0x0000b604
 
+#define REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_0			0x0000b608
+
+#define REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_1			0x0000b609
+
+#define REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_2			0x0000b60a
+
+#define REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_3			0x0000b60b
+
+#define REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_4			0x0000b60c
+
 #define REG_A6XX_TPL1_PERFCTR_TP_SEL_0				0x0000b610
 
 #define REG_A6XX_TPL1_PERFCTR_TP_SEL_1				0x0000b611
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index be68d4e6551c2..c3a81594f4fb7 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -411,7 +411,16 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 
 	/* VBIF start */
 	gpu_write(gpu, REG_A6XX_VBIF_GATE_OFF_WRREQ_EN, 0x00000009);
-	gpu_write(gpu, REG_A6XX_RBBM_VBIF_CLIENT_QOS_CNTL, 0x3);
+	if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu)) {
+		gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE0, 0x00071620);
+		gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE1, 0x00071620);
+		gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE2, 0x00071620);
+		gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE3, 0x00071620);
+		gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE3, 0x00071620);
+		gpu_write(gpu, REG_A6XX_RBBM_GBIF_CLIENT_QOS_CNTL, 0x3);
+	} else {
+		gpu_write(gpu, REG_A6XX_RBBM_VBIF_CLIENT_QOS_CNTL, 0x3);
+	}
 
 	/* Make all blocks contribute to the GPU BUSY perf counter */
 	gpu_write(gpu, REG_A6XX_RBBM_PERFCTR_GPU_BUSY_MASKED, 0xffffffff);
@@ -424,25 +433,35 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 	gpu_write(gpu, REG_A6XX_UCHE_WRITE_THRU_BASE_LO, 0xfffff000);
 	gpu_write(gpu, REG_A6XX_UCHE_WRITE_THRU_BASE_HI, 0x0001ffff);
 
-	/* Set the GMEM VA range [0x100000:0x100000 + gpu->gmem - 1] */
-	gpu_write64(gpu, REG_A6XX_UCHE_GMEM_RANGE_MIN_LO,
-		REG_A6XX_UCHE_GMEM_RANGE_MIN_HI, 0x00100000);
+	if (!adreno_is_a650(adreno_gpu)) {
+		/* Set the GMEM VA range [0x100000:0x100000 + gpu->gmem - 1] */
+		gpu_write64(gpu, REG_A6XX_UCHE_GMEM_RANGE_MIN_LO,
+			REG_A6XX_UCHE_GMEM_RANGE_MIN_HI, 0x00100000);
 
-	gpu_write64(gpu, REG_A6XX_UCHE_GMEM_RANGE_MAX_LO,
-		REG_A6XX_UCHE_GMEM_RANGE_MAX_HI,
-		0x00100000 + adreno_gpu->gmem - 1);
+		gpu_write64(gpu, REG_A6XX_UCHE_GMEM_RANGE_MAX_LO,
+			REG_A6XX_UCHE_GMEM_RANGE_MAX_HI,
+			0x00100000 + adreno_gpu->gmem - 1);
+	}
 
 	gpu_write(gpu, REG_A6XX_UCHE_FILTER_CNTL, 0x804);
 	gpu_write(gpu, REG_A6XX_UCHE_CACHE_WAYS, 0x4);
 
-	gpu_write(gpu, REG_A6XX_CP_ROQ_THRESHOLDS_2, 0x010000c0);
+	if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu))
+		gpu_write(gpu, REG_A6XX_CP_ROQ_THRESHOLDS_2, 0x02000140);
+	else
+		gpu_write(gpu, REG_A6XX_CP_ROQ_THRESHOLDS_2, 0x010000c0);
 	gpu_write(gpu, REG_A6XX_CP_ROQ_THRESHOLDS_1, 0x8040362c);
 
 	/* Setting the mem pool size */
 	gpu_write(gpu, REG_A6XX_CP_MEM_POOL_SIZE, 128);
 
 	/* Setting the primFifo thresholds default values */
-	gpu_write(gpu, REG_A6XX_PC_DBG_ECO_CNTL, (0x300 << 11));
+	if (adreno_is_a650(adreno_gpu))
+		gpu_write(gpu, REG_A6XX_PC_DBG_ECO_CNTL, 0x00300000);
+	else if (adreno_is_a640(adreno_gpu))
+		gpu_write(gpu, REG_A6XX_PC_DBG_ECO_CNTL, 0x00200000);
+	else
+		gpu_write(gpu, REG_A6XX_PC_DBG_ECO_CNTL, (0x300 << 11));
 
 	/* Set the AHB default slave response to "ERROR" */
 	gpu_write(gpu, REG_A6XX_CP_AHB_CNTL, 0x1);
@@ -464,6 +483,19 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 
 	gpu_write(gpu, REG_A6XX_UCHE_CLIENT_PF, 1);
 
+	/* Set weights for bicubic filtering */
+	if (adreno_is_a650(adreno_gpu)) {
+		gpu_write(gpu, REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_0, 0);
+		gpu_write(gpu, REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_1,
+			0x3fe05ff4);
+		gpu_write(gpu, REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_2,
+			0x3fa0ebee);
+		gpu_write(gpu, REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_3,
+			0x3f5193ed);
+		gpu_write(gpu, REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE_4,
+			0x3f0243f0);
+	}
+
 	/* Protect registers from the CP */
 	gpu_write(gpu, REG_A6XX_CP_PROTECT_CNTL, 0x00000003);
 
@@ -501,6 +533,11 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 			A6XX_PROTECT_RDONLY(0x980, 0x4));
 	gpu_write(gpu, REG_A6XX_CP_PROTECT(25), A6XX_PROTECT_RW(0xa630, 0x0));
 
+	if (adreno_is_a650(adreno_gpu)) {
+		gpu_write(gpu, REG_A6XX_CP_APRIV_CNTL,
+			(1 << 6) | (1 << 5) | (1 << 3) | (1 << 2) | (1 << 1));
+	}
+
 	/* Enable interrupts */
 	gpu_write(gpu, REG_A6XX_RBBM_INT_0_MASK, A6XX_INT_MASK);
 
-- 
2.25.1




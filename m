Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BE66D9AA
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfGSD5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbfGSD5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940EF2082E;
        Fri, 19 Jul 2019 03:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508659;
        bh=JRMsjUM6twyTvjz1WSwYCsB1tXVYUgsBy61Dm3RlWuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmb9RpqEmRDt7QRUQGQoeaJcBWpdWKX+oW8j189PXKY3t36pVMEqh47MbvnbQ1wUJ
         pk0CL2nY12IroE5exOXkRZ0BmmJUuqd3AISCETihSzsgz3RJDLSLkyLL3ZKVsd6/pP
         f2wZ2DABZDc3thbUsbTuWBVJthI9l43Fevyk/HJ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Paul <seanpaul@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 020/171] drm/msm/a6xx: Avoid freeing gmu resources multiple times
Date:   Thu, 18 Jul 2019 23:54:11 -0400
Message-Id: <20190719035643.14300-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

[ Upstream commit 606ec90fc2266284f584a96ebf7f874589f56251 ]

The driver checks for gmu->mmio as a sign that the device has been
initialized, however there are failures in probe below the mmio init.
If one of those is hit, mmio will be non-null but freed.

In that case, a6xx_gmu_probe will return an error to a6xx_gpu_init which
will in turn call a6xx_gmu_remove which checks gmu->mmio and tries to free
resources for a second time. This causes a great boom.

Fix this by adding an initialized member to gmu which is set on
successful probe and cleared on removal.

Changes in v2:
- None

Cc: Jordan Crouse <jcrouse@codeaurora.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190523171653.138678-1-sean@poorly.run
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 14 +++++++++-----
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 418bb08bbed7..6910d0468e3c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -74,7 +74,7 @@ bool a6xx_gmu_sptprac_is_on(struct a6xx_gmu *gmu)
 	u32 val;
 
 	/* This can be called from gpu state code so make sure GMU is valid */
-	if (IS_ERR_OR_NULL(gmu->mmio))
+	if (!gmu->initialized)
 		return false;
 
 	val = gmu_read(gmu, REG_A6XX_GMU_SPTPRAC_PWR_CLK_STATUS);
@@ -90,7 +90,7 @@ bool a6xx_gmu_gx_is_on(struct a6xx_gmu *gmu)
 	u32 val;
 
 	/* This can be called from gpu state code so make sure GMU is valid */
-	if (IS_ERR_OR_NULL(gmu->mmio))
+	if (!gmu->initialized)
 		return false;
 
 	val = gmu_read(gmu, REG_A6XX_GMU_SPTPRAC_PWR_CLK_STATUS);
@@ -697,7 +697,7 @@ int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 	struct a6xx_gmu *gmu = &a6xx_gpu->gmu;
 	int status, ret;
 
-	if (WARN(!gmu->mmio, "The GMU is not set up yet\n"))
+	if (WARN(!gmu->initialized, "The GMU is not set up yet\n"))
 		return 0;
 
 	gmu->hung = false;
@@ -767,7 +767,7 @@ bool a6xx_gmu_isidle(struct a6xx_gmu *gmu)
 {
 	u32 reg;
 
-	if (!gmu->mmio)
+	if (!gmu->initialized)
 		return true;
 
 	reg = gmu_read(gmu, REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS);
@@ -1229,7 +1229,7 @@ void a6xx_gmu_remove(struct a6xx_gpu *a6xx_gpu)
 {
 	struct a6xx_gmu *gmu = &a6xx_gpu->gmu;
 
-	if (IS_ERR_OR_NULL(gmu->mmio))
+	if (!gmu->initialized)
 		return;
 
 	a6xx_gmu_stop(a6xx_gpu);
@@ -1247,6 +1247,8 @@ void a6xx_gmu_remove(struct a6xx_gpu *a6xx_gpu)
 	iommu_detach_device(gmu->domain, gmu->dev);
 
 	iommu_domain_free(gmu->domain);
+
+	gmu->initialized = false;
 }
 
 int a6xx_gmu_probe(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
@@ -1311,6 +1313,8 @@ int a6xx_gmu_probe(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 	/* Set up the HFI queues */
 	a6xx_hfi_init(gmu);
 
+	gmu->initialized = true;
+
 	return 0;
 err:
 	a6xx_gmu_memory_free(gmu, gmu->hfi);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
index bedd8e6a63aa..39a26dd63674 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
@@ -75,6 +75,7 @@ struct a6xx_gmu {
 
 	struct a6xx_hfi_queue queues[2];
 
+	bool initialized;
 	bool hung;
 };
 
-- 
2.20.1


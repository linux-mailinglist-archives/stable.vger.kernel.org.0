Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFDE3290C3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243099AbhCAUOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:14:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242759AbhCAUDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:03:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056D265396;
        Mon,  1 Mar 2021 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621488;
        bh=UcjbaxvrfcFUahnpCOMvUv2s4HEwNAeA7aU94NlNq40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pY+2V3loZo1Qmla8Vf/XM67qqu8V/DHIcNdEne1QcM++oR7Qp83YrXGIUeQwkAznW
         E0N/Pq/Rc+zH4cvgiWT3k0Qz9VxO3CdCmzBsnFo/YoFiJ+wY8v3tx0TdrosArBGApQ
         EShQn9k6X9PiEizHZdMwitTuzsVJ8VRNP+ZnUTGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 493/775] drm/msm: Add proper checks for GPU LLCC support
Date:   Mon,  1 Mar 2021 17:11:01 +0100
Message-Id: <20210301161225.880825277@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit 276619c0923f8fa6a82e60edb88a82468645362d ]

Domain attribute setting for LLCC is guarded by !IS_ERR
check which works fine only when CONFIG_QCOM_LLCC=y but
when it is disabled, the LLCC apis return NULL and that
is not handled by IS_ERR check. Due to this, domain attribute
for LLCC will be set even on GPUs which do not support it
and cause issues, so correct this by using IS_ERR_OR_NULL
checks appropriately. Meanwhile also cleanup comment block
and remove unwanted blank line.

Fixes: 00fd44a1a470 ("drm/msm: Only enable A6xx LLCC code on A6xx")
Fixes: 474dadb8b0d5 ("drm/msm/a6xx: Add support for using system cache(LLC)")
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c   |  2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 130661898546a..3b798e883f822 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1117,7 +1117,7 @@ static void a6xx_llc_slices_init(struct platform_device *pdev,
 	a6xx_gpu->llc_slice = llcc_slice_getd(LLCC_GPU);
 	a6xx_gpu->htw_llc_slice = llcc_slice_getd(LLCC_GPUHTW);
 
-	if (IS_ERR(a6xx_gpu->llc_slice) && IS_ERR(a6xx_gpu->htw_llc_slice))
+	if (IS_ERR_OR_NULL(a6xx_gpu->llc_slice) && IS_ERR_OR_NULL(a6xx_gpu->htw_llc_slice))
 		a6xx_gpu->llc_mmio = ERR_PTR(-EINVAL);
 }
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index f09175698827a..b35914de1b275 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -200,15 +200,15 @@ adreno_iommu_create_address_space(struct msm_gpu *gpu,
 	if (!iommu)
 		return NULL;
 
-
 	if (adreno_is_a6xx(adreno_gpu)) {
 		struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
 		struct io_pgtable_domain_attr pgtbl_cfg;
+
 		/*
-		* This allows GPU to set the bus attributes required to use system
-		* cache on behalf of the iommu page table walker.
-		*/
-		if (!IS_ERR(a6xx_gpu->htw_llc_slice)) {
+		 * This allows GPU to set the bus attributes required to use system
+		 * cache on behalf of the iommu page table walker.
+		 */
+		if (!IS_ERR_OR_NULL(a6xx_gpu->htw_llc_slice)) {
 			pgtbl_cfg.quirks = IO_PGTABLE_QUIRK_ARM_OUTER_WBWA;
 			iommu_domain_set_attr(iommu, DOMAIN_ATTR_IO_PGTABLE_CFG, &pgtbl_cfg);
 		}
-- 
2.27.0




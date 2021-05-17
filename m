Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6953383130
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhEQOfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239798AbhEQOcI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98ECA6187E;
        Mon, 17 May 2021 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260955;
        bh=JZqn9YUYgXqbdsw3UJqgUoZNEMHCDSDsyp1CcJCbWk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5s3EAdPwvDrxc+VEIG54+oUq/wN1ltXZL2Mqa2q3RK6CPnWCpwJg7FiiZuZ7NhQH
         4yiG/yQRE+El9oQkZK2GICJlsXwHkApa2cgshLL5lEDRR0qODlCCDidbzn1zLusssB
         Fl1UH2Kf7WI4BvDj0mv23AxQFyiuomIqMRFCEmJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 274/363] drm/msm: fix LLC not being enabled for mmu500 targets
Date:   Mon, 17 May 2021 16:02:20 +0200
Message-Id: <20210517140311.878859439@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 4b95d371fb001185af84d177e69a23d55bd0167a ]

mmu500 targets don't have a "cx_mem" region, set llc_mmio to NULL in that
case to avoid the IS_ERR() condition in a6xx_llc_activate().

Fixes: 3d247123b5a1 ("drm/msm/a6xx: Add support for using system cache on MMU500 based targets")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://lore.kernel.org/r/20210424014927.1661-1-jonathan@marek.ca
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index d553f62f4eeb..b4d8e1b01ee4 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1153,10 +1153,6 @@ static void a6xx_llc_slices_init(struct platform_device *pdev,
 {
 	struct device_node *phandle;
 
-	a6xx_gpu->llc_mmio = msm_ioremap(pdev, "cx_mem", "gpu_cx");
-	if (IS_ERR(a6xx_gpu->llc_mmio))
-		return;
-
 	/*
 	 * There is a different programming path for targets with an mmu500
 	 * attached, so detect if that is the case
@@ -1166,6 +1162,11 @@ static void a6xx_llc_slices_init(struct platform_device *pdev,
 		of_device_is_compatible(phandle, "arm,mmu-500"));
 	of_node_put(phandle);
 
+	if (a6xx_gpu->have_mmu500)
+		a6xx_gpu->llc_mmio = NULL;
+	else
+		a6xx_gpu->llc_mmio = msm_ioremap(pdev, "cx_mem", "gpu_cx");
+
 	a6xx_gpu->llc_slice = llcc_slice_getd(LLCC_GPU);
 	a6xx_gpu->htw_llc_slice = llcc_slice_getd(LLCC_GPUHTW);
 
-- 
2.30.2




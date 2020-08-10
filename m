Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D595D2410C4
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgHJTJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgHJTJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4E3522B45;
        Mon, 10 Aug 2020 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086576;
        bh=9FN3Q3tnh73C0rRCFPvO7ky/kSOJoa79l+EkBe8XSbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDxhi3gbfiB9uY1rT8bJbUMSzui+kp5WhmalXoxlItFiYAPAp8b67q9AdCzxZEp6y
         lFJRGfcXHSHXpOaB62iGkXJtOeKlWRIEJXvyRdU8oidKn+GvZ6o4MRNH0v/6t+9j7w
         WdYBXDkf1i7nvkHCSBlUukTbCcVqUbsA2c0J1YKU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akhil P Oommen <akhilpo@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 27/64] drm: msm: a6xx: fix gpu failure after system resume
Date:   Mon, 10 Aug 2020 15:08:22 -0400
Message-Id: <20200810190859.3793319-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <akhilpo@codeaurora.org>

[ Upstream commit 57c0bd517c06b088106b0236ed604056c8e06da5 ]

On targets where GMU is available, GMU takes over the ownership of GX GDSC
during its initialization. So, move the refcount-get on GX PD before we
initialize the GMU. This ensures that nobody can collapse the GX GDSC
once GMU owns the GX GDSC. This patch fixes some GMU OOB errors seen
during GPU wake up during a system resume.

Reported-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 21e77d67151f5..1d330204c465c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -854,10 +854,19 @@ int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 	/* Turn on the resources */
 	pm_runtime_get_sync(gmu->dev);
 
+	/*
+	 * "enable" the GX power domain which won't actually do anything but it
+	 * will make sure that the refcounting is correct in case we need to
+	 * bring down the GX after a GMU failure
+	 */
+	if (!IS_ERR_OR_NULL(gmu->gxpd))
+		pm_runtime_get_sync(gmu->gxpd);
+
 	/* Use a known rate to bring up the GMU */
 	clk_set_rate(gmu->core_clk, 200000000);
 	ret = clk_bulk_prepare_enable(gmu->nr_clocks, gmu->clocks);
 	if (ret) {
+		pm_runtime_put(gmu->gxpd);
 		pm_runtime_put(gmu->dev);
 		return ret;
 	}
@@ -903,19 +912,12 @@ int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 	else
 		a6xx_hfi_set_freq(gmu, gmu->current_perf_index);
 
-	/*
-	 * "enable" the GX power domain which won't actually do anything but it
-	 * will make sure that the refcounting is correct in case we need to
-	 * bring down the GX after a GMU failure
-	 */
-	if (!IS_ERR_OR_NULL(gmu->gxpd))
-		pm_runtime_get(gmu->gxpd);
-
 out:
 	/* On failure, shut down the GMU to leave it in a good state */
 	if (ret) {
 		disable_irq(gmu->gmu_irq);
 		a6xx_rpmh_stop(gmu);
+		pm_runtime_put(gmu->gxpd);
 		pm_runtime_put(gmu->dev);
 	}
 
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17D715EF1D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbgBNRpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389297AbgBNQCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44D9A2082F;
        Fri, 14 Feb 2020 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696153;
        bh=di8khRlYDSskFUMn8Lp9Smww22MVmawjUEsgEdLehbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdX3dxc89NrVwkfbaLvBMU6bGI5/v/p/PGRMQeS/QzwDDaS/av8oCW7b/BAvYHQMR
         zJCYKxG/SnO3JvpwGEcvtG8Zfxe6wbnxGZAGdajvypcFaVFxAW3wR74u6tY80rY4VZ
         LrGEHSKGP2Bfs6UQ/KQLiI4tM/kkoVTb2l5sHvLA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 032/459] drm/msm/adreno: fix zap vs no-zap handling
Date:   Fri, 14 Feb 2020 10:54:42 -0500
Message-Id: <20200214160149.11681-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 15ab987c423df561e0949d77fb5043921ae59956 ]

We can have two cases, when it comes to "zap" fw.  Either the fw
requires zap fw to take the GPU out of secure mode at boot, or it does
not and we can write RBBM_SECVID_TRUST_CNTL directly.  Previously we
decided based on whether zap fw load succeeded, but this is not a great
plan because:

1) we could have zap fw in the filesystem on a device where it is not
   required
2) we could have the inverse case

Instead, shift to deciding based on whether we have a 'zap-shader' node
in dt.  In practice, there is only one device (currently) with upstream
dt that does not use zap (cheza), and it already has a /delete-node/ for
the zap-shader node.

Fixes: abccb9fe3267 ("drm/msm/a6xx: Add zap shader load")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 11 +++++++++--
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 11 +++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index e9c55d1d6c044..99cd6e62a9715 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -726,11 +726,18 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 		gpu->funcs->flush(gpu, gpu->rb[0]);
 		if (!a5xx_idle(gpu, gpu->rb[0]))
 			return -EINVAL;
-	} else {
-		/* Print a warning so if we die, we know why */
+	} else if (ret == -ENODEV) {
+		/*
+		 * This device does not use zap shader (but print a warning
+		 * just in case someone got their dt wrong.. hopefully they
+		 * have a debug UART to realize the error of their ways...
+		 * if you mess this up you are about to crash horribly)
+		 */
 		dev_warn_once(gpu->dev->dev,
 			"Zap shader not enabled - using SECVID_TRUST_CNTL instead\n");
 		gpu_write(gpu, REG_A5XX_RBBM_SECVID_TRUST_CNTL, 0x0);
+	} else {
+		return ret;
 	}
 
 	/* Last step - yield the ringbuffer */
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index dc8ec2c94301b..686c34d706b0d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -537,12 +537,19 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 		a6xx_flush(gpu, gpu->rb[0]);
 		if (!a6xx_idle(gpu, gpu->rb[0]))
 			return -EINVAL;
-	} else {
-		/* Print a warning so if we die, we know why */
+	} else if (ret == -ENODEV) {
+		/*
+		 * This device does not use zap shader (but print a warning
+		 * just in case someone got their dt wrong.. hopefully they
+		 * have a debug UART to realize the error of their ways...
+		 * if you mess this up you are about to crash horribly)
+		 */
 		dev_warn_once(gpu->dev->dev,
 			"Zap shader not enabled - using SECVID_TRUST_CNTL instead\n");
 		gpu_write(gpu, REG_A6XX_RBBM_SECVID_TRUST_CNTL, 0x0);
 		ret = 0;
+	} else {
+		return ret;
 	}
 
 out:
-- 
2.20.1


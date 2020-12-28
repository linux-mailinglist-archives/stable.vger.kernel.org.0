Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D062E422D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439352AbgL1PSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437060AbgL1ODE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E5B3205CB;
        Mon, 28 Dec 2020 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164168;
        bh=50xODR39V2ws8Z3tk3CUEKjrZRMbyLflUJDarGx0Wko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KROQTshXMWo5CaZqymDSGJ6x4zALKDzJA1R0gkd6wd0Zi//LMLN/nv25Cv8FVuy/Z
         +CplwtMa98+qXi5ynryfeiqlBKyKUa52vsAI4j+xQh+U319Ayvg1uaduxFeRzL8KqJ
         4ylbvBJSvZVdhp9tqboGQMcmGb/qW0DHqX94I74g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/717] drm/msm/a6xx: Clear shadow on suspend
Date:   Mon, 28 Dec 2020 13:41:24 +0100
Message-Id: <20201228125025.107792556@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit e8b0b994c3a5881f0648d53f90435120089c56ad ]

Clear the shadow rptr on suspend.  Otherwise, when we resume, we can
have a stale value until CP_WHERE_AM_I executes.  If we suspend near
the ringbuffer wraparound point, this can lead to a chicken/egg
situation where we are waiting for ringbuffer space to write the
CP_WHERE_AM_I (or CP_INIT) packet, because we mistakenly believe that
the ringbuffer is full (due to stale rptr value in the shadow).

Fixes errors like:

  [drm:adreno_wait_ring [msm]] *ERROR* timeout waiting for space in ringbuffer 0

in the resume path.

Fixes: d3a569fccfa0 ("drm/msm: a6xx: Use WHERE_AM_I for eligible targets")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 948f3656c20ca..420ca4a0eb5f7 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1045,12 +1045,21 @@ static int a6xx_pm_suspend(struct msm_gpu *gpu)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
+	int i, ret;
 
 	trace_msm_gpu_suspend(0);
 
 	devfreq_suspend_device(gpu->devfreq.devfreq);
 
-	return a6xx_gmu_stop(a6xx_gpu);
+	ret = a6xx_gmu_stop(a6xx_gpu);
+	if (ret)
+		return ret;
+
+	if (adreno_gpu->base.hw_apriv || a6xx_gpu->has_whereami)
+		for (i = 0; i < gpu->nr_rings; i++)
+			a6xx_gpu->shadow[i] = 0;
+
+	return 0;
 }
 
 static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
-- 
2.27.0




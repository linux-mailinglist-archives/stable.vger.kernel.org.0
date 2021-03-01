Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F3D3290BA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhCAUNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242667AbhCAUDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:03:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E697D65397;
        Mon,  1 Mar 2021 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621472;
        bh=lciBhy/oZ0sLenJ1ioMIPds6KMH2ZlwmVE6yXClkjqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lvy1i7MfOE/+tYhn3IIx4O1aTBdauN/YrViGrgw2XsFromPgrEEyu+LZ0cz8h9q7o
         lgTNfmPzxdY8fgWs3ED6JQbd6TniXQaK8dqX0mcmQ0IDxk5MutWM61zjJDC3+epoec
         MpepHbj/FPubl7/Vq8MRaTiiTATPuZc91kpfBs9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 497/775] drm/msm: Fix races managing the OOB state for timestamp vs timestamps.
Date:   Mon,  1 Mar 2021 17:11:05 +0100
Message-Id: <20210301161226.075224950@linuxfoundation.org>
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

From: Eric Anholt <eric@anholt.net>

[ Upstream commit 5f98b33b04c02c0d9088c7486c59d058696782f9 ]

Now that we're not racing with GPU setup, also fix races of timestamps
against other timestamps.  In freedreno CI, we were seeing this path trigger
timeouts on setting the GMU bit, producing:

[drm:_a6xx_gmu_set_oob] *ERROR* Timeout waiting for GMU OOB set GPU_SET: 0x0

and this triggered especially on the first set of tests right after
boot (it's probably easier to lose the race than one might think,
given that we start many tests in parallel, and waiting for NFS to
page in code probably means that lots of tests hit the same point of
screen init at the same time).  As of this patch, the message seems to
have completely gone away.

Signed-off-by: Eric Anholt <eric@anholt.net>
Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 2dc6b342cf9b5..0366419d8bfed 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1169,6 +1169,9 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
+	static DEFINE_MUTEX(perfcounter_oob);
+
+	mutex_lock(&perfcounter_oob);
 
 	/* Force the GPU power on so we can read this register */
 	a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
@@ -1177,6 +1180,7 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 		REG_A6XX_RBBM_PERFCTR_CP_0_HI);
 
 	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
+	mutex_unlock(&perfcounter_oob);
 	return 0;
 }
 
-- 
2.27.0




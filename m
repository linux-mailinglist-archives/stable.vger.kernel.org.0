Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9044F328F95
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242358AbhCATxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242272AbhCAToU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F0F6520D;
        Mon,  1 Mar 2021 17:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619321;
        bh=q4Xz1M1S8mHOD5EmwOWeVChdZjCeSzG2zfpid3VYMmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1rZiiDeCKFX0WVdKyGMmjLZdhSBcQ4zFEOuwbSNvS244FWfBspE6t0VavC6RfnqT
         fc2/IGFrpQ0kL5pv43gQMp3pwvC2FGp8aHkdTTO+tZKcOEYrK413TnElw20Hk5p1NL
         2nsFqAZuS4E+8B9EkHKKokIcKXrOtfrS4uj/WnAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/663] drm/msm: Fix races managing the OOB state for timestamp vs timestamps.
Date:   Mon,  1 Mar 2021 17:11:00 +0100
Message-Id: <20210301161202.258366886@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 9fda02550d80d..83b50f6d6bb78 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1066,6 +1066,9 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
+	static DEFINE_MUTEX(perfcounter_oob);
+
+	mutex_lock(&perfcounter_oob);
 
 	/* Force the GPU power on so we can read this register */
 	a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
@@ -1074,6 +1077,7 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 		REG_A6XX_RBBM_PERFCTR_CP_0_HI);
 
 	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
+	mutex_unlock(&perfcounter_oob);
 	return 0;
 }
 
-- 
2.27.0




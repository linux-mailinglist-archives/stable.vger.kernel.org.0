Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BDB25CF42
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 04:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgIDCD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 22:03:27 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:40418 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgIDCD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 22:03:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1599185005; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=R5koSp1TQhYlp1uOwdFEuOPb+yndppKWgSrSbtX3c/Y=; b=g769euq3bBj7YhNe+3I53fWvOpm28ki27geoqUiDrlUEuJP4dZeRmV6d/9BPljOlqcA1Usph
 m9pGPy7mzw0KIiu9ybNHYUoRoUy58x7ILPVGX/cSJV7VDDDiRAL9C9UtB8MBT15pquhg9ini
 b6X5u5BZ58EZLRKoHI1eEtRmpLo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f51a06c9f3347551fcf4a04 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Sep 2020 02:03:24
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1EBEFC43387; Fri,  4 Sep 2020 02:03:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from jordan-laptop.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jcrouse)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AEDCAC43391;
        Fri,  4 Sep 2020 02:03:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AEDCAC43391
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=jcrouse@codeaurora.org
From:   Jordan Crouse <jcrouse@codeaurora.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drm/msm: Split the a5xx preemption record
Date:   Thu,  3 Sep 2020 20:03:10 -0600
Message-Id: <20200904020313.1810988-2-jcrouse@codeaurora.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904020313.1810988-1-jcrouse@codeaurora.org>
References: <20200904020313.1810988-1-jcrouse@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The main a5xx preemption record can be marked as privileged to
protect it from user access but the counters storage needs to be
remain unprivileged. Split the buffers and mark the critical memory
as privileged.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
---

 drivers/gpu/drm/msm/adreno/a5xx_gpu.h     |  1 +
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c | 25 ++++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.h b/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
index 54868d4e3958..1e5b1a15a70f 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
@@ -31,6 +31,7 @@ struct a5xx_gpu {
 	struct msm_ringbuffer *next_ring;
 
 	struct drm_gem_object *preempt_bo[MSM_GPU_MAX_RINGS];
+	struct drm_gem_object *preempt_counters_bo[MSM_GPU_MAX_RINGS];
 	struct a5xx_preempt_record *preempt[MSM_GPU_MAX_RINGS];
 	uint64_t preempt_iova[MSM_GPU_MAX_RINGS];
 
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index 9cf9353a7ff1..9f3fe177b00e 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -226,19 +226,31 @@ static int preempt_init_ring(struct a5xx_gpu *a5xx_gpu,
 	struct adreno_gpu *adreno_gpu = &a5xx_gpu->base;
 	struct msm_gpu *gpu = &adreno_gpu->base;
 	struct a5xx_preempt_record *ptr;
-	struct drm_gem_object *bo = NULL;
-	u64 iova = 0;
+	void *counters;
+	struct drm_gem_object *bo = NULL, *counters_bo = NULL;
+	u64 iova = 0, counters_iova = 0;
 
 	ptr = msm_gem_kernel_new(gpu->dev,
 		A5XX_PREEMPT_RECORD_SIZE + A5XX_PREEMPT_COUNTER_SIZE,
-		MSM_BO_UNCACHED, gpu->aspace, &bo, &iova);
+		MSM_BO_UNCACHED | MSM_BO_MAP_PRIV, gpu->aspace, &bo, &iova);
 
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 
+	/* The buffer to store counters needs to be unprivileged */
+	counters = msm_gem_kernel_new(gpu->dev,
+		A5XX_PREEMPT_COUNTER_SIZE,
+		MSM_BO_UNCACHED, gpu->aspace, &counters_bo, &counters_iova);
+	if (IS_ERR(counters)) {
+		msm_gem_kernel_put(bo, gpu->aspace, true);
+		return PTR_ERR(counters);
+	}
+
 	msm_gem_object_set_name(bo, "preempt");
+	msm_gem_object_set_name(counters_bo, "preempt_counters");
 
 	a5xx_gpu->preempt_bo[ring->id] = bo;
+	a5xx_gpu->preempt_counters_bo[ring->id] = counters_bo;
 	a5xx_gpu->preempt_iova[ring->id] = iova;
 	a5xx_gpu->preempt[ring->id] = ptr;
 
@@ -249,7 +261,7 @@ static int preempt_init_ring(struct a5xx_gpu *a5xx_gpu,
 	ptr->data = 0;
 	ptr->cntl = MSM_GPU_RB_CNTL_DEFAULT;
 	ptr->rptr_addr = rbmemptr(ring, rptr);
-	ptr->counter = iova + A5XX_PREEMPT_RECORD_SIZE;
+	ptr->counter = counters_iova;
 
 	return 0;
 }
@@ -260,8 +272,11 @@ void a5xx_preempt_fini(struct msm_gpu *gpu)
 	struct a5xx_gpu *a5xx_gpu = to_a5xx_gpu(adreno_gpu);
 	int i;
 
-	for (i = 0; i < gpu->nr_rings; i++)
+	for (i = 0; i < gpu->nr_rings; i++) {
 		msm_gem_kernel_put(a5xx_gpu->preempt_bo[i], gpu->aspace, true);
+		msm_gem_kernel_put(a5xx_gpu->preempt_counters_bo[i],
+			gpu->aspace, true);
+	}
 }
 
 void a5xx_preempt_init(struct msm_gpu *gpu)
-- 
2.25.1


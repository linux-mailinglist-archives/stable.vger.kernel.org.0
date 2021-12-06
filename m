Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A95469E08
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388524AbhLFPeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36516 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387446AbhLFPbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:31:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D587FB8101B;
        Mon,  6 Dec 2021 15:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F42C34901;
        Mon,  6 Dec 2021 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804467;
        bh=YrzbCQyjZ5TKrKKzKGNLB+/saZKPFu+EUhagqJZ5/4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHFzBwgm8BXpfGdL8QucfIu9tRLu38xgss6mTURLSquJdV4xFibtjMsuYhE7ATaV9
         GZ3RlZJRrwRNbpL7fBX96ETcDeic8JWel0W4vm70k73CnFdeHRKEOVyVlGfFWd6W7Y
         oqHxaBGPDl7Y+vdzz/E0XK9FMXLEPsDu8qRPwzGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/207] drm/msm: Restore error return on invalid fence
Date:   Mon,  6 Dec 2021 15:56:51 +0100
Message-Id: <20211206145615.700419538@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 067ecab9eef620d41040715669e5fcdc2f8ff963 ]

When converting to use an idr to map userspace fence seqno values back
to a dma_fence, we lost the error return when userspace passes seqno
that is larger than the last submitted fence.  Restore this check.

Reported-by: Akhil P Oommen <akhilpo@codeaurora.org>
Fixes: a61acbbe9cf8 ("drm/msm: Track "seqno" fences by idr")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20211111192457.747899-3-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c        | 6 ++++++
 drivers/gpu/drm/msm/msm_gem_submit.c | 1 +
 drivers/gpu/drm/msm/msm_gpu.h        | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 4c5661f38dd26..27f737a253c77 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -944,6 +944,12 @@ static int wait_fence(struct msm_gpu_submitqueue *queue, uint32_t fence_id,
 	struct dma_fence *fence;
 	int ret;
 
+	if (fence_id > queue->last_fence) {
+		DRM_ERROR_RATELIMITED("waiting on invalid fence: %u (of %u)\n",
+				      fence_id, queue->last_fence);
+		return -EINVAL;
+	}
+
 	/*
 	 * Map submitqueue scoped "seqno" (which is actually an idr key)
 	 * back to underlying dma-fence
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 151d19e4453cd..a38f23be497d8 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -911,6 +911,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	drm_sched_entity_push_job(&submit->base, queue->entity);
 
 	args->fence = submit->fence_id;
+	queue->last_fence = submit->fence_id;
 
 	msm_reset_syncobjs(syncobjs_to_reset, args->nr_in_syncobjs);
 	msm_process_post_deps(post_deps, args->nr_out_syncobjs,
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index ee25d556c8a10..2e2424066e701 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -352,6 +352,8 @@ static inline int msm_gpu_convert_priority(struct msm_gpu *gpu, int prio,
  * @ring_nr:   the ringbuffer used by this submitqueue, which is determined
  *             by the submitqueue's priority
  * @faults:    the number of GPU hangs associated with this submitqueue
+ * @last_fence: the sequence number of the last allocated fence (for error
+ *             checking)
  * @ctx:       the per-drm_file context associated with the submitqueue (ie.
  *             which set of pgtables do submits jobs associated with the
  *             submitqueue use)
@@ -367,6 +369,7 @@ struct msm_gpu_submitqueue {
 	u32 flags;
 	u32 ring_nr;
 	int faults;
+	uint32_t last_fence;
 	struct msm_file_private *ctx;
 	struct list_head node;
 	struct idr fence_idr;
-- 
2.33.0




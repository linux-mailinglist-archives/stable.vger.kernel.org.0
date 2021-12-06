Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239A1469F17
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391388AbhLFPpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390533AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A0C0698CF;
        Mon,  6 Dec 2021 07:27:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B785B8111B;
        Mon,  6 Dec 2021 15:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6398EC34901;
        Mon,  6 Dec 2021 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804464;
        bh=cBQWjnLnI1zor9PfLU/0gYogPu2RfybBpsLnNssECEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kt3L87VWWEmvizzFXU2US2kXNALOr4OsTgVcMQyJr2lTAm50YdoWfijEmg+QAoCgo
         w8dADn8DQDyJsK/JwIh2N0mBacvoS1MssrZeSgcHaXATmTGd9itHBjnCGTIBriOec6
         J8wEBKBjV7FzACuz7LbsVRqEQIEWlhqC9zyl1Ks0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/207] drm/msm: Fix wait_fence submitqueue leak
Date:   Mon,  6 Dec 2021 15:56:50 +0100
Message-Id: <20211206145615.661426507@linuxfoundation.org>
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

[ Upstream commit ea0006d390a28012f8187717aea61498b2b341e5 ]

We weren't dropping the submitqueue reference in all paths.  In
particular, when the fence has already been signalled. Split out
a helper to simplify handling this in the various different return
paths.

Fixes: a61acbbe9cf8 ("drm/msm: Track "seqno" fences by idr")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20211111192457.747899-2-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 49 +++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index d4e09703a87db..4c5661f38dd26 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -938,29 +938,12 @@ static int msm_ioctl_gem_info(struct drm_device *dev, void *data,
 	return ret;
 }
 
-static int msm_ioctl_wait_fence(struct drm_device *dev, void *data,
-		struct drm_file *file)
+static int wait_fence(struct msm_gpu_submitqueue *queue, uint32_t fence_id,
+		      ktime_t timeout)
 {
-	struct msm_drm_private *priv = dev->dev_private;
-	struct drm_msm_wait_fence *args = data;
-	ktime_t timeout = to_ktime(args->timeout);
-	struct msm_gpu_submitqueue *queue;
-	struct msm_gpu *gpu = priv->gpu;
 	struct dma_fence *fence;
 	int ret;
 
-	if (args->pad) {
-		DRM_ERROR("invalid pad: %08x\n", args->pad);
-		return -EINVAL;
-	}
-
-	if (!gpu)
-		return 0;
-
-	queue = msm_submitqueue_get(file->driver_priv, args->queueid);
-	if (!queue)
-		return -ENOENT;
-
 	/*
 	 * Map submitqueue scoped "seqno" (which is actually an idr key)
 	 * back to underlying dma-fence
@@ -972,7 +955,7 @@ static int msm_ioctl_wait_fence(struct drm_device *dev, void *data,
 	ret = mutex_lock_interruptible(&queue->lock);
 	if (ret)
 		return ret;
-	fence = idr_find(&queue->fence_idr, args->fence);
+	fence = idr_find(&queue->fence_idr, fence_id);
 	if (fence)
 		fence = dma_fence_get_rcu(fence);
 	mutex_unlock(&queue->lock);
@@ -988,6 +971,32 @@ static int msm_ioctl_wait_fence(struct drm_device *dev, void *data,
 	}
 
 	dma_fence_put(fence);
+
+	return ret;
+}
+
+static int msm_ioctl_wait_fence(struct drm_device *dev, void *data,
+		struct drm_file *file)
+{
+	struct msm_drm_private *priv = dev->dev_private;
+	struct drm_msm_wait_fence *args = data;
+	struct msm_gpu_submitqueue *queue;
+	int ret;
+
+	if (args->pad) {
+		DRM_ERROR("invalid pad: %08x\n", args->pad);
+		return -EINVAL;
+	}
+
+	if (!priv->gpu)
+		return 0;
+
+	queue = msm_submitqueue_get(file->driver_priv, args->queueid);
+	if (!queue)
+		return -ENOENT;
+
+	ret = wait_fence(queue, args->fence, to_ktime(args->timeout));
+
 	msm_submitqueue_put(queue);
 
 	return ret;
-- 
2.33.0




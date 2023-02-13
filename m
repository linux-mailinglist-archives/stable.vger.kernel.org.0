Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0E6948DE
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBMOyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjBMOyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44263C19
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED7226115A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D01DC433D2;
        Mon, 13 Feb 2023 14:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300031;
        bh=wTQfEyiRhG8w2HrFmdpNdGjnM88fpsxaOqfmnq1X89M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mF0k8xsmYtJ8Dun9JEebCB8FILA5KaZtbz5jAUtI/YuM5aUlS3XxHbfm8EVCyGkdJ
         rE8Yeoh01LazJ6iV/Dypo+0eNm9Ycr8c2n1GeW5jajj3F68EFzCF+7bIJn9jZOkInc
         8fqrP+ku5I5v1GuAzd6Th/X8UAbpUvAWtuNZEyr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ryan Neph <ryanneph@chromium.org>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/114] drm/virtio: exbuf->fence_fd unmodified on interrupted wait
Date:   Mon, 13 Feb 2023 15:47:52 +0100
Message-Id: <20230213144744.058712134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryan Neph <ryanneph@chromium.org>

[ Upstream commit 8f20660f053cefd4693e69cfff9cf58f4f7c4929 ]

An interrupted dma_fence_wait() becomes an -ERESTARTSYS returned
to userspace ioctl(DRM_IOCTL_VIRTGPU_EXECBUFFER) calls, prompting to
retry the ioctl(), but the passed exbuf->fence_fd has been reset to -1,
making the retry attempt fail at sync_file_get_fence().

The uapi for DRM_IOCTL_VIRTGPU_EXECBUFFER is changed to retain the
passed value for exbuf->fence_fd when returning anything besides a
successful result from the ioctl.

Fixes: 2cd7b6f08bc4 ("drm/virtio: add in/out fence support for explicit synchronization")
Signed-off-by: Ryan Neph <ryanneph@chromium.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230203233345.2477767-1-ryanneph@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 5 +----
 include/uapi/drm/virtgpu_drm.h         | 1 +
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 9f4a90493aeac..da45215a933d0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -126,7 +126,6 @@ static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 	void __user *user_bo_handles = NULL;
 	struct virtio_gpu_object_array *buflist = NULL;
 	struct sync_file *sync_file;
-	int in_fence_fd = exbuf->fence_fd;
 	int out_fence_fd = -1;
 	void *buf;
 	uint64_t fence_ctx;
@@ -152,13 +151,11 @@ static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 		ring_idx = exbuf->ring_idx;
 	}
 
-	exbuf->fence_fd = -1;
-
 	virtio_gpu_create_context(dev, file);
 	if (exbuf->flags & VIRTGPU_EXECBUF_FENCE_FD_IN) {
 		struct dma_fence *in_fence;
 
-		in_fence = sync_file_get_fence(in_fence_fd);
+		in_fence = sync_file_get_fence(exbuf->fence_fd);
 
 		if (!in_fence)
 			return -EINVAL;
diff --git a/include/uapi/drm/virtgpu_drm.h b/include/uapi/drm/virtgpu_drm.h
index 0512fde5e6978..7b158fcb02b45 100644
--- a/include/uapi/drm/virtgpu_drm.h
+++ b/include/uapi/drm/virtgpu_drm.h
@@ -64,6 +64,7 @@ struct drm_virtgpu_map {
 	__u32 pad;
 };
 
+/* fence_fd is modified on success if VIRTGPU_EXECBUF_FENCE_FD_OUT flag is set. */
 struct drm_virtgpu_execbuffer {
 	__u32 flags;
 	__u32 size;
-- 
2.39.0




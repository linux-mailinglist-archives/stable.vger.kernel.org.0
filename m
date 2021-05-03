Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0955F3719C6
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhECQhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhECQhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A2A461283;
        Mon,  3 May 2021 16:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059753;
        bh=VkO9kDar+T5480JzDWlIRMDbg+VsBAidXambrt3br0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIBqPWRgo8ExnhDJYzyH1WVjahXyQvrK6qojbVXnNl43CeDdAHXVXxxV/9zu0+zLC
         F1H6iPAyWhSIK6+zW7XTpBEXR8kQUoxMCQxMAtY3rkZJEfmYcr64uiiz+a8uyGuzdA
         m7gItlmRRIAnGMx9Qvup91JO/4UIyq2g2HIuKqgw4dyACb2mwMFZ3JczkvAIyIJCBK
         tfXq/LrGr6AEvNurST3zaRdLrZ5EJfNhaMy4qU0trx3odhNz3x0tCklMjtC/HhPXy8
         Dvc8ImdDG3cQxT8Z/XNQ8InqGvc1E2wft3E7ljCLPFOnuvBPmUB4VdZeBHYfO1urKO
         cWSS9Wiun9Yyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xndcn <xndchn@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.12 025/134] drm/virtio: fix possible leak/unlock virtio_gpu_object_array
Date:   Mon,  3 May 2021 12:33:24 -0400
Message-Id: <20210503163513.2851510-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xndcn <xndchn@gmail.com>

[ Upstream commit 377f8331d0565e6f71ba081c894029a92d0c7e77 ]

virtio_gpu_object array is not freed or unlocked in some
failed cases.

Signed-off-by: xndcn <xndchn@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210305151819.14330-1-xndchn@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c  | 2 +-
 drivers/gpu/drm/virtio/virtgpu_object.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 23eb6d772e40..669f2ee39515 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -174,7 +174,7 @@ static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 		if (!sync_file) {
 			dma_fence_put(&out_fence->f);
 			ret = -ENOMEM;
-			goto out_memdup;
+			goto out_unresv;
 		}
 
 		exbuf->fence_fd = out_fence_fd;
diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index d69a5b6da553..4ff1ec28e630 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -248,6 +248,7 @@ int virtio_gpu_object_create(struct virtio_gpu_device *vgdev,
 
 	ret = virtio_gpu_object_shmem_init(vgdev, bo, &ents, &nents);
 	if (ret != 0) {
+		virtio_gpu_array_put_free(objs);
 		virtio_gpu_free_object(&shmem_obj->base);
 		return ret;
 	}
-- 
2.30.2


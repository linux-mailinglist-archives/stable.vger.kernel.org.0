Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C623785FF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhEJLDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234811AbhEJK5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 806BF619BE;
        Mon, 10 May 2021 10:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643766;
        bh=VkO9kDar+T5480JzDWlIRMDbg+VsBAidXambrt3br0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwLh7ztGBUmbgBsTV5i3TxnoAroi3ymPn3AXZAwafTf7DZmuVNwodEjtbdKZ2mNYP
         9rUH2zWPEYr5DGe9Kch/wciEIlMDTJGuBHsaKrgVpYG94sVeANJ0TOABi0ZRLhPSK6
         mIZtPqgAVhBNJ/tb5MtFs49iKxNkO0kjd9Q2XNKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xndcn <xndchn@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 150/342] drm/virtio: fix possible leak/unlock virtio_gpu_object_array
Date:   Mon, 10 May 2021 12:19:00 +0200
Message-Id: <20210510102015.050097610@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




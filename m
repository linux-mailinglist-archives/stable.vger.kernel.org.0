Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2528615C58
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfEGGC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbfEGFfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C172087F;
        Tue,  7 May 2019 05:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207321;
        bh=pdVdyom2uZTEAtZ+3r+7LEvj378VMGzw2pWsGonkZFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDhVKSXB9VQD5C7OazCIf0nIjlDEGmYWsaNIxogDMuoEKewAbk5c6ikOglXLvbF4N
         0E+4blx8e5Wir0DT9mCUTWNvhRAYqLzih2vhQ7J1UviNy5QU50PpBqliyLFJmsEq7K
         DvkBGrhqVEysH4QLC2D2kak79YgHp1kftjCJ7Ks4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Airlie <airlied@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.0 85/99] Revert "drm/virtio: drop prime import/export callbacks"
Date:   Tue,  7 May 2019 01:32:19 -0400
Message-Id: <20190507053235.29900-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit a0cecc23cfcbf2626497a8c8770856dd56b67917 ]

This patch does more harm than good, as it breaks both Xwayland and
gnome-shell with X11.

Xwayland requires DRI3 & DRI3 requires PRIME.

X11 crash for obscure double-free reason which are hard to debug
(starting X11 by hand doesn't trigger the crash).

I don't see an apparent problem implementing those stub prime
functions, they may return an error at run-time, and it seems to be
handled fine by GNOME at least.

This reverts commit b318e3ff7ca065d6b107e424c85a63d7a6798a69.
[airlied:
This broke userspace for virtio-gpus, and regressed things from DRI3 to DRI2.

This brings back the original problem, but it's better than regressions.]

Fixes: b318e3ff7ca065d6b107e424c85a63d7a6798a ("drm/virtio: drop prime import/export callbacks")
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.c   |  4 ++++
 drivers/gpu/drm/virtio/virtgpu_drv.h   |  4 ++++
 drivers/gpu/drm/virtio/virtgpu_prime.c | 12 ++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
index 2d1aaca49105..f7f32a885af7 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -127,10 +127,14 @@ static struct drm_driver driver = {
 #if defined(CONFIG_DEBUG_FS)
 	.debugfs_init = virtio_gpu_debugfs_init,
 #endif
+	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
+	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
 	.gem_prime_export = drm_gem_prime_export,
 	.gem_prime_import = drm_gem_prime_import,
 	.gem_prime_pin = virtgpu_gem_prime_pin,
 	.gem_prime_unpin = virtgpu_gem_prime_unpin,
+	.gem_prime_get_sg_table = virtgpu_gem_prime_get_sg_table,
+	.gem_prime_import_sg_table = virtgpu_gem_prime_import_sg_table,
 	.gem_prime_vmap = virtgpu_gem_prime_vmap,
 	.gem_prime_vunmap = virtgpu_gem_prime_vunmap,
 	.gem_prime_mmap = virtgpu_gem_prime_mmap,
diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index 0c15000f926e..1deb41d42ea4 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -372,6 +372,10 @@ int virtio_gpu_object_wait(struct virtio_gpu_object *bo, bool no_wait);
 /* virtgpu_prime.c */
 int virtgpu_gem_prime_pin(struct drm_gem_object *obj);
 void virtgpu_gem_prime_unpin(struct drm_gem_object *obj);
+struct sg_table *virtgpu_gem_prime_get_sg_table(struct drm_gem_object *obj);
+struct drm_gem_object *virtgpu_gem_prime_import_sg_table(
+	struct drm_device *dev, struct dma_buf_attachment *attach,
+	struct sg_table *sgt);
 void *virtgpu_gem_prime_vmap(struct drm_gem_object *obj);
 void virtgpu_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr);
 int virtgpu_gem_prime_mmap(struct drm_gem_object *obj,
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index c59ec34c80a5..eb51a78e1199 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -39,6 +39,18 @@ void virtgpu_gem_prime_unpin(struct drm_gem_object *obj)
 	WARN_ONCE(1, "not implemented");
 }
 
+struct sg_table *virtgpu_gem_prime_get_sg_table(struct drm_gem_object *obj)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+struct drm_gem_object *virtgpu_gem_prime_import_sg_table(
+	struct drm_device *dev, struct dma_buf_attachment *attach,
+	struct sg_table *table)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 void *virtgpu_gem_prime_vmap(struct drm_gem_object *obj)
 {
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(obj);
-- 
2.20.1


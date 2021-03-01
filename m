Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF0C328EAE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbhCATfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241872AbhCAT3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 739DC650B9;
        Mon,  1 Mar 2021 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620544;
        bh=ngi3Q45PoehC+knzpLbiwwDtrtBnqEd3LxD8aPMfeUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6pkgUC6b5vllE7LgRh8vxUC7Z671hXSNZ9BPblI4NFsdRycE8sBvLUEUfGoojWsr
         GRX7rv6/6fy5JGERBkpl4QzzHPh8NxvgDrjPYxpN2FoufQB8OJTc1cFLV/y7E02r1F
         VFCGCEMziBbykQbDcOO9WvvKjnEWhQtpCm2FU940=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Chia-I Wu <olvaffe@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 191/775] drm/virtio: make sure context is created in gem open
Date:   Mon,  1 Mar 2021 17:05:59 +0100
Message-Id: <20210301161211.066715475@linuxfoundation.org>
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

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 8aeef9d4f48917ce85710949b079548974b4a638 ]

The context might still be missing when DRM_IOCTL_PRIME_FD_TO_HANDLE is
the first ioctl on the drm_file.

Fixes: 72b48ae800da ("drm/virtio: enqueue virtio_gpu_create_context after the first 3D ioctl")
Cc: Gurchetan Singh <gurchetansingh@chromium.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210107210726.269584-1-olvaffe@gmail.com
Reviewed-by: Gurchetan Singh <gurchetansingh@chromium.org>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_gem.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_gem.c b/drivers/gpu/drm/virtio/virtgpu_gem.c
index c30c75ee83fce..8502400b2f9c9 100644
--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -39,9 +39,6 @@ static int virtio_gpu_gem_create(struct drm_file *file,
 	int ret;
 	u32 handle;
 
-	if (vgdev->has_virgl_3d)
-		virtio_gpu_create_context(dev, file);
-
 	ret = virtio_gpu_object_create(vgdev, params, &obj, NULL);
 	if (ret < 0)
 		return ret;
@@ -119,6 +116,11 @@ int virtio_gpu_gem_object_open(struct drm_gem_object *obj,
 	if (!vgdev->has_virgl_3d)
 		goto out_notify;
 
+	/* the context might still be missing when the first ioctl is
+	 * DRM_IOCTL_MODE_CREATE_DUMB or DRM_IOCTL_PRIME_FD_TO_HANDLE
+	 */
+	virtio_gpu_create_context(obj->dev, file);
+
 	objs = virtio_gpu_array_alloc(1);
 	if (!objs)
 		return -ENOMEM;
-- 
2.27.0




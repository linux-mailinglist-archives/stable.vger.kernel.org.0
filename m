Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801D213FD55
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgAPXYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388054AbgAPXYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC6A20748;
        Thu, 16 Jan 2020 23:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217081;
        bh=r+x76sD36E+bLkWQym59zq8FtZSERquePm26s+owZXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8n7NxMG0RVxMEEZdcHGVsB1/59SseMV8yxszAP0Y829K8GITdaB4gHv7xaIbOKMj
         9zvlO/C3lMObibELEgfjVw1UsVk32xjB3ivANZqBALDNkdNsxWKSkQCkhZkMhmlva1
         D1sSsgAF39ecpue4Liy0oO463LJogIxtKGhdGn3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chia-I Wu <olvaffe@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/203] Revert "drm/virtio: switch virtio_gpu_wait_ioctl() to gem helper."
Date:   Fri, 17 Jan 2020 00:17:21 +0100
Message-Id: <20200116231756.104058057@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit e6733ec8948475c4b62574e452135dc629294d75 which is
commit 29cf12394c0565d7eb1685bf0c1b4749aa6a8b66 upstream.

Alistair writes:
	After updating to 5.4.7 we noticed that virtio_gpu's wait ioctl
	stopped working correctly.

	It looks like 29cf12394c05 ("drm/virtio: switch
	virtio_gpu_wait_ioctl() to gem helper.") was picked up automatically,
	but it depends on 889165ad6190 ("drm/virtio: pass gem reservation
	object to ttm init") from earlier in Gerd's series in Linus's tree,
	which was not picked up.

Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chia-I Wu <olvaffe@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -463,29 +463,25 @@ out:
 }
 
 static int virtio_gpu_wait_ioctl(struct drm_device *dev, void *data,
-				 struct drm_file *file)
+			    struct drm_file *file)
 {
 	struct drm_virtgpu_3d_wait *args = data;
-	struct drm_gem_object *obj;
-	long timeout = 15 * HZ;
+	struct drm_gem_object *gobj = NULL;
+	struct virtio_gpu_object *qobj = NULL;
 	int ret;
+	bool nowait = false;
 
-	obj = drm_gem_object_lookup(file, args->handle);
-	if (obj == NULL)
+	gobj = drm_gem_object_lookup(file, args->handle);
+	if (gobj == NULL)
 		return -ENOENT;
 
-	if (args->flags & VIRTGPU_WAIT_NOWAIT) {
-		ret = dma_resv_test_signaled_rcu(obj->resv, true);
-	} else {
-		ret = dma_resv_wait_timeout_rcu(obj->resv, true, true,
-						timeout);
-	}
-	if (ret == 0)
-		ret = -EBUSY;
-	else if (ret > 0)
-		ret = 0;
+	qobj = gem_to_virtio_gpu_obj(gobj);
 
-	drm_gem_object_put_unlocked(obj);
+	if (args->flags & VIRTGPU_WAIT_NOWAIT)
+		nowait = true;
+	ret = virtio_gpu_object_wait(qobj, nowait);
+
+	drm_gem_object_put_unlocked(gobj);
 	return ret;
 }
 



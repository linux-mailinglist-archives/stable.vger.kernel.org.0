Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8179B3BD272
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhGFLmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237765AbhGFLhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C52AF61F45;
        Tue,  6 Jul 2021 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570982;
        bh=2cP6HYPMtPVu7Ubwu2OuPXW6uDmh/dY1DWdA5sj8Tww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5CvV7SoNiQCeTDJ/E+Bib6Qej5z7TeuEo1sFYN79gle03xXIokj0KgZ+BoC80vGZ
         aLAaWafyJxaNELq0KwzE87dES9xOVIQxw+fz19OD5JQHiim9ZCVN744r8D7hbdkYT8
         QXGVg7G6lXMJPy7y7T1IkedGLpUsEIYMmvzRIIJyvoFYACWKovi5E9Olv7DmPmInbf
         T9Ib0e87oImSOE5qv3sU41MLpOo0+KcZUJblw47NZ88jJaIJMuuS8uKqnROPY5jr88
         088j0Nq1FePGdGIYWB4K/oKdKQi03EuOORVO5t5pQamJ7bKVljsUiFOj+Zu31MvajW
         0OY/jzrfujPSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.4 08/31] drm/virtio: Fixes a potential NULL pointer dereference on probe failure
Date:   Tue,  6 Jul 2021 07:29:08 -0400
Message-Id: <20210706112931.2066397-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 17f46f488a5d82c5568e6e786cd760bba1c2ee09 ]

The dev->dev_private might not be allocated if virtio_gpu_pci_quirk()
or virtio_gpu_init() failed. In this case, we should avoid the cleanup
in virtio_gpu_release().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210517084913.403-1-xieyongji@bytedance.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 476b9993b068..88ed5e235e55 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -257,6 +257,9 @@ int virtio_gpu_driver_unload(struct drm_device *dev)
 	flush_work(&vgdev->config_changed_work);
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 
+	if (!vgdev)
+		return;
+
 	virtio_gpu_modeset_fini(vgdev);
 	virtio_gpu_ttm_fini(vgdev);
 	virtio_gpu_free_vbufs(vgdev);
-- 
2.30.2


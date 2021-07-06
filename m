Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CE03BD1B4
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238762AbhGFLkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237334AbhGFLgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A3461C9B;
        Tue,  6 Jul 2021 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570816;
        bh=4SACsFJG8/9jJecMl2IR/V5GA4+8aU0CP4m8Q7Ajasg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6WUn1zChwRjp/VLW54vZl0rdCa5+2/a87A3XtqaAk2FP2OAtcQ0UE1nML744vOye
         6Sg+Iwe05fOsXFCz1J0xD0KdEDmJA4PbpTyRpNYbq4Ql8m2cxQQCA22xFFZN6q4Wg7
         0qxZgBFjNXeRkgDbuuvNdk80moP3tcFSfVyaZMejJhPL0G72FWXAfExcSKUkKOCErO
         ZCh6Ns9+YAmW/ZRzp7gPD98plHQE+ethGpzuuciKMTvV1vvux/fRD9jva5Unn3Pd+1
         PEYhzvU3JpG2c/ZTzpBPezlXANdftnASbF+a7RDD38Hc6tpKgFYba82Hb6B5ei7uWV
         kHzrq9BljUsJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 13/55] drm/virtio: Fixes a potential NULL pointer dereference on probe failure
Date:   Tue,  6 Jul 2021 07:25:56 -0400
Message-Id: <20210706112638.2065023-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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
index 22397a23780c..2cfd0016bd70 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -261,6 +261,9 @@ void virtio_gpu_driver_unload(struct drm_device *dev)
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


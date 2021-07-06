Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0CA3BD4CB
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbhGFMR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235945AbhGFLbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53A8761C65;
        Tue,  6 Jul 2021 11:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570552;
        bh=4J5DrekW+Z6vq8uQPBlInErgQlOeQjUUHuZOl0FkA3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9G4Wbe8IPkTm1vavyRwqVza7OtdIpn2ebLhZQH+Z++iKuxzwpkU4KeGBhZ+Jf6NE
         mPdFXU+IBvv3c+JsJ1tuM7jR6N9ISOI4jbcQ2b97WGNnav/XVlUTOS730CV6NqD+We
         NCNwuo4QkjPS1/Y4wNoQkfhmjSsNMhmDv2tgq2mThd7MlbR3lAKow6grwMGuCM6foN
         BxWI/s6N/TPr/rKNLpzNlEfs2E+sXReFR5+gM0tpJ8KOGlIDQuYIHgISYnVqmvfPz7
         P8JbO5w4CxoFBN7Qg3LUNTnytQYXSRnVTy6HapEt12D5NR9SGNO53N0k15q3uKXdIt
         hKB7sfCD9JTjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 021/137] drm/virtio: Fixes a potential NULL pointer dereference on probe failure
Date:   Tue,  6 Jul 2021 07:20:07 -0400
Message-Id: <20210706112203.2062605-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index eed57a931309..5e716199ccee 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -239,6 +239,9 @@ void virtio_gpu_release(struct drm_device *dev)
 {
 	struct virtio_gpu_device *vgdev = dev->dev_private;
 
+	if (!vgdev)
+		return;
+
 	virtio_gpu_modeset_fini(vgdev);
 	virtio_gpu_free_vbufs(vgdev);
 	virtio_gpu_cleanup_cap_cache(vgdev);
-- 
2.30.2


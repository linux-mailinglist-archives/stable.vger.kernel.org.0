Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30C04539D9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239519AbhKPTJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239841AbhKPTIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:08:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 148D56321B;
        Tue, 16 Nov 2021 19:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637089505;
        bh=pUC+/2H427L7tAVUY+8YM20rMCV65nBnq4xSfR84FZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arWDxm81MhlbXKoc6f9V25if+gxL5Fjf6hKZbroC6mJOnpdJVyv20RJvFA00Jt/aN
         kDsO78F+7Ueg3j1OE3PMDqmexiiaI+ufVrbBt+aPK+jH8roAZf/fU4vdj9hdgkCh5y
         EBFpR9ZT/vHA/tmAs9Hx0tmmx1svYpssTEDLsf+zO0AFpZLlOPJgXwVoJrK5Ux4Fep
         Yn1hmu6kGH6HuVE8E1+CEROqEV2TEV6XS3Bt74abSMp1JHx9FxGS4QpM3oDObylhyX
         YoZ91Z6NsGnqg4ylp+Mx7BTPV9IEqJxMN9lZLhssmFBTu8xyVYy4VOT86FnqHqRDwx
         9kcz7Dh0DJW1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 08/65] drm/virtio: fix the missed drm_gem_object_put() in virtio_gpu_user_framebuffer_create()
Date:   Tue, 16 Nov 2021 14:03:28 -0500
Message-Id: <20211116190443.2418144-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116190443.2418144-1-sashal@kernel.org>
References: <20211116190443.2418144-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit a63f393dd7e1ebee707c9dee1d197fdc33d6486b ]

virtio_gpu_user_framebuffer_create() misses to call drm_gem_object_put()
in an error path. Add the missed function call to fix it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Link: http://patchwork.freedesktop.org/patch/msgid/1633770560-11658-1-git-send-email-jingxiangfeng@huawei.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_display.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_display.c b/drivers/gpu/drm/virtio/virtgpu_display.c
index a6caebd4a0dd6..5b00310ac4cd4 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -308,8 +308,10 @@ virtio_gpu_user_framebuffer_create(struct drm_device *dev,
 		return ERR_PTR(-EINVAL);
 
 	virtio_gpu_fb = kzalloc(sizeof(*virtio_gpu_fb), GFP_KERNEL);
-	if (virtio_gpu_fb == NULL)
+	if (virtio_gpu_fb == NULL) {
+		drm_gem_object_put(obj);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	ret = virtio_gpu_framebuffer_init(dev, virtio_gpu_fb, mode_cmd, obj);
 	if (ret) {
-- 
2.33.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B728453A0D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhKPTVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239952AbhKPTVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38CD363222;
        Tue, 16 Nov 2021 19:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637090295;
        bh=pUC+/2H427L7tAVUY+8YM20rMCV65nBnq4xSfR84FZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCYF0xNMcHupOKf6Hr+F6U5NfWBleIffhW0+44H/V9ffQkJ1IXwiRD0NJ3wUDdxa6
         XaqtSN9guUF7nX1EvzKRqR9w2PaocSCa6nGd86S77iUjhSS5OONB0XFMY748WxNFO+
         +RfTCHfU4xVLWjyz9sk+oDOOU2UHNwaBGhak487XgRc56KBg1gf8h/vHcEYxnXJu5u
         uSc4qqag99QggJWHPGbbw8/KWZygXeHw6uL/rkVm94Qo50Ni7p/lfVY7HBugEAM/Rg
         5GxliFPB+HT1EZaG5LG9LQ4AQkFIwvqfQpOM1xi/nq6oSvVWjFKrM//XD2A6D9FO/l
         SNDzoaDSQ0rLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 08/65] drm/virtio: fix the missed drm_gem_object_put() in virtio_gpu_user_framebuffer_create()
Date:   Tue, 16 Nov 2021 14:16:53 -0500
Message-Id: <20211116191754.2419097-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116191754.2419097-1-sashal@kernel.org>
References: <20211116191754.2419097-1-sashal@kernel.org>
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


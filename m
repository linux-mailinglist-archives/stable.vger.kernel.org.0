Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55BD3BD106
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbhGFLh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235946AbhGFLbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C35D61D00;
        Tue,  6 Jul 2021 11:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570553;
        bh=t+WR/nCFP0tngsNLIaNM1FbBfFvCfQ7k0s1hVT10z28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEL0Cou3XpAhGqLg4kX6XmOVZ9sEOGO25Vw4J90BwvH2sL2Yn+xonYoorZeXYiFrl
         9gHagRAsJ9N0U8xrZsUey13vyxYfbzgKkAyHsekHzvOto3cMNkVJBbL4ymyoZit8B1
         Wx7SES2Yn/TXLtu1PRn3d8LG+nryjUkgjC4WzuJKtJWgATzQZRHRQYMTjb9hkaR2w9
         jo8ufqw7ITWn9fw2EZnoPFssgRW/eHo4NpwZohVHABclcyOnchVMecRZbSBbEmeZVw
         vu3UX5wpx/AQrUlQooM5BBe+ceuizhGMXXoej//aXnGrc7/Opplov0skdo5hLjfvAv
         8wNGDR61uVl9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 022/137] drm/virtio: Fix double free on probe failure
Date:   Tue,  6 Jul 2021 07:20:08 -0400
Message-Id: <20210706112203.2062605-22-sashal@kernel.org>
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

[ Upstream commit cec7f1774605a5ef47c134af62afe7c75c30b0ee ]

The virtio_gpu_init() will free vgdev and vgdev->vbufs on failure.
But such failure will be caught by virtio_gpu_probe() and then
virtio_gpu_release() will be called to do some cleanup which
will free vgdev and vgdev->vbufs again. So let's set dev->dev_private
to NULL to avoid double free.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210517084913.403-2-xieyongji@bytedance.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 5e716199ccee..618e46afcfc7 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -209,6 +209,7 @@ int virtio_gpu_init(struct drm_device *dev)
 err_vbufs:
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 err_vqs:
+	dev->dev_private = NULL;
 	kfree(vgdev);
 	return ret;
 }
-- 
2.30.2


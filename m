Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267283BD274
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhGFLmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237771AbhGFLhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9A4061DFA;
        Tue,  6 Jul 2021 11:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570983;
        bh=8yNEdd/0MjZ/xocDbC+PHtFygZD/hiHQOqnRNmoxL2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGLz3ASUuoWKBkAiQlUFl8ZLXlbymlpX1HxfH1dLku4mWiLYY//fijbiE+phsr4w/
         gnvinln6KrmDCpAngFyo6dyMon9oJvYqhsJ/qcs3XLmdNODfciUsXmy8lWrR0c4YGE
         NdOYdPhpaSQE2FFmd44FRj55dpJLhs0Wi+iboXaJcmBO+7AiYbxUB1IxliwZz/kdak
         JYAcBJdq/NqNdIQj1rPiOURchK0bqgNIdqvfEm0QB9DF5VEYTbOAGjXT3wEob3ilHE
         LuvDbGcrjRIix1p/LIS50/nVndDAVki3l/Dj7j5dk7boVjcuthMjfPFEnbwaJpg4g5
         UWV54v3D1QWpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.4 09/31] drm/virtio: Fix double free on probe failure
Date:   Tue,  6 Jul 2021 07:29:09 -0400
Message-Id: <20210706112931.2066397-9-sashal@kernel.org>
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
index 88ed5e235e55..fcf9b572ec03 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -233,6 +233,7 @@ int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags)
 err_vbufs:
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 err_vqs:
+	dev->dev_private = NULL;
 	kfree(vgdev);
 	return ret;
 }
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C50A24F4CE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgHXIlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728825AbgHXIlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:41:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A8F12087D;
        Mon, 24 Aug 2020 08:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258477;
        bh=75XYQvMC5k0maFPnExRGe5oedy+fRbrygDuwe1pxjbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKjh/0had0ol9qipQtLjRkPcz7fYKnwf7F7Cq/+Ij94TxuiL+hmOn33KzmcGRh5dv
         oFPx3eJupXu12IwxXDV01D15CgrbelaMZnKXrprOlQyYT5g1PT8I0X2mnDEy0rzE0E
         WRO8/WU7nTn8/4zqZiZyYjqqIzXLrVTsZA2tGKtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin He <hexin.op@bytedance.com>,
        Qi Liu <liuqi.16@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 060/124] drm/virtio: fix missing dma_fence_put() in virtio_gpu_execbuffer_ioctl()
Date:   Mon, 24 Aug 2020 10:29:54 +0200
Message-Id: <20200824082412.375270834@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Liu <liuqi.16@bytedance.com>

[ Upstream commit 8b6ec999b198b59ae61e86e70f5e9df73fe4754f ]

We should put the reference count of the fence after calling
virtio_gpu_cmd_submit(). So add the missing dma_fence_put().

Fixes: 2cd7b6f08bc4 ("drm/virtio: add in/out fence support for explicit synchronization")
Co-developed-by: Xin He <hexin.op@bytedance.com>
Signed-off-by: Xin He <hexin.op@bytedance.com>
Signed-off-by: Qi Liu <liuqi.16@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200721101647.42653-1-hexin.op@bytedance.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 512daff920387..1fc3fa00685d0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -180,6 +180,7 @@ static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 
 	virtio_gpu_cmd_submit(vgdev, buf, exbuf->size,
 			      vfpriv->ctx_id, buflist, out_fence);
+	dma_fence_put(&out_fence->f);
 	virtio_gpu_notify(vgdev);
 	return 0;
 
-- 
2.25.1




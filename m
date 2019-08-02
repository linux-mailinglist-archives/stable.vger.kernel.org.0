Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FB97F177
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391544AbfHBJeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391541AbfHBJeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:34:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E486217D4;
        Fri,  2 Aug 2019 09:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738464;
        bh=B3YAsxj1v3i/F2IxYcVkQZBQRn+uNvZ8Psu/Iv43SSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSLG28XJXTcqmU4a8FSaGSEKIYfZtRayoXYKbYM1a0GKTxP8UWqJMCqNMNlR93HAU
         NNTWDKdylbqQ3T/QNguyKBU/QuyUiMM4Rr87hSWsClaOHjqpCy3jqQtq4uL1CkQ/zO
         ABB5XjP3sPA5l2mnTEzJCP7MXxfZDV/+KJFDlVng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Riley <davidriley@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 114/158] drm/virtio: Add memory barriers for capset cache.
Date:   Fri,  2 Aug 2019 11:28:55 +0200
Message-Id: <20190802092227.258450827@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9ff3a5c88e1f1ab17a31402b96d45abe14aab9d7 ]

After data is copied to the cache entry, atomic_set is used indicate
that the data is the entry is valid without appropriate memory barriers.
Similarly the read side was missing the corresponding memory barriers.

Signed-off-by: David Riley <davidriley@chromium.org>
Link: http://patchwork.freedesktop.org/patch/msgid/20190610211810.253227-5-davidriley@chromium.org
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 3 +++
 drivers/gpu/drm/virtio/virtgpu_vq.c    | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 6296e9f270ca..0b8f8c10f2ed 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -535,6 +535,9 @@ static int virtio_gpu_get_caps_ioctl(struct drm_device *dev,
 	ret = wait_event_timeout(vgdev->resp_wq,
 				 atomic_read(&cache_ent->is_valid), 5 * HZ);
 
+	/* is_valid check must proceed before copy of the cache entry. */
+	smp_rmb();
+
 	ptr = cache_ent->caps_cache;
 
 copy_exit:
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 52436b3c01bb..a1b3ea1ccb65 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -618,6 +618,8 @@ static void virtio_gpu_cmd_capset_cb(struct virtio_gpu_device *vgdev,
 		    cache_ent->id == le32_to_cpu(cmd->capset_id)) {
 			memcpy(cache_ent->caps_cache, resp->capset_data,
 			       cache_ent->size);
+			/* Copy must occur before is_valid is signalled. */
+			smp_wmb();
 			atomic_set(&cache_ent->is_valid, 1);
 			break;
 		}
-- 
2.20.1




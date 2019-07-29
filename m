Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CE1798B7
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfG2UJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729794AbfG2Tfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:35:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA3A217D4;
        Mon, 29 Jul 2019 19:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428943;
        bh=ZGWD3sUV9uHaEwmTx4a0VLY6cZXDAmvPWcFM/D4w6YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5i5i2i0fEWv/G/6K3NhQdsdlqW7iUTehHXyDkQAEUN7mlDEp4vQ/3WX31LTae1rd
         GBWOlwDt9TgpKIRA0+OHiAeU/wHfBxMWx8bTqxncsGpmrTM2iDs3DZJ5Wfg8i5+Brq
         5GRuUdybzOft9wInMXPWSKZY6Sza/QLrNaHpfSbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Riley <davidriley@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 236/293] drm/virtio: Add memory barriers for capset cache.
Date:   Mon, 29 Jul 2019 21:22:07 +0200
Message-Id: <20190729190842.535102914@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index ed9c443bb8a1..40cc2f6707cf 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -523,6 +523,9 @@ static int virtio_gpu_get_caps_ioctl(struct drm_device *dev,
 	ret = wait_event_timeout(vgdev->resp_wq,
 				 atomic_read(&cache_ent->is_valid), 5 * HZ);
 
+	/* is_valid check must proceed before copy of the cache entry. */
+	smp_rmb();
+
 	ptr = cache_ent->caps_cache;
 
 copy_exit:
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 26a2da1f712d..21c2de81f3e3 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -585,6 +585,8 @@ static void virtio_gpu_cmd_capset_cb(struct virtio_gpu_device *vgdev,
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




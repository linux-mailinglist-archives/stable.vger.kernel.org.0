Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F19451396
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348466AbhKOTxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343653AbhKOTVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F33A6332D;
        Mon, 15 Nov 2021 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001839;
        bh=jDcNUAY7sQTIAgMdiaSRc9e9qxP7r73jQJtoHfkXLLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlO6Mao4LE50eTYVZgjCSxaU3/nhnW3OPcfbTO3g3O9gJcq9M64rLGZIP2/O634r4
         tO4o+/PAuoKOqdysTsrHsIk9EfqDlwnevpe4gfoJU1NjTy3UfmwiplbMZshzMQ5ndb
         fkeGujUDETu5BfAcdmmf7hgggzFFeOM/zLmkGYfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Liu <liuyuntao10@huawei.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/917] virtio-gpu: fix possible memory allocation failure
Date:   Mon, 15 Nov 2021 17:57:14 +0100
Message-Id: <20211115165440.243439247@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liuyuntao <liuyuntao10@huawei.com>

[ Upstream commit 5bd4f20de8acad37dbb3154feb34dbc36d506c02 ]

When kmem_cache_zalloc in virtio_gpu_get_vbuf fails, it will return
an error code. But none of its callers checks this error code, and
a core dump will take place.

Considering many of its callers can't handle such error, I add
a __GFP_NOFAIL flag when calling kmem_cache_zalloc to make sure
it won't fail, and delete those unused error handlings.

Fixes: dc5698e80cf724 ("Add virtio gpu driver.")
Signed-off-by: Yuntao Liu <liuyuntao10@huawei.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210828104321.3410312-1-liuyuntao10@huawei.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 2e71e91278b45..93a41d018dca6 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -91,9 +91,7 @@ virtio_gpu_get_vbuf(struct virtio_gpu_device *vgdev,
 {
 	struct virtio_gpu_vbuffer *vbuf;
 
-	vbuf = kmem_cache_zalloc(vgdev->vbufs, GFP_KERNEL);
-	if (!vbuf)
-		return ERR_PTR(-ENOMEM);
+	vbuf = kmem_cache_zalloc(vgdev->vbufs, GFP_KERNEL | __GFP_NOFAIL);
 
 	BUG_ON(size > MAX_INLINE_CMD_SIZE ||
 	       size < sizeof(struct virtio_gpu_ctrl_hdr));
@@ -147,10 +145,6 @@ static void *virtio_gpu_alloc_cmd_resp(struct virtio_gpu_device *vgdev,
 
 	vbuf = virtio_gpu_get_vbuf(vgdev, cmd_size,
 				   resp_size, resp_buf, cb);
-	if (IS_ERR(vbuf)) {
-		*vbuffer_p = NULL;
-		return ERR_CAST(vbuf);
-	}
 	*vbuffer_p = vbuf;
 	return (struct virtio_gpu_command *)vbuf->buf;
 }
-- 
2.33.0




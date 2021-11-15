Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A999D452437
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242470AbhKPBgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242469AbhKOSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9C8E6337C;
        Mon, 15 Nov 2021 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999580;
        bh=fRivFF4TBTjE8IRMFk3uj0Sfb0CupuIuRQ2rg33z+Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGlac6fxZa4TEuKNkAj4HugIF/uxpGQ47LdoDWTQbjNgIcddJSxm+rTUg79Hj4Tgq
         BWhpZfrthtyWf6HLfzwyRUQhqdIY3kJq9JrHigIRq7SJ5hmCroXGN//YD4HX0APsgi
         C4F9KK0WX+jt/tirj/y+cGFGoguv1uk5JS1Zl1Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuntao Liu <liuyuntao10@huawei.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 348/849] virtio-gpu: fix possible memory allocation failure
Date:   Mon, 15 Nov 2021 17:57:11 +0100
Message-Id: <20211115165432.005568992@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index cf84d382dd41d..5286cf1102088 100644
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




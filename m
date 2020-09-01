Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344222596D2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgIAQHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731500AbgIAPkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E0DF2064B;
        Tue,  1 Sep 2020 15:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974841;
        bh=rNtO65T5X977LmrSthX8B1rxzgNWxxn9MfHEe6m/FhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5agG54M+CkEIPvtVg3bz4q5TbDBGXsbjQVH4xHvGZLOiOuTIH8/CccUeXi2h6xT9
         I2uLRmA7dirzvJiOgotffiWmUhEflyMn4vs0ui48ZTZmweyaJdq4ART6MkZy5YVX70
         LTcy8DfmyFGd2yoxoT53ou3BEqn8Dw2tAIhYaUBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin He <hexin.op@bytedance.com>,
        Qi Liu <liuqi.16@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 111/255] drm/virtio: fix memory leak in virtio_gpu_cleanup_object()
Date:   Tue,  1 Sep 2020 17:09:27 +0200
Message-Id: <20200901151006.038695488@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin He <hexin.op@bytedance.com>

[ Upstream commit 836b194d65782aaec4485a07d2aab52d3f698505 ]

Before setting shmem->pages to NULL, kfree() should
be called.

Signed-off-by: Xin He <hexin.op@bytedance.com>
Reviewed-by: Qi Liu <liuqi.16@bytedance.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200722051851.72662-1-hexin.op@bytedance.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 6ccbd01cd888c..703b5cd517519 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -79,6 +79,7 @@ void virtio_gpu_cleanup_object(struct virtio_gpu_object *bo)
 			}
 
 			sg_free_table(shmem->pages);
+			kfree(shmem->pages);
 			shmem->pages = NULL;
 			drm_gem_shmem_unpin(&bo->base.base);
 		}
-- 
2.25.1




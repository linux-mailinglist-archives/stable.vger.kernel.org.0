Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7570A40E8A3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356084AbhIPRpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355653AbhIPRlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF00B63257;
        Thu, 16 Sep 2021 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811225;
        bh=Win2FUA14UtzRhj37+IIrKpGua+D0mCGiZ+2ENmq7KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDRSDy09545SOsNkAez/jDp7LnA7MjVReyBeQq0w5i/plxoDPHtBJxpe+tsBYjkXl
         o8QoKF1JOG8BLRbcffEJPWuTJXOfkRI6guyGft5r6uxFbVq1qkaYs2y9RxWJDNvM8g
         B23VStrS2BnKNQNCImr2jAxIugtrIZ4GJhoeXzgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <skeggsb@gmail.com>,
        Dave Airlie <airlied@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.14 428/432] drm/ttm: Fix ttm_bo_move_memcpy() for subclassed struct ttm_resource
Date:   Thu, 16 Sep 2021 18:02:57 +0200
Message-Id: <20210916155825.348520145@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit efcefc7127290e7e9fa98dea029163ad8eda8fb3 upstream.

The code was making a copy of a struct ttm_resource. However,
recently the struct ttm_resources were allowed to be subclassed and
also were allowed to be malloced, hence the driver could end up assuming
the copy we handed it was subclassed and worse, the original could have
been freed at this point.

Fix this by using the original struct ttm_resource before it is
potentially freed in ttm_bo_move_sync_cleanup()

v2: Base on drm-misc-next-fixes rather than drm-tip.

Reported-by: Ben Skeggs <skeggsb@gmail.com>
Reported-by: Dave Airlie <airlied@gmail.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
Fixes: 3bf3710e3718 ("drm/ttm: Add a generic TTM memcpy move for page-based iomem")
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210831071536.80636-1-thomas.hellstrom@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -143,7 +143,6 @@ int ttm_bo_move_memcpy(struct ttm_buffer
 	struct ttm_resource *src_mem = bo->resource;
 	struct ttm_resource_manager *src_man =
 		ttm_manager_type(bdev, src_mem->mem_type);
-	struct ttm_resource src_copy = *src_mem;
 	union {
 		struct ttm_kmap_iter_tt tt;
 		struct ttm_kmap_iter_linear_io io;
@@ -173,11 +172,11 @@ int ttm_bo_move_memcpy(struct ttm_buffer
 	}
 
 	ttm_move_memcpy(bo, dst_mem->num_pages, dst_iter, src_iter);
-	src_copy = *src_mem;
-	ttm_bo_move_sync_cleanup(bo, dst_mem);
 
 	if (!src_iter->ops->maps_tt)
-		ttm_kmap_iter_linear_io_fini(&_src_iter.io, bdev, &src_copy);
+		ttm_kmap_iter_linear_io_fini(&_src_iter.io, bdev, src_mem);
+	ttm_bo_move_sync_cleanup(bo, dst_mem);
+
 out_src_iter:
 	if (!dst_iter->ops->maps_tt)
 		ttm_kmap_iter_linear_io_fini(&_dst_iter.io, bdev, dst_mem);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF33A417407
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344472AbhIXNB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344515AbhIXM7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44B6A6136A;
        Fri, 24 Sep 2021 12:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488015;
        bh=Y0ifqwM0ik/0txa17mlwIy+/Fc1YXrdfnwMXOUfSEUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrRSOT5xZLgRkMvxLMWErqyjDG3kXT3LzmoVxxIkhHvzj5GPgL34Mi9fnXQMR0bSw
         0vZnvnBY1mJc+yoNqWFzAO/8y8wgcRwFu4EJsSu2YMOBupEnavlJqUQ2b5Av9eOFNE
         ccgt0PvQFVre2jS+kluukK0t/rECSrSs/YQFBMds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 051/100] drm/ttm: Fix a deadlock if the target BO is not idle during swap
Date:   Fri, 24 Sep 2021 14:44:00 +0200
Message-Id: <20210924124343.150751601@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit 70982eef4d7eebb47a3b1ef25ec1bc742f3a21cf ]

The ret value might be -EBUSY, caller will think lru lock is still
locked but actually NOT. So return -ENOSPC instead. Otherwise we hit
list corruption.

ttm_bo_cleanup_refs might fail too if BO is not idle. If we return 0,
caller(ttm_tt_populate -> ttm_global_swapout ->ttm_device_swapout) will
be stuck as we actually did not free any BO memory. This usually happens
when the fence is not signaled for a long time.

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: ebd59851c796 ("drm/ttm: move swapout logic around v3")
Link: https://patchwork.freedesktop.org/patch/msgid/20210907040832.1107747-1-xinhui.pan@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 32202385073a..b47a5053eb85 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1157,9 +1157,9 @@ int ttm_bo_swapout(struct ttm_buffer_object *bo, struct ttm_operation_ctx *ctx,
 	}
 
 	if (bo->deleted) {
-		ttm_bo_cleanup_refs(bo, false, false, locked);
+		ret = ttm_bo_cleanup_refs(bo, false, false, locked);
 		ttm_bo_put(bo);
-		return 0;
+		return ret == -EBUSY ? -ENOSPC : ret;
 	}
 
 	ttm_bo_del_from_lru(bo);
@@ -1213,7 +1213,7 @@ out:
 	if (locked)
 		dma_resv_unlock(bo->base.resv);
 	ttm_bo_put(bo);
-	return ret;
+	return ret == -EBUSY ? -ENOSPC : ret;
 }
 
 void ttm_bo_tt_destroy(struct ttm_buffer_object *bo)
-- 
2.33.0




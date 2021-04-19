Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2436431C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240058AbhDSNOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240218AbhDSNNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:13:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5C461246;
        Mon, 19 Apr 2021 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837925;
        bh=uGEXhgoiB83cl9XIBBwWbh5Xu/ZBnSdjsQ3ORwcGSgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5gpfl3tqTtL00EaSTuAUP2ux1ZQL7xkQ9MsOkRKwxBob8/fzFL7HxxlBKgopMMkW
         hrPW2h21YccvNugU2meAJBT44iZoNem3OmWtyTRSEeYbfu/ckNxyG9btxIGnPh4Gkr
         pVjt/yVhHRIX60/9uNE6QgLDGTF1cRgbKTKvyoms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Huang Rui <ray.huang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.11 068/122] drm/vmwgfx: Make sure we unpin no longer needed buffers
Date:   Mon, 19 Apr 2021 15:05:48 +0200
Message-Id: <20210419130532.496009143@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

commit ab4d9913632b1e5ffcf3365783e98718b3c83c7f upstream.

We were not correctly unpinning no longer needed buffers. In particular
vmw_buffer_object, which is internally often pinned on creation wasn't
unpinned on destruction and none of the internal MOB buffers were
unpinned before being put back. Technically this existed for a
long time but commit 57fcd550eb15 ("drm/ttm: Warn on pinning without
holding a reference") introduced a WARN_ON which was filling up the
kernel logs rather quickly.

Quite frankly internal usage of vmw_buffer_object and in general
pinning needs to be refactored in vmwgfx but for now this makes
it work.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Roland Scheidegger <sroland@vmware.com>
Fixes: 57fcd550eb15 ("drm/ttm: Warn on pinning without holding a reference")
Link: https://patchwork.freedesktop.org/patch/414984/?series=86052&rev=1
Cc: Huang Rui <ray.huang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h |    2 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1554,6 +1554,8 @@ static inline void vmw_bo_unreference(st
 
 	*buf = NULL;
 	if (tmp_buf != NULL) {
+		if (tmp_buf->base.pin_count > 0)
+			ttm_bo_unpin(&tmp_buf->base);
 		ttm_bo_put(&tmp_buf->base);
 	}
 }
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -277,6 +277,7 @@ out_no_setup:
 						 &batch->otables[i]);
 	}
 
+	ttm_bo_unpin(batch->otable_bo);
 	ttm_bo_put(batch->otable_bo);
 	batch->otable_bo = NULL;
 	return ret;
@@ -342,6 +343,7 @@ static void vmw_otable_batch_takedown(st
 	vmw_bo_fence_single(bo, NULL);
 	ttm_bo_unreserve(bo);
 
+	ttm_bo_unpin(batch->otable_bo);
 	ttm_bo_put(batch->otable_bo);
 	batch->otable_bo = NULL;
 }
@@ -528,6 +530,7 @@ static void vmw_mob_pt_setup(struct vmw_
 void vmw_mob_destroy(struct vmw_mob *mob)
 {
 	if (mob->pt_bo) {
+		ttm_bo_unpin(mob->pt_bo);
 		ttm_bo_put(mob->pt_bo);
 		mob->pt_bo = NULL;
 	}
@@ -643,6 +646,7 @@ int vmw_mob_bind(struct vmw_private *dev
 out_no_cmd_space:
 	vmw_fifo_resource_dec(dev_priv);
 	if (pt_set_up) {
+		ttm_bo_unpin(mob->pt_bo);
 		ttm_bo_put(mob->pt_bo);
 		mob->pt_bo = NULL;
 	}



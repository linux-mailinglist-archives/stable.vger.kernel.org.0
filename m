Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9033441B5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhCVMfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231643AbhCVMeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29C2A6199F;
        Mon, 22 Mar 2021 12:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416442;
        bh=N40+fZ3YNOp4uPZiFC1mNZfL5mBEIhSqyr+K9hCmHuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsw8DBfkw37M/szzFaLZn4B2aGR+/8kYFndz3tp2sgdUT3CaYQL1zfQ+MuAr2d/r8
         k67dFxLrGxBlcoavJXVqbITCreCEoGZEvQq0gbDo6Qk/oJU6l/6f1R1TET3uLvvy4X
         lVGaATcuzPRdxNHJo6PbKb2ceXZaHPvzCcFF4f2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 073/120] drm/ttm: Warn on pinning without holding a reference
Date:   Mon, 22 Mar 2021 13:27:36 +0100
Message-Id: <20210322121932.109281887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 57fcd550eb15bce14a7154736379dfd4ed60ae81 ]

Not technically a problem for ttm, but very likely a driver bug and
pretty big time confusing for reviewing code.

So warn about it, both at cleanup time (so we catch these for sure)
and at pin/unpin time (so we know who's the culprit).

Reviewed-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201028113120.3641237-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 2 +-
 include/drm/ttm/ttm_bo_api.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 22073e77fdf9..a76eb2c14e8c 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -514,7 +514,7 @@ static void ttm_bo_release(struct kref *kref)
 		 * shrinkers, now that they are queued for
 		 * destruction.
 		 */
-		if (bo->pin_count) {
+		if (WARN_ON(bo->pin_count)) {
 			bo->pin_count = 0;
 			ttm_bo_del_from_lru(bo);
 			ttm_bo_add_mem_to_lru(bo, &bo->mem);
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 2564e66e67d7..79b9367e0ffd 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -600,6 +600,7 @@ static inline bool ttm_bo_uses_embedded_gem_object(struct ttm_buffer_object *bo)
 static inline void ttm_bo_pin(struct ttm_buffer_object *bo)
 {
 	dma_resv_assert_held(bo->base.resv);
+	WARN_ON_ONCE(!kref_read(&bo->kref));
 	++bo->pin_count;
 }
 
@@ -613,6 +614,7 @@ static inline void ttm_bo_unpin(struct ttm_buffer_object *bo)
 {
 	dma_resv_assert_held(bo->base.resv);
 	WARN_ON_ONCE(!bo->pin_count);
+	WARN_ON_ONCE(!kref_read(&bo->kref));
 	--bo->pin_count;
 }
 
-- 
2.30.1




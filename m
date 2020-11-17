Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CD02B6515
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731722AbgKQNaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731687AbgKQNaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E93520781;
        Tue, 17 Nov 2020 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619800;
        bh=ZVTm+Rl8VcqdTjTPSlRjmhjKNKF9Qy8NpA4GzF+FyQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vo+IoBBQiQeOOtnJpCMxpWGPP6sJKo6r6EV/7BHzg7gdcRvXTjYJ0jwqbQ/WB70C8
         rt67/MC7q4XOoimqmyIjy9DM8P8njnUsaDJi2+940tWm8CrqjUbr3K4kckk42H1Jv6
         EoEKFy3+0qOrtwpz58itPhOblzEYcV98edxgFasA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 001/255] drm/i915: Hold onto an explicit ref to i915_vma_work.pinned
Date:   Tue, 17 Nov 2020 14:02:21 +0100
Message-Id: <20201117122138.996869649@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 537457a979a02a410b555fab289dcb28b588f33b ]

Since __vma_release is run by a kworker after the fence has been
signaled, it is no longer protected by the active reference on the vma,
and so the alias of vw->pinned to vma->obj is also not protected by a
reference on the object. Add an explicit reference for vw->pinned so it
will always be safe.

Found by inspection.

Fixes: 54d7195f8c64 ("drm/i915: Unpin vma->obj on early error")
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201102161931.30031-1-chris@chris-wilson.co.uk
(cherry picked from commit bc73e5d33048b7ab5f12b11b5d923700467a8e1d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_vma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index bc64f773dcdb4..034d0a8d24c8c 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -315,8 +315,10 @@ static void __vma_release(struct dma_fence_work *work)
 {
 	struct i915_vma_work *vw = container_of(work, typeof(*vw), base);
 
-	if (vw->pinned)
+	if (vw->pinned) {
 		__i915_gem_object_unpin_pages(vw->pinned);
+		i915_gem_object_put(vw->pinned);
+	}
 }
 
 static const struct dma_fence_work_ops bind_ops = {
@@ -430,7 +432,7 @@ int i915_vma_bind(struct i915_vma *vma,
 
 		if (vma->obj) {
 			__i915_gem_object_pin_pages(vma->obj);
-			work->pinned = vma->obj;
+			work->pinned = i915_gem_object_get(vma->obj);
 		}
 	} else {
 		ret = vma->ops->bind_vma(vma->vm, vma, cache_level, bind_flags);
-- 
2.27.0




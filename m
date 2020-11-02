Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F842A2F90
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgKBQTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:19:36 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:64210 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726862AbgKBQTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 11:19:36 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22871149-1500050 
        for multiple; Mon, 02 Nov 2020 16:19:35 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Hold onto an explicit ref to i915_vma_work.pinned
Date:   Mon,  2 Nov 2020 16:19:31 +0000
Message-Id: <20201102161931.30031-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/i915/i915_vma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index ffb5287e055a..caa9b041616b 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -314,8 +314,10 @@ static void __vma_release(struct dma_fence_work *work)
 {
 	struct i915_vma_work *vw = container_of(work, typeof(*vw), base);
 
-	if (vw->pinned)
+	if (vw->pinned) {
 		__i915_gem_object_unpin_pages(vw->pinned);
+		i915_gem_object_put(vw->pinned);
+	}
 
 	i915_vm_free_pt_stash(vw->vm, &vw->stash);
 	i915_vm_put(vw->vm);
@@ -431,7 +433,7 @@ int i915_vma_bind(struct i915_vma *vma,
 
 		if (vma->obj) {
 			__i915_gem_object_pin_pages(vma->obj);
-			work->pinned = vma->obj;
+			work->pinned = i915_gem_object_get(vma->obj);
 		}
 	} else {
 		vma->ops->bind_vma(vma->vm, NULL, vma, cache_level, bind_flags);
-- 
2.20.1


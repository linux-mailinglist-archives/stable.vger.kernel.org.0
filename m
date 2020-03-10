Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30A6180954
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgCJUlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:41:22 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:61524 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbgCJUlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:41:22 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20514553-1500050 
        for multiple; Tue, 10 Mar 2020 20:40:47 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 1/5] drm/i915: Check activity on i915_vma after confirming pin_count==0
Date:   Tue, 10 Mar 2020 20:40:42 +0000
Message-Id: <20200310204046.3995087-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only assert that the i915_vma is now idle if and only if no other pins
are present. If another user has the i915_vma pinned, they may submit
more work to the i915_vma skipping the vm->mutex used to serialise the
unbind. We need to wait again, if we want to continue and unbind this
vma.

However, if we own the i915_vma (we hold the vm->mutex for the unbind
and the pin_count is 0), we can assert that the vma remains idle as we
unbind.

Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/530
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200123224459.38128-1-chris@chris-wilson.co.uk
(cherry picked from commit 60e94557fff1f5514c7fc4da7ddc2c7a13ffff26)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit e4edd4fcbf4daf9d4319bef0bfaf350cb672239a)
---
 drivers/gpu/drm/i915/i915_vma.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 01c822256b39..7c7e152cc5ff 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1149,16 +1149,26 @@ int __i915_vma_unbind(struct i915_vma *vma)
 	if (ret)
 		return ret;
 
-	GEM_BUG_ON(i915_vma_is_active(vma));
 	if (i915_vma_is_pinned(vma)) {
 		vma_print_allocator(vma, "is pinned");
 		return -EBUSY;
 	}
 
-	GEM_BUG_ON(i915_vma_is_active(vma));
+	/*
+	 * After confirming that no one else is pinning this vma, wait for
+	 * any laggards who may have crept in during the wait (through
+	 * a residual pin skipping the vm->mutex) to complete.
+	 */
+	ret = i915_vma_sync(vma);
+	if (ret)
+		return ret;
+
 	if (!drm_mm_node_allocated(&vma->node))
 		return 0;
 
+	GEM_BUG_ON(i915_vma_is_pinned(vma));
+	GEM_BUG_ON(i915_vma_is_active(vma));
+
 	if (i915_vma_is_map_and_fenceable(vma)) {
 		/*
 		 * Check that we have flushed all writes through the GGTT
-- 
2.25.1


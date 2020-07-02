Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC1E211ED9
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 10:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgGBIcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 04:32:31 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60345 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726042AbgGBIcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 04:32:31 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21685223-1500050 
        for multiple; Thu, 02 Jul 2020 09:32:24 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/23] drm/i915: Drop vm.ref for duplicate vma on construction
Date:   Thu,  2 Jul 2020 09:32:03 +0100
Message-Id: <20200702083225.20044-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As we allow for parallel threads to create vma instances in parallel,
and we only filter out the duplicates upon reacquiring the spinlock for
the rbtree, we have to free the loser of the constructors' race. When
freeing, we should also drop any resource references acquired for the
redundant vma.

Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/i915_vma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 1f63c4a1f055..7fe1f317cd2b 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -198,6 +198,7 @@ vma_create(struct drm_i915_gem_object *obj,
 		cmp = i915_vma_compare(pos, vm, view);
 		if (cmp == 0) {
 			spin_unlock(&obj->vma.lock);
+			i915_vm_put(vm);
 			i915_vma_free(vma);
 			return pos;
 		}
-- 
2.20.1


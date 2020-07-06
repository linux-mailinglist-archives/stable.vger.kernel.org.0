Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AADB215C83
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 19:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgGFRBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 13:01:42 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:59955 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729384AbgGFRBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 13:01:42 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21731755-1500050 
        for multiple; Mon, 06 Jul 2020 18:01:40 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Pin the rings before marking active
Date:   Mon,  6 Jul 2020 18:01:38 +0100
Message-Id: <20200706170138.8993-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200706170021.8832-1-chris@chris-wilson.co.uk>
References: <20200706170021.8832-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On eviction, we acquire the vm->mutex and then wait on the vma->active.
Thereore when binding and pinning the vma, we must follow the same
sequence, lock/pin the vma then mark it active. Otherwise, we mark the
vma as active, then wait for the vm->mutex, and meanwhile the evictor
holding the mutex waits upon us to complete our activity.

Fixes: 8ccfc20a7d56 ("drm/i915/gt: Mark ring->vma as active while pinned")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/i915/gt/intel_context.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
index e4aece20bc80..52db2bde44a3 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -204,25 +204,25 @@ static int __ring_active(struct intel_ring *ring)
 {
 	int err;
 
-	err = i915_active_acquire(&ring->vma->active);
+	err = intel_ring_pin(ring);
 	if (err)
 		return err;
 
-	err = intel_ring_pin(ring);
+	err = i915_active_acquire(&ring->vma->active);
 	if (err)
-		goto err_active;
+		goto err_pin;
 
 	return 0;
 
-err_active:
-	i915_active_release(&ring->vma->active);
+err_pin:
+	intel_ring_unpin(ring);
 	return err;
 }
 
 static void __ring_retire(struct intel_ring *ring)
 {
-	intel_ring_unpin(ring);
 	i915_active_release(&ring->vma->active);
+	intel_ring_unpin(ring);
 }
 
 __i915_active_call
-- 
2.20.1


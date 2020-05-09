Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C05E1CC117
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 13:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgEILwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 07:52:25 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:57408 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726063AbgEILwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 07:52:25 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21147690-1500050 
        for multiple; Sat, 09 May 2020 12:52:21 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Watch out for idling during i915_gem_evict_something
Date:   Sat,  9 May 2020 12:52:17 +0100
Message-Id: <20200509115217.26853-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

i915_gem_evict_something() is charged with finding a slot within the GTT
that we may reuse. Since our goal is not to stall, we first look for a
slot that only overlaps idle vma. To this end, on the first pass we move
any active vma to the end of the search list. However, we only stopped
moving active vma after we see the first active vma twice. If during the
search, that first active vma completed, we would not notice and keep on
extending the search list.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1746
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/i915_gem_evict.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index 0ba7b1e881c0..6501939929d5 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -128,6 +128,13 @@ i915_gem_evict_something(struct i915_address_space *vm,
 	active = NULL;
 	INIT_LIST_HEAD(&eviction_list);
 	list_for_each_entry_safe(vma, next, &vm->bound_list, vm_link) {
+		if (vma == active) { /* now seen this vma twice */
+			if (flags & PIN_NONBLOCK)
+				break;
+
+			active = ERR_PTR(-EAGAIN);
+		}
+
 		/*
 		 * We keep this list in a rough least-recently scanned order
 		 * of active elements (inactive elements are cheap to reap).
@@ -143,21 +150,12 @@ i915_gem_evict_something(struct i915_address_space *vm,
 		 * To notice when we complete one full cycle, we record the
 		 * first active element seen, before moving it to the tail.
 		 */
-		if (i915_vma_is_active(vma)) {
-			if (vma == active) {
-				if (flags & PIN_NONBLOCK)
-					break;
-
-				active = ERR_PTR(-EAGAIN);
-			}
-
-			if (active != ERR_PTR(-EAGAIN)) {
-				if (!active)
-					active = vma;
+		if (active != ERR_PTR(-EAGAIN) && i915_vma_is_active(vma)) {
+			if (!active)
+				active = vma;
 
-				list_move_tail(&vma->vm_link, &vm->bound_list);
-				continue;
-			}
+			list_move_tail(&vma->vm_link, &vm->bound_list);
+			continue;
 		}
 
 		if (mark_free(&scan, vma, flags, &eviction_list))
-- 
2.20.1


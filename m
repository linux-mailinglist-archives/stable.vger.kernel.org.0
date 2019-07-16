Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B876A8E9
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfGPMtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 08:49:39 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:55268 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725926AbfGPMtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 08:49:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17342692-1500050 
        for multiple; Tue, 16 Jul 2019 13:49:30 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/5] drm/i915/userptr: Beware recursive lock_page()
Date:   Tue, 16 Jul 2019 13:49:27 +0100
Message-Id: <20190716124931.5870-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following a try_to_unmap() we may want to remove the userptr and so call
put_pages(). However, try_to_unmap() acquires the page lock and so we
must avoid recursively locking the pages ourselves -- which means that
we cannot safely acquire the lock around set_page_dirty(). Since we
can't be sure of the lock, we have to risk skip dirtying the page, or
else risk calling set_page_dirty() without a lock and so risk fs
corruption.

Reported-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: cb6d7c7dc7ff ("drm/i915/userptr: Acquire the page lock around set_page_dirty()")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index b9d2bb15e4a6..1ad2047a6dbd 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -672,7 +672,7 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 		obj->mm.dirty = false;
 
 	for_each_sgt_page(page, sgt_iter, pages) {
-		if (obj->mm.dirty)
+		if (obj->mm.dirty && trylock_page(page)) {
 			/*
 			 * As this may not be anonymous memory (e.g. shmem)
 			 * but exist on a real mapping, we have to lock
@@ -680,8 +680,20 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 			 * the page reference is not sufficient to
 			 * prevent the inode from being truncated.
 			 * Play safe and take the lock.
+			 *
+			 * However...!
+			 *
+			 * The mmu-notifier can be invalidated for a
+			 * migrate_page, that is alreadying holding the lock
+			 * on the page. Such a try_to_unmap() will result
+			 * in us calling put_pages() and so recursively try
+			 * to lock the page. We avoid that deadlock with
+			 * a trylock_page() and in exchange we risk missing
+			 * some page dirtying.
 			 */
-			set_page_dirty_lock(page);
+			set_page_dirty(page);
+			unlock_page(page);
+		}
 
 		mark_page_accessed(page);
 		put_page(page);
-- 
2.22.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA89F7500
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKKNcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:32:11 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:51832 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726843AbfKKNcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 08:32:11 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 19159918-1500050 
        for multiple; Mon, 11 Nov 2019 13:32:08 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@linux.intel.com, joonas.lahtinen@linux.intel.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [FIXES 1/3] drm/i915/userptr: Try to acquire the page lock around set_page_dirty()
Date:   Mon, 11 Nov 2019 13:32:03 +0000
Message-Id: <20191111133205.11590-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

set_page_dirty says:

	For pages with a mapping this should be done under the page lock
	for the benefit of asynchronous memory errors who prefer a
	consistent dirty state. This rule can be broken in some special
	cases, but should be better not to.

Under those rules, it is only safe for us to use the plain set_page_dirty
calls for shmemfs/anonymous memory. Userptr may be used with real
mappings and so needs to use the locked version (set_page_dirty_lock).

However, following a try_to_unmap() we may want to remove the userptr and
so call put_pages(). However, try_to_unmap() acquires the page lock and
so we must avoid recursively locking the pages ourselves -- which means
that we cannot safely acquire the lock around set_page_dirty(). Since we
can't be sure of the lock, we have to risk skip dirtying the page, or
else risk calling set_page_dirty() without a lock and so risk fs
corruption.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112012
Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video m
References: cb6d7c7dc7ff ("drm/i915/userptr: Acquire the page lock around set_page_dirty()")
References: 505a8ec7e11a ("Revert "drm/i915/userptr: Acquire the page lock around set_page_dirty()"")
References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 22 ++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index ee65c6acf0e2..dd104b0e2071 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -646,8 +646,28 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 		obj->mm.dirty = false;
 
 	for_each_sgt_page(page, sgt_iter, pages) {
-		if (obj->mm.dirty)
+		if (obj->mm.dirty && trylock_page(page)) {
+			/*
+			 * As this may not be anonymous memory (e.g. shmem)
+			 * but exist on a real mapping, we have to lock
+			 * the page in order to dirty it -- holding
+			 * the page reference is not sufficient to
+			 * prevent the inode from being truncated.
+			 * Play safe and take the lock.
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
+			 */
 			set_page_dirty(page);
+			unlock_page(page);
+		}
 
 		mark_page_accessed(page);
 		put_page(page);
-- 
2.24.0


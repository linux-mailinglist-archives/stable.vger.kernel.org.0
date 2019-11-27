Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1451010BC38
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732908AbfK0VJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732898AbfK0VJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 285EF21555;
        Wed, 27 Nov 2019 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888978;
        bh=2qfpcX+cD/9Z47Vc3pIFUjPlA9Rmg+HXjRPO1wwbwXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLh5Y6VSv0V/4s3pcLfSsap+Go8/NEeYQ1eO5Wzn/4QVxn6xVcFfKrvRssKI+Ux7B
         X4OlZlKkFKnjqhkvVsNtNTQkbsN9g+nX8673NySvH1j/PkGoDGfbOK53ePTiK3nS+r
         DV6+nDkM/tSNRg598eASWOUee4kRH3FlzyqoaIVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 35/95] drm/i915/userptr: Try to acquire the page lock around set_page_dirty()
Date:   Wed, 27 Nov 2019 21:31:52 +0100
Message-Id: <20191127202859.627144881@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 2d691aeca4aecbb8d0414a777a46981a8e142b05 upstream.

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
Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191111133205.11590-1-chris@chris-wilson.co.uk
(cherry picked from commit 0d4bbe3d407f79438dc4f87943db21f7134cfc65)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit cee7fb437edcdb2f9f8affa959e274997f5dca4d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -663,8 +663,28 @@ i915_gem_userptr_put_pages(struct drm_i9
 	i915_gem_gtt_finish_pages(obj, pages);
 
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



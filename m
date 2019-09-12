Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2065B0F3B
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 14:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbfILM4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 08:56:39 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:57034 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731772AbfILM4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Sep 2019 08:56:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 18464246-1500050 
        for multiple; Thu, 12 Sep 2019 13:56:36 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org, torvalds@linux-foundation.org
Cc:     Martin.Wilck@suse.com, MKoutny@suse.com, leho@kraav.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] Revert "drm/i915/userptr: Acquire the page lock around set_page_dirty()"
Date:   Thu, 12 Sep 2019 13:56:34 +0100
Message-Id: <20190912125634.29054-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <CAHk-=wjKv_Zw2zGHduyrQH_VQzxXYzwKdwwzzpsdnsdx=EK30Q@mail.gmail.com>
References: <CAHk-=wjKv_Zw2zGHduyrQH_VQzxXYzwKdwwzzpsdnsdx=EK30Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The userptr put_pages can be called from inside try_to_unmap, and so
enters with the page lock held on one of the object's backing pages. We
cannot take the page lock ourselves for fear of recursion.

Reported-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Reported-by: Martin Wilck <Martin.Wilck@suse.com>
Reported-by: Leo Kraav <leho@kraav.com>
Fixes: aa56a292ce62 ("drm/i915/userptr: Acquire the page lock around set_page_dirty()")
References: https://bugzilla.kernel.org/show_bug.cgi?id=203317
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index 74da35611d7c..11b231c187c5 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -672,15 +672,7 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 
 	for_each_sgt_page(page, sgt_iter, pages) {
 		if (obj->mm.dirty)
-			/*
-			 * As this may not be anonymous memory (e.g. shmem)
-			 * but exist on a real mapping, we have to lock
-			 * the page in order to dirty it -- holding
-			 * the page reference is not sufficient to
-			 * prevent the inode from being truncated.
-			 * Play safe and take the lock.
-			 */
-			set_page_dirty_lock(page);
+			set_page_dirty(page);
 
 		mark_page_accessed(page);
 		put_page(page);
-- 
2.23.0


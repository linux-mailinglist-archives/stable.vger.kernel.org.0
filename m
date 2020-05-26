Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B364E1A5129
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgDKMS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgDKMS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6006220673;
        Sat, 11 Apr 2020 12:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607505;
        bh=cnfW//iFPTjHMwCTSZLNmYBO4X0mI7EXj0oDE+xuzDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8xWH84QxGxfCgo72P+XhhzAwuygmZNfzcLYu7UZdqnt9vbdIIxy6j+x+1SEFaPY4
         lVDRNyDP16+dpKjH32sDC6qoSpkfWQHuMR7MHUcZoCnSnujHn4ne1apSLDzFL8hGCu
         fDzLXYz+PWzXCMBdywOS6Ac+hAPK/NnYNHQI+JVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH 5.4 40/41] drm/i915: Fix ref->mutex deadlock in i915_active_wait()
Date:   Sat, 11 Apr 2020 14:09:49 +0200
Message-Id: <20200411115507.029644194@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

The following deadlock exists in i915_active_wait() due to a double lock
on ref->mutex (call chain listed in order from top to bottom):
 i915_active_wait();
 mutex_lock_interruptible(&ref->mutex); <-- ref->mutex first acquired
 i915_active_request_retire();
 node_retire();
 active_retire();
 mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING); <-- DEADLOCK

Fix the deadlock by skipping the second ref->mutex lock when
active_retire() is called through i915_active_request_retire().

Note that this bug only affects 5.4 and has since been fixed in 5.5.
Normally, a backport of the fix from 5.5 would be in order, but the
patch set that fixes this deadlock involves massive changes that are
neither feasible nor desirable for backporting [1][2][3]. Therefore,
this small patch was made to address the deadlock specifically for 5.4.

[1] 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
[2] 093b92287363 ("drm/i915: Split i915_active.mutex into an irq-safe spinlock for the rbtree")
[3] 750bde2fd4ff ("drm/i915: Serialise with remote retirement")

Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_active.c |   29 +++++++++++++++++++----------
 drivers/gpu/drm/i915/i915_active.h |    4 ++--
 2 files changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -121,7 +121,7 @@ static inline void debug_active_assert(s
 #endif
 
 static void
-__active_retire(struct i915_active *ref)
+__active_retire(struct i915_active *ref, bool lock)
 {
 	struct active_node *it, *n;
 	struct rb_root root;
@@ -138,7 +138,8 @@ __active_retire(struct i915_active *ref)
 		retire = true;
 	}
 
-	mutex_unlock(&ref->mutex);
+	if (likely(lock))
+		mutex_unlock(&ref->mutex);
 	if (!retire)
 		return;
 
@@ -153,21 +154,28 @@ __active_retire(struct i915_active *ref)
 }
 
 static void
-active_retire(struct i915_active *ref)
+active_retire(struct i915_active *ref, bool lock)
 {
 	GEM_BUG_ON(!atomic_read(&ref->count));
 	if (atomic_add_unless(&ref->count, -1, 1))
 		return;
 
 	/* One active may be flushed from inside the acquire of another */
-	mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING);
-	__active_retire(ref);
+	if (likely(lock))
+		mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING);
+	__active_retire(ref, lock);
 }
 
 static void
 node_retire(struct i915_active_request *base, struct i915_request *rq)
 {
-	active_retire(node_from_active(base)->ref);
+	active_retire(node_from_active(base)->ref, true);
+}
+
+static void
+node_retire_nolock(struct i915_active_request *base, struct i915_request *rq)
+{
+	active_retire(node_from_active(base)->ref, false);
 }
 
 static struct i915_active_request *
@@ -364,7 +372,7 @@ int i915_active_acquire(struct i915_acti
 void i915_active_release(struct i915_active *ref)
 {
 	debug_active_assert(ref);
-	active_retire(ref);
+	active_retire(ref, true);
 }
 
 static void __active_ungrab(struct i915_active *ref)
@@ -391,7 +399,7 @@ void i915_active_ungrab(struct i915_acti
 {
 	GEM_BUG_ON(!test_bit(I915_ACTIVE_GRAB_BIT, &ref->flags));
 
-	active_retire(ref);
+	active_retire(ref, true);
 	__active_ungrab(ref);
 }
 
@@ -421,12 +429,13 @@ int i915_active_wait(struct i915_active
 			break;
 		}
 
-		err = i915_active_request_retire(&it->base, BKL(ref));
+		err = i915_active_request_retire(&it->base, BKL(ref),
+						 node_retire_nolock);
 		if (err)
 			break;
 	}
 
-	__active_retire(ref);
+	__active_retire(ref, true);
 	if (err)
 		return err;
 
--- a/drivers/gpu/drm/i915/i915_active.h
+++ b/drivers/gpu/drm/i915/i915_active.h
@@ -309,7 +309,7 @@ i915_active_request_isset(const struct i
  */
 static inline int __must_check
 i915_active_request_retire(struct i915_active_request *active,
-			   struct mutex *mutex)
+			   struct mutex *mutex, i915_active_retire_fn retire)
 {
 	struct i915_request *request;
 	long ret;
@@ -327,7 +327,7 @@ i915_active_request_retire(struct i915_a
 	list_del_init(&active->link);
 	RCU_INIT_POINTER(active->request, NULL);
 
-	active->retire(active, request);
+	retire(active, request);
 
 	return 0;
 }



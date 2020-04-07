Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8841A16DB
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 22:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgDGUcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 16:32:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40392 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGUcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 16:32:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id c5so2267768pgi.7
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qhPpfFteZIfWrEJlntDkn6if+yF8uTQoq/j753BbP0E=;
        b=qt2IdTVLiIW8xUJiCpdPv/D4YuXx9OyCK3iJ9JbqJFnv4dJ17BombULLkVmlqJEIPm
         +P9WBiAYUGLTpqnyfae2ciKJCoGOqujUgYTI4jtYkd8FwlBt6tHWdNTJaniIxvmxLSna
         KJahECsvIHXotZehip/i+YN4Gf/aiaHIITA5DYYC5iZWizZch9sxq084jyJspqOcvdwB
         VzJiiVx/CVzVYykY4AetXOtPMNDSRXm9sC6NpklGICVv5GFJZPbCePimwnJN8866VxsJ
         xUGRKFDGdefsodc6fEJWl7a4AfeyT3//p0UMP6bOe45uhNCN1Q9BiHtFFrZygtFgwU0Z
         uMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=qhPpfFteZIfWrEJlntDkn6if+yF8uTQoq/j753BbP0E=;
        b=AetofRPOYMcxoocFQK2C+mHPynjohUSyIaLdkFnwPvEHe1hOVgeRGthSzDHwET3eN9
         5TTNhm+2xt7TZdAI6YoWe5P9ExMuEYy8exlh2f38F7BFB0VDc3UTpxhaCuitC67coSqR
         8R6cOfnwd61GDa7spAIP1nZC9yw/ctS7pd2e4BT92h3bMbUTt+kiVNS+zwEx75p6SKBQ
         q+QN3HqoJgDuGv/ehg4F5pVvFl+ffhn1rO5FLTtemsHWnbspXOEQBfOVPv0iNbH13Rhl
         H5i+R9WTHgiRu29gayu/a0suXLLhhtuOcsFh91sAmfHpVd8Tkl0kzP0mtljoLvvEqhxz
         CgUA==
X-Gm-Message-State: AGi0PuYDm/PWPNODMU5sSRPeej/6stB6vxRDN3rcnoFJG8i5Z6gyBfXp
        rU/x8z9oIiLI9FpGs+7b4RbZs4iZ
X-Google-Smtp-Source: APiQypKLItpqc6k/pyzeGTdcU9htT7qY2tFPuj7AiEfM/jLGNp2gU1Y4+145Fity8Rn9knrnilkqlw==
X-Received: by 2002:a63:d801:: with SMTP id b1mr3804589pgh.49.1586291551390;
        Tue, 07 Apr 2020 13:32:31 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id 202sm1162995pgf.41.2020.04.07.13.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 13:32:30 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     stable@vger.kernel.org
Cc:     Greg KH <greg@kroah.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH v3] drm/i915: Fix ref->mutex deadlock in i915_active_wait()
Date:   Tue,  7 Apr 2020 13:32:22 -0700
Message-Id: <20200407203222.2493-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407071809.3148-1-sultan@kerneltoast.com>
References: <20200407071809.3148-1-sultan@kerneltoast.com>
MIME-Version: 1.0
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
---
v3: The `ref` pointer can be unaligned, so we can't pack it. Shucks.

 drivers/gpu/drm/i915/i915_active.c | 29 +++++++++++++++++++----------
 drivers/gpu/drm/i915/i915_active.h |  4 ++--
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 48e16ad93bbd..51dc8753b527 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -121,7 +121,7 @@ static inline void debug_active_assert(struct i915_active *ref) { }
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
@@ -364,7 +372,7 @@ int i915_active_acquire(struct i915_active *ref)
 void i915_active_release(struct i915_active *ref)
 {
 	debug_active_assert(ref);
-	active_retire(ref);
+	active_retire(ref, true);
 }
 
 static void __active_ungrab(struct i915_active *ref)
@@ -391,7 +399,7 @@ void i915_active_ungrab(struct i915_active *ref)
 {
 	GEM_BUG_ON(!test_bit(I915_ACTIVE_GRAB_BIT, &ref->flags));
 
-	active_retire(ref);
+	active_retire(ref, true);
 	__active_ungrab(ref);
 }
 
@@ -421,12 +429,13 @@ int i915_active_wait(struct i915_active *ref)
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
 
diff --git a/drivers/gpu/drm/i915/i915_active.h b/drivers/gpu/drm/i915/i915_active.h
index f95058f99057..0ad7ef60d15f 100644
--- a/drivers/gpu/drm/i915/i915_active.h
+++ b/drivers/gpu/drm/i915/i915_active.h
@@ -309,7 +309,7 @@ i915_active_request_isset(const struct i915_active_request *active)
  */
 static inline int __must_check
 i915_active_request_retire(struct i915_active_request *active,
-			   struct mutex *mutex)
+			   struct mutex *mutex, i915_active_retire_fn retire)
 {
 	struct i915_request *request;
 	long ret;
@@ -327,7 +327,7 @@ i915_active_request_retire(struct i915_active_request *active,
 	list_del_init(&active->link);
 	RCU_INIT_POINTER(active->request, NULL);
 
-	active->retire(active, request);
+	retire(active, request);
 
 	return 0;
 }
-- 
2.26.0


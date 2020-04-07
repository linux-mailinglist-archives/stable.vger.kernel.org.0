Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E8F1A0811
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 09:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgDGHSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 03:18:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35487 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgDGHSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 03:18:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id k5so1301949pga.2
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 00:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/GQ4Mzd+Y4zQQzO7Nj/8dbDh4gKCCxe6FOawSokHhzY=;
        b=lSIOiSLlJ1/XZuliqXmf8INwB4Q4FTbmueYFZ1KyRFLOYScBYLDVw54KR/6LWTtCb3
         kIiM8nVxohqR3UMuojfookwscbiNbeJ6MSM1SsyBywU3hVEAGmtfdvftHVmxo/Ni5R+Y
         Yk38p+5jF0i0CMZ2YPNOieQNAphCn4dl/AWhCnUGyPEA/ik9gxopFX+NNx0ieUDFd2Rm
         W3He2l9tT9v4IyNNIw0Zrf/6yczc0qC9sLhJcbNo1TPo87nLMBDSFkz47d38HsA9RmPL
         1ujnJRBSXkquDcKjyUKCPaZYg7c3HsSKqys7r6aSpCZE0Aw8sF0z+c2qwdkkIshXA1YI
         oy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=/GQ4Mzd+Y4zQQzO7Nj/8dbDh4gKCCxe6FOawSokHhzY=;
        b=PkCtcy12fpDQfIHTUJDY0TwvBvXXEtxCEFyRPZl1Xy2pvknNClz41slgDJHMCHjdBs
         SbFKacTGMECDTUwDfphuLDg3X2GMacN8TSuqq/oyhSX8hQxT0549m8jUqNHRAxHOSjH1
         nWhWDpBX0qp9Rwjsfow4RgucL5VCw0Hd6PRm3cXWDJl3w0snWWSkK4PyY9scavZyp44I
         hNiWpTQvWM7IqnTNHT9OetgQsw1q2zj+GOPC4oBeXP3EW/UuILEMi93Xovv0W+qb0NZP
         tUM2gjt8WziGgzggWXInPJwm1edUJW/V3E2EAYr4q3Kww4gW5F4A50Gqhjt4fjTq1l0U
         olVg==
X-Gm-Message-State: AGi0PubaQ9GxT2vWXkbgtLzabrnm69X3GX3+1ANOSiEsOYXzoRZw5xLX
        BT5zAx4NnF3lZD2txtWqSgQ=
X-Google-Smtp-Source: APiQypIfpF6w4PQ1GhuSU3dN5IMlZ+xs2VdvaGoulKgis5I8TfA+Zx0VjdOT+kvEY8yDMeoxQrnCkA==
X-Received: by 2002:a63:1d4:: with SMTP id 203mr714113pgb.74.1586243916722;
        Tue, 07 Apr 2020 00:18:36 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id u41sm12818677pgn.8.2020.04.07.00.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 00:18:36 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH v2] drm/i915: Fix ref->mutex deadlock in i915_active_wait()
Date:   Tue,  7 Apr 2020 00:18:09 -0700
Message-Id: <20200407071809.3148-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407065210.GA263852@kroah.com>
References: <20200407065210.GA263852@kroah.com>
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
 drivers/gpu/drm/i915/i915_active.c | 27 +++++++++++++++++++++++----
 drivers/gpu/drm/i915/i915_active.h |  4 ++--
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 48e16ad93bbd..cfc77c08a273 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -120,13 +120,17 @@ static inline void debug_active_assert(struct i915_active *ref) { }
 
 #endif
 
+#define I915_ACTIVE_RETIRE_NOLOCK BIT(0)
+
 static void
 __active_retire(struct i915_active *ref)
 {
 	struct active_node *it, *n;
 	struct rb_root root;
 	bool retire = false;
+	unsigned long bits;
 
+	ref = ptr_unpack_bits(ref, &bits, 2);
 	lockdep_assert_held(&ref->mutex);
 
 	/* return the unused nodes to our slabcache -- flushing the allocator */
@@ -138,7 +142,8 @@ __active_retire(struct i915_active *ref)
 		retire = true;
 	}
 
-	mutex_unlock(&ref->mutex);
+	if (!(bits & I915_ACTIVE_RETIRE_NOLOCK))
+		mutex_unlock(&ref->mutex);
 	if (!retire)
 		return;
 
@@ -155,13 +160,18 @@ __active_retire(struct i915_active *ref)
 static void
 active_retire(struct i915_active *ref)
 {
+	struct i915_active *ref_packed = ref;
+	unsigned long bits;
+
+	ref = ptr_unpack_bits(ref, &bits, 2);
 	GEM_BUG_ON(!atomic_read(&ref->count));
 	if (atomic_add_unless(&ref->count, -1, 1))
 		return;
 
 	/* One active may be flushed from inside the acquire of another */
-	mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING);
-	__active_retire(ref);
+	if (!(bits & I915_ACTIVE_RETIRE_NOLOCK))
+		mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING);
+	__active_retire(ref_packed);
 }
 
 static void
@@ -170,6 +180,14 @@ node_retire(struct i915_active_request *base, struct i915_request *rq)
 	active_retire(node_from_active(base)->ref);
 }
 
+static void
+node_retire_nolock(struct i915_active_request *base, struct i915_request *rq)
+{
+	struct i915_active *ref = node_from_active(base)->ref;
+
+	active_retire(ptr_pack_bits(ref, I915_ACTIVE_RETIRE_NOLOCK, 2));
+}
+
 static struct i915_active_request *
 active_instance(struct i915_active *ref, struct intel_timeline *tl)
 {
@@ -421,7 +439,8 @@ int i915_active_wait(struct i915_active *ref)
 			break;
 		}
 
-		err = i915_active_request_retire(&it->base, BKL(ref));
+		err = i915_active_request_retire(&it->base, BKL(ref),
+						 node_retire_nolock);
 		if (err)
 			break;
 	}
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


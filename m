Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF0C1A0774
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 08:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgDGGkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 02:40:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37636 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgDGGkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 02:40:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id r4so1253857pgg.4;
        Mon, 06 Apr 2020 23:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fm6LJDmH7DpHAZWmJ7CtgnKu1qV4Pl1oU9w/s7UYiNc=;
        b=r6Vz6eOsIhiT8PYQV8Gm/1nhdDnr4xPfN2AsBulNfdQV2EuHeBoN1SaNeghGd18hJq
         SK8sySk68JNsgKq2JRu9Sgcy12RM/eOCPJR/OFAZT00pCWL5NIpbr962vB/PYssRmrzL
         4HioGlTsN+xvZi1SPdgwh8gyNuj9PuaSsGKhw/CGtc+X3a56zIyxtTWIfabxPhsv8kbe
         hhot1TxStK//JND9f/WXrjfIT1WpRUT2HKs6aBKWpJfXn3Vk3B0SYN4jHi79rVZzqB4e
         udLTtfxKTRdyjVo3hSKxYLZNKQdV+9aDTFQayZMGGCDpQCJ+oR9oW9J8KqutdW43xWYZ
         iaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Fm6LJDmH7DpHAZWmJ7CtgnKu1qV4Pl1oU9w/s7UYiNc=;
        b=mFUlHyIJNOkJO6shh5P62pHcbvES2UXBjY1/6XaXWA5TsH0jPrIHTrQ2MpvyBNvDjp
         ljYI8tiucOEfsv3ARDYCYm4JUSSTDj2T2aj6l3284mTOE9WTHnrL1meXrGMAoNpUJMPp
         opkY1/XQko4puSMQWx/3oiAxO5Np0aROA6+SUkqOl9ODN3ZouHbQ5bfvC8LvY6WjORaj
         dJDWvIybaOh2oX9pDPaHDzNaWBYZDMUtmqS+KMnigle3zhqjK48JYE3uIz15rHDvhBRT
         2l8WVn185YyMo9PS59waQSIax5T57iRrRgja7VO/oTthehkBidZXGNBXaj7Sr2mbnbLF
         gANg==
X-Gm-Message-State: AGi0PuYo/lEi1dQu2uNRkJzTrTWst7MVlbO59nnSLqFOgTCtrZyGE8KJ
        wSUk8tCY4HqSdO8EHyJWmLSt6p/z
X-Google-Smtp-Source: APiQypK1+hQ+hBZG9UWboAxuUmwj3dA4Mm9U1VZjA5ind4vIZ1SgCpnzksadtHZegrQLLMp/J3Vo+A==
X-Received: by 2002:a63:4c21:: with SMTP id z33mr553131pga.359.1586241614715;
        Mon, 06 Apr 2020 23:40:14 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id iq23sm703764pjb.18.2020.04.06.23.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 23:40:14 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] drm/i915: Synchronize active and retire callbacks
Date:   Mon,  6 Apr 2020 23:40:06 -0700
Message-Id: <20200407064007.7599-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200404024156.GA10382@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

Active and retire callbacks can run simultaneously, causing panics and
mayhem. The most notable case is with the intel_context_pin/unpin race
that causes ring and page table corruption. In 5.4, this race is more
noticeable because intel_ring_unpin() sets ring->vaddr to NULL and
causes a clean NULL-pointer-dereference panic, but in newer kernels this
race goes unnoticed.

Here is an example of a crash caused by this race on 5.4:
BUG: unable to handle page fault for address: 0000000000003448
RIP: 0010:gen8_emit_flush_render+0x163/0x190
Call Trace:
 execlists_request_alloc+0x25/0x40
 __i915_request_create+0x1f4/0x2c0
 i915_request_create+0x71/0xc0
 i915_gem_do_execbuffer+0xb98/0x1a80
 ? preempt_count_add+0x68/0xa0
 ? _raw_spin_lock+0x13/0x30
 ? _raw_spin_unlock+0x16/0x30
 i915_gem_execbuffer2_ioctl+0x1de/0x3c0
 ? i915_gem_busy_ioctl+0x7f/0x1d0
 ? i915_gem_execbuffer_ioctl+0x2d0/0x2d0
 drm_ioctl_kernel+0xb2/0x100
 drm_ioctl+0x209/0x360
 ? i915_gem_execbuffer_ioctl+0x2d0/0x2d0
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x4e/0x150
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Protect the active and retire callbacks with their own lock to prevent
them from running at the same time as one another.

Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/gpu/drm/i915/i915_active.c       | 52 ++++++++++++++++++++----
 drivers/gpu/drm/i915/i915_active.h       | 10 ++---
 drivers/gpu/drm/i915/i915_active_types.h |  2 +
 3 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index b0a499753526..5802233f71ec 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -147,8 +147,22 @@ __active_retire(struct i915_active *ref)
 	spin_unlock_irqrestore(&ref->tree_lock, flags);
 
 	/* After the final retire, the entire struct may be freed */
-	if (ref->retire)
-		ref->retire(ref);
+	if (ref->retire) {
+		if (ref->active) {
+			bool freed = false;
+
+			/* Don't race with the active callback, and avoid UaF */
+			down_write(&ref->rwsem);
+			ref->freed = &freed;
+			ref->retire(ref);
+			if (!freed) {
+				ref->freed = NULL;
+				up_write(&ref->rwsem);
+			}
+		} else {
+			ref->retire(ref);
+		}
+	}
 
 	/* ... except if you wait on it, you must manage your own references! */
 	wake_up_var(ref);
@@ -278,7 +292,8 @@ void __i915_active_init(struct i915_active *ref,
 			int (*active)(struct i915_active *ref),
 			void (*retire)(struct i915_active *ref),
 			struct lock_class_key *mkey,
-			struct lock_class_key *wkey)
+			struct lock_class_key *wkey,
+			struct lock_class_key *rkey)
 {
 	unsigned long bits;
 
@@ -287,8 +302,13 @@ void __i915_active_init(struct i915_active *ref,
 	ref->flags = 0;
 	ref->active = active;
 	ref->retire = ptr_unpack_bits(retire, &bits, 2);
-	if (bits & I915_ACTIVE_MAY_SLEEP)
+	ref->freed = NULL;
+	if (ref->active && ref->retire) {
+		__init_rwsem(&ref->rwsem, "i915_active.rwsem", rkey);
 		ref->flags |= I915_ACTIVE_RETIRE_SLEEPS;
+	} else if (bits & I915_ACTIVE_MAY_SLEEP) {
+		ref->flags |= I915_ACTIVE_RETIRE_SLEEPS;
+	}
 
 	spin_lock_init(&ref->tree_lock);
 	ref->tree = RB_ROOT;
@@ -417,8 +437,20 @@ int i915_active_acquire(struct i915_active *ref)
 		return err;
 
 	if (likely(!i915_active_acquire_if_busy(ref))) {
-		if (ref->active)
-			err = ref->active(ref);
+		if (ref->active) {
+			if (ref->retire) {
+				/*
+				 * This can be a recursive call, and the mutex
+				 * above already protects from concurrent active
+				 * callbacks, so a read lock fits best.
+				 */
+				down_read(&ref->rwsem);
+				err = ref->active(ref);
+				up_read(&ref->rwsem);
+			} else {
+				err = ref->active(ref);
+			}
+		}
 		if (!err) {
 			spin_lock_irq(&ref->tree_lock); /* __active_retire() */
 			debug_active_activate(ref);
@@ -502,16 +534,20 @@ int i915_request_await_active(struct i915_request *rq, struct i915_active *ref)
 	return err;
 }
 
-#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM)
 void i915_active_fini(struct i915_active *ref)
 {
+	if (ref->freed) {
+		*ref->freed = true;
+		up_write(&ref->rwsem);
+	}
+#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM)
 	debug_active_fini(ref);
 	GEM_BUG_ON(atomic_read(&ref->count));
 	GEM_BUG_ON(work_pending(&ref->work));
 	GEM_BUG_ON(!RB_EMPTY_ROOT(&ref->tree));
 	mutex_destroy(&ref->mutex);
-}
 #endif
+}
 
 static inline bool is_idle_barrier(struct active_node *node, u64 idx)
 {
diff --git a/drivers/gpu/drm/i915/i915_active.h b/drivers/gpu/drm/i915/i915_active.h
index 51e1e854ca55..b684b1fdcc02 100644
--- a/drivers/gpu/drm/i915/i915_active.h
+++ b/drivers/gpu/drm/i915/i915_active.h
@@ -153,14 +153,16 @@ void __i915_active_init(struct i915_active *ref,
 			int (*active)(struct i915_active *ref),
 			void (*retire)(struct i915_active *ref),
 			struct lock_class_key *mkey,
-			struct lock_class_key *wkey);
+			struct lock_class_key *wkey,
+			struct lock_class_key *rkey);
 
 /* Specialise each class of i915_active to avoid impossible lockdep cycles. */
 #define i915_active_init(ref, active, retire) do {		\
 	static struct lock_class_key __mkey;				\
 	static struct lock_class_key __wkey;				\
+	static struct lock_class_key __rkey;				\
 									\
-	__i915_active_init(ref, active, retire, &__mkey, &__wkey);	\
+	__i915_active_init(ref, active, retire, &__mkey, &__wkey, &__rkey);	\
 } while (0)
 
 int i915_active_ref(struct i915_active *ref,
@@ -200,11 +202,7 @@ i915_active_is_idle(const struct i915_active *ref)
 	return !atomic_read(&ref->count);
 }
 
-#if IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM)
 void i915_active_fini(struct i915_active *ref);
-#else
-static inline void i915_active_fini(struct i915_active *ref) { }
-#endif
 
 int i915_active_acquire_preallocate_barrier(struct i915_active *ref,
 					    struct intel_engine_cs *engine);
diff --git a/drivers/gpu/drm/i915/i915_active_types.h b/drivers/gpu/drm/i915/i915_active_types.h
index 6360c3e4b765..aaee2548cb19 100644
--- a/drivers/gpu/drm/i915/i915_active_types.h
+++ b/drivers/gpu/drm/i915/i915_active_types.h
@@ -32,6 +32,8 @@ struct active_node;
 struct i915_active {
 	atomic_t count;
 	struct mutex mutex;
+	struct rw_semaphore rwsem;
+	bool *freed;
 
 	spinlock_t tree_lock;
 	struct active_node *cache;
-- 
2.26.0


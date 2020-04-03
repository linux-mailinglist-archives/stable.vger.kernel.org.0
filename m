Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858CF19E11F
	for <lists+stable@lfdr.de>; Sat,  4 Apr 2020 00:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbgDCWf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 18:35:57 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51068 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388671AbgDCWf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 18:35:57 -0400
Received: by mail-pj1-f67.google.com with SMTP id v13so3679866pjb.0;
        Fri, 03 Apr 2020 15:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dR+Oy8zkwr65n1hWzP0tj7ddjB1+ZTKp2sEmv1JW1cc=;
        b=ikbMnwyPC2eJ2PcujNmDXEkMTBOPmuA8gg57R4r3Lr4OBmLrOqkIwFNfM/Jsbjuopz
         pt7cUzx3waSJSuNDndtPDooj063+cvRpnmP3s2PHjDCBei0KzpY4HyebYblSjfH5bnor
         AI12+0bawm/gUVGEHnVLcSUrPoX7iPYUw/0TjLLD0rVRviD5SXFnxymVwcUHyZENC/eq
         t/q5CoxpBVV8qHx8b6uvM6AoLJteQumxvTuKx+q0b4v9luySnZVoOrO8vg7GN0L+7gPY
         T6TWQgFYrvci1G+VFIgdXBanl8FKyBI6AF/0UfSgCGIMqodAi0X3jOA7Ua8Pln/SPVsO
         UCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dR+Oy8zkwr65n1hWzP0tj7ddjB1+ZTKp2sEmv1JW1cc=;
        b=KPCcHj3hh/YRXat3RzTWq07niNQfMiBrSzIKG2LM8muZqLns5AsB6bVMitjyEEWZtS
         9tR9kPpisbZQgLqzWWeFTdIhAXTy7X7UDC3QYWpHxbk1uqnrgshAQI3IoDqEp6nU1k9c
         r5SOSPrTS3JvaWGK1yTs4b65Z0ZccBt1jFbF9HebtxBRf1F4m6Z8C/qYDwf9fxCeO0FC
         /ItevJUEoeRa0kis1qNbxIz+6EP1O0VP8tpGLAiC7yyukY9f3lIBZNNKD4XPklSGzHYM
         d5hzmIWQ9v6KDpLw2kjs45VWdLN3529I77xZ4CzpeIHbqwaBssDxux46w6rXeVlhsdbb
         IlCA==
X-Gm-Message-State: AGi0PuajUSANMtPFCB+ZiYZ+gFXtX1sK1OPtsTQ0MErLusD79O3EBTVu
        dVclds1dZfh7Bk+39gbt8PQ=
X-Google-Smtp-Source: APiQypLoJAimf5LOpbzmjKJWbT8xvOWwP44Z5T0b5L4AKtJ5W00IDnuUP+/UnyHPB3pUbYf0R1QF/g==
X-Received: by 2002:a17:90b:3849:: with SMTP id nl9mr11995082pjb.86.1585953355350;
        Fri, 03 Apr 2020 15:35:55 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id z17sm6512354pff.12.2020.04.03.15.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 15:35:54 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] drm/i915: Synchronize active and retire callbacks
Date:   Fri,  3 Apr 2020 15:35:15 -0700
Message-Id: <20200403223528.2570-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200403042948.2533-1-sultan@kerneltoast.com>
References: <20200403042948.2533-1-sultan@kerneltoast.com>
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

Protect the active and retire callbacks with their own mutex to prevent
them from running at the same time as one another. This change makes
the i915_active_may_sleep() functionality a redundant for its only user,
so clean that out as well since it's no longer needed.

Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
v3: Protecting only intel_context_pin/unpin is insufficient because all
    the callbacks race with each other, not just those ones. Now, all
    callbacks are protected from racing with their counterparts with a
    new mutex lock for reduced scope. This isn't as pretty, but it is
    unavoidable.

 .../gpu/drm/i915/display/intel_frontbuffer.c  |  4 +--
 drivers/gpu/drm/i915/gem/i915_gem_context.c   |  1 -
 drivers/gpu/drm/i915/gt/intel_context.c       |  1 -
 drivers/gpu/drm/i915/gt/intel_engine_pool.c   |  1 -
 drivers/gpu/drm/i915/gt/intel_timeline.c      |  1 -
 drivers/gpu/drm/i915/i915_active.c            | 30 ++++++++++++++-----
 drivers/gpu/drm/i915/i915_active_types.h      |  6 +---
 drivers/gpu/drm/i915/i915_vma.c               |  1 -
 8 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.c b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
index 6cb02c912acc..766325948b5b 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.c
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
@@ -206,7 +206,6 @@ static int frontbuffer_active(struct i915_active *ref)
 	return 0;
 }
 
-__i915_active_call
 static void frontbuffer_retire(struct i915_active *ref)
 {
 	struct intel_frontbuffer *front =
@@ -254,8 +253,7 @@ intel_frontbuffer_get(struct drm_i915_gem_object *obj)
 	kref_init(&front->ref);
 	atomic_set(&front->bits, 0);
 	i915_active_init(&front->write,
-			 frontbuffer_active,
-			 i915_active_may_sleep(frontbuffer_retire));
+			 frontbuffer_active, frontbuffer_retire);
 
 	spin_lock(&i915->fb_tracking.lock);
 	if (rcu_access_pointer(obj->frontbuffer)) {
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 68326ad3b2e0..31791b4ae086 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1057,7 +1057,6 @@ struct context_barrier_task {
 	void *data;
 };
 
-__i915_active_call
 static void cb_retire(struct i915_active *base)
 {
 	struct context_barrier_task *cb = container_of(base, typeof(*cb), base);
diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
index aea992e46c42..964e32cf5856 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -222,7 +222,6 @@ static void __ring_retire(struct intel_ring *ring)
 	i915_active_release(&ring->vma->active);
 }
 
-__i915_active_call
 static void __intel_context_retire(struct i915_active *active)
 {
 	struct intel_context *ce = container_of(active, typeof(*ce), active);
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pool.c b/drivers/gpu/drm/i915/gt/intel_engine_pool.c
index 397186818305..60dde6978511 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_pool.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_pool.c
@@ -61,7 +61,6 @@ static int pool_active(struct i915_active *ref)
 	return 0;
 }
 
-__i915_active_call
 static void pool_retire(struct i915_active *ref)
 {
 	struct intel_engine_pool_node *node =
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 91debbc97c9a..ecd120e1cf2a 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -131,7 +131,6 @@ static void __idle_cacheline_free(struct intel_timeline_cacheline *cl)
 	kfree_rcu(cl, rcu);
 }
 
-__i915_active_call
 static void __cacheline_retire(struct i915_active *active)
 {
 	struct intel_timeline_cacheline *cl =
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index c4048628188a..165216aee122 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -148,8 +148,15 @@ __active_retire(struct i915_active *ref)
 	spin_unlock_irqrestore(&ref->tree_lock, flags);
 
 	/* After the final retire, the entire struct may be freed */
-	if (ref->retire)
-		ref->retire(ref);
+	if (ref->retire) {
+		if (ref->active) {
+			mutex_lock(&ref->callback_lock);
+			ref->retire(ref);
+			mutex_unlock(&ref->callback_lock);
+		} else {
+			ref->retire(ref);
+		}
+	}
 
 	/* ... except if you wait on it, you must manage your own references! */
 	wake_up_var(ref);
@@ -281,15 +288,15 @@ void __i915_active_init(struct i915_active *ref,
 			struct lock_class_key *mkey,
 			struct lock_class_key *wkey)
 {
-	unsigned long bits;
-
 	debug_active_init(ref);
 
 	ref->flags = 0;
 	ref->active = active;
-	ref->retire = ptr_unpack_bits(retire, &bits, 2);
-	if (bits & I915_ACTIVE_MAY_SLEEP)
+	ref->retire = retire;
+	if (ref->active && ref->retire) {
+		mutex_init(&ref->callback_lock);
 		ref->flags |= I915_ACTIVE_RETIRE_SLEEPS;
+	}
 
 	spin_lock_init(&ref->tree_lock);
 	ref->tree = RB_ROOT;
@@ -428,8 +435,15 @@ int i915_active_acquire(struct i915_active *ref)
 		return err;
 
 	if (likely(!i915_active_acquire_if_busy(ref))) {
-		if (ref->active)
-			err = ref->active(ref);
+		if (ref->active) {
+			if (ref->retire) {
+				mutex_lock(&ref->callback_lock);
+				err = ref->active(ref);
+				mutex_unlock(&ref->callback_lock);
+			} else {
+				err = ref->active(ref);
+			}
+		}
 		if (!err) {
 			spin_lock_irq(&ref->tree_lock); /* __active_retire() */
 			debug_active_activate(ref);
diff --git a/drivers/gpu/drm/i915/i915_active_types.h b/drivers/gpu/drm/i915/i915_active_types.h
index 6360c3e4b765..19b06c64c017 100644
--- a/drivers/gpu/drm/i915/i915_active_types.h
+++ b/drivers/gpu/drm/i915/i915_active_types.h
@@ -24,11 +24,6 @@ struct i915_active_fence {
 
 struct active_node;
 
-#define I915_ACTIVE_MAY_SLEEP BIT(0)
-
-#define __i915_active_call __aligned(4)
-#define i915_active_may_sleep(fn) ptr_pack_bits(&(fn), I915_ACTIVE_MAY_SLEEP, 2)
-
 struct i915_active {
 	atomic_t count;
 	struct mutex mutex;
@@ -45,6 +40,7 @@ struct i915_active {
 
 	int (*active)(struct i915_active *ref);
 	void (*retire)(struct i915_active *ref);
+	struct mutex callback_lock;
 
 	struct work_struct work;
 
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 08699fa069aa..0f73beb586ab 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -93,7 +93,6 @@ static int __i915_vma_active(struct i915_active *ref)
 	return i915_vma_tryget(active_to_vma(ref)) ? 0 : -ENOENT;
 }
 
-__i915_active_call
 static void __i915_vma_retire(struct i915_active *ref)
 {
 	i915_vma_put(active_to_vma(ref));
-- 
2.26.0


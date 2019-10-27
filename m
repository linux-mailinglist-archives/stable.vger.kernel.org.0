Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06BE67A8
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfJ0VXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbfJ0VXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A4C6205C9;
        Sun, 27 Oct 2019 21:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211380;
        bh=qwuAzWlSe/QotcbvNf67xnRTOku+QsMdlNKKv52LMM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4yPf+bqTpCuZASz7rTkOK57j/0+RHqgKyCeYb7um8ihS9YQz3R6pCZB4dfHYonzR
         Ahoaga7dPfK9h0aekAKM/sW0YE+jHpzbTGAYbFUepoAW2IRSChRcGGWkOq68krrt5C
         iYtbPrZhrR6XWSx5zHLlUaPnJEzTA1B1q6pxAcb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 129/197] drm/i915/userptr: Never allow userptr into the mappable GGTT
Date:   Sun, 27 Oct 2019 22:00:47 +0100
Message-Id: <20191027203358.688892523@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4f2a572eda67aecb1e7e4fc26cc985fb8158f6e8 upstream.

Daniel Vetter uncovered a nasty cycle in using the mmu-notifiers to
invalidate userptr objects which also happen to be pulled into GGTT
mmaps. That is when we unbind the userptr object (on mmu invalidation),
we revoke all CPU mmaps, which may then recurse into mmu invalidation.

We looked for ways of breaking the cycle, but the revocation on
invalidation is required and cannot be avoided. The only solution we
could see was to not allow such GGTT bindings of userptr objects in the
first place. In practice, no one really wants to use a GGTT mmapping of
a CPU pointer...

Just before Daniel's explosive lockdep patches land in v5.4-rc1, we got
a genuine blip from CI:

<4>[  246.793958] ======================================================
<4>[  246.793972] WARNING: possible circular locking dependency detected
<4>[  246.793989] 5.3.0-gbd6c56f50d15-drmtip_372+ #1 Tainted: G     U
<4>[  246.794003] ------------------------------------------------------
<4>[  246.794017] kswapd0/145 is trying to acquire lock:
<4>[  246.794030] 000000003f565be6 (&dev->struct_mutex/1){+.+.}, at: userptr_mn_invalidate_range_start+0x18f/0x220 [i915]
<4>[  246.794250]
                  but task is already holding lock:
<4>[  246.794263] 000000001799cef9 (&anon_vma->rwsem){++++}, at: page_lock_anon_vma_read+0xe6/0x2a0
<4>[  246.794291]
                  which lock already depends on the new lock.

<4>[  246.794307]
                  the existing dependency chain (in reverse order) is:
<4>[  246.794322]
                  -> #3 (&anon_vma->rwsem){++++}:
<4>[  246.794344]        down_write+0x33/0x70
<4>[  246.794357]        __vma_adjust+0x3d9/0x7b0
<4>[  246.794370]        __split_vma+0x16a/0x180
<4>[  246.794385]        mprotect_fixup+0x2a5/0x320
<4>[  246.794399]        do_mprotect_pkey+0x208/0x2e0
<4>[  246.794413]        __x64_sys_mprotect+0x16/0x20
<4>[  246.794429]        do_syscall_64+0x55/0x1c0
<4>[  246.794443]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
<4>[  246.794456]
                  -> #2 (&mapping->i_mmap_rwsem){++++}:
<4>[  246.794478]        down_write+0x33/0x70
<4>[  246.794493]        unmap_mapping_pages+0x48/0x130
<4>[  246.794519]        i915_vma_revoke_mmap+0x81/0x1b0 [i915]
<4>[  246.794519]        i915_vma_unbind+0x11d/0x4a0 [i915]
<4>[  246.794519]        i915_vma_destroy+0x31/0x300 [i915]
<4>[  246.794519]        __i915_gem_free_objects+0xb8/0x4b0 [i915]
<4>[  246.794519]        drm_file_free.part.0+0x1e6/0x290
<4>[  246.794519]        drm_release+0xa6/0xe0
<4>[  246.794519]        __fput+0xc2/0x250
<4>[  246.794519]        task_work_run+0x82/0xb0
<4>[  246.794519]        do_exit+0x35b/0xdb0
<4>[  246.794519]        do_group_exit+0x34/0xb0
<4>[  246.794519]        __x64_sys_exit_group+0xf/0x10
<4>[  246.794519]        do_syscall_64+0x55/0x1c0
<4>[  246.794519]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
<4>[  246.794519]
                  -> #1 (&vm->mutex){+.+.}:
<4>[  246.794519]        i915_gem_shrinker_taints_mutex+0x6d/0xe0 [i915]
<4>[  246.794519]        i915_address_space_init+0x9f/0x160 [i915]
<4>[  246.794519]        i915_ggtt_init_hw+0x55/0x170 [i915]
<4>[  246.794519]        i915_driver_probe+0xc9f/0x1620 [i915]
<4>[  246.794519]        i915_pci_probe+0x43/0x1b0 [i915]
<4>[  246.794519]        pci_device_probe+0x9e/0x120
<4>[  246.794519]        really_probe+0xea/0x3d0
<4>[  246.794519]        driver_probe_device+0x10b/0x120
<4>[  246.794519]        device_driver_attach+0x4a/0x50
<4>[  246.794519]        __driver_attach+0x97/0x130
<4>[  246.794519]        bus_for_each_dev+0x74/0xc0
<4>[  246.794519]        bus_add_driver+0x13f/0x210
<4>[  246.794519]        driver_register+0x56/0xe0
<4>[  246.794519]        do_one_initcall+0x58/0x300
<4>[  246.794519]        do_init_module+0x56/0x1f6
<4>[  246.794519]        load_module+0x25bd/0x2a40
<4>[  246.794519]        __se_sys_finit_module+0xd3/0xf0
<4>[  246.794519]        do_syscall_64+0x55/0x1c0
<4>[  246.794519]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
<4>[  246.794519]
                  -> #0 (&dev->struct_mutex/1){+.+.}:
<4>[  246.794519]        __lock_acquire+0x15d8/0x1e90
<4>[  246.794519]        lock_acquire+0xa6/0x1c0
<4>[  246.794519]        __mutex_lock+0x9d/0x9b0
<4>[  246.794519]        userptr_mn_invalidate_range_start+0x18f/0x220 [i915]
<4>[  246.794519]        __mmu_notifier_invalidate_range_start+0x85/0x110
<4>[  246.794519]        try_to_unmap_one+0x76b/0x860
<4>[  246.794519]        rmap_walk_anon+0x104/0x280
<4>[  246.794519]        try_to_unmap+0xc0/0xf0
<4>[  246.794519]        shrink_page_list+0x561/0xc10
<4>[  246.794519]        shrink_inactive_list+0x220/0x440
<4>[  246.794519]        shrink_node_memcg+0x36e/0x740
<4>[  246.794519]        shrink_node+0xcb/0x490
<4>[  246.794519]        balance_pgdat+0x241/0x580
<4>[  246.794519]        kswapd+0x16c/0x530
<4>[  246.794519]        kthread+0x119/0x130
<4>[  246.794519]        ret_from_fork+0x24/0x50
<4>[  246.794519]
                  other info that might help us debug this:

<4>[  246.794519] Chain exists of:
                    &dev->struct_mutex/1 --> &mapping->i_mmap_rwsem --> &anon_vma->rwsem

<4>[  246.794519]  Possible unsafe locking scenario:

<4>[  246.794519]        CPU0                    CPU1
<4>[  246.794519]        ----                    ----
<4>[  246.794519]   lock(&anon_vma->rwsem);
<4>[  246.794519]                                lock(&mapping->i_mmap_rwsem);
<4>[  246.794519]                                lock(&anon_vma->rwsem);
<4>[  246.794519]   lock(&dev->struct_mutex/1);
<4>[  246.794519]
                   *** DEADLOCK ***

v2: Say no to mmap_ioctl

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111744
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111870
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190928082546.3473-1-chris@chris-wilson.co.uk
(cherry picked from commit a4311745bba9763e3c965643d4531bd5765b0513)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c         |    7 +++++++
 drivers/gpu/drm/i915/gem/i915_gem_object.h       |    6 ++++++
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h |    3 ++-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c      |    1 +
 drivers/gpu/drm/i915/i915_gem.c                  |    3 +++
 5 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -365,6 +365,7 @@ err:
 		return VM_FAULT_OOM;
 	case -ENOSPC:
 	case -EFAULT:
+	case -ENODEV: /* bad object, how did you get here! */
 		return VM_FAULT_SIGBUS;
 	default:
 		WARN_ONCE(ret, "unhandled error in %s: %i\n", __func__, ret);
@@ -475,10 +476,16 @@ i915_gem_mmap_gtt(struct drm_file *file,
 	if (!obj)
 		return -ENOENT;
 
+	if (i915_gem_object_never_bind_ggtt(obj)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	ret = create_mmap_offset(obj);
 	if (ret == 0)
 		*offset = drm_vma_node_offset_addr(&obj->base.vma_node);
 
+out:
 	i915_gem_object_put(obj);
 	return ret;
 }
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -153,6 +153,12 @@ i915_gem_object_is_proxy(const struct dr
 }
 
 static inline bool
+i915_gem_object_never_bind_ggtt(const struct drm_i915_gem_object *obj)
+{
+	return obj->ops->flags & I915_GEM_OBJECT_NO_GGTT;
+}
+
+static inline bool
 i915_gem_object_needs_async_cancel(const struct drm_i915_gem_object *obj)
 {
 	return obj->ops->flags & I915_GEM_OBJECT_ASYNC_CANCEL;
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -31,7 +31,8 @@ struct drm_i915_gem_object_ops {
 #define I915_GEM_OBJECT_HAS_STRUCT_PAGE	BIT(0)
 #define I915_GEM_OBJECT_IS_SHRINKABLE	BIT(1)
 #define I915_GEM_OBJECT_IS_PROXY	BIT(2)
-#define I915_GEM_OBJECT_ASYNC_CANCEL	BIT(3)
+#define I915_GEM_OBJECT_NO_GGTT		BIT(3)
+#define I915_GEM_OBJECT_ASYNC_CANCEL	BIT(4)
 
 	/* Interface between the GEM object and its backing storage.
 	 * get_pages() is called once prior to the use of the associated set
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -694,6 +694,7 @@ i915_gem_userptr_dmabuf_export(struct dr
 static const struct drm_i915_gem_object_ops i915_gem_userptr_ops = {
 	.flags = I915_GEM_OBJECT_HAS_STRUCT_PAGE |
 		 I915_GEM_OBJECT_IS_SHRINKABLE |
+		 I915_GEM_OBJECT_NO_GGTT |
 		 I915_GEM_OBJECT_ASYNC_CANCEL,
 	.get_pages = i915_gem_userptr_get_pages,
 	.put_pages = i915_gem_userptr_put_pages,
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1030,6 +1030,9 @@ i915_gem_object_ggtt_pin(struct drm_i915
 
 	lockdep_assert_held(&obj->base.dev->struct_mutex);
 
+	if (i915_gem_object_never_bind_ggtt(obj))
+		return ERR_PTR(-ENODEV);
+
 	if (flags & PIN_MAPPABLE &&
 	    (!view || view->type == I915_GGTT_VIEW_NORMAL)) {
 		/* If the required space is larger than the available



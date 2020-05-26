Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCEB1B0B31
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgDTMyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:54:22 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:54196 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728618AbgDTMyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 08:54:10 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20959361-1500050 
        for multiple; Mon, 20 Apr 2020 13:53:58 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, matthew.auld@intel.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/i915/gem: Remove object_is_locked assertion from unpin_from_display_plane
Date:   Mon, 20 Apr 2020 13:53:55 +0100
Message-Id: <20200420125356.26614-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since moving the obj->vma.list to a spin_lock, and the vm->bound_list to
its vm->mutex, along with tracking shrinkable status under its own
spinlock, we no long require the object to be locked by the caller.

This is fortunate as it appears we can be called with the lock along an
error path in flipping:

<4> [139.942851] WARN_ON(debug_locks && !lock_is_held(&(&((obj)->base.resv)->lock.base)->dep_map))
<4> [139.943242] WARNING: CPU: 0 PID: 1203 at drivers/gpu/drm/i915/gem/i915_gem_domain.c:405 i915_gem_object_unpin_from_display_plane+0x70/0x130 [i915]
<4> [139.943263] Modules linked in: snd_hda_intel i915 vgem snd_hda_codec_realtek snd_hda_codec_generic coretemp snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core r8169 lpc_ich snd_pcm realtek prime_numbers [last unloaded: i915]
<4> [139.943347] CPU: 0 PID: 1203 Comm: kms_flip Tainted: G     U            5.6.0-gd0fda5c2cf3f1-drmtip_474+ #1
<4> [139.943363] Hardware name:  /D510MO, BIOS MOPNV10J.86A.0311.2010.0802.2346 08/02/2010
<4> [139.943589] RIP: 0010:i915_gem_object_unpin_from_display_plane+0x70/0x130 [i915]
<4> [139.943589] Code: 85 28 01 00 00 be ff ff ff ff 48 8d 78 60 e8 d7 9b f0 e2 85 c0 75 b9 48 c7 c6 50 b9 38 c0 48 c7 c7 e9 48 3c c0 e8 20 d4 e9 e2 <0f> 0b eb a2 48 c7 c1 08 bb 38 c0 ba 0a 01 00 00 48 c7 c6 88 a3 35
<4> [139.943589] RSP: 0018:ffffb774c0603b48 EFLAGS: 00010282
<4> [139.943589] RAX: 0000000000000000 RBX: ffff9a142fa36e80 RCX: 0000000000000006
<4> [139.943589] RDX: 000000000000160d RSI: ffff9a142c1a88f8 RDI: ffffffffa434a64d
<4> [139.943589] RBP: ffff9a1410a513c0 R08: ffff9a142c1a88f8 R09: 0000000000000000
<4> [139.943589] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9a1436ee94b8
<4> [139.943589] R13: 0000000000000001 R14: 00000000ffffffff R15: ffff9a1410960000
<4> [139.943589] FS:  00007fc73a744e40(0000) GS:ffff9a143da00000(0000) knlGS:0000000000000000
<4> [139.943589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4> [139.943589] CR2: 00007fc73997e098 CR3: 000000002f5fe000 CR4: 00000000000006f0
<4> [139.943589] Call Trace:
<4> [139.943589]  intel_pin_and_fence_fb_obj+0x1c9/0x1f0 [i915]
<4> [139.943589]  intel_plane_pin_fb+0x3f/0xd0 [i915]
<4> [139.943589]  intel_prepare_plane_fb+0x13b/0x5c0 [i915]
<4> [139.943589]  drm_atomic_helper_prepare_planes+0x85/0x110
<4> [139.943589]  intel_atomic_commit+0xda/0x390 [i915]
<4> [139.943589]  drm_atomic_helper_page_flip+0x9c/0xd0
<4> [139.943589]  ? drm_event_reserve_init+0x46/0x60
<4> [139.943589]  drm_mode_page_flip_ioctl+0x587/0x5d0

This completes the symmetry lost in commit 8b1c78e06e61 ("drm/i915: Avoid
calling i915_gem_object_unbind holding object lock").

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1743
Fixes: 8b1c78e06e61 ("drm/i915: Avoid calling i915_gem_object_unbind holding object lock")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/i915/gem/i915_gem_domain.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
index af43e82f45c7..7f76fc68f498 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -368,7 +368,6 @@ static void i915_gem_object_bump_inactive_ggtt(struct drm_i915_gem_object *obj)
 	struct drm_i915_private *i915 = to_i915(obj->base.dev);
 	struct i915_vma *vma;
 
-	GEM_BUG_ON(!i915_gem_object_has_pinned_pages(obj));
 	if (list_empty(&obj->vma.list))
 		return;
 
@@ -400,12 +399,8 @@ static void i915_gem_object_bump_inactive_ggtt(struct drm_i915_gem_object *obj)
 void
 i915_gem_object_unpin_from_display_plane(struct i915_vma *vma)
 {
-	struct drm_i915_gem_object *obj = vma->obj;
-
-	assert_object_held(obj);
-
 	/* Bump the LRU to try and avoid premature eviction whilst flipping  */
-	i915_gem_object_bump_inactive_ggtt(obj);
+	i915_gem_object_bump_inactive_ggtt(vma->obj);
 
 	i915_vma_unpin(vma);
 }
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EE6178208
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgCCSLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731743AbgCCRtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E339F214D8;
        Tue,  3 Mar 2020 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257752;
        bh=hi2YvfoQlcBQq7bi3vtsjrIKcqdT+5CigMVX5uC+INs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOcCkMrwjIbtVI1Nao8NzIE5pSensCeBqo9AYZqwm+Xts+OQ/i7o95J8jq0BLhY3l
         Zz0gCVw5NpOPSPZuwAi3UC8mloL+uR/InO5Z2JAuI/vZlSQyu5+mt2jDtZZTBn45f4
         ur/N1X0jz/f0k9iw+v+6u3lIFPtoz4rdUDHHlvm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 116/176] drm/i915: Avoid recursing onto active vma from the shrinker
Date:   Tue,  3 Mar 2020 18:43:00 +0100
Message-Id: <20200303174318.245919059@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 238734262142075056653b4de091458e0ca858f2 upstream.

We mark the vma as active while binding it in order to protect outselves
from being shrunk under mempressure. This only works if we are strict in
not attempting to shrink active objects.

<6> [472.618968] Workqueue: events_unbound fence_work [i915]
<4> [472.618970] Call Trace:
<4> [472.618974]  ? __schedule+0x2e5/0x810
<4> [472.618978]  schedule+0x37/0xe0
<4> [472.618982]  schedule_preempt_disabled+0xf/0x20
<4> [472.618984]  __mutex_lock+0x281/0x9c0
<4> [472.618987]  ? mark_held_locks+0x49/0x70
<4> [472.618989]  ? _raw_spin_unlock_irqrestore+0x47/0x60
<4> [472.619038]  ? i915_vma_unbind+0xae/0x110 [i915]
<4> [472.619084]  ? i915_vma_unbind+0xae/0x110 [i915]
<4> [472.619122]  i915_vma_unbind+0xae/0x110 [i915]
<4> [472.619165]  i915_gem_object_unbind+0x1dc/0x400 [i915]
<4> [472.619208]  i915_gem_shrink+0x328/0x660 [i915]
<4> [472.619250]  ? i915_gem_shrink_all+0x38/0x60 [i915]
<4> [472.619282]  i915_gem_shrink_all+0x38/0x60 [i915]
<4> [472.619325]  vm_alloc_page.constprop.25+0x1aa/0x240 [i915]
<4> [472.619330]  ? rcu_read_lock_sched_held+0x4d/0x80
<4> [472.619363]  ? __alloc_pd+0xb/0x30 [i915]
<4> [472.619366]  ? module_assert_mutex_or_preempt+0xf/0x30
<4> [472.619368]  ? __module_address+0x23/0xe0
<4> [472.619371]  ? is_module_address+0x26/0x40
<4> [472.619374]  ? static_obj+0x34/0x50
<4> [472.619376]  ? lockdep_init_map+0x4d/0x1e0
<4> [472.619407]  setup_page_dma+0xd/0x90 [i915]
<4> [472.619437]  alloc_pd+0x29/0x50 [i915]
<4> [472.619470]  __gen8_ppgtt_alloc+0x443/0x6b0 [i915]
<4> [472.619503]  gen8_ppgtt_alloc+0xd7/0x300 [i915]
<4> [472.619535]  ppgtt_bind_vma+0x2a/0xe0 [i915]
<4> [472.619577]  __vma_bind+0x26/0x40 [i915]
<4> [472.619611]  fence_work+0x1c/0x90 [i915]
<4> [472.619617]  process_one_work+0x26a/0x620

Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200221221818.2861432-1-chris@chris-wilson.co.uk
(cherry picked from commit 6f24e41022f28061368776ea1514db0a6e67a9b1)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
@@ -257,8 +257,7 @@ unsigned long i915_gem_shrink_all(struct
 	with_intel_runtime_pm(&i915->runtime_pm, wakeref) {
 		freed = i915_gem_shrink(i915, -1UL, NULL,
 					I915_SHRINK_BOUND |
-					I915_SHRINK_UNBOUND |
-					I915_SHRINK_ACTIVE);
+					I915_SHRINK_UNBOUND);
 	}
 
 	return freed;
@@ -337,7 +336,6 @@ i915_gem_shrinker_oom(struct notifier_bl
 	freed_pages = 0;
 	with_intel_runtime_pm(&i915->runtime_pm, wakeref)
 		freed_pages += i915_gem_shrink(i915, -1UL, NULL,
-					       I915_SHRINK_ACTIVE |
 					       I915_SHRINK_BOUND |
 					       I915_SHRINK_UNBOUND |
 					       I915_SHRINK_WRITEBACK);



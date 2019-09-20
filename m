Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A92B8F9B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 14:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438265AbfITMSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 08:18:30 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:65274 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2438264AbfITMSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 08:18:30 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 18558832-1500050 
        for multiple; Fri, 20 Sep 2019 13:18:23 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Mark contents as dirty on a write fault
Date:   Fri, 20 Sep 2019 13:18:21 +0100
Message-Id: <20190920121821.7223-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since dropping the set-to-gtt-domain in commit a679f58d0510 ("drm/i915:
Flush pages on acquisition"), we no longer mark the contents as dirty on
a write fault. This has the issue of us then not marking the pages as
dirty on releasing the buffer, which means the contents are not written
out to the swap device (should we ever pick that buffer as a victim).
Notably, this is visible in the dumb buffer interface used for cursors.
Having updated the cursor contents via mmap, and swapped away, if the
shrinker should evict the old cursor, upon next reuse, the cursor would
be invisible.

E.g. echo 80 > /proc/sys/kernel/sysrq ; echo f > /proc/sysrq-trigger

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111541
Fixes: a679f58d0510 ("drm/i915: Flush pages on acquisition")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 1748e63156a2..860b751c51f1 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -319,7 +319,11 @@ vm_fault_t i915_gem_fault(struct vm_fault *vmf)
 		intel_wakeref_auto(&i915->ggtt.userfault_wakeref,
 				   msecs_to_jiffies_timeout(CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND));
 
-	i915_vma_set_ggtt_write(vma);
+	if (write) {
+		GEM_BUG_ON(!i915_gem_object_has_pinned_pages(obj));
+		i915_vma_set_ggtt_write(vma);
+		obj->mm.dirty = true;
+	}
 
 err_fence:
 	i915_vma_unpin_fence(vma);
-- 
2.23.0


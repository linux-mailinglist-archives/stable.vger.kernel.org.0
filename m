Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D84C3C70EA
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 15:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbhGMNHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 09:07:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:25636 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236449AbhGMNHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 09:07:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="189840681"
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="189840681"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 06:04:40 -0700
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="503090143"
Received: from ewaterla-mobl2.ger.corp.intel.com (HELO mwauld-desk1.intel.com) ([10.252.5.95])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 06:04:38 -0700
From:   Matthew Auld <matthew.auld@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gtt: drop the page table optimisation
Date:   Tue, 13 Jul 2021 14:04:31 +0100
Message-Id: <20210713130431.2392740-1-matthew.auld@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We skip filling out the pt with scratch entries if the va range covers
the entire pt, since we later have to fill it with the PTEs for the
object pages anyway. However this might leave open a small window where
the PTEs don't point to anything valid for the HW to consume.

When for example using 2M GTT pages this fill_px() showed up as being
quite significant in perf measurements, and ends up being completely
wasted since we ignore the pt and just use the pde directly.

Anyway, currently we have our PTE construction split between alloc and
insert, which is probably slightly iffy nowadays, since the alloc
doesn't actually allocate anything anymore, instead it just sets up the
page directories and points the PTEs at the scratch page. Later when we
do the insert step we re-program the PTEs again. Better might be to
squash the alloc and insert into a single step, then bringing back this
optimisation(along with some others) should be possible.

Fixes: 14826673247e ("drm/i915: Only initialize partially filled pagetables")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: <stable@vger.kernel.org> # v4.15+
---
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
index 3d02c726c746..6e0e52eeb87a 100644
--- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
@@ -303,10 +303,7 @@ static void __gen8_ppgtt_alloc(struct i915_address_space * const vm,
 			__i915_gem_object_pin_pages(pt->base);
 			i915_gem_object_make_unshrinkable(pt->base);
 
-			if (lvl ||
-			    gen8_pt_count(*start, end) < I915_PDES ||
-			    intel_vgpu_active(vm->i915))
-				fill_px(pt, vm->scratch[lvl]->encode);
+			fill_px(pt, vm->scratch[lvl]->encode);
 
 			spin_lock(&pd->lock);
 			if (likely(!pd->entry[idx])) {
-- 
2.26.3


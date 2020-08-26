Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA2A252FC2
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgHZN2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:28:18 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:54219 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729646AbgHZN2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 09:28:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22244727-1500050 
        for multiple; Wed, 26 Aug 2020 14:28:13 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Subject: [PATCH 03/39] drm/i915/gem: Prevent using pgprot_writecombine() if PAT is not supported
Date:   Wed, 26 Aug 2020 14:27:35 +0100
Message-Id: <20200826132811.17577-3-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200826132811.17577-1-chris@chris-wilson.co.uk>
References: <20200826132811.17577-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Let's not try and use PAT attributes for I915_MAP_WC is the CPU doesn't
support PAT.

Fixes: 6056e50033d9 ("drm/i915/gem: Support discontiguous lmem object maps")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 0c3d0d6429ae..d729f6d05b97 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -265,6 +265,9 @@ static void *i915_gem_object_map(struct drm_i915_gem_object *obj,
 	if (!i915_gem_object_has_struct_page(obj) && type != I915_MAP_WC)
 		return NULL;
 
+	if (GEM_WARN_ON(type == I915_MAP_WC && !boot_cpu_has(X86_FEATURE_PAT)))
+		return NULL;
+
 	/* A single page can always be kmapped */
 	if (n_pte == 1 && type == I915_MAP_WB) {
 		struct page *page = sg_page(sgt->sgl);
-- 
2.20.1


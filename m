Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89143252FC4
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgHZN2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:28:19 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:54218 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728276AbgHZN2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 09:28:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22244725-1500050 
        for multiple; Wed, 26 Aug 2020 14:28:12 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Harald Arnesen <harald@skogtun.org>, stable@vger.kernel.org
Subject: [PATCH 01/39] drm/i915/gem: Avoid implicit vmap for highmem on x86-32
Date:   Wed, 26 Aug 2020 14:27:33 +0100
Message-Id: <20200826132811.17577-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 32b, highmem uses a finite set of indirect PTE (i.e. vmap) to provide
virtual mappings of the high pages. As these are finite, map_new_virtual()
must wait for some other kmap() to finish when it runs out. If we map a
large number of objects, there is no method for it to tell us to release
the mappings, and we deadlock.

However, if we make an explicit vmap of the page, that uses a larger
vmalloc arena, and also has the ability to tell us to release unwanted
mappings. Most importantly, it will fail and propagate an error instead
of waiting forever.

Fixes: fb8621d3bee8 ("drm/i915: Avoid allocating a vmap arena for a single page") #x86-32
References: e87666b52f00 ("drm/i915/shrinker: Hook up vmap allocation failure notifier")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Harald Arnesen <harald@skogtun.org>
Cc: <stable@vger.kernel.org> # v4.7+
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 26 +++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 7050519c87a4..51b63e05dbe4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -255,8 +255,30 @@ static void *i915_gem_object_map(struct drm_i915_gem_object *obj,
 		return NULL;
 
 	/* A single page can always be kmapped */
-	if (n_pte == 1 && type == I915_MAP_WB)
-		return kmap(sg_page(sgt->sgl));
+	if (n_pte == 1 && type == I915_MAP_WB) {
+		struct page *page = sg_page(sgt->sgl);
+
+		/*
+		 * On 32b, highmem uses a finite set of indirect PTE (i.e.
+		 * vmap) to provide virtual mappings of the high pages.
+		 * As these are finite, map_new_virtual() must wait for some
+		 * other kmap() to finish when it runs out. If we map a large
+		 * number of objects, there is no method for it to tell us
+		 * to release the mappings, and we deadlock.
+		 *
+		 * However, if we make an explicit vmap of the page, that
+		 * uses a larger vmalloc arena, and also has the ability
+		 * to tell us to release unwanted mappings. Most importantly,
+		 * it will fail and propagate an error instead of waiting
+		 * forever.
+		 *
+		 * So if the page is beyond the 32b boundary, make an explicit
+		 * vmap. On 64b, this check will be optimised away as we can
+		 * directly kmap any page on the system.
+		 */
+		if (!PageHighMem(page))
+			return kmap(page);
+	}
 
 	mem = stack;
 	if (n_pte > ARRAY_SIZE(stack)) {
-- 
2.20.1


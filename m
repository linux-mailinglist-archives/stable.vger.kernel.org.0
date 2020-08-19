Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859B724A7BE
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHSUcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:32:01 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:50880 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726617AbgHSUb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:31:58 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22178535-1500050 
        for multiple; Wed, 19 Aug 2020 21:31:51 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Prevent using pgprot_writecombine() if PAT is not supported
Date:   Wed, 19 Aug 2020 21:31:53 +0100
Message-Id: <20200819203153.16000-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
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
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 7050519c87a4..5f1725268988 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -254,6 +254,9 @@ static void *i915_gem_object_map(struct drm_i915_gem_object *obj,
 	if (!i915_gem_object_has_struct_page(obj) && type != I915_MAP_WC)
 		return NULL;
 
+	if (type == I915_MAP_WC && !boot_cpu_has(X86_FEATURE_PAT))
+		return NULL;
+
 	/* A single page can always be kmapped */
 	if (n_pte == 1 && type == I915_MAP_WB)
 		return kmap(sg_page(sgt->sgl));
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A22861F1
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 17:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgJGPRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 11:17:24 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:63077 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726152AbgJGPRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 11:17:24 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22648396-1500050 
        for multiple; Wed, 07 Oct 2020 16:17:19 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Exclude low pages (128KiB) of stolen from use
Date:   Wed,  7 Oct 2020 16:17:18 +0100
Message-Id: <20201007151718.22710-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GPU is trashing the low pages of its reserved memory upon reset. If
we are using this memory for ringbuffers, then we will dutiful resubmit
the trashed rings after the reset causing further resets, and worse. We
must exclude this range from our own use. The value of 128KiB was found
by empirical measurement on gen9.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gem/i915_gem_stolen.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_stolen.c b/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
index 0be5e8683337..c0cc2a972a11 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
@@ -53,8 +53,9 @@ int i915_gem_stolen_insert_node(struct drm_i915_private *i915,
 				struct drm_mm_node *node, u64 size,
 				unsigned alignment)
 {
-	return i915_gem_stolen_insert_node_in_range(i915, node, size,
-						    alignment, 0, U64_MAX);
+	return i915_gem_stolen_insert_node_in_range(i915, node,
+						    size, alignment,
+						    SZ_128K, U64_MAX);
 }
 
 void i915_gem_stolen_remove_node(struct drm_i915_private *i915,
-- 
2.20.1


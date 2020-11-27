Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0A12C630D
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 11:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgK0KZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 05:25:47 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:50001 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbgK0KZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 05:25:46 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23129948-1500050 
        for multiple; Fri, 27 Nov 2020 10:25:40 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Declare gen9 has 64 mocs entries!
Date:   Fri, 27 Nov 2020 10:25:40 +0000
Message-Id: <20201127102540.13117-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We checked the table size against a hardcoded number of entries, and
that number was excluding the special mocs registers at the end.

Fixes: 977933b5da7c ("drm/i915/gt: Program mocs:63 for cache eviction on gen9")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.3+
---
 drivers/gpu/drm/i915/gt/intel_mocs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index b8d0c32ae9dd..ab6870242e18 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -59,8 +59,7 @@ struct drm_i915_mocs_table {
 #define _L3_CACHEABILITY(value)	((value) << 4)
 
 /* Helper defines */
-#define GEN9_NUM_MOCS_ENTRIES	62  /* 62 out of 64 - 63 & 64 are reserved. */
-#define GEN11_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
+#define GEN9_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
 
 /* (e)LLC caching options */
 /*
@@ -361,15 +360,15 @@ static unsigned int get_mocs_settings(const struct drm_i915_private *i915,
 	if (IS_DG1(i915)) {
 		table->size = ARRAY_SIZE(dg1_mocs_table);
 		table->table = dg1_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 	} else if (INTEL_GEN(i915) >= 12) {
 		table->size  = ARRAY_SIZE(tgl_mocs_table);
 		table->table = tgl_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 	} else if (IS_GEN(i915, 11)) {
 		table->size  = ARRAY_SIZE(icl_mocs_table);
 		table->table = icl_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 	} else if (IS_GEN9_BC(i915) || IS_CANNONLAKE(i915)) {
 		table->size  = ARRAY_SIZE(skl_mocs_table);
 		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
-- 
2.20.1


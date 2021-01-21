Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DD12FF6CB
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 22:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbhAUVHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 16:07:54 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:65420 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727666AbhAUVF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 16:05:28 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23665476-1500050 
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 21:04:40 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Declare gen9 has 64 mocs entries!
Date:   Thu, 21 Jan 2021 21:04:40 +0000
Message-Id: <20210121210440.1087231-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e57344d7e4ec upstream, backported to v5.4

We checked the table size against a hardcoded number of entries, and
that number was excluding the special mocs registers at the end.

Fixes: 977933b5da7c ("drm/i915/gt: Program mocs:63 for cache eviction on gen9")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201127102540.13117-1-chris@chris-wilson.co.uk
(cherry picked from commit 444fbf5d7058099447c5366ba8bb60d610aeb44b)
---
 drivers/gpu/drm/i915/gt/intel_mocs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index e97a2aa31485..7de6528e8df4 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -58,8 +58,7 @@ struct drm_i915_mocs_table {
 #define _L3_CACHEABILITY(value)	((value) << 4)
 
 /* Helper defines */
-#define GEN9_NUM_MOCS_ENTRIES	62  /* 62 out of 64 - 63 & 64 are reserved. */
-#define GEN11_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
+#define GEN9_NUM_MOCS_ENTRIES	64  /* 63-64 are reserved, but configured. */
 
 /* (e)LLC caching options */
 /*
@@ -300,12 +299,12 @@ static bool get_mocs_settings(struct intel_gt *gt,
 	if (INTEL_GEN(i915) >= 12) {
 		table->size  = ARRAY_SIZE(tigerlake_mocs_table);
 		table->table = tigerlake_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 		result = true;
 	} else if (IS_GEN(i915, 11)) {
 		table->size  = ARRAY_SIZE(icelake_mocs_table);
 		table->table = icelake_mocs_table;
-		table->n_entries = GEN11_NUM_MOCS_ENTRIES;
+		table->n_entries = GEN9_NUM_MOCS_ENTRIES;
 		result = true;
 	} else if (IS_GEN9_BC(i915) || IS_CANNONLAKE(i915)) {
 		table->size  = ARRAY_SIZE(skylake_mocs_table);
-- 
2.30.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145CC2C5283
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 11:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgKZKzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 05:55:44 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:59079 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728698AbgKZKzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 05:55:44 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23115059-1500050 
        for multiple; Thu, 26 Nov 2020 10:55:41 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9
Date:   Thu, 26 Nov 2020 10:55:39 +0000
Message-Id: <20201126105539.2661-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ville noticed that the last mocs entry is used unconditionally by the HW
when it performs cache evictions, and noted that while the value is not
meant to be writable by the driver, we should program it to a reasonable
value nevertheless.

As it turns out, we can change the value of mocs:63 and the value we
were programming into it would cause hard hangs in conjunction with
atomic operations.

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2707
Fixes: 3bbaba0ceaa2 ("drm/i915: Added Programming of the MOCS")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: <stable@vger.kernel.org> # v4.3+
---
 drivers/gpu/drm/i915/gt/intel_mocs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index 254873e1646e..6ae512847f64 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -131,7 +131,10 @@ static const struct drm_i915_mocs_entry skl_mocs_table[] = {
 	GEN9_MOCS_ENTRIES,
 	MOCS_ENTRY(I915_MOCS_CACHED,
 		   LE_3_WB | LE_TC_2_LLC_ELLC | LE_LRUM(3),
-		   L3_3_WB)
+		   L3_3_WB),
+	MOCS_ENTRY(63,
+		   LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
+		   L3_1_UC)
 };
 
 /* NOTE: the LE_TGT_CACHE is not used on Broxton */
-- 
2.20.1


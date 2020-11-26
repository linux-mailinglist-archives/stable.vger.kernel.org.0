Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1E2C56B3
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 15:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390067AbgKZOIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 09:08:46 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:64540 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390012AbgKZOIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 09:08:45 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23117628-1500050 
        for multiple; Thu, 26 Nov 2020 14:08:42 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Program mocs:63 for cache eviction on gen9
Date:   Thu, 26 Nov 2020 14:08:41 +0000
Message-Id: <20201126140841.1982-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201126105539.2661-1-chris@chris-wilson.co.uk>
References: <20201126105539.2661-1-chris@chris-wilson.co.uk>
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

v2: Add details from bspec about how it is used by HW

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2707
Fixes: 3bbaba0ceaa2 ("drm/i915: Added Programming of the MOCS")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: <stable@vger.kernel.org> # v4.3+
---
 drivers/gpu/drm/i915/gt/intel_mocs.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index 254873e1646e..26cedde80476 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -131,7 +131,19 @@ static const struct drm_i915_mocs_entry skl_mocs_table[] = {
 	GEN9_MOCS_ENTRIES,
 	MOCS_ENTRY(I915_MOCS_CACHED,
 		   LE_3_WB | LE_TC_2_LLC_ELLC | LE_LRUM(3),
-		   L3_3_WB)
+		   L3_3_WB),
+
+	/*
+	 * mocs:63
+	 * - used by the L3 for all its evictions.
+	 *   Thus it is expected to allow LLC cacheability to enable coherent
+	 *   flows to be maintained.
+	 * - used to force L3 uncachable cycles.
+	 *   Thus it is expected to make the surce L3 uncacheable.
+	 */
+	MOCS_ENTRY(63,
+		   LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
+		   L3_1_UC)
 };
 
 /* NOTE: the LE_TGT_CACHE is not used on Broxton */
-- 
2.20.1


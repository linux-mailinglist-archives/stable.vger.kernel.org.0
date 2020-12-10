Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915EB2D62A1
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391025AbgLJOge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391022AbgLJOg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:28 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 24/54] drm/i915/gt: Program mocs:63 for cache eviction on gen9
Date:   Thu, 10 Dec 2020 15:27:01 +0100
Message-Id: <20201210142603.225606332@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 777a7717d60ccdc9b84f35074f848d3f746fc3bf upstream.

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
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201126140841.1982-1-chris@chris-wilson.co.uk
(cherry picked from commit 977933b5da7c16f39295c4c1d4259a58ece65dbe)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_mocs.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -130,7 +130,19 @@ static const struct drm_i915_mocs_entry
 	GEN9_MOCS_ENTRIES,
 	MOCS_ENTRY(I915_MOCS_CACHED,
 		   LE_3_WB | LE_TC_2_LLC_ELLC | LE_LRUM(3),
-		   L3_3_WB)
+		   L3_3_WB),
+
+	/*
+	 * mocs:63
+	 * - used by the L3 for all of its evictions.
+	 *   Thus it is expected to allow LLC cacheability to enable coherent
+	 *   flows to be maintained.
+	 * - used to force L3 uncachable cycles.
+	 *   Thus it is expected to make the surface L3 uncacheable.
+	 */
+	MOCS_ENTRY(63,
+		   LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
+		   L3_1_UC)
 };
 
 /* NOTE: the LE_TGT_CACHE is not used on Broxton */



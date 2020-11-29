Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAE52C7773
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 04:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgK2Dwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 22:52:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:36094 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgK2Dwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Nov 2020 22:52:35 -0500
IronPort-SDR: pZ69AA/F1j0q7NeCfb4NRlu1nts4z4q9SC9X2NKZM7pwULNreA+fDOskIyMI2TzWpIrDFdcFX2
 xy3EJ8vwGC6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9819"; a="160284665"
X-IronPort-AV: E=Sophos;i="5.78,378,1599548400"; 
   d="scan'208";a="160284665"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2020 19:51:55 -0800
IronPort-SDR: 9+c3ac338m2We2RriEdURtTR/9N0dTrJZX1SYNNJy/9MZDr0Hbp5gFs2n8PnyEQsQtrqAOWw6C
 4fqxp+JC38GQ==
X-IronPort-AV: E=Sophos;i="5.78,378,1599548400"; 
   d="scan'208";a="314104489"
Received: from schung-mobl.amr.corp.intel.com (HELO rdvivi-mobl4.intel.com) ([10.209.4.69])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2020 19:51:54 -0800
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Fixup tgl mocs for PTE tracking
Date:   Sat, 28 Nov 2020 19:51:51 -0800
Message-Id: <20201129035151.1071647-1-rodrigo.vivi@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit be33805c65297611971003d72e7f9235e23ec84d upstream.

Forcing mocs:1 [used for our winsys follows-pte mode] to be cached
caused display glitches. Though it is documented as deprecated (and so
likely behaves as uncached) use the follow-pte bit and force it out of
L3 cache.

Testcase: igt/kms_frontbuffer_tracking
Testcase: igt/kms_big_fb
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ayaz A Siddiqui <ayaz.siddiqui@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201015122138.30161-4-chris@chris-wilson.co.uk
(cherry picked from commit a04ac827366594c7244f60e9be79fcb404af69f0)
Fixes: 849c0fe9e831 ("drm/i915/gt: Initialize reserved and unspecified MOCS indices")
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo: Updated Fixes tag]
Cc: <stable@vger.kernel.org> # 5.9.x
---
 drivers/gpu/drm/i915/gt/intel_mocs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_mocs.c b/drivers/gpu/drm/i915/gt/intel_mocs.c
index b8f56e62158e..313e51e7d4f7 100644
--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -243,8 +243,9 @@ static const struct drm_i915_mocs_entry tgl_mocs_table[] = {
 	 * only, __init_mocs_table() take care to program unused index with
 	 * this entry.
 	 */
-	MOCS_ENTRY(1, LE_3_WB | LE_TC_1_LLC | LE_LRUM(3),
-		   L3_3_WB),
+	MOCS_ENTRY(I915_MOCS_PTE,
+		   LE_0_PAGETABLE | LE_TC_0_PAGETABLE,
+		   L3_1_UC),
 	GEN11_MOCS_ENTRIES,
 
 	/* Implicitly enable L1 - HDC:L1 + L3 + LLC */
-- 
2.28.0


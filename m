Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7832D0475
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgLFLpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbgLFLpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:49 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Ayaz A Siddiqui <ayaz.siddiqui@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 46/46] drm/i915/gt: Fixup tgl mocs for PTE tracking
Date:   Sun,  6 Dec 2020 12:17:54 +0100
Message-Id: <20201206111558.681285823@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_mocs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_mocs.c
+++ b/drivers/gpu/drm/i915/gt/intel_mocs.c
@@ -243,8 +243,9 @@ static const struct drm_i915_mocs_entry
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48029205E1B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbgFWUUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389277AbgFWUT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B2652080C;
        Tue, 23 Jun 2020 20:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943598;
        bh=KSchARG4prvgD4cRrERkvOUIcyR1BweienIh+sApG5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GujoVf1ItxcTzPEFebuJoHzEMdXbBMB5kiGB+1l2DmIPcA3eFlFzrJ3SHNb64Vt4J
         A2ZddSv3KDMTFlBR0OYK57blogC0d1JmepPX32ntwJ4my9ifr8Tce8fAbqQQT5knzL
         i7+yNj5yUiNoiknrFt8CL/lwVSqZME7iLHaNIrwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 454/477] drm/i915/gt: Move snb GT workarounds from init_clock_gating to workarounds
Date:   Tue, 23 Jun 2020 21:57:31 +0200
Message-Id: <20200623195429.003607887@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit fd2599bda5a989c3332f4956fd7760ec32bd51ee upstream.

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-4-chris@chris-wilson.co.uk
(cherry picked from commit c3b93a943f2c9ee4a106db100a2fc3b2f126bfc5)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   41 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_pm.c             |   33 ----------------------
 2 files changed, 41 insertions(+), 33 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -704,6 +704,45 @@ int intel_engine_emit_ctx_wa(struct i915
 }
 
 static void
+snb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	/* WaDisableHiZPlanesWhenMSAAEnabled:snb */
+	wa_masked_en(wal,
+		     _3D_CHICKEN,
+		     _3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB);
+
+	/* WaDisable_RenderCache_OperationalFlush:snb */
+	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+
+	/*
+	 * BSpec recommends 8x4 when MSAA is used,
+	 * however in practice 16x4 seems fastest.
+	 *
+	 * Note that PS/WM thread counts depend on the WIZ hashing
+	 * disable bit, which we don't touch here, but it's good
+	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
+	 */
+	wa_add(wal,
+	       GEN6_GT_MODE, 0,
+	       _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4),
+	       GEN6_WIZ_HASHING_16x4);
+
+	wa_masked_dis(wal, CACHE_MODE_0, CM0_STC_EVICT_DISABLE_LRA_SNB);
+
+	wa_masked_en(wal,
+		     _3D_CHICKEN3,
+		     /* WaStripsFansDisableFastClipPerformanceFix:snb */
+		     _3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL |
+		     /*
+		      * Bspec says:
+		      * "This bit must be set if 3DSTATE_CLIP clip mode is set
+		      * to normal and 3DSTATE_SF number of SF output attributes
+		      * is more than 16."
+		      */
+		   _3D_CHICKEN3_SF_DISABLE_PIPELINED_ATTR_FETCH);
+}
+
+static void
 ivb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
 	/* WaDisableEarlyCull:ivb */
@@ -1084,6 +1123,8 @@ gt_init_workarounds(struct drm_i915_priv
 		hsw_gt_workarounds_init(i915, wal);
 	else if (IS_IVYBRIDGE(i915))
 		ivb_gt_workarounds_init(i915, wal);
+	else if (IS_GEN(i915, 6))
+		snb_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6665,27 +6665,6 @@ static void gen6_init_clock_gating(struc
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
 
-	/* WaDisableHiZPlanesWhenMSAAEnabled:snb */
-	I915_WRITE(_3D_CHICKEN,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
-
-	/* WaDisable_RenderCache_OperationalFlush:snb */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
-	/*
-	 * BSpec recoomends 8x4 when MSAA is used,
-	 * however in practice 16x4 seems fastest.
-	 *
-	 * Note that PS/WM thread counts depend on the WIZ hashing
-	 * disable bit, which we don't touch here, but it's good
-	 * to keep in mind (see 3DSTATE_PS and 3DSTATE_WM).
-	 */
-	I915_WRITE(GEN6_GT_MODE,
-		   _MASKED_FIELD(GEN6_WIZ_HASHING_MASK, GEN6_WIZ_HASHING_16x4));
-
-	I915_WRITE(CACHE_MODE_0,
-		   _MASKED_BIT_DISABLE(CM0_STC_EVICT_DISABLE_LRA_SNB));
-
 	I915_WRITE(GEN6_UCGCTL1,
 		   I915_READ(GEN6_UCGCTL1) |
 		   GEN6_BLBUNIT_CLOCK_GATE_DISABLE |
@@ -6708,18 +6687,6 @@ static void gen6_init_clock_gating(struc
 		   GEN6_RCPBUNIT_CLOCK_GATE_DISABLE |
 		   GEN6_RCCUNIT_CLOCK_GATE_DISABLE);
 
-	/* WaStripsFansDisableFastClipPerformanceFix:snb */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL));
-
-	/*
-	 * Bspec says:
-	 * "This bit must be set if 3DSTATE_CLIP clip mode is set to normal and
-	 * 3DSTATE_SF number of SF output attributes is more than 16."
-	 */
-	I915_WRITE(_3D_CHICKEN3,
-		   _MASKED_BIT_ENABLE(_3D_CHICKEN3_SF_DISABLE_PIPELINED_ATTR_FETCH));
-
 	/*
 	 * According to the spec the following bits should be
 	 * set in order to enable memory self-refresh and fbc:



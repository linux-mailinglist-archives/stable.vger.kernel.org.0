Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECFC20633F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389565AbgFWUUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389599AbgFWUUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60CAB2080C;
        Tue, 23 Jun 2020 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943605;
        bh=oo51x5EQhWJuseftlFJxl0FZBh3KHWrE2vskUof0qkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APFEEcVLC0c3XcB9rlkOu6H+5INaPHSF/0x87fyndXm+gs6VTne+xAy3RUp3nzXDi
         CFzbFrBf16k50BvEGBXOFRQQ3OA6hM5+qtPwvlg0v+6VutE+5aO46jySb4gs+HEao6
         mR4FxMFs1HZShW9jJyYjqE3fPFKccSyqxmzdaG1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 457/477] drm/i915/gt: Move gen4 GT workarounds from init_clock_gating to workarounds
Date:   Tue, 23 Jun 2020 21:57:34 +0200
Message-Id: <20200623195429.152286516@linuxfoundation.org>
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

commit 27582a9c917940bc71c0df0b8e022cbde8d735d2 upstream.

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-6-chris@chris-wilson.co.uk
(cherry picked from commit 2bcefd0d263ab4a72f0d61921ae6b0dc81606551)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   27 ++++++++++++++++++++++-----
 drivers/gpu/drm/i915/intel_pm.c             |   15 ---------------
 2 files changed, 22 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -704,15 +704,28 @@ int intel_engine_emit_ctx_wa(struct i915
 }
 
 static void
-ilk_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+gen4_gt_workarounds_init(struct drm_i915_private *i915,
+			 struct i915_wa_list *wal)
 {
-	wa_masked_en(wal, _3D_CHICKEN2, _3D_CHICKEN2_WM_READ_PIPELINED);
+	/* WaDisable_RenderCache_OperationalFlush:gen4,ilk */
+	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+}
+
+static void
+g4x_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	gen4_gt_workarounds_init(i915, wal);
 
-	/* WaDisableRenderCachePipelinedFlush:ilk */
+	/* WaDisableRenderCachePipelinedFlush:g4x,ilk */
 	wa_masked_en(wal, CACHE_MODE_0, CM0_PIPELINED_RENDER_FLUSH_DISABLE);
+}
 
-	/* WaDisable_RenderCache_OperationalFlush:ilk */
-	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+static void
+ilk_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	g4x_gt_workarounds_init(i915, wal);
+
+	wa_masked_en(wal, _3D_CHICKEN2, _3D_CHICKEN2_WM_READ_PIPELINED);
 }
 
 static void
@@ -1198,6 +1211,10 @@ gt_init_workarounds(struct drm_i915_priv
 		snb_gt_workarounds_init(i915, wal);
 	else if (IS_GEN(i915, 5))
 		ilk_gt_workarounds_init(i915, wal);
+	else if (IS_G4X(i915))
+		g4x_gt_workarounds_init(i915, wal);
+	else if (IS_GEN(i915, 4))
+		gen4_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -7070,13 +7070,6 @@ static void g4x_init_clock_gating(struct
 		dspclk_gate |= DSSUNIT_CLOCK_GATE_DISABLE;
 	I915_WRITE(DSPCLK_GATE_D, dspclk_gate);
 
-	/* WaDisableRenderCachePipelinedFlush */
-	I915_WRITE(CACHE_MODE_0,
-		   _MASKED_BIT_ENABLE(CM0_PIPELINED_RENDER_FLUSH_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:g4x */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
-
 	g4x_disable_trickle_feed(dev_priv);
 }
 
@@ -7092,11 +7085,6 @@ static void i965gm_init_clock_gating(str
 	intel_uncore_write(uncore,
 			   MI_ARB_STATE,
 			   _MASKED_BIT_ENABLE(MI_ARB_DISPLAY_TRICKLE_FEED_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:gen4 */
-	intel_uncore_write(uncore,
-			   CACHE_MODE_0,
-			   _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 }
 
 static void i965g_init_clock_gating(struct drm_i915_private *dev_priv)
@@ -7109,9 +7097,6 @@ static void i965g_init_clock_gating(stru
 	I915_WRITE(RENCLK_GATE_D2, 0);
 	I915_WRITE(MI_ARB_STATE,
 		   _MASKED_BIT_ENABLE(MI_ARB_DISPLAY_TRICKLE_FEED_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:gen4 */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 }
 
 static void gen3_init_clock_gating(struct drm_i915_private *dev_priv)



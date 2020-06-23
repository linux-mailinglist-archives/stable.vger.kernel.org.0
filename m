Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC020649B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391096AbgFWVYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389861AbgFWUUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 704962064B;
        Tue, 23 Jun 2020 20:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943600;
        bh=X3McVrf4UDQ6uxJEjMAhJPbTokNz2F5lVo7gXnHyRK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6OyES4Ua+YIIf7nszQZGAG/i1Pv+1CquksoDGZI/HlohHNwAyijjyAfalW2AS+RV
         Qwwiqx+NRn4PkK/clanDYdPcjLMSnh3xkQNfPsKlgf/cHmFTDxVe5y9ZsFdQ4gY08+
         ZCv1i6h3cbVwHvl/kpa5zxu9V2eqTfwHsjs/8+GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.7 455/477] drm/i915/gt: Move ilk GT workarounds from init_clock_gating to workarounds
Date:   Tue, 23 Jun 2020 21:57:32 +0200
Message-Id: <20200623195429.054666189@linuxfoundation.org>
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

commit eacf21040aa97fd1b3c6bb201bfd43820e1c49be upstream.

Rescue the GT workarounds from being buried inside init_clock_gating so
that we remember to apply them after a GT reset, and that they are
included in our verification that the workarounds are applied.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200611080140.30228-5-chris@chris-wilson.co.uk
(cherry picked from commit 806a45c0838d253e306a6384057e851b65d11099)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   14 ++++++++++++++
 drivers/gpu/drm/i915/intel_pm.c             |   10 ----------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -704,6 +704,18 @@ int intel_engine_emit_ctx_wa(struct i915
 }
 
 static void
+ilk_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
+{
+	wa_masked_en(wal, _3D_CHICKEN2, _3D_CHICKEN2_WM_READ_PIPELINED);
+
+	/* WaDisableRenderCachePipelinedFlush:ilk */
+	wa_masked_en(wal, CACHE_MODE_0, CM0_PIPELINED_RENDER_FLUSH_DISABLE);
+
+	/* WaDisable_RenderCache_OperationalFlush:ilk */
+	wa_masked_dis(wal, CACHE_MODE_0, RC_OP_FLUSH_ENABLE);
+}
+
+static void
 snb_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 {
 	/* WaDisableHiZPlanesWhenMSAAEnabled:snb */
@@ -1125,6 +1137,8 @@ gt_init_workarounds(struct drm_i915_priv
 		ivb_gt_workarounds_init(i915, wal);
 	else if (IS_GEN(i915, 6))
 		snb_gt_workarounds_init(i915, wal);
+	else if (IS_GEN(i915, 5))
+		ilk_gt_workarounds_init(i915, wal);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6593,16 +6593,6 @@ static void ilk_init_clock_gating(struct
 	I915_WRITE(ILK_DISPLAY_CHICKEN2,
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
-	I915_WRITE(_3D_CHICKEN2,
-		   _3D_CHICKEN2_WM_READ_PIPELINED << 16 |
-		   _3D_CHICKEN2_WM_READ_PIPELINED);
-
-	/* WaDisableRenderCachePipelinedFlush:ilk */
-	I915_WRITE(CACHE_MODE_0,
-		   _MASKED_BIT_ENABLE(CM0_PIPELINED_RENDER_FLUSH_DISABLE));
-
-	/* WaDisable_RenderCache_OperationalFlush:ilk */
-	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 
 	g4x_disable_trickle_feed(dev_priv);
 



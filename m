Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EFD2C0C2B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732772AbgKWNua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbgKWNu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 08:50:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C9FA206F1;
        Mon, 23 Nov 2020 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606139428;
        bh=pz37Gn97ch7Lk3IMpVMcl1eN/9hIUcnk2VqStcv/jlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1p48ovJYKWZoOZdRAY0wIqnwLMn5xiqmzDLsbqzXQdY6qNg1pQ1z3Ar+o+OVwOx9E
         cPtbgF/yL2rbWV5D6SDueyliN0xXcjr4BhxPvl6Hi0WHMU84zaUjy1oA+/IkxgvMkD
         T0I8dxiSy61qrEgIe9SCbzACftb1TxYi7OtIUU6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>,
        stable@vger.kernel.org, Dale B Stimson <dale.b.stimson@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 5.9 238/252] drm/i915/tgl: Fix Media power gate sequence.
Date:   Mon, 23 Nov 2020 13:23:08 +0100
Message-Id: <20201123121847.066523510@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

commit 85a12d7eb8fe449cf38f1aa9ead5ca744729a98f upstream.

Some media power gates are disabled by default. commit 5d86923060fc
("drm/i915/tgl: Enable VD HCP/MFX sub-pipe power gating")
tried to enable it, but it duplicated an existent register.
So, the main PG setup sequences ended up overwriting it.

So, let's now merge this to the main PG setup sequence.

v2: (Chris): s/BIT/REG_BIT, remove useless comment,
    	     remove useless =0, use the right gt,
	     remove rc6 sequence doubt from commit message.

Fixes: 5d86923060fc ("drm/i915/tgl: Enable VD HCP/MFX sub-pipe power gating")
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: stable@vger.kernel.org#v5.5+
Cc: Dale B Stimson <dale.b.stimson@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201111072859.1186070-1-rodrigo.vivi@intel.com
(cherry picked from commit 695dc55b573985569259e18f8e6261a77924342b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_rc6.c |   22 +++++++++++++++++-----
 drivers/gpu/drm/i915/i915_reg.h     |   12 +++++-------
 drivers/gpu/drm/i915/intel_pm.c     |   13 -------------
 3 files changed, 22 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -56,9 +56,12 @@ static inline void set(struct intel_unco
 
 static void gen11_rc6_enable(struct intel_rc6 *rc6)
 {
-	struct intel_uncore *uncore = rc6_to_uncore(rc6);
+	struct intel_gt *gt = rc6_to_gt(rc6);
+	struct intel_uncore *uncore = gt->uncore;
 	struct intel_engine_cs *engine;
 	enum intel_engine_id id;
+	u32 pg_enable;
+	int i;
 
 	/* 2b: Program RC6 thresholds.*/
 	set(uncore, GEN6_RC6_WAKE_RATE_LIMIT, 54 << 16 | 85);
@@ -102,10 +105,19 @@ static void gen11_rc6_enable(struct inte
 		GEN6_RC_CTL_RC6_ENABLE |
 		GEN6_RC_CTL_EI_MODE(1);
 
-	set(uncore, GEN9_PG_ENABLE,
-	    GEN9_RENDER_PG_ENABLE |
-	    GEN9_MEDIA_PG_ENABLE |
-	    GEN11_MEDIA_SAMPLER_PG_ENABLE);
+	pg_enable =
+		GEN9_RENDER_PG_ENABLE |
+		GEN9_MEDIA_PG_ENABLE |
+		GEN11_MEDIA_SAMPLER_PG_ENABLE;
+
+	if (INTEL_GEN(gt->i915) >= 12) {
+		for (i = 0; i < I915_MAX_VCS; i++)
+			if (HAS_ENGINE(gt, _VCS(i)))
+				pg_enable |= (VDN_HCP_POWERGATE_ENABLE(i) |
+					      VDN_MFX_POWERGATE_ENABLE(i));
+	}
+
+	set(uncore, GEN9_PG_ENABLE, pg_enable);
 }
 
 static void gen9_rc6_enable(struct intel_rc6 *rc6)
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -8974,10 +8974,6 @@ enum {
 #define   GEN9_PWRGT_MEDIA_STATUS_MASK		(1 << 0)
 #define   GEN9_PWRGT_RENDER_STATUS_MASK		(1 << 1)
 
-#define POWERGATE_ENABLE			_MMIO(0xa210)
-#define    VDN_HCP_POWERGATE_ENABLE(n)		BIT(((n) * 2) + 3)
-#define    VDN_MFX_POWERGATE_ENABLE(n)		BIT(((n) * 2) + 4)
-
 #define  GTFIFODBG				_MMIO(0x120000)
 #define    GT_FIFO_SBDEDICATE_FREE_ENTRY_CHV	(0x1f << 20)
 #define    GT_FIFO_FREE_ENTRIES_CHV		(0x7f << 13)
@@ -9117,9 +9113,11 @@ enum {
 #define GEN9_MEDIA_PG_IDLE_HYSTERESIS		_MMIO(0xA0C4)
 #define GEN9_RENDER_PG_IDLE_HYSTERESIS		_MMIO(0xA0C8)
 #define GEN9_PG_ENABLE				_MMIO(0xA210)
-#define GEN9_RENDER_PG_ENABLE			REG_BIT(0)
-#define GEN9_MEDIA_PG_ENABLE			REG_BIT(1)
-#define GEN11_MEDIA_SAMPLER_PG_ENABLE		REG_BIT(2)
+#define   GEN9_RENDER_PG_ENABLE			REG_BIT(0)
+#define   GEN9_MEDIA_PG_ENABLE			REG_BIT(1)
+#define   GEN11_MEDIA_SAMPLER_PG_ENABLE		REG_BIT(2)
+#define   VDN_HCP_POWERGATE_ENABLE(n)		REG_BIT(3 + 2 * (n))
+#define   VDN_MFX_POWERGATE_ENABLE(n)		REG_BIT(4 + 2 * (n))
 #define GEN8_PUSHBUS_CONTROL			_MMIO(0xA248)
 #define GEN8_PUSHBUS_ENABLE			_MMIO(0xA250)
 #define GEN8_PUSHBUS_SHIFT			_MMIO(0xA25C)
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -7124,23 +7124,10 @@ static void icl_init_clock_gating(struct
 
 static void tgl_init_clock_gating(struct drm_i915_private *dev_priv)
 {
-	u32 vd_pg_enable = 0;
-	unsigned int i;
-
 	/* Wa_1409120013:tgl */
 	I915_WRITE(ILK_DPFC_CHICKEN,
 		   ILK_DPFC_CHICKEN_COMP_DUMMY_PIXEL);
 
-	/* This is not a WA. Enable VD HCP & MFX_ENC powergate */
-	for (i = 0; i < I915_MAX_VCS; i++) {
-		if (HAS_ENGINE(&dev_priv->gt, _VCS(i)))
-			vd_pg_enable |= VDN_HCP_POWERGATE_ENABLE(i) |
-					VDN_MFX_POWERGATE_ENABLE(i);
-	}
-
-	I915_WRITE(POWERGATE_ENABLE,
-		   I915_READ(POWERGATE_ENABLE) | vd_pg_enable);
-
 	/* Wa_1409825376:tgl (pre-prod)*/
 	if (IS_TGL_REVID(dev_priv, TGL_REVID_A0, TGL_REVID_A0))
 		I915_WRITE(GEN9_CLKGATE_DIS_3, I915_READ(GEN9_CLKGATE_DIS_3) |



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C820AB2077
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390992AbfIMNWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390989AbfIMNWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:22:16 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF368206BB;
        Fri, 13 Sep 2019 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380935;
        bh=WU84xUoe0tYLWwJG8iE934g2D098MEcnZqMAR9KL6IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdpXP74NwSlbtKulzTwUEmg52gowE5KLZSrZZNz6FithAlkPLwwEVD8shDFEpuRkB
         32NKUSLR0I+Sp6S5nGzypR2nLALPh0WmGBmeiWkXqi8gO6R27kPn0BgTQqBCDSq99Q
         m6/9bFySnWFoivSrP+xNZNSFFm2JrFjLqHiYl728=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Harrison <John.C.Harrison@Intel.com>,
        "Robert M. Fosha" <robert.m.fosha@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 31/37] drm/i915: Support whitelist workarounds on all engines
Date:   Fri, 13 Sep 2019 14:07:36 +0100
Message-Id: <20190913130521.552482786@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ebd2de47a19f1c17ae47f8331aae3cd436766663 ]

Newer hardware requires setting up whitelists on engines other than
render. So, extend the whitelist code to support all engines.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Robert M. Fosha <robert.m.fosha@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618010108.27499-3-John.C.Harrison@Intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 65 +++++++++++++++++-------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index 1db826b12774e..0b80fde927899 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -1012,48 +1012,79 @@ static void gen9_whitelist_build(struct i915_wa_list *w)
 	whitelist_reg(w, GEN8_HDC_CHICKEN1);
 }
 
-static void skl_whitelist_build(struct i915_wa_list *w)
+static void skl_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
+	if (engine->class != RENDER_CLASS)
+		return;
+
 	gen9_whitelist_build(w);
 
 	/* WaDisableLSQCROPERFforOCL:skl */
 	whitelist_reg(w, GEN8_L3SQCREG4);
 }
 
-static void bxt_whitelist_build(struct i915_wa_list *w)
+static void bxt_whitelist_build(struct intel_engine_cs *engine)
 {
-	gen9_whitelist_build(w);
+	if (engine->class != RENDER_CLASS)
+		return;
+
+	gen9_whitelist_build(&engine->whitelist);
 }
 
-static void kbl_whitelist_build(struct i915_wa_list *w)
+static void kbl_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
+	if (engine->class != RENDER_CLASS)
+		return;
+
 	gen9_whitelist_build(w);
 
 	/* WaDisableLSQCROPERFforOCL:kbl */
 	whitelist_reg(w, GEN8_L3SQCREG4);
 }
 
-static void glk_whitelist_build(struct i915_wa_list *w)
+static void glk_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
+	if (engine->class != RENDER_CLASS)
+		return;
+
 	gen9_whitelist_build(w);
 
 	/* WA #0862: Userspace has to set "Barrier Mode" to avoid hangs. */
 	whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
 }
 
-static void cfl_whitelist_build(struct i915_wa_list *w)
+static void cfl_whitelist_build(struct intel_engine_cs *engine)
 {
-	gen9_whitelist_build(w);
+	if (engine->class != RENDER_CLASS)
+		return;
+
+	gen9_whitelist_build(&engine->whitelist);
 }
 
-static void cnl_whitelist_build(struct i915_wa_list *w)
+static void cnl_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
+	if (engine->class != RENDER_CLASS)
+		return;
+
 	/* WaEnablePreemptionGranularityControlByUMD:cnl */
 	whitelist_reg(w, GEN8_CS_CHICKEN1);
 }
 
-static void icl_whitelist_build(struct i915_wa_list *w)
+static void icl_whitelist_build(struct intel_engine_cs *engine)
 {
+	struct i915_wa_list *w = &engine->whitelist;
+
+	if (engine->class != RENDER_CLASS)
+		return;
+
 	/* WaAllowUMDToModifyHalfSliceChicken7:icl */
 	whitelist_reg(w, GEN9_HALF_SLICE_CHICKEN7);
 
@@ -1069,24 +1100,22 @@ void intel_engine_init_whitelist(struct intel_engine_cs *engine)
 	struct drm_i915_private *i915 = engine->i915;
 	struct i915_wa_list *w = &engine->whitelist;
 
-	GEM_BUG_ON(engine->id != RCS0);
-
 	wa_init_start(w, "whitelist");
 
 	if (IS_GEN(i915, 11))
-		icl_whitelist_build(w);
+		icl_whitelist_build(engine);
 	else if (IS_CANNONLAKE(i915))
-		cnl_whitelist_build(w);
+		cnl_whitelist_build(engine);
 	else if (IS_COFFEELAKE(i915))
-		cfl_whitelist_build(w);
+		cfl_whitelist_build(engine);
 	else if (IS_GEMINILAKE(i915))
-		glk_whitelist_build(w);
+		glk_whitelist_build(engine);
 	else if (IS_KABYLAKE(i915))
-		kbl_whitelist_build(w);
+		kbl_whitelist_build(engine);
 	else if (IS_BROXTON(i915))
-		bxt_whitelist_build(w);
+		bxt_whitelist_build(engine);
 	else if (IS_SKYLAKE(i915))
-		skl_whitelist_build(w);
+		skl_whitelist_build(engine);
 	else if (INTEL_GEN(i915) <= 8)
 		return;
 	else
-- 
2.20.1




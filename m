Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73327A6E4C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbfICQZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730307AbfICQZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3490A2343A;
        Tue,  3 Sep 2019 16:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527911;
        bh=ZnpwUH/bPiEE4wslv4yPlhf2ZtPaAnT2HGWxhurSN98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+a3l8pYptK6lnQ+XfHUf+FPXUpOmv0zmCRn8M60zeClwUOwfj2ZdqUXaxvxEtpO1
         km0lM/t5bUg80YDXDGk7QQWzlz8rBrtHf3rCYc4C5QEdJCR7/k3/Mx2jzgLmnmDNGh
         9df/qUrFX7r4osWDGDUMS3TMBaP7h6Mi/+wkc4jI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Harrison <John.C.Harrison@Intel.com>,
        "Robert M . Fosha" <robert.m.fosha@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 20/23] drm/i915: Support whitelist workarounds on all engines
Date:   Tue,  3 Sep 2019 12:24:21 -0400
Message-Id: <20190903162424.6877-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

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


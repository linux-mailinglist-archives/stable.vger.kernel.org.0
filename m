Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D36A709C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfICQZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbfICQZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB83123711;
        Tue,  3 Sep 2019 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527913;
        bh=24HeKgZc0EdrCzr8e/aVIGvdzcTwEfQ6sZ6O29G15NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00WD3xG1HXVmfZCWpIRI6NgAfgxq9CJbQsZdJoQ2ElVDbFVR29qcqJ0ih4VGnjyHL
         sDwYBUdplNaVqHypg1Z4G1P5s1hPb9b7KAOo2fNL3b69A9W9YSBK2RkBK9To7U+q0N
         YKAzlj/q9qlnSU036H8BleVMdwSdt/1dvvepczcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Harrison <John.C.Harrison@Intel.com>,
        "Robert M . Fosha" <robert.m.fosha@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 22/23] drm/i915: Add whitelist workarounds for ICL
Date:   Tue,  3 Sep 2019 12:24:23 -0400
Message-Id: <20190903162424.6877-22-sashal@kernel.org>
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

[ Upstream commit 7b3d406310983a89ed7a1ecdd115efbe12b0ded5 ]

Updated whitelist table for ICL.

v2: Reduce changes to just those required for media driver until
the selftest can be updated to support the new features of the
other entries.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Robert M. Fosha <robert.m.fosha@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618010108.27499-4-John.C.Harrison@Intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_workarounds.c | 38 +++++++++++++++++-------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_workarounds.c b/drivers/gpu/drm/i915/intel_workarounds.c
index be3688908f0ce..efea5a18fa6db 100644
--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -1097,17 +1097,33 @@ static void icl_whitelist_build(struct intel_engine_cs *engine)
 {
 	struct i915_wa_list *w = &engine->whitelist;
 
-	if (engine->class != RENDER_CLASS)
-		return;
-
-	/* WaAllowUMDToModifyHalfSliceChicken7:icl */
-	whitelist_reg(w, GEN9_HALF_SLICE_CHICKEN7);
-
-	/* WaAllowUMDToModifySamplerMode:icl */
-	whitelist_reg(w, GEN10_SAMPLER_MODE);
-
-	/* WaEnableStateCacheRedirectToCS:icl */
-	whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
+	switch (engine->class) {
+	case RENDER_CLASS:
+		/* WaAllowUMDToModifyHalfSliceChicken7:icl */
+		whitelist_reg(w, GEN9_HALF_SLICE_CHICKEN7);
+
+		/* WaAllowUMDToModifySamplerMode:icl */
+		whitelist_reg(w, GEN10_SAMPLER_MODE);
+
+		/* WaEnableStateCacheRedirectToCS:icl */
+		whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
+		break;
+
+	case VIDEO_DECODE_CLASS:
+		/* hucStatusRegOffset */
+		whitelist_reg_ext(w, _MMIO(0x2000 + engine->mmio_base),
+				  RING_FORCE_TO_NONPRIV_RD);
+		/* hucUKernelHdrInfoRegOffset */
+		whitelist_reg_ext(w, _MMIO(0x2014 + engine->mmio_base),
+				  RING_FORCE_TO_NONPRIV_RD);
+		/* hucStatus2RegOffset */
+		whitelist_reg_ext(w, _MMIO(0x23B0 + engine->mmio_base),
+				  RING_FORCE_TO_NONPRIV_RD);
+		break;
+
+	default:
+		break;
+	}
 }
 
 void intel_engine_init_whitelist(struct intel_engine_cs *engine)
-- 
2.20.1


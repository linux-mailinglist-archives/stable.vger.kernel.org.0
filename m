Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80443B1FAC
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390903AbfIMNVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390900AbfIMNVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:47 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E98D20717;
        Fri, 13 Sep 2019 13:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380906;
        bh=MI4WDWM+C2NHPKLPkdzsoUBHKRJhI8Jr7GHXBKGn/9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goFsvmRmWhYp64bbmsMZzTlzhKh0hBDXGyoMgXs1pmaxpQk5kWHeFd72fyD4sKo9q
         7e4pjjykcYOVFNrjXj2ZHEnVtov6NCNHbhEddKSeDis8tQV87NLE0WcSngHB+DyR5F
         1IZN2NSHripteH2Vwi/QabazCx+oYvo/b8X9vtzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Harrison <John.C.Harrison@Intel.com>,
        "Robert M. Fosha" <robert.m.fosha@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 33/37] drm/i915: Add whitelist workarounds for ICL
Date:   Fri, 13 Sep 2019 14:07:38 +0100
Message-Id: <20190913130521.753967325@linuxfoundation.org>
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




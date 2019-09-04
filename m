Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46989A7FFE
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfIDKHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 06:07:15 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:61580 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726240AbfIDKHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 06:07:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 18368401-1500050 
        for multiple; Wed, 04 Sep 2019 11:07:08 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Jason Ekstrand <jason@jlekstrand.net>,
        denys.kostin@globallogic.com,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE) for skl+
Date:   Wed,  4 Sep 2019 11:07:07 +0100
Message-Id: <20190904100707.7377-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This bit was fliped on for "syncing dependencies between camera and
graphics". BSpec has no recollection why, and it is causing
unrecoverable GPU hangs with Vulkan compute workloads.

From BSpec, setting bit5 to 0 enables relaxed padding requiremets for
buffers, 1D and 2D non-array, non-MSAA, non-mip-mapped linear surfaces;
and *must* be set to 0h on skl+ to ensure "Out of Bounds" case is
suppressed.

Reported-by: Jason Ekstrand <jason@jlekstrand.net>
Suggested-by: Jason Ekstrand <jason@jlekstrand.net>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110998
Fixes: 8424171e135c ("drm/i915/gen9: h/w w/a: syncing dependencies between camera and graphics")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: denys.kostin@globallogic.com
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.1+
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 8639fcccdb42..243d3f77be13 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -297,11 +297,6 @@ static void gen9_ctx_workarounds_init(struct intel_engine_cs *engine,
 			  FLOW_CONTROL_ENABLE |
 			  PARTIAL_INSTRUCTION_SHOOTDOWN_DISABLE);
 
-	/* Syncing dependencies between camera and graphics:skl,bxt,kbl */
-	if (!IS_COFFEELAKE(i915))
-		WA_SET_BIT_MASKED(HALF_SLICE_CHICKEN3,
-				  GEN9_DISABLE_OCL_OOB_SUPPRESS_LOGIC);
-
 	/* WaEnableYV12BugFixInHalfSliceChicken7:skl,bxt,kbl,glk,cfl */
 	/* WaEnableSamplerGPGPUPreemptionSupport:skl,bxt,kbl,cfl */
 	WA_SET_BIT_MASKED(GEN9_HALF_SLICE_CHICKEN7,
-- 
2.23.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC865277D
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfFYJHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:07:03 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60977 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728365AbfFYJHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 05:07:02 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17014818-1500050 
        for multiple; Tue, 25 Jun 2019 10:06:58 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Kenneth Graunke <kenneth@whitecape.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.
Date:   Tue, 25 Jun 2019 10:06:55 +0100
Message-Id: <20190625090655.19220-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625070829.25277-1-kenneth@whitecape.org>
References: <20190625070829.25277-1-kenneth@whitecape.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Graunke <kenneth@whitecape.org>

The Demand Prefetch workaround (binding table prefetching) only applies
to Icelake A0/B0.  But the Sampler Prefetch workaround needs to be
applied to all Gen11 steppings, according to a programming note in the
SARCHKMD documentation.

Using the Intel Gallium driver, I have seen intermittent failures in
the dEQP-GLES31.functional.copy_image.non_compressed.* tests.  After
applying this workaround, the tests reliably pass.

v2: Remove the overlap with a pre-production w/a

BSpec: 9663
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index c70445adfb02..993804d09517 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1252,8 +1252,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		if (IS_ICL_REVID(i915, ICL_REVID_A0, ICL_REVID_B0))
 			wa_write_or(wal,
 				    GEN7_SARCHKMD,
-				    GEN7_DISABLE_DEMAND_PREFETCH |
-				    GEN7_DISABLE_SAMPLER_PREFETCH);
+				    GEN7_DISABLE_DEMAND_PREFETCH);
+
+		/* Wa_1606682166:icl */
+		wa_write_or(wal,
+			    GEN7_SARCHKMD,
+			    GEN7_DISABLE_SAMPLER_PREFETCH);
 	}
 
 	if (IS_GEN_RANGE(i915, 9, 11)) {
-- 
2.20.1


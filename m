Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3AA2EF48A
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 16:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbhAHPKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 10:10:08 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:59695 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726666AbhAHPKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 10:10:08 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23539641-1500050 
        for multiple; Fri, 08 Jan 2021 15:09:25 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matt Roper <matthew.d.roper@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Prevent use of engine->wa_ctx after error
Date:   Fri,  8 Jan 2021 15:09:24 +0000
Message-Id: <20210108150924.29437-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On error we unpin and free the wa_ctx.vma, but do not clear any of the
derived flags. During lrc_init, we look at the flags and attempt to
dereference the wa_ctx.vma if they are set. To protect the error path
where we try to limp along without the wa_ctx, make sure we clear those
flags!

Reported-by: Matt Roper <matthew.d.roper@intel.com>
Fixes: 604a8f6f1e33 ("drm/i915/lrc: Only enable per-context and per-bb buffers if set")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.15+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 4e856947fb13..703d9ecc3f7e 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1453,6 +1453,9 @@ static int lrc_setup_wa_ctx(struct intel_engine_cs *engine)
 void lrc_fini_wa_ctx(struct intel_engine_cs *engine)
 {
 	i915_vma_unpin_and_release(&engine->wa_ctx.vma, 0);
+
+	/* Called on error unwind, clear all flags to prevent further use */
+	memset(&engine->wa_ctx, 0, sizeof(engine->wa_ctx));
 }
 
 typedef u32 *(*wa_bb_func_t)(struct intel_engine_cs *engine, u32 *batch);
-- 
2.20.1


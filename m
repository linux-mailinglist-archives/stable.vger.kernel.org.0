Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D875375FF0
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfGZHgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:36:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:41199 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGZHgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:36:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 00:36:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="369967774"
Received: from jlahtine-desk.ger.corp.intel.com ([10.252.2.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jul 2019 00:36:12 -0700
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 8/8] drm/i915: Don't dereference request if it may have been retired when printing
Date:   Fri, 26 Jul 2019 10:35:56 +0300
Message-Id: <20190726073556.9011-9-joonas.lahtinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

This has caught me out on countless occasions, when we retrieve a pointer
from the submission/execlists backend, it does not carry a reference to
the context or ring. Those are only pinned while the request is active,
so if we see the request is already completed, it may be in the process
of being retired and those pointers defunct.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110938
Fixes: 3a068721a973 ("drm/i915: Show ring->start for the ELSP context/request queue")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618161951.28820-2-chris@chris-wilson.co.uk
(cherry picked from commit eca153603f2f020e15d071918e0daf1d56c17d29)
Cc: stable@vger.kernel.org
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_engine_cs.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c b/drivers/gpu/drm/i915/intel_engine_cs.c
index 9d4f12e982c3..ecc0458a4a8d 100644
--- a/drivers/gpu/drm/i915/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/intel_engine_cs.c
@@ -1349,12 +1349,13 @@ static void hexdump(struct drm_printer *m, const void *buf, size_t len)
 	}
 }
 
-static void intel_engine_print_registers(const struct intel_engine_cs *engine,
+static void intel_engine_print_registers(struct intel_engine_cs *engine,
 					 struct drm_printer *m)
 {
 	struct drm_i915_private *dev_priv = engine->i915;
 	const struct intel_engine_execlists * const execlists =
 		&engine->execlists;
+	unsigned long flags;
 	u64 addr;
 
 	if (engine->id == RCS0 && IS_GEN_RANGE(dev_priv, 4, 7))
@@ -1435,15 +1436,16 @@ static void intel_engine_print_registers(const struct intel_engine_cs *engine,
 				   idx, hws[idx * 2], hws[idx * 2 + 1]);
 		}
 
-		rcu_read_lock();
+		spin_lock_irqsave(&engine->timeline.lock, flags);
 		for (idx = 0; idx < execlists_num_ports(execlists); idx++) {
 			struct i915_request *rq;
 			unsigned int count;
+			char hdr[80];
 
 			rq = port_unpack(&execlists->port[idx], &count);
-			if (rq) {
-				char hdr[80];
-
+			if (!rq) {
+				drm_printf(m, "\t\tELSP[%d] idle\n", idx);
+			} else if (!i915_request_signaled(rq)) {
 				snprintf(hdr, sizeof(hdr),
 					 "\t\tELSP[%d] count=%d, ring:{start:%08x, hwsp:%08x, seqno:%08x}, rq: ",
 					 idx, count,
@@ -1452,11 +1454,11 @@ static void intel_engine_print_registers(const struct intel_engine_cs *engine,
 					 hwsp_seqno(rq));
 				print_request(m, rq, hdr);
 			} else {
-				drm_printf(m, "\t\tELSP[%d] idle\n", idx);
+				print_request(m, rq, "\t\tELSP[%d] rq: ");
 			}
 		}
 		drm_printf(m, "\t\tHW active? 0x%x\n", execlists->active);
-		rcu_read_unlock();
+		spin_unlock_irqrestore(&engine->timeline.lock, flags);
 	} else if (INTEL_GEN(dev_priv) > 6) {
 		drm_printf(m, "\tPP_DIR_BASE: 0x%08x\n",
 			   ENGINE_READ(engine, RING_PP_DIR_BASE));
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1F2CEF53
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 15:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgLDOEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 09:04:04 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:56592 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729039AbgLDOED (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 09:04:03 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23215310-1500050 
        for multiple; Fri, 04 Dec 2020 14:03:18 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org
Subject: [PATCH 03/24] drm/i915/gt: Cancel the preemption timeout on responding to it
Date:   Fri,  4 Dec 2020 14:02:54 +0000
Message-Id: <20201204140315.24341-3-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201204140315.24341-1-chris@chris-wilson.co.uk>
References: <20201204140315.24341-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We currently presume that the engine reset is successful, cancelling the
expired preemption timer in the process. However, engine resets can
fail, leaving the timeout still pending and we will then respond to the
timeout again next time the tasklet fires. What we want is for the
failed engine reset to be promoted to a full device reset, which is
kicked by the heartbeat once the engine stops processing events.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1168
Fixes: 3a7a92aba8fb ("drm/i915/execlists: Force preemption")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 1d209a8a95e8..7f25894e41d5 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3209,8 +3209,10 @@ static void execlists_submission_tasklet(unsigned long data)
 		spin_unlock_irqrestore(&engine->active.lock, flags);
 
 		/* Recheck after serialising with direct-submission */
-		if (unlikely(timeout && preempt_timeout(engine)))
+		if (unlikely(timeout && preempt_timeout(engine))) {
+			cancel_timer(&engine->execlists.preempt);
 			execlists_reset(engine, "preemption time out");
+		}
 	}
 }
 
-- 
2.20.1


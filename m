Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E14F1BAF76
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 22:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgD0U1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 16:27:54 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:53056 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726205AbgD0U1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 16:27:54 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21040032-1500050 
        for multiple; Mon, 27 Apr 2020 21:26:36 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Francisco Jerez <currojerez@riseup.net>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH] drm/i915/gt: Update PMINTRMSK holding fw
Date:   Mon, 27 Apr 2020 21:26:35 +0100
Message-Id: <20200427202635.527044-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit e1eb075c5051987fbbadbc0fb8211679df657721.

If we use a non-forcewaked write to PMINTRMSK, it does not take effect
until much later, if at all, causing a loss of RPS interrupts and no GPU
reclocking, leaving the GPU running at the wrong frequency for long
periods of time.

Reported-by: Francisco Jerez <currojerez@riseup.net>
Suggested-by: Francisco Jerez <currojerez@riseup.net>
Fixes: 35cc7f32c298 ("drm/i915/gt: Use non-forcewake writes for RPS")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Francisco Jerez <currojerez@riseup.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Reviewed-by: Francisco Jerez <currojerez@riseup.net>
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20200415170318.16771-2-chris@chris-wilson.co.uk
(cherry picked from commit a080bd994c4023042a2b605c65fa10a25933f636)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit e1eb075c5051987fbbadbc0fb8211679df657721)
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index b2d245963d9f..8accea06185b 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -83,7 +83,8 @@ static void rps_enable_interrupts(struct intel_rps *rps)
 	gen6_gt_pm_enable_irq(gt, rps->pm_events);
 	spin_unlock_irq(&gt->irq_lock);
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_mask(rps, rps->cur_freq));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_mask(rps, rps->last_freq));
 }
 
 static void gen6_rps_reset_interrupts(struct intel_rps *rps)
@@ -117,7 +118,8 @@ static void rps_disable_interrupts(struct intel_rps *rps)
 
 	rps->pm_events = 0;
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
 
 	spin_lock_irq(&gt->irq_lock);
 	gen6_gt_pm_disable_irq(gt, GEN6_PM_RPS_EVENTS);
-- 
2.26.2


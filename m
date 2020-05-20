Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E63F1DAD98
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 10:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgETIgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 04:36:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:8735 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETIgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 04:36:08 -0400
IronPort-SDR: 9uT6VN0NrKdxWqm/0h+m4jPfRJOaUQzNz6w3B9FaiN2yJbSI+PAIeQvK/YGXV38vSCVoizrSvZ
 8hmMbppndy2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 01:36:07 -0700
IronPort-SDR: ANcmbTLnrfFdbHZkoFeRrHRBqYuOwhHkIrgXGARHr9vaXG4dvFS5MkHd7XudmYayKFwX8aUuNH
 3QQ2MTBL4x1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="299864437"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2020 01:36:04 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     jon.ewins@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Francisco Jerez <currojerez@riseup.net>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>, stable@vger.kernel.org
Subject: [PATCH 02/54] drm/i915/gt: Update PMINTRMSK holding fw
Date:   Wed, 20 May 2020 14:03:20 +0530
Message-Id: <20200520083412.25470-3-prasad.nallani@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520083412.25470-1-prasad.nallani@intel.com>
References: <20200520083412.25470-1-prasad.nallani@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

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
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index c1a3d360de06..6beaa2b4e8f7 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -85,7 +85,8 @@ static void rps_enable_interrupts(struct intel_rps *rps)
 	gen6_gt_pm_enable_irq(gt, rps->pm_events);
 	spin_unlock_irq(&gt->irq_lock);
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_mask(rps, rps->cur_freq));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_mask(rps, rps->last_freq));
 }
 
 static void gen6_rps_reset_interrupts(struct intel_rps *rps)
@@ -119,7 +120,8 @@ static void rps_disable_interrupts(struct intel_rps *rps)
 
 	rps->pm_events = 0;
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
 
 	spin_lock_irq(&gt->irq_lock);
 	gen6_gt_pm_disable_irq(gt, GEN6_PM_RPS_EVENTS);

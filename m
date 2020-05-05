Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEAE1C53C7
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 12:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgEEK4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 06:56:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:20635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgEEK4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 06:56:07 -0400
IronPort-SDR: RHTDSQ7I/FoAfb+V0Xei8u4JlOX+e6tuN2rOnyly5Kr0BHokOjbIutizt+fH0g0y6CkHQk7vjX
 vLSjNdnJ5p6A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 03:56:05 -0700
IronPort-SDR: dl27Vn5cETOm+BoL2MlEDQ51JdoA44Iyq1m1W5mcKp/A+2Lx2hNvlhqvnEFprj+/vhNXoo87ZB
 W1686/pREE6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="460997403"
Received: from gem-build.fi.intel.com (HELO localhost) ([10.237.72.180])
  by fmsmga005.fm.intel.com with ESMTP; 05 May 2020 03:56:03 -0700
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Francisco Jerez <currojerez@riseup.net>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>, stable@vger.kernel.org
Subject: [PATCH 02/55] drm/i915/gt: Update PMINTRMSK holding fw
Date:   Tue,  5 May 2020 10:55:04 +0000
Message-Id: <20200505105558.127979-3-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505105558.127979-1-chris@chris-wilson.co.uk>
References: <20200505105558.127979-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index d2a3d935d186..3a3f49a71974 100644
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
---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


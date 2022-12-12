Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26DC64A49F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 17:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiLLQOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 11:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiLLQOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 11:14:30 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08C312AC1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 08:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670861668; x=1702397668;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VrzWj9lWfykGiVQkbkT7RF/HzKw+iPf7nBZwnVXRAiw=;
  b=f+D0wYTWZs0HeOhWffJHIS++XE00VVC2EHshpyBqYopqWs440ggvbHLs
   TyhYYqS40SlwYbrg9kNfjHyJuUJfMQoes8GiGB5FzK5QEz5PzzdqiN5xI
   1q8RHGjImxxoKKHCmtpyM51TpEL1+6KcMNkwqFlFNzDMgF2WBB7z610Xd
   kvvCR9r6ETFiV+XndQ0EnfPxYmggxqZfLOjim/DmybQ3AA/k/Ks6SG48J
   ib5EIaXUw3ufC4bPg+ZdrKAknb9W3+H9jMV3sAxalX0XYVsoEFM8njZb4
   9ATkB5kqa+FPeNnCNOswg9q7IeFXoo2Y/V9VgcTX+u2uMgvA8Se4W0uu8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="297572294"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="297572294"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 08:14:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="680728030"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="680728030"
Received: from anicol1x-mobl.ger.corp.intel.com (HELO intel.com) ([10.252.59.70])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 08:14:09 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH] drm/i915/gt: Reset twice
Date:   Mon, 12 Dec 2022 17:13:38 +0100
Message-Id: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

After applying an engine reset, on some platforms like Jasperlake, we
occasionally detect that the engine state is not cleared until shortly
after the resume. As we try to resume the engine with volatile internal
state, the first request fails with a spurious CS event (it looks like
it reports a lite-restore to the hung context, instead of the expected
idle->active context switch).

Signed-off-by: Chris Wilson <hris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
---
 drivers/gpu/drm/i915/gt/intel_reset.c | 34 ++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index ffde89c5835a4..88dfc0c5316ff 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt, intel_engine_mask_t engine_mask,
 static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 {
 	struct intel_uncore *uncore = gt->uncore;
+	int loops = 2;
 	int err;
 
 	/*
@@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 	 * for fifo space for the write or forcewake the chip for
 	 * the read
 	 */
-	intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
+	do {
+		intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
 
-	/* Wait for the device to ack the reset requests */
-	err = __intel_wait_for_register_fw(uncore,
-					   GEN6_GDRST, hw_domain_mask, 0,
-					   500, 0,
-					   NULL);
+		/*
+		 * Wait for the device to ack the reset requests.
+		 *
+		 * On some platforms, e.g. Jasperlake, we see see that the
+		 * engine register state is not cleared until shortly after
+		 * GDRST reports completion, causing a failure as we try
+		 * to immediately resume while the internal state is still
+		 * in flux. If we immediately repeat the reset, the second
+		 * reset appears to serialise with the first, and since
+		 * it is a no-op, the registers should retain their reset
+		 * value. However, there is still a concern that upon
+		 * leaving the second reset, the internal engine state
+		 * is still in flux and not ready for resuming.
+		 */
+		err = __intel_wait_for_register_fw(uncore, GEN6_GDRST,
+						   hw_domain_mask, 0,
+						   2000, 0,
+						   NULL);
+	} while (err == 0 && --loops);
 	if (err)
 		GT_TRACE(gt,
 			 "Wait for 0x%08x engines reset failed\n",
 			 hw_domain_mask);
 
+	/*
+	 * As we have observed that the engine state is still volatile
+	 * after GDRST is acked, impose a small delay to let everything settle.
+	 */
+	udelay(50);
+
 	return err;
 }
 
-- 
2.38.1


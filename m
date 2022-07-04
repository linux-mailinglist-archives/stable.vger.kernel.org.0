Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5197056599E
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 17:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiGDPUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 11:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGDPUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 11:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7560C5F4C;
        Mon,  4 Jul 2022 08:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE2C6172F;
        Mon,  4 Jul 2022 15:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62598C341CE;
        Mon,  4 Jul 2022 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656948008;
        bh=06YFOWy5ci6Ny48R6RNGVBykXsXj0MvRxiXVVF8DTPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwGYVJhlAmZYDpy38yA6SzXey0ODv2ll15HQX6jQk6W+1C37witucXSPi8V3GqxSs
         VnXqtS6q29ezCZi2jwrEQR9yOkmegoZQJEdpZIW9f77x+Yj+8j3Sr568k3oeEsrJYr
         uXvBBenHiLgazJQQizCGdqewnvWgqaUEUoS4Jt3/QK8nQWDo/mGX7ovWtUQXgmMms1
         RRu3bsk2SmJeqZFN4aACI5o31zLZ5FFU7SpGSc42n2KB+sHftz5aaqV2eVdoEgcpPM
         Kowc4BLf924CJWCboXyA5rxKts/O0+n7Nl27xHGUTAaYmFihf+4+3xbcK+PJZpORl1
         IVbrNjMccg9ig==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o8Nrp-009fKZ-66;
        Mon, 04 Jul 2022 16:20:05 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andi Shyti <andi.shyti@intel.com>
Subject: [PATCH v3 2/2] drm/i915/gt: Serialize TLB invalidates with GT resets
Date:   Mon,  4 Jul 2022 16:20:04 +0100
Message-Id: <3ecc1f94290a66b2e682f956b5232b4903c32a2c.1656921701.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656921701.git.mchehab@kernel.org>
References: <cover.1656921701.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

Avoid trying to invalidate the TLB in the middle of performing an
engine reset, as this may result in the reset timing out. Currently,
the TLB invalidate is only serialised by its own mutex, forgoing the
uncore lock, but we can take the uncore->lock as well to serialise
the mmio access, thereby serialising with the GDRST.

Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
i915 selftest/hangcheck.

Cc: stable@vger.kernel.org # Up to 4.4
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v3 0/2] at: https://lore.kernel.org/all/cover.1656921701.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/gt/intel_gt.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 8da3314bb6bf..68c2b0d8f187 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -952,6 +952,20 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	mutex_lock(&gt->tlb_invalidate_lock);
 	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
 
+	spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
+
+	for_each_engine(engine, gt, id) {
+		struct reg_and_bit rb;
+
+		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
+		if (!i915_mmio_reg_offset(rb.reg))
+			continue;
+
+		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
+	}
+
+	spin_unlock_irq(&uncore->lock);
+
 	for_each_engine(engine, gt, id) {
 		/*
 		 * HW architecture suggest typical invalidation time at 40us,
@@ -966,7 +980,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
-		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 		if (__intel_wait_for_register_fw(uncore,
 						 rb.reg, rb.bit, 0,
 						 timeout_us, timeout_ms,
-- 
2.36.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C59591A49
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiHMMs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiHMMs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:48:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35BC13F4B
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DFFB8013C
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EDAC433D6;
        Sat, 13 Aug 2022 12:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660394933;
        bh=aPgw+Xh9nw+yLkArcI60LyPf2mEsJJiGz+ITYOAUsb0=;
        h=Subject:To:Cc:From:Date:From;
        b=kuqrXbwRC5nnaFk6K8VnNHzpRrMG1RS7OZ9TqHfjUsaHNqcFfgcmltZb0OXPkrblf
         hzMJ7M8K3c666inULEowMTInh3aO+UGVHD1IlB3fjLqmkE4RN8fFx7ZnwARdajlddP
         ENZ6guoQlZpJEbBgBB66QmSVIkca2eEGZ4LtbCiI=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Serialize TLB invalidates with GT resets" failed to apply to 4.14-stable tree
To:     chris.p.wilson@intel.com, andi.shyti@linux.intel.com,
        mchehab@kernel.org, rodrigo.vivi@intel.com,
        thomas.hellstrom@linux.intel.com, tvrtko.ursulin@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:48:39 +0200
Message-ID: <16603949193516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 33da97894758737895e90c909f16786052680ef4 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris.p.wilson@intel.com>
Date: Tue, 12 Jul 2022 16:21:33 +0100
Subject: [PATCH] drm/i915/gt: Serialize TLB invalidates with GT resets
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Avoid trying to invalidate the TLB in the middle of performing an
engine reset, as this may result in the reset timing out. Currently,
the TLB invalidate is only serialised by its own mutex, forgoing the
uncore lock, but we can take the uncore->lock as well to serialise
the mmio access, thereby serialising with the GDRST.

Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
i915 selftest/hangcheck.

Cc: stable@vger.kernel.org  # v4.4 and upper
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1e59a7c45dd919a530256b9ac721ac6ea86c0677.1657639152.git.mchehab@kernel.org

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


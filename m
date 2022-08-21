Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDB959B43F
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiHUOGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 10:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiHUOGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 10:06:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0B6FD23
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 07:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D357B80D5B
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 14:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3577BC433C1;
        Sun, 21 Aug 2022 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661090756;
        bh=dWpPYhkEx4UVFLnoqfpyAMt+N63NvJwZcb4JGMQkhrc=;
        h=Subject:To:Cc:From:Date:From;
        b=mHp7rfCEXi/rWXacGKP7v9dvCic8CJ7Q4uWcj+Xe8cAgNNJulAxG3aiYQ3GGRk/Hc
         hXvUyD6nYM11I9bHP88muY64UGXznViRQxdbsNA4V64//iRxDa4RAFRD0OvA0OiVjE
         o1KBqGMqZs6OYA89rYCYRlwtTLGqllY7zDIOMbb0=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Invalidate TLB of the OA unit at TLB" failed to apply to 5.4-stable tree
To:     chris.p.wilson@intel.com, andi.shyti@linux.intel.com,
        fei.yang@intel.com, mchehab@kernel.org, rodrigo.vivi@intel.com,
        thomas.hellstrom@linux.intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 16:05:53 +0200
Message-ID: <16610907533668@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 180abeb2c5032704787151135b6a38c6b71295a6 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris.p.wilson@intel.com>
Date: Wed, 27 Jul 2022 14:29:53 +0200
Subject: [PATCH] drm/i915/gt: Invalidate TLB of the OA unit at TLB
 invalidations
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ensure that the TLB of the OA unit is also invalidated
on gen12 HW, as just invalidating the TLB of an engine is not
enough.

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/59724d9f5cf1e93b1620d01b8332ac991555283d.1658924372.git.mchehab@kernel.org
(cherry picked from commit dfc83de118ff7930acc9a4c8dfdba7c153aa44d6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index c4d43da84d8e..1d84418e8676 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -11,6 +11,7 @@
 #include "pxp/intel_pxp.h"
 
 #include "i915_drv.h"
+#include "i915_perf_oa_regs.h"
 #include "intel_context.h"
 #include "intel_engine_pm.h"
 #include "intel_engine_regs.h"
@@ -969,6 +970,15 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		awake |= engine->mask;
 	}
 
+	/* Wa_2207587034:tgl,dg1,rkl,adl-s,adl-p */
+	if (awake &&
+	    (IS_TIGERLAKE(i915) ||
+	     IS_DG1(i915) ||
+	     IS_ROCKETLAKE(i915) ||
+	     IS_ALDERLAKE_S(i915) ||
+	     IS_ALDERLAKE_P(i915)))
+		intel_uncore_write_fw(uncore, GEN12_OA_TLB_INV_CR, 1);
+
 	spin_unlock_irq(&uncore->lock);
 
 	for_each_engine_masked(engine, gt, awake, tmp) {


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8643659B457
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 16:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiHUOI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 10:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiHUOI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 10:08:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DD319035
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 07:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A237B80D80
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 14:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDFBC433C1;
        Sun, 21 Aug 2022 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661090934;
        bh=hbVzrZzzimII7e96HG4Wad4UuI6DYSpvmHFthYj5rnI=;
        h=Subject:To:Cc:From:Date:From;
        b=dhMJ0iBaFen92rLrQ2ZvKfjt9puJGXTndyuiERyoh/ExxuTAyqwOVOLbpfoju15tO
         uj2iQriDWYUhW1lPKED9tEFR240NLtrNBregePoVIjMnG1BDUzV8bHkszI5GuXopSL
         grw1qRfZlp6dbSHxuaQk+tw6guF/3dopOHtyXrXU=
Subject: FAILED: patch "[PATCH] drm/i915/gt: Skip TLB invalidations once wedged" failed to apply to 5.15-stable tree
To:     chris.p.wilson@intel.com, andi.shyti@linux.intel.com,
        fei.yang@intel.com, mchehab@kernel.org, rodrigo.vivi@intel.com,
        thomas.hellstrom@linux.intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 21 Aug 2022 16:08:51 +0200
Message-ID: <166109093196249@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e5a95c83ed1492c0f442b448b20c90c8faaf702b Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris.p.wilson@intel.com>
Date: Wed, 27 Jul 2022 14:29:54 +0200
Subject: [PATCH] drm/i915/gt: Skip TLB invalidations once wedged
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Skip all further TLB invalidations once the device is wedged and
had been reset, as, on such cases, it can no longer process instructions
on the GPU and the user no longer has access to the TLB's in each engine.

So, an attempt to do a TLB cache invalidation will produce a timeout.

That helps to reduce the performance regression introduced by TLB
invalidate logic.

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/5aa86564b9ec5fe7fe605c1dd7de76855401ed73.1658924372.git.mchehab@kernel.org
(cherry picked from commit be0366f168033374a93e4c43fdaa1a90ab905184)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 1d84418e8676..5c55a90672f4 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -934,6 +934,9 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
 		return;
 
+	if (intel_gt_is_wedged(gt))
+		return;
+
 	if (GRAPHICS_VER(i915) == 12) {
 		regs = gen12_regs;
 		num = ARRAY_SIZE(gen12_regs);


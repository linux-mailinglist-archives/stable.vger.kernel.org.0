Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1400579E18
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiGSM5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242403AbiGSM5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:57:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF059B192;
        Tue, 19 Jul 2022 05:23:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D59E61913;
        Tue, 19 Jul 2022 12:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA87FC341C6;
        Tue, 19 Jul 2022 12:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233379;
        bh=5eseb3gcyY9nM+ZlZrhdlo7NLp4RLmzgYXbJ80QXtiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jntI1R1qt/T6qQkev3XHtAqErhiPWQilDQBolFglQE7/NdI1sGRZ2ulDbZvSibZHl
         xLxF0hjTiibXgsQdm1AHhOt3XM/B0mq02A7BHw+Uiqw/AoqcjrYT9ss5WGDnM+hQMG
         AQueMA1UEC1BCowpbtQLxt0lC551zBX2xFxzdQwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 103/231] drm/i915/gt: Serialize TLB invalidates with GT resets
Date:   Tue, 19 Jul 2022 13:53:08 +0200
Message-Id: <20220719114723.312935813@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

[ Upstream commit a1c5a7bf79c1faa5633b918b5c0666545e84c4d1 ]

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
(cherry picked from commit 33da97894758737895e90c909f16786052680ef4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 8a2483ccbfb9..f4375479e6f0 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -1012,6 +1012,20 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
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
@@ -1026,7 +1040,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
-		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 		if (__intel_wait_for_register_fw(uncore,
 						 rb.reg, rb.bit, 0,
 						 timeout_us, timeout_ms,
-- 
2.35.1




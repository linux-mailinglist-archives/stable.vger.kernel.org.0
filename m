Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18914579E19
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242397AbiGSM5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242266AbiGSM5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:57:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8555C9C5;
        Tue, 19 Jul 2022 05:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE838B81B08;
        Tue, 19 Jul 2022 12:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA41C341C6;
        Tue, 19 Jul 2022 12:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233376;
        bh=XXbXHJXvxJrzUxIUhJtRBBaqXbxp1MJ2QMAF03qMuX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cx7bxvUd7gTSMaOLE6ReoVGU2qTp7YzLAml313gynz6v/FnKL00C8w6mK7fwQmj8d
         m/TBOLBJm7WLGAPJf8OmK6UPAhfF+tf+dSFAYuYiACT4Ryb9dyO7Z/jcE3/RdXYOGk
         Wcxj0F2JoVpDVnu33XnG5PTQLD6WV656oLjXzH7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 102/231] drm/i915/gt: Serialize GRDOM access between multiple engine resets
Date:   Tue, 19 Jul 2022 13:53:07 +0200
Message-Id: <20220719114723.242242143@linuxfoundation.org>
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

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit b24dcf1dc507f69ed3b5c66c2b6a0209ae80d4d4 ]

Don't allow two engines to be reset in parallel, as they would both
try to select a reset bit (and send requests to common registers)
and wait on that register, at the same time. Serialize control of
the reset requests/acks using the uncore->lock, which will also ensure
that no other GT state changes at the same time as the actual reset.

Cc: stable@vger.kernel.org # v4.4 and upper
Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/e0a2d894e77aed7c2e36b0d1abdc7dbac3011729.1657639152.git.mchehab@kernel.org
(cherry picked from commit 336561a914fc0c6f1218228718f633b31b7af1c3)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_reset.c | 37 ++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index b7c6d4462ec5..d57db66ac7ea 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -299,9 +299,9 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 	return err;
 }
 
-static int gen6_reset_engines(struct intel_gt *gt,
-			      intel_engine_mask_t engine_mask,
-			      unsigned int retry)
+static int __gen6_reset_engines(struct intel_gt *gt,
+				intel_engine_mask_t engine_mask,
+				unsigned int retry)
 {
 	struct intel_engine_cs *engine;
 	u32 hw_mask;
@@ -320,6 +320,20 @@ static int gen6_reset_engines(struct intel_gt *gt,
 	return gen6_hw_domain_reset(gt, hw_mask);
 }
 
+static int gen6_reset_engines(struct intel_gt *gt,
+			      intel_engine_mask_t engine_mask,
+			      unsigned int retry)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&gt->uncore->lock, flags);
+	ret = __gen6_reset_engines(gt, engine_mask, retry);
+	spin_unlock_irqrestore(&gt->uncore->lock, flags);
+
+	return ret;
+}
+
 static struct intel_engine_cs *find_sfc_paired_vecs_engine(struct intel_engine_cs *engine)
 {
 	int vecs_id;
@@ -486,9 +500,9 @@ static void gen11_unlock_sfc(struct intel_engine_cs *engine)
 	rmw_clear_fw(uncore, sfc_lock.lock_reg, sfc_lock.lock_bit);
 }
 
-static int gen11_reset_engines(struct intel_gt *gt,
-			       intel_engine_mask_t engine_mask,
-			       unsigned int retry)
+static int __gen11_reset_engines(struct intel_gt *gt,
+				 intel_engine_mask_t engine_mask,
+				 unsigned int retry)
 {
 	struct intel_engine_cs *engine;
 	intel_engine_mask_t tmp;
@@ -582,8 +596,11 @@ static int gen8_reset_engines(struct intel_gt *gt,
 	struct intel_engine_cs *engine;
 	const bool reset_non_ready = retry >= 1;
 	intel_engine_mask_t tmp;
+	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&gt->uncore->lock, flags);
+
 	for_each_engine_masked(engine, gt, engine_mask, tmp) {
 		ret = gen8_engine_reset_prepare(engine);
 		if (ret && !reset_non_ready)
@@ -611,17 +628,19 @@ static int gen8_reset_engines(struct intel_gt *gt,
 	 * This is best effort, so ignore any error from the initial reset.
 	 */
 	if (IS_DG2(gt->i915) && engine_mask == ALL_ENGINES)
-		gen11_reset_engines(gt, gt->info.engine_mask, 0);
+		__gen11_reset_engines(gt, gt->info.engine_mask, 0);
 
 	if (GRAPHICS_VER(gt->i915) >= 11)
-		ret = gen11_reset_engines(gt, engine_mask, retry);
+		ret = __gen11_reset_engines(gt, engine_mask, retry);
 	else
-		ret = gen6_reset_engines(gt, engine_mask, retry);
+		ret = __gen6_reset_engines(gt, engine_mask, retry);
 
 skip_reset:
 	for_each_engine_masked(engine, gt, engine_mask, tmp)
 		gen8_engine_reset_cancel(engine);
 
+	spin_unlock_irqrestore(&gt->uncore->lock, flags);
+
 	return ret;
 }
 
-- 
2.35.1




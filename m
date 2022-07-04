Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5FA564F5D
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 10:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiGDIJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 04:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiGDIJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 04:09:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0CA65F2;
        Mon,  4 Jul 2022 01:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B61B6611A0;
        Mon,  4 Jul 2022 08:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0664CC341CD;
        Mon,  4 Jul 2022 08:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656922176;
        bh=06YFOWy5ci6Ny48R6RNGVBykXsXj0MvRxiXVVF8DTPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy0qAlNtXVAGX0wBXJFMGzhJ8+MCbNo8U9DyoSrbGtZjpLs9Dw6b1RBFC4eRmv4Cl
         OmjeY2/sehbLyXjOyUFe0K16h/2Gc6qJebr1WyMIWl7yMTMW41GEJOjocyowsnW6to
         M+de7o4z1OrhVYyeLHb118weP6oGa9RyyzjDqKoWno5Va6VX3xgPOaAUlvvyPcxCMk
         JnFi2XSZ8BBEb/GsfwLf3GFnft6gYCZgY8Cyk2Tl1jGWudN7pR9nbQ1krZ4LNDQouu
         N2yxaOgKmxMFB7E/TYalKSWQfrn6AsEWtApNwqN1svpG/nFMLW9BZsazsRcu7wHW5m
         FkEnFjpYeC0wg==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o8H9A-009Oab-Si;
        Mon, 04 Jul 2022 09:09:32 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
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
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>
Subject: [PATCH v3 2/2] drm/i915/gt: Serialize TLB invalidates with GT resets
Date:   Mon,  4 Jul 2022 09:09:29 +0100
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


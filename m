Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3B574CD8
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 14:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbiGNMGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 08:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbiGNMGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 08:06:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C89E5C9CD;
        Thu, 14 Jul 2022 05:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9757B82489;
        Thu, 14 Jul 2022 12:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67863C34114;
        Thu, 14 Jul 2022 12:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657800390;
        bh=tKvr8A/PV/OYhxebT/0A/UtjGajc65mqiZg4KsRuS+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGW2B3eLsHznG0BW4nIk8kc49YNbanrSpYcseMn1UUODA3hkDfj5z2BFVqOpZTXiN
         WuswAMJ5oDm/CxQFrZeNa35psXxGX9XcySNBvo3PaiaeXn30UU3G1A9uw3dGmx6+kb
         akNMDeAj83TV8d7oEc9EUUeSYXo0s+q5sd9ozNVkZt5TghiZqsgfVX+uWXjUum9YPM
         r75BWae0RWT2tiTRXwWnp09gIMOCpjCpL4ppPOFsTiNhb+fjbU/QR92/suyImCpbbw
         n30/mIrTx8A+F/BCl+tBdV4mgrMCTLhdr1ZSaYP7pvEjj25Ln+opHqa+E6pPS3gEtP
         3lZlWG7fnWTrQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1oBxbv-0059sb-Qn;
        Thu, 14 Jul 2022 13:06:27 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: [PATCH v2 03/21] drm/i915/gt: Invalidate TLB of the OA unit at TLB invalidations
Date:   Thu, 14 Jul 2022 13:06:08 +0100
Message-Id: <44ec6a01ef2e82184abbb075b9c8a09297fa120c.1657800199.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657800199.git.mchehab@kernel.org>
References: <cover.1657800199.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Ensure that the TLB of the OA unit is also invalidated
on gen12 HW, as just invalidating the TLB of an engine is not
enough.

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v2 00/21] at: https://lore.kernel.org/all/cover.1657800199.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/gt/intel_gt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

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
-- 
2.36.1


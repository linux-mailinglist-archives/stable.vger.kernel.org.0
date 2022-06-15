Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455C554CCE4
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243162AbiFOP3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 11:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355309AbiFOP2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 11:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238874F1F3;
        Wed, 15 Jun 2022 08:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB29B61720;
        Wed, 15 Jun 2022 15:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049ADC341C0;
        Wed, 15 Jun 2022 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655306866;
        bh=8ReZPcBGEj7z1AKZG+D3Lo4912WJuXG6ESeM/dKTzl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaIVU0Tss08B9KniFRBUMT/rBzskVD1GrxtrCV+Mt0QMmLPB8FiAva4kFBjBzAtdL
         LPvF1LiI/+W7CGgihPWqX+zSwgiacXT6sqK8UoZqNPfhGb4/lXgzgqLVAY5NXavsrB
         b0Uppr8tCzYTyyms5Zqs7z+i0yOJy1wnCmJEriZJfhQF1C2ynOXI52UeOgF4vvdlxv
         Zj5bI59MvUSn4JYMcTAwDqnS1TCZNKSCZz5LO75zRUQ0nX9/E00WmS6enpGeSRNHY3
         2Hq0VGGSS2WESzax7kt87Mb+5BnCos1jPnTF5vdjTglFNPpNfpdHtDge0SUJIoLTSA
         9MATc4KNiJxWA==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o1Uvm-00A4Jg-Df;
        Wed, 15 Jun 2022 16:27:42 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        "Fei Yang" <fei.yang@intel.com>,
        =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        "Thomas Hellstrom" <thomas.hellstrom@intel.com>,
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
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/6] drm/i915/gt: Invalidate TLB of the OA unit at TLB invalidations
Date:   Wed, 15 Jun 2022 16:27:36 +0100
Message-Id: <653bf9815d562f02c7247c6b66b85b243f3172e7.1655306128.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655306128.git.mchehab@kernel.org>
References: <cover.1655306128.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On gen12 HW, ensure that the TLB of the OA unit is also invalidated
as just invalidating the TLB of an engine is not enough.

Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")

Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

See [PATCH 0/6] at: https://lore.kernel.org/all/cover.1655306128.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/gt/intel_gt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index d5ed6a6ac67c..61b7ec5118f9 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -10,6 +10,7 @@
 #include "pxp/intel_pxp.h"
 
 #include "i915_drv.h"
+#include "i915_perf_oa_regs.h"
 #include "intel_context.h"
 #include "intel_engine_pm.h"
 #include "intel_engine_regs.h"
@@ -1259,6 +1260,15 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
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
 	for_each_engine_masked(engine, gt, awake, tmp) {
 		struct reg_and_bit rb;
 
-- 
2.36.1


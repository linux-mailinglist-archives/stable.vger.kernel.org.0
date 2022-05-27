Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93DF535CE7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbiE0JC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350381AbiE0JCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:02:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56A011905A;
        Fri, 27 May 2022 01:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FDE9B82371;
        Fri, 27 May 2022 08:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323BAC385A9;
        Fri, 27 May 2022 08:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653641921;
        bh=zMEPRIvOxtolvSGdfKNn72JhOSa8qO+tUa865Q5G3/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=rdMZQoOjHQst6A7c3TSCYMcgxXrNlvMsRL5cC3Va6gX1ySpnr3rFzdHu9491KTshy
         vBMX5vShoMgR/qyXD6nWh3iF/PI0jttJFAkEs/jEqlCCekkFGwHMDIMdCcKcxLIGRN
         7OafZKxEHOD5VK3Zck6qmduMjDfoQMmysKxy9gz8j3kM9kRGiDyrfxbDFADjTSb7gu
         PO3Z7/OqvfiYYOk7lMwASYO3yF2c4BfVNtuGenzEfm5mZE4/Bx4lmPAXJ/BIdsjln8
         DoUl4CNCnPJYhWVGckVHOet2PHH2oaxa4b8ZTrxJ8LbVUU7o6QH1h/4O23Ez85BFap
         z8H7f9IT4C2YA==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1nuVnn-008Jvo-P8;
        Fri, 27 May 2022 10:58:35 +0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
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
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] drm/i915: don't flush TLB on GEN8
Date:   Fri, 27 May 2022 10:58:34 +0200
Message-Id: <8c1571f1a642c5c462da9f662aaab271756ca735.1653641899.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

i915 selftest hangcheck is causing the i915 driver timeouts, as
reported by Intel CI:

	http://gfx-ci.fi.intel.com/cibuglog-ng/issuefilterassoc/24297?query_key=42a999f48fa6ecce068bc8126c069be7c31153b4

When such test runs, the only output is:

	[   68.811639] i915: Performing live selftests with st_random_seed=0xe138eac7 st_timeout=500
	[   68.811792] i915: Running hangcheck
	[   68.811859] i915: Running intel_hangcheck_live_selftests/igt_hang_sanitycheck
	[   68.816910] i915 0000:00:02.0: [drm] Cannot find any crtc or sizes
	[   68.841597] i915: Running intel_hangcheck_live_selftests/igt_reset_nop
	[   69.346347] igt_reset_nop: 80 resets
	[   69.362695] i915: Running intel_hangcheck_live_selftests/igt_reset_nop_engine
	[   69.863559] igt_reset_nop_engine(rcs0): 709 resets
	[   70.364924] igt_reset_nop_engine(bcs0): 903 resets
	[   70.866005] igt_reset_nop_engine(vcs0): 659 resets
	[   71.367934] igt_reset_nop_engine(vcs1): 549 resets
	[   71.869259] igt_reset_nop_engine(vecs0): 553 resets
	[   71.882592] i915: Running intel_hangcheck_live_selftests/igt_reset_idle_engine
	[   72.383554] rcs0: Completed 16605 idle resets
	[   72.884599] bcs0: Completed 18641 idle resets
	[   73.385592] vcs0: Completed 17517 idle resets
	[   73.886658] vcs1: Completed 15474 idle resets
	[   74.387600] vecs0: Completed 17983 idle resets
	[   74.387667] i915: Running intel_hangcheck_live_selftests/igt_reset_active_engine
	[   74.889017] rcs0: Completed 747 active resets
	[   75.174240] intel_engine_reset(bcs0) failed, err:-110
	[   75.174301] bcs0: Completed 525 active resets

After that, the machine just silently hangs.

The root cause is that the flush TLB logic is not working as
expected on GEN8.

Tested on an Intel NUC5i7RYB with an i7-5557U Broadwell CPU.

This patch partially reverts the logic by skipping GEN8 from
the TLB cache flush.

Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org # Kernel 5.17 and upper

Fixes: 494c2c9b630e ("drm/i915: Flush TLBs before releasing backing store")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 034182f85501..7965a77e5046 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -1191,10 +1191,10 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	if (GRAPHICS_VER(i915) == 12) {
 		regs = gen12_regs;
 		num = ARRAY_SIZE(gen12_regs);
-	} else if (GRAPHICS_VER(i915) >= 8 && GRAPHICS_VER(i915) <= 11) {
+	} else if (GRAPHICS_VER(i915) > 8 && GRAPHICS_VER(i915) <= 11) {
 		regs = gen8_regs;
 		num = ARRAY_SIZE(gen8_regs);
-	} else if (GRAPHICS_VER(i915) < 8) {
+	} else if (GRAPHICS_VER(i915) <= 8) {
 		return;
 	}
 
-- 
2.36.1


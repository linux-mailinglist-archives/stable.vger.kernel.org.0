Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A95254CCE5
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347617AbiFOP3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 11:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355472AbiFOP2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 11:28:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE94427F1;
        Wed, 15 Jun 2022 08:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55EF2B81F0B;
        Wed, 15 Jun 2022 15:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDEDC34115;
        Wed, 15 Jun 2022 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655306866;
        bh=d5dFQ9NHsAkSm+gLQzVN8kPNqSNsxZsVoyo0jFhjNL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXQf8xhEcd/2SP9lwnz0ukumi2OpBNyaaWzqoWEweJNDGmokgwGwt3y1sppwNHyQ7
         Rzxzuq4qly/kJRh9TpXSJs/vZ4SSwYySPo6oCtR3lSb9i2ZGukCYt4ukqKgYmFIxCi
         4RYwiBl2BDFOyJEqVGqfPdTjg/wDJ2XcvxfPYlQ/2GwAx3ebFWcSy330pPk76hRvDv
         m1eLCgWxxKsmve7jSKKvt972JvLb/DQ1dXV3QlwxS2UNwbNxjFozXlJyyu8o8WPTFV
         KO/BfNu64ZOcJb9+Gdm3qMvPUeiwovYMC/uqNJ7oIVn1Y+/K4J48asEamxxyleAP/i
         6fvv0mYBklH9w==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o1Uvm-00A4Jj-EX;
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
Subject: [PATCH 3/6] drm/i915/gt: Skip TLB invalidations once wedged
Date:   Wed, 15 Jun 2022 16:27:37 +0100
Message-Id: <9d9e663ca8e97becf04e1d4c8cb8a9a1f397a5f1.1655306128.git.mchehab@kernel.org>
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

Skip all further TLB invalidations once the device is wedged and
had been reset, as, on such cases, it can no longer process instructions
on the GPU and the user no longer has access to the TLB's in each engine.

Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")

Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

See [PATCH 0/6] at: https://lore.kernel.org/all/cover.1655306128.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/gt/intel_gt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 61b7ec5118f9..fb4fd5273ca4 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -1226,6 +1226,9 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
 		return;
 
+	if (intel_gt_is_wedged(gt))
+		return;
+
 	if (GRAPHICS_VER(i915) == 12) {
 		regs = gen12_regs;
 		num = ARRAY_SIZE(gen12_regs);
-- 
2.36.1


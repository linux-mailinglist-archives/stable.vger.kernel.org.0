Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3C556047B
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbiF2PZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 11:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiF2PZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 11:25:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC732F3A4;
        Wed, 29 Jun 2022 08:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C044DB8253F;
        Wed, 29 Jun 2022 15:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F761C34114;
        Wed, 29 Jun 2022 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656516330;
        bh=WfCqVL/HkSy9hkFb7D4vO+nAC41+jUaURlFZDbgG3v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRx39RV40TrGV8qKo3powlOOuJ+tBL7T9QXd+/oSz3zRcIFKlEshJoKdCH4iOYjv1
         0iTPGzr+8Absf0vnUJCvFw8jTiCy3t2Z6490sH6TOO8Jw48hv6p+9nJOpailhc4EjM
         YixY6a7BVJO5imxUkRYh5MHuv1mictKpOYg8OFMxNf5SpeX/smRY0X7Vh5lF18pM8h
         OUASz1u7dWfJ2OvuRKS80bNkX/+HtGEodiw5gk+cxXCXG4+4FimqlraqpPaoHtcPSz
         /HCuNIZ5KYFYCKo7wCDK4Qi7YgZaKujpcK3Jnt0mxRsinZi5h2WBxq8ZldFQ2swy9P
         BbkmMNBJS+zag==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o6ZZH-005hFO-PX;
        Wed, 29 Jun 2022 16:25:27 +0100
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
Subject: [PATCH v2 3/3] drm/i915/gt: Serialize TLB invalidates with GT resets
Date:   Wed, 29 Jun 2022 16:25:26 +0100
Message-Id: <de312b133227e0a6ad41f465b3a51573cc054b88.1656516220.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656516220.git.mchehab@kernel.org>
References: <cover.1656516220.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

See [PATCH v2 0/3] at: https://lore.kernel.org/all/cover.1656516220.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/gt/intel_gt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 30c60cd960e8..7e57a90b4095 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -952,6 +952,8 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	mutex_lock(&gt->tlb_invalidate_lock);
 	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
 
+	spin_lock_irq(&uncore->lock); /* seralise invalidate with GT reset */
+
 	awake = 0;
 	for_each_engine(engine, gt, id) {
 		struct reg_and_bit rb;
@@ -967,6 +969,8 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		awake |= engine->mask;
 	}
 
+	spin_unlock_irq(&uncore->lock);
+
 	for_each_engine_masked(engine, gt, awake, tmp) {
 		struct reg_and_bit rb;
 
-- 
2.36.1


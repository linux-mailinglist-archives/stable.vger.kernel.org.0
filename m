Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE02854CCE1
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 17:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiFOP3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 11:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355496AbiFOP2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 11:28:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01A342A06;
        Wed, 15 Jun 2022 08:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6061BB81F0E;
        Wed, 15 Jun 2022 15:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02093C385A5;
        Wed, 15 Jun 2022 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655306866;
        bh=7pc/xKe4ZdwnskrQCRUD+TTNRE6A+ErRUxrsSCmYE1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qaq1+tBx1+bt4SshGdEjpnAntGkki8cqcHlFENHDJujz41uB5g3hWZyTnPexsguLs
         IH68RjS9AS+BlNt1b5VYGzSm7Q4RPHbtjNFW2heHi2/37cayJje7Vrmd8/Zhr1fxGZ
         XOvEXtxq81DyZaok2AIhQUEXMGlUv0DJ6t3oYpM6Psf/PocxKX47EctWpGmx4xEFnb
         Oy6nHDBgLSzWgDNbHOMsIIlK3ho5hrnNtl/Yaz3TwniC4u4VIA7qBxqDZ/YM4gGRYS
         6btexI/QV2/Knts39rsqhcwp4L4SI1D8XFHaEVlk2foWx+I8XlNcYIxp3STyq98n95
         Hv5kWhYH6N68w==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o1Uvm-00A4Js-Gn;
        Wed, 15 Jun 2022 16:27:42 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        "Fei Yang" <fei.yang@intel.com>,
        =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        "Thomas Hellstrom" <thomas.hellstrom@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 6/6] drm/i915/gt: Serialize TLB invalidates with GT resets
Date:   Wed, 15 Jun 2022 16:27:40 +0100
Message-Id: <cd5696e3800fd29114ddf0cebc950b57a17bc1b8.1655306128.git.mchehab@kernel.org>
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

Avoid trying to invalidate the TLB in the middle of performing an
engine reset, as this may result in the reset timing out. Currently,
the TLB invalidate is only serialised by its own mutex, forgoing the
uncore lock, but we can take the uncore->lock as well to serialise
the mmio access, thereby serialising with the GDRST.

Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
i915 selftest/hangcheck.

Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")

Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: stable@vger.kernel.org
Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

See [PATCH 0/6] at: https://lore.kernel.org/all/cover.1655306128.git.mchehab@kernel.org/

 drivers/gpu/drm/i915/gt/intel_gt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index fb4fd5273ca4..33eb93586858 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -1248,6 +1248,8 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	mutex_lock(&gt->tlb_invalidate_lock);
 	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
 
+	spin_lock_irq(&uncore->lock); /* seralise invalidate with GT reset */
+
 	awake = 0;
 	for_each_engine(engine, gt, id) {
 		struct reg_and_bit rb;
@@ -1272,6 +1274,8 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	     IS_ALDERLAKE_P(i915)))
 		intel_uncore_write_fw(uncore, GEN12_OA_TLB_INV_CR, 1);
 
+	spin_unlock_irq(&uncore->lock);
+
 	for_each_engine_masked(engine, gt, awake, tmp) {
 		struct reg_and_bit rb;
 
-- 
2.36.1


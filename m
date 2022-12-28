Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612C2657C26
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiL1P32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiL1P30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:29:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AA115722
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EC36B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68C4C433D2;
        Wed, 28 Dec 2022 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241363;
        bh=LbPBkLsQ7kmazh9kDWXgxYRjhKF5eyLSrujJg/KWihc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrWzzCUIi+oJGPmr3fvXol5I0VQi1H8Ak3wDpDUFjFCk89s4qtDJTEGVQj/6Fl1it
         ZN9EXtFjozrRvtLHjDXoElV3lkbdwxtlDFOB69LVhOwY2IZW7jefR2zf7lOyEfPVtS
         Emu/gAm0qlLoz/92/ZN6XFrrBMza3vdLYwOM240Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Aravind Iddamsetty <aravind.iddamsetty@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0237/1146] drm/i915: Fix compute pre-emption w/a to apply to compute engines
Date:   Wed, 28 Dec 2022 15:29:36 +0100
Message-Id: <20221228144336.575818881@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit c3bd49cd9a1043b963331e7fd874b380bed3f2bd ]

An earlier patch added support for compute engines. However, it missed
enabling the anti-pre-emption w/a for the new engine class. So move
the 'compute capable' flag earlier and use it for the pre-emption w/a
test.

Fixes: c674c5b9342e ("drm/i915/xehp: CCS should use RCS setup functions")
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: "Michał Winiarski" <michal.winiarski@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006213813.1563435-3-John.C.Harrison@Intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index d6cc90ae70c9..83bfeb872bda 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -486,6 +486,17 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id,
 	engine->logical_mask = BIT(logical_instance);
 	__sprint_engine_name(engine);
 
+	if ((engine->class == COMPUTE_CLASS && !RCS_MASK(engine->gt) &&
+	     __ffs(CCS_MASK(engine->gt)) == engine->instance) ||
+	     engine->class == RENDER_CLASS)
+		engine->flags |= I915_ENGINE_FIRST_RENDER_COMPUTE;
+
+	/* features common between engines sharing EUs */
+	if (engine->class == RENDER_CLASS || engine->class == COMPUTE_CLASS) {
+		engine->flags |= I915_ENGINE_HAS_RCS_REG_STATE;
+		engine->flags |= I915_ENGINE_HAS_EU_PRIORITY;
+	}
+
 	engine->props.heartbeat_interval_ms =
 		CONFIG_DRM_I915_HEARTBEAT_INTERVAL;
 	engine->props.max_busywait_duration_ns =
@@ -498,20 +509,9 @@ static int intel_engine_setup(struct intel_gt *gt, enum intel_engine_id id,
 		CONFIG_DRM_I915_TIMESLICE_DURATION;
 
 	/* Override to uninterruptible for OpenCL workloads. */
-	if (GRAPHICS_VER(i915) == 12 && engine->class == RENDER_CLASS)
+	if (GRAPHICS_VER(i915) == 12 && (engine->flags & I915_ENGINE_HAS_RCS_REG_STATE))
 		engine->props.preempt_timeout_ms = 0;
 
-	if ((engine->class == COMPUTE_CLASS && !RCS_MASK(engine->gt) &&
-	     __ffs(CCS_MASK(engine->gt)) == engine->instance) ||
-	     engine->class == RENDER_CLASS)
-		engine->flags |= I915_ENGINE_FIRST_RENDER_COMPUTE;
-
-	/* features common between engines sharing EUs */
-	if (engine->class == RENDER_CLASS || engine->class == COMPUTE_CLASS) {
-		engine->flags |= I915_ENGINE_HAS_RCS_REG_STATE;
-		engine->flags |= I915_ENGINE_HAS_EU_PRIORITY;
-	}
-
 	/* Cap properties according to any system limits */
 #define CLAMP_PROP(field) \
 	do { \
-- 
2.35.1




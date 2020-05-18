Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27C61D8458
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbgERSLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732836AbgERSEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6BDC20873;
        Mon, 18 May 2020 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825085;
        bh=vvO58edxBBfMDGU/CA+sbKPkuGmRSwNhdMK6PcSRDFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+U4c8GWZe5nf2fMQRk6ZCbbrGV8V5HhQKDRIIu2C/zFiumNTqXzZufhgVQGJvvlH
         U36W+grfU48WTOjeiN5RDfxRFyhZ/252vXAoPYRKZByV+XDY4cydxuUSQgowvsb/em
         f8FYE8assUV78CxX95WkgShQsTLX64HcBVwaUw7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 084/194] drm/i915/gt: Make timeslicing an explicit engine property
Date:   Mon, 18 May 2020 19:36:14 +0200
Message-Id: <20200518173538.719488345@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit fe5a708267911d55cce42910d93e303924b088fd ]

In order to allow userspace to rely on timeslicing to reorder their
batches, we must support preemption of those user batches. Declare
timeslicing as an explicit property that is a combination of having the
kernel support and HW support.

Suggested-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200501122249.12417-1-chris@chris-wilson.co.uk
(cherry picked from commit a211da9c771bf97395a3ced83a3aa383372b13a7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine.h       |  9 ---------
 drivers/gpu/drm/i915/gt/intel_engine_types.h | 18 ++++++++++++++----
 drivers/gpu/drm/i915/gt/intel_lrc.c          |  5 ++++-
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine.h b/drivers/gpu/drm/i915/gt/intel_engine.h
index 5df003061e442..beb3211a6249d 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -338,13 +338,4 @@ intel_engine_has_preempt_reset(const struct intel_engine_cs *engine)
 	return intel_engine_has_preemption(engine);
 }
 
-static inline bool
-intel_engine_has_timeslices(const struct intel_engine_cs *engine)
-{
-	if (!IS_ACTIVE(CONFIG_DRM_I915_TIMESLICE_DURATION))
-		return false;
-
-	return intel_engine_has_semaphores(engine);
-}
-
 #endif /* _INTEL_RINGBUFFER_H_ */
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 92be41a6903c0..4ea067e1508a5 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -473,10 +473,11 @@ struct intel_engine_cs {
 #define I915_ENGINE_SUPPORTS_STATS   BIT(1)
 #define I915_ENGINE_HAS_PREEMPTION   BIT(2)
 #define I915_ENGINE_HAS_SEMAPHORES   BIT(3)
-#define I915_ENGINE_NEEDS_BREADCRUMB_TASKLET BIT(4)
-#define I915_ENGINE_IS_VIRTUAL       BIT(5)
-#define I915_ENGINE_HAS_RELATIVE_MMIO BIT(6)
-#define I915_ENGINE_REQUIRES_CMD_PARSER BIT(7)
+#define I915_ENGINE_HAS_TIMESLICES   BIT(4)
+#define I915_ENGINE_NEEDS_BREADCRUMB_TASKLET BIT(5)
+#define I915_ENGINE_IS_VIRTUAL       BIT(6)
+#define I915_ENGINE_HAS_RELATIVE_MMIO BIT(7)
+#define I915_ENGINE_REQUIRES_CMD_PARSER BIT(8)
 	unsigned int flags;
 
 	/*
@@ -573,6 +574,15 @@ intel_engine_has_semaphores(const struct intel_engine_cs *engine)
 	return engine->flags & I915_ENGINE_HAS_SEMAPHORES;
 }
 
+static inline bool
+intel_engine_has_timeslices(const struct intel_engine_cs *engine)
+{
+	if (!IS_ACTIVE(CONFIG_DRM_I915_TIMESLICE_DURATION))
+		return false;
+
+	return engine->flags & I915_ENGINE_HAS_TIMESLICES;
+}
+
 static inline bool
 intel_engine_needs_breadcrumb_tasklet(const struct intel_engine_cs *engine)
 {
diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 31455eceeb0c6..5bebda4a2d0b4 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -4194,8 +4194,11 @@ void intel_execlists_set_default_submission(struct intel_engine_cs *engine)
 	engine->flags |= I915_ENGINE_SUPPORTS_STATS;
 	if (!intel_vgpu_active(engine->i915)) {
 		engine->flags |= I915_ENGINE_HAS_SEMAPHORES;
-		if (HAS_LOGICAL_RING_PREEMPTION(engine->i915))
+		if (HAS_LOGICAL_RING_PREEMPTION(engine->i915)) {
 			engine->flags |= I915_ENGINE_HAS_PREEMPTION;
+			if (IS_ACTIVE(CONFIG_DRM_I915_TIMESLICE_DURATION))
+				engine->flags |= I915_ENGINE_HAS_TIMESLICES;
+		}
 	}
 
 	if (INTEL_GEN(engine->i915) >= 12)
-- 
2.20.1




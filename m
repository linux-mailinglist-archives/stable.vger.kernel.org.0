Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0CD2ABA3E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbgKINRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387550AbgKINRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA5C206D8;
        Mon,  9 Nov 2020 13:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927824;
        bh=XaVMIKk/Fu7nd4j8T4EkH/lhmw7SGKRwAW1MZpKBHpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+UtMm0eRmiUCfQZd0K05oO+3wAljSsIwmF0uNHeRkEysSxP8KWcVhUaF9x7DWv+h
         CdBCyh2DXE+AIiLJ3/ZHlxUyqM2fyVTJzfwPYPjFQKnZ08U2pNQP2u6/kKV8bR6Sep
         Fol/w52sWYa2HFRGucDjWk71ZM+9efdh9Tw0G/ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 008/133] drm/i915: Cancel outstanding work after disabling heartbeats on an engine
Date:   Mon,  9 Nov 2020 13:54:30 +0100
Message-Id: <20201109125031.119093258@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7d442ea7c504adcc9798b07cd8f6a0d235fca2da upstream.

We only allow persistent requests to remain on the GPU past the closure
of their containing context (and process) so long as they are continuously
checked for hangs or allow other requests to preempt them, as we need to
ensure forward progress of the system. If we allow persistent contexts
to remain on the system after the the hangcheck mechanism is disabled,
the system may grind to a halt. On disabling the mechanism, we sent a
pulse along the engine to remove all executing contexts from the engine
which would check for hung contexts -- but we did not prevent those
contexts from being resubmitted if they survived the final hangcheck.

Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
Testcase: igt/gem_ctx_persistence/heartbeat-stop
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Acked-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200928221510.26044-1-chris@chris-wilson.co.uk
(cherry picked from commit 7a991cd3e3da9a56d5616b62d425db000a3242f2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_engine.h |    9 +++++++++
 drivers/gpu/drm/i915/i915_request.c    |    5 +++++
 2 files changed, 14 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_engine.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine.h
@@ -357,4 +357,13 @@ intel_engine_has_preempt_reset(const str
 	return intel_engine_has_preemption(engine);
 }
 
+static inline bool
+intel_engine_has_heartbeat(const struct intel_engine_cs *engine)
+{
+	if (!IS_ACTIVE(CONFIG_DRM_I915_HEARTBEAT_INTERVAL))
+		return false;
+
+	return READ_ONCE(engine->props.heartbeat_interval_ms);
+}
+
 #endif /* _INTEL_RINGBUFFER_H_ */
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -549,8 +549,13 @@ bool __i915_request_submit(struct i915_r
 	if (i915_request_completed(request))
 		goto xfer;
 
+	if (unlikely(intel_context_is_closed(request->context) &&
+		     !intel_engine_has_heartbeat(engine)))
+		intel_context_set_banned(request->context);
+
 	if (unlikely(intel_context_is_banned(request->context)))
 		i915_request_set_error_once(request, -EIO);
+
 	if (unlikely(fatal_error(request->fence.error)))
 		__i915_request_skip(request);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274FE653B2
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 11:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfGKJXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 05:23:00 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:53906 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727595AbfGKJXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 05:23:00 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 17217793-1500050 
        for multiple; Thu, 11 Jul 2019 10:22:55 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Revert "drm/i915: Enable PSR2 by default"
Date:   Thu, 11 Jul 2019 10:22:54 +0100
Message-Id: <20190711092254.1719-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Multiple users are reporting black screens upon boot, after resume, or
frozen after a short period of idleness. A black screen on boot is a
critical issue so disable psr2 again until resolved.

This reverts commit 8f6e87d6d561f10cfa48a687345512419839b6d8.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
Fixes: 8f6e87d6d561 ("drm/i915: Enable PSR2 by default")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org #v5.2
---
 drivers/gpu/drm/i915/display/intel_psr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 69d908e6a050..ddde4da2de33 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -83,6 +83,9 @@ static bool intel_psr2_enabled(struct drm_i915_private *dev_priv,
 	case I915_PSR_DEBUG_DISABLE:
 	case I915_PSR_DEBUG_FORCE_PSR1:
 		return false;
+	case I915_PSR_DEBUG_DEFAULT:
+		if (i915_modparams.enable_psr <= 0)
+			return false;
 	default:
 		return crtc_state->has_psr2;
 	}
-- 
2.22.0


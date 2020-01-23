Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3BF14688A
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 13:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgAWM7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 07:59:40 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:52844 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726605AbgAWM7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 07:59:40 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 19982326-1500050 
        for multiple; Thu, 23 Jan 2020 12:59:35 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Ramalingam C <ramalingam.c@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Detect overflow in calculating dumb buffer size
Date:   Thu, 23 Jan 2020 12:59:34 +0000
Message-Id: <20200123125934.1401755-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

To multiply 2 u32 numbers to generate a u64 in C requires a bit of
forewarning for the compiler.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_gem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 0a20083321a3..ff79da5657f8 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -265,7 +265,10 @@ i915_gem_dumb_create(struct drm_file *file,
 						    DRM_FORMAT_MOD_LINEAR))
 		args->pitch = ALIGN(args->pitch, 4096);
 
-	args->size = args->pitch * args->height;
+	if (args->pitch < args->width)
+		return -EINVAL;
+
+	args->size = mul_u32_u32(args->pitch, args->height);
 
 	mem_type = INTEL_MEMORY_SYSTEM;
 	if (HAS_LMEM(to_i915(dev)))
-- 
2.25.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA74E292536
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 12:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgJSKMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 06:12:34 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:53536 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725921AbgJSKMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 06:12:34 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22755041-1500050 
        for multiple; Mon, 19 Oct 2020 11:12:30 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Stefan Fritsch <sf@sfritsch.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915: Force VT'd workarounds when running as a guest OS
Date:   Mon, 19 Oct 2020 11:12:30 +0100
Message-Id: <20201019101230.29860-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If i915.ko is being used as a passthrough device, it does not know if
the host is using intel_iommu. Mixing the iommu and gfx causing a few
issues (such as scanout overfetch) which we need to workaround inside
the driver, so if we detect we are running under a hypervisor, also
assume the device access is being virtualised.

Reported-by: Stefan Fritsch <sf@sfritsch.de>
Suggested-by: Stefan Fritsch <sf@sfritsch.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Stefan Fritsch <sf@sfritsch.de>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_drv.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 1a5729932c81..02a3dac412d8 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -33,6 +33,8 @@
 #include <uapi/drm/i915_drm.h>
 #include <uapi/drm/drm_fourcc.h>
 
+#include <asm/hypervisor.h>
+
 #include <linux/io-mapping.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
@@ -1760,6 +1762,13 @@ static inline bool intel_vtd_active(void)
 	if (intel_iommu_gfx_mapped)
 		return true;
 #endif
+
+#ifdef CONFIG_HYPERVISOR_GUEST
+	/* Running as a guest, we assume the host is enforcing VT'd */
+	if (x86_hyper_type != X86_HYPER_NATIVE)
+		return true;
+#endif
+
 	return false;
 }
 
-- 
2.20.1


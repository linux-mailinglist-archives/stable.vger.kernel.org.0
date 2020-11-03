Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672A82A53F9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388165AbgKCVGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388173AbgKCVGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 630A120658;
        Tue,  3 Nov 2020 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437591;
        bh=sN+tqHSXQ89aDEyAQLzAjoxXd0VmwnWxlC71/q/pbJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4lC+jBYNPd/1QXghsZPOcTfgOAZRXbelQXo5UDgWxGob61mJwPPzABqhXd1f0+xl
         0lgqKuDNJ4fHjMgfFFBEST+1ffrfgpOj9g6gOrNmUy7myloeTMcKVQQJs+4JZ+2ETO
         2I3uGrPsMsGDVSVNTf85gKwg98XWfOJr5e9nH5jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Fritsch <sf@sfritsch.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 4.19 143/191] drm/i915: Force VTd workarounds when running as a guest OS
Date:   Tue,  3 Nov 2020 21:37:15 +0100
Message-Id: <20201103203246.208082091@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 8195400f7ea95399f721ad21f4d663a62c65036f upstream.

If i915.ko is being used as a passthrough device, it does not know if
the host is using intel_iommu. Mixing the iommu and gfx causes a few
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
Tested-by: Stefan Fritsch <sf@sfritsch.de>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201019101523.4145-1-chris@chris-wilson.co.uk
(cherry picked from commit f566fdcd6cc49a9d5b5d782f56e3e7cb243f01b8)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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
@@ -2683,7 +2685,9 @@ static inline bool intel_vtd_active(void
 	if (intel_iommu_gfx_mapped)
 		return true;
 #endif
-	return false;
+
+	/* Running as a guest, we assume the host is enforcing VT'd */
+	return !hypervisor_is_type(X86_HYPER_NATIVE);
 }
 
 static inline bool intel_scanout_needs_vtd_wa(struct drm_i915_private *dev_priv)



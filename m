Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0CC2F010A
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbhAIQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 11:00:00 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:55994 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbhAIQAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 11:00:00 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23547807-1500050 
        for multiple; Sat, 09 Jan 2021 15:59:15 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Allow the user to override security mitigations
Date:   Sat,  9 Jan 2021 15:59:15 +0000
Message-Id: <20210109155915.20397-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210109154931.10098-3-chris@chris-wilson.co.uk>
References: <20210109154931.10098-3-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The clear-residuals mitigate is a relatively heavy hammer and under some
circumstances the user may wish to forgo the context isolation in order
to meet some performance requirement. Introduce a generic module
parameter to allow selectively enabling/disabling different mitigations.

Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: stable@vger.kernel.org # v5.7
---
 drivers/gpu/drm/i915/Makefile                 |   1 +
 .../gpu/drm/i915/gt/intel_ring_submission.c   |   4 +-
 drivers/gpu/drm/i915/i915_mitigations.c       | 119 ++++++++++++++++++
 drivers/gpu/drm/i915/i915_mitigations.h       |  13 ++
 4 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/i915/i915_mitigations.c
 create mode 100644 drivers/gpu/drm/i915/i915_mitigations.h

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 4074d8cb0d6e..48f82c354611 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -38,6 +38,7 @@ i915-y += i915_drv.o \
 	  i915_config.o \
 	  i915_irq.o \
 	  i915_getparam.o \
+	  i915_mitigations.o \
 	  i915_params.o \
 	  i915_pci.o \
 	  i915_scatterlist.o \
diff --git a/drivers/gpu/drm/i915/gt/intel_ring_submission.c b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
index 72d4722441bf..d529608d4456 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -32,6 +32,7 @@
 #include "gen6_ppgtt.h"
 #include "gen7_renderclear.h"
 #include "i915_drv.h"
+#include "i915_mitigations.h"
 #include "intel_breadcrumbs.h"
 #include "intel_context.h"
 #include "intel_gt.h"
@@ -920,7 +921,8 @@ static int switch_context(struct i915_request *rq)
 	GEM_BUG_ON(HAS_EXECLISTS(engine->i915));
 
 	if (engine->wa_ctx.vma && ce != engine->kernel_context) {
-		if (engine->wa_ctx.vma->private != ce) {
+		if (engine->wa_ctx.vma->private != ce &&
+		    i915_mitigate_clear_residuals()) {
 			ret = clear_residuals(rq);
 			if (ret)
 				return ret;
diff --git a/drivers/gpu/drm/i915/i915_mitigations.c b/drivers/gpu/drm/i915/i915_mitigations.c
new file mode 100644
index 000000000000..01ad74721e65
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_mitigations.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "i915_mitigations.h"
+
+static unsigned long mitigations = ~0UL;
+
+enum {
+	CLEAR_RESIDUALS = 0,
+};
+
+bool i915_mitigate_clear_residuals(void)
+{
+	return READ_ONCE(mitigations) & BIT(CLEAR_RESIDUALS);
+}
+
+static int mitigations_parse(const char *arg)
+{
+	unsigned long new = ~0UL;
+	char *str, *sep, *tok;
+	bool first = true;
+	int err = 0;
+
+	str = kstrdup(arg, GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	for (sep = strim(str); (tok = strsep(&sep, ","));) {
+		bool enable = true;
+
+		if (first) {
+			first = false;
+
+			if (!strcmp(tok, "auto")) {
+				new = ~0UL;
+				continue;
+			}
+
+			new = 0;
+			if (!strcmp(tok, "off"))
+				continue;
+		}
+
+		if (*tok == '!') {
+			enable = !enable;
+			tok++;
+		}
+
+		if (!strncmp(tok, "no", 2)) {
+			enable = !enable;
+			tok += 2;
+		}
+
+		if (*tok == '\0')
+			continue;
+
+		if (!strcmp(tok, "residuals")) {
+			if (enable)
+				new |= BIT(CLEAR_RESIDUALS);
+			else
+				new &= ~BIT(CLEAR_RESIDUALS);
+		} else {
+			err = -EINVAL;
+			break;
+		}
+	}
+	kfree(str);
+	if (err)
+		return err;
+
+	WRITE_ONCE(mitigations, new);
+	return 0;
+}
+
+static int mitigations_set(const char *val, const struct kernel_param *kp)
+{
+	int err;
+
+	err = mitigations_parse(val);
+	if (err)
+		return err;
+
+	err = param_set_charp(val, kp);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct kernel_param_ops ops = {
+	.set = mitigations_set,
+	.get = param_get_charp,
+	.free = param_free_charp
+};
+
+static char *param;
+module_param_cb_unsafe(mitigations, &ops, &param, 0600);
+MODULE_PARM_DESC(mitigations,
+"Selectively enable security mitigations for all Intel® GPUs.\n"
+"\n"
+"  auto -- enables all mitigations required for the platform [default]\n"
+"  off  -- disables all mitigations\n"
+"\n"
+"Individual mitigations can be enabled by passing a comma-separated string,\n"
+"e.g. mitigations=residuals to enable only clearing residuals or\n"
+"mitigations=auto,noresiduals to disable only the clear residual mitigation.\n"
+"Either '!' or 'no' may be used to switch from enabling the mitigation to\n"
+"disabling it.\n"
+"\n"
+"Active mitigations for Ivybridge, Baytrail, Haswell:\n"
+"  residuals -- clear all thread-local registers between contexts"
+);
diff --git a/drivers/gpu/drm/i915/i915_mitigations.h b/drivers/gpu/drm/i915/i915_mitigations.h
new file mode 100644
index 000000000000..1359d8135287
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_mitigations.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright © 2021 Intel Corporation
+ */
+
+#ifndef __I915_MITIGATIONS_H__
+#define __I915_MITIGATIONS_H__
+
+#include <linux/types.h>
+
+bool i915_mitigate_clear_residuals(void);
+
+#endif /* __I915_MITIGATIONS_H__ */
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EE72FA90C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390752AbhARSlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:41:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390663AbhARLlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADEEE22D49;
        Mon, 18 Jan 2021 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970040;
        bh=Nlwmy2oGSaP4WLwkHTzr+qxUZPfGrT8VFvpkeON1WJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVJg3qYBXCfIOB1yL/PzUXjbR4fKD1lQhvci3lBkleWV02iB6yiTNtzg+hhTn7aKn
         zczg7/BONRFSueDNrnmiVZurI+ZyZQGOrSiBFgWoYVGAr8W9sCngohFWjRO1eiZG9c
         SvrXVEV3w0Hi5BYOdNW9+P7+LMl9t4CpdSxdN3yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 012/152] drm/i915: Allow the sysadmin to override security mitigations
Date:   Mon, 18 Jan 2021 12:33:07 +0100
Message-Id: <20210118113353.352644272@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 984cadea032b103c5824a5f29d0a36b3e9df6333 upstream.

The clear-residuals mitigation is a relatively heavy hammer and under some
circumstances the user may wish to forgo the context isolation in order
to meet some performance requirement. Introduce a generic module
parameter to allow selectively enabling/disabling different mitigations.

To disable just the clear-residuals mitigation (on Ivybridge, Baytrail,
or Haswell) use the module parameter: i915.mitigations=auto,!residuals

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1858
Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: stable@vger.kernel.org # v5.7
Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111225220.3483-3-chris@chris-wilson.co.uk
(cherry picked from commit f7452c7cbd5b5dfb9a6c84cb20bea04c89be50cd)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/Makefile                   |    1 
 drivers/gpu/drm/i915/gt/intel_ring_submission.c |    4 
 drivers/gpu/drm/i915/i915_mitigations.c         |  146 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_mitigations.h         |   13 ++
 4 files changed, 163 insertions(+), 1 deletion(-)

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
@@ -885,7 +886,8 @@ static int switch_context(struct i915_re
 	GEM_BUG_ON(HAS_EXECLISTS(engine->i915));
 
 	if (engine->wa_ctx.vma && ce != engine->kernel_context) {
-		if (engine->wa_ctx.vma->private != ce) {
+		if (engine->wa_ctx.vma->private != ce &&
+		    i915_mitigate_clear_residuals()) {
 			ret = clear_residuals(rq);
 			if (ret)
 				return ret;
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_mitigations.c
@@ -0,0 +1,146 @@
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
+#include "i915_drv.h"
+#include "i915_mitigations.h"
+
+static unsigned long mitigations __read_mostly = ~0UL;
+
+enum {
+	CLEAR_RESIDUALS = 0,
+};
+
+static const char * const names[] = {
+	[CLEAR_RESIDUALS] = "residuals",
+};
+
+bool i915_mitigate_clear_residuals(void)
+{
+	return READ_ONCE(mitigations) & BIT(CLEAR_RESIDUALS);
+}
+
+static int mitigations_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned long new = ~0UL;
+	char *str, *sep, *tok;
+	bool first = true;
+	int err = 0;
+
+	BUILD_BUG_ON(ARRAY_SIZE(names) >= BITS_PER_TYPE(mitigations));
+
+	str = kstrdup(val, GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	for (sep = str; (tok = strsep(&sep, ","));) {
+		bool enable = true;
+		int i;
+
+		/* Be tolerant of leading/trailing whitespace */
+		tok = strim(tok);
+
+		if (first) {
+			first = false;
+
+			if (!strcmp(tok, "auto"))
+				continue;
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
+		for (i = 0; i < ARRAY_SIZE(names); i++) {
+			if (!strcmp(tok, names[i])) {
+				if (enable)
+					new |= BIT(i);
+				else
+					new &= ~BIT(i);
+				break;
+			}
+		}
+		if (i == ARRAY_SIZE(names)) {
+			pr_err("Bad \"%s.mitigations=%s\", '%s' is unknown\n",
+			       DRIVER_NAME, val, tok);
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
+static int mitigations_get(char *buffer, const struct kernel_param *kp)
+{
+	unsigned long local = READ_ONCE(mitigations);
+	int count, i;
+	bool enable;
+
+	if (!local)
+		return scnprintf(buffer, PAGE_SIZE, "%s\n", "off");
+
+	if (local & BIT(BITS_PER_LONG - 1)) {
+		count = scnprintf(buffer, PAGE_SIZE, "%s,", "auto");
+		enable = false;
+	} else {
+		enable = true;
+		count = 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(names); i++) {
+		if ((local & BIT(i)) != enable)
+			continue;
+
+		count += scnprintf(buffer + count, PAGE_SIZE - count,
+				   "%s%s,", enable ? "" : "!", names[i]);
+	}
+
+	buffer[count - 1] = '\n';
+	return count;
+}
+
+static const struct kernel_param_ops ops = {
+	.set = mitigations_set,
+	.get = mitigations_get,
+};
+
+module_param_cb_unsafe(mitigations, &ops, NULL, 0600);
+MODULE_PARM_DESC(mitigations,
+"Selectively enable security mitigations for all Intel® GPUs in the system.\n"
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



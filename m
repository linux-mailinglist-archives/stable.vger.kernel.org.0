Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F78975FEA
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfGZHgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:36:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:41199 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGZHgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:36:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 00:36:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="369967743"
Received: from jlahtine-desk.ger.corp.intel.com ([10.252.2.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jul 2019 00:36:05 -0700
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 2/8] drm/i915/perf: fix ICL perf register offsets
Date:   Fri, 26 Jul 2019 10:35:50 +0300
Message-Id: <20190726073556.9011-3-joonas.lahtinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>

We got the wrong offsets (could they have changed?). New values were
computed off an error state by looking up the register offset in the
context image as written by the HW.

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: 1de401c08fa805 ("drm/i915/perf: enable perf support on ICL")
Acked-by: Kenneth Graunke <kenneth@whitecape.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610081914.25428-1-lionel.g.landwerlin@intel.com
(cherry picked from commit 8dcfdfb4501012a8d36d2157dc73925715f2befb)
Cc: stable@vger.kernel.org
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_perf.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index dc4ce694c06a..235aedc62b4c 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -3457,9 +3457,13 @@ void i915_perf_init(struct drm_i915_private *dev_priv)
 			dev_priv->perf.oa.ops.enable_metric_set = gen8_enable_metric_set;
 			dev_priv->perf.oa.ops.disable_metric_set = gen10_disable_metric_set;
 
-			dev_priv->perf.oa.ctx_oactxctrl_offset = 0x128;
-			dev_priv->perf.oa.ctx_flexeu0_offset = 0x3de;
-
+			if (IS_GEN(dev_priv, 10)) {
+				dev_priv->perf.oa.ctx_oactxctrl_offset = 0x128;
+				dev_priv->perf.oa.ctx_flexeu0_offset = 0x3de;
+			} else {
+				dev_priv->perf.oa.ctx_oactxctrl_offset = 0x124;
+				dev_priv->perf.oa.ctx_flexeu0_offset = 0x78e;
+			}
 			dev_priv->perf.oa.gen8_valid_ctx_bit = (1<<16);
 		}
 	}
-- 
2.20.1


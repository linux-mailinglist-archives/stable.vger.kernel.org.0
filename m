Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C13612DB0F
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 20:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfLaTHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 14:07:19 -0500
Received: from mga12.intel.com ([192.55.52.136]:2039 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfLaTHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Dec 2019 14:07:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 11:07:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="215645737"
Received: from mdroper-desk1.fm.intel.com ([10.1.27.64])
  by fmsmga007.fm.intel.com with ESMTP; 31 Dec 2019 11:07:18 -0800
From:   Matt Roper <matthew.d.roper@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Matt Roper <matthew.d.roper@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>
Subject: [PATCH v3] drm/i915: Add Wa_1407352427:icl,ehl
Date:   Tue, 31 Dec 2019 11:07:13 -0800
Message-Id: <20191231190713.1549533-1-matthew.d.roper@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191226184056.266739-1-matthew.d.roper@intel.com>
References: <20191226184056.266739-1-matthew.d.roper@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The workaround database now indicates we need to disable psdunit clock
gating as well.

v3:
 - Rebase on top of other workarounds that have landed.
 - Restrict cc:stable tag to 5.2+ since that's when ICL was first
   officially supported.

Bspec: 32354
Bspec: 33450
Bspec: 33451
Suggested-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org # v5.2+
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 1 +
 drivers/gpu/drm/i915/intel_pm.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 030a3f3e69af..cf770793be54 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4183,6 +4183,7 @@ enum {
 
 #define UNSLICE_UNIT_LEVEL_CLKGATE2	_MMIO(0x94e4)
 #define   VSUNIT_CLKGATE_DIS_TGL	REG_BIT(19)
+#define   PSDUNIT_CLKGATE_DIS		REG_BIT(5)
 
 #define INF_UNIT_LEVEL_CLKGATE		_MMIO(0x9560)
 #define   CGPSF_CLKGATE_DIS		(1 << 3)
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index d3dd80db8813..148ac455dfa7 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6607,6 +6607,9 @@ static void icl_init_clock_gating(struct drm_i915_private *dev_priv)
 	intel_uncore_rmw(&dev_priv->uncore, UNSLICE_UNIT_LEVEL_CLKGATE,
 			 0, VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
 
+	/* Wa_1407352427:icl,ehl */
+	intel_uncore_rmw(&dev_priv->uncore, UNSLICE_UNIT_LEVEL_CLKGATE2,
+			 0, PSDUNIT_CLKGATE_DIS);
 }
 
 static void tgl_init_clock_gating(struct drm_i915_private *dev_priv)
-- 
2.23.0


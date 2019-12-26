Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C1012ADF0
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 19:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfLZSk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 13:40:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:26837 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbfLZSk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Dec 2019 13:40:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 10:40:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,360,1571727600"; 
   d="scan'208";a="250436253"
Received: from mdroper-desk1.fm.intel.com ([10.1.27.64])
  by fmsmga002.fm.intel.com with ESMTP; 26 Dec 2019 10:40:58 -0800
From:   Matt Roper <matthew.d.roper@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Matt Roper <matthew.d.roper@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>
Subject: [PATCH v2] drm/i915: Add Wa_1407352427:icl,ehl
Date:   Thu, 26 Dec 2019 10:40:56 -0800
Message-Id: <20191226184056.266739-1-matthew.d.roper@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <5e4b8127-61a6-4f3d-1b85-8c81b96ac543@intel.com>
References: <5e4b8127-61a6-4f3d-1b85-8c81b96ac543@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The workaround database now indicates we need to disable psdunit clock
gating as well.

Bspec: 32354
Bspec: 33450
Bspec: 33451
Suggested-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: stable@vger.kernel.org
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 3 +++
 drivers/gpu/drm/i915/intel_pm.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index bbfedeb00b7f..b98734378c9a 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4179,6 +4179,9 @@ enum {
 #define UNSLICE_UNIT_LEVEL_CLKGATE	_MMIO(0x9434)
 #define  VFUNIT_CLKGATE_DIS		(1 << 20)
 
+#define UNSLICE_UNIT_LEVEL_CLKGATE2	_MMIO(0x94e4)
+#define   PSDUNIT_CLKGATE_DIS		REG_BIT(5)
+
 #define INF_UNIT_LEVEL_CLKGATE		_MMIO(0x9560)
 #define   CGPSF_CLKGATE_DIS		(1 << 3)
 
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 31ec82337e4f..8bc8f0836368 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6590,6 +6590,10 @@ static void icl_init_clock_gating(struct drm_i915_private *dev_priv)
 	/* WaEnable32PlaneMode:icl */
 	I915_WRITE(GEN9_CSFE_CHICKEN1_RCS,
 		   _MASKED_BIT_ENABLE(GEN11_ENABLE_32_PLANE_MODE));
+
+	/* Wa_1407352427:icl,ehl */
+	intel_uncore_rmw(&dev_priv->uncore, UNSLICE_UNIT_LEVEL_CLKGATE2,
+			 0, PSDUNIT_CLKGATE_DIS);
 }
 
 static void tgl_init_clock_gating(struct drm_i915_private *dev_priv)
-- 
2.23.0


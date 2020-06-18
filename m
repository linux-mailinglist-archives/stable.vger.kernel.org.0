Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49B41FFC7D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 22:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgFRU3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 16:29:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:51202 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgFRU3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 16:29:18 -0400
IronPort-SDR: KAIkDS+jXuia26DMs2yCPuetCM/4Bq4ZQPiRVgOaczlMrczjnzzCqbSdrPU6vUmPEA7CnQULFN
 gKvpIiJCYtLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="140240125"
X-IronPort-AV: E=Sophos;i="5.75,252,1589266800"; 
   d="scan'208";a="140240125"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 13:29:17 -0700
IronPort-SDR: mUPA4RGvkOlj+3E87uSmjqXZKpywcjo7iuNFSWb7OcRlB9fv2yslUe1hWCEMvBzckuJoWlOQSe
 EPSyXGktJcZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,252,1589266800"; 
   d="scan'208";a="477318158"
Received: from rdvivi-losangeles.jf.intel.com ([10.165.21.202])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jun 2020 13:29:17 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gfx@lists.freedesktop.org,
        Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>,
        Rafael Antognolli <rafael.antognolli@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH] drm/i915/tgl: Make Wa_14010229206 permanent
Date:   Thu, 18 Jun 2020 13:27:00 -0700
Message-Id: <20200618202701.729-1-rodrigo.vivi@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>

commit 63d0f3ea8ebb67160eca281320d255c72b0cb51a upstream.

This workaround now applies to all steppings, not just A0.
Wa_1409085225 is a temporary A0-only W/A however it is
identical to Wa_14010229206 and hence the combined workaround
is made permanent.
Bspec: 52890

Signed-off-by: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
Tested-by: Rafael Antognolli <rafael.antognolli@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
[mattrope: added missing blank line]
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200326234955.16155-1-swathi.dhanavanthri@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 5176ad1a3976..092a42367851 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1379,12 +1379,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 			    GEN7_FF_THREAD_MODE,
 			    GEN12_FF_TESSELATION_DOP_GATE_DISABLE);
 
-		/*
-		 * Wa_1409085225:tgl
-		 * Wa_14010229206:tgl
-		 */
-		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
-
 		/* Wa_1408615072:tgl */
 		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
 			    VSUNIT_CLKGATE_DIS_TGL);
@@ -1402,6 +1396,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_masked_en(wal,
 			     GEN9_CS_DEBUG_MODE1,
 			     FF_DOP_CLOCK_GATE_DISABLE);
+
+		/*
+		 * Wa_1409085225:tgl
+		 * Wa_14010229206:tgl
+		 */
+		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
 	}
 
 	if (IS_GEN(i915, 11)) {
-- 
2.24.1


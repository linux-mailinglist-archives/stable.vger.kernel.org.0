Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074CE6C32F
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 00:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfGQWhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 18:37:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:27547 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbfGQWhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 18:37:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 15:37:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,275,1559545200"; 
   d="scan'208";a="169681745"
Received: from dk-chv.jf.intel.com ([10.54.75.59])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jul 2019 15:37:10 -0700
From:   Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
Date:   Wed, 17 Jul 2019 15:34:51 -0700
Message-Id: <20190717223451.2595-1-dhinakaran.pandiyan@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A single 32-bit PSR2 training pattern field follows the sixteen element
array of PSR table entries in the VBT spec. But, we incorrectly define
this PSR2 field for each of the PSR table entries. As a result, the PSR1
training pattern duration for any panel_type != 0 will be parsed
incorrectly. Secondly, PSR2 training pattern durations for VBTs with bdb
version >= 226 will also be wrong.

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org #v5.2
Fixes: 88a0d9606aff ("drm/i915/vbt: Parse and use the new field with PSR2 TP2/3 wakeup time")
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204183
Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Tested-by: François Guerraz <kubrick@fgv6.net>
---
 drivers/gpu/drm/i915/display/intel_bios.c     | 2 +-
 drivers/gpu/drm/i915/display/intel_vbt_defs.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 21501d565327..b416b394b641 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -766,7 +766,7 @@ parse_psr(struct drm_i915_private *dev_priv, const struct bdb_header *bdb)
 	}
 
 	if (bdb->version >= 226) {
-		u32 wakeup_time = psr_table->psr2_tp2_tp3_wakeup_time;
+		u32 wakeup_time = psr->psr2_tp2_tp3_wakeup_time;
 
 		wakeup_time = (wakeup_time >> (2 * panel_type)) & 0x3;
 		switch (wakeup_time) {
diff --git a/drivers/gpu/drm/i915/display/intel_vbt_defs.h b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
index 93f5c9d204d6..09cd37fb0b1c 100644
--- a/drivers/gpu/drm/i915/display/intel_vbt_defs.h
+++ b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
@@ -481,13 +481,13 @@ struct psr_table {
 	/* TP wake up time in multiple of 100 */
 	u16 tp1_wakeup_time;
 	u16 tp2_tp3_wakeup_time;
-
-	/* PSR2 TP2/TP3 wakeup time for 16 panels */
-	u32 psr2_tp2_tp3_wakeup_time;
 } __packed;
 
 struct bdb_psr {
 	struct psr_table psr_table[16];
+
+	/* PSR2 TP2/TP3 wakeup time for 16 panels */
+	u32 psr2_tp2_tp3_wakeup_time;
 } __packed;
 
 /*
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45C466907
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 10:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfGLIUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 04:20:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:4196 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbfGLIUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 04:20:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 01:20:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="177438654"
Received: from slisovsk-lenovo-ideapad-720s-13ikb.fi.intel.com ([10.237.66.154])
  by orsmga002.jf.intel.com with ESMTP; 12 Jul 2019 01:20:12 -0700
From:   Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     martin.peres@intel.com, maarten.lankhorst@linux.intel.com,
        ville.syrjala@linux.intel.com, jani.saarinen@intel.com,
        stanislav.lisovskiy@intel.com, jani.nikula@intel.com,
        vandita.kulkarni@intel.com, stable@vger.kernel.org
Subject: [PATCH v3] drm/i915: Fix wrong escape clock divisor init for GLK
Date:   Fri, 12 Jul 2019 11:19:38 +0300
Message-Id: <20190712081938.14185-1-stanislav.lisovskiy@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to Bspec clock divisor registers in GeminiLake
should be initialized by shifting 1(<<) to amount of correspondent
divisor. While i915 was writing all this time that value as is.

Surprisingly that it by accident worked, until we met some issues
with Microtech Etab.

v2: Added Fixes tag and cc
v3: Added stable to cc as well.

Signed-off-by: stanislav.lisovskiy@intel.com
Reviewed-by: Vandita Kulkarni <vandita.kulkarni@intel.com>
Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=108826
Fixes: bcc657004841 ("drm/i915/glk: Program txesc clock divider for GLK")
Cc: Deepak M <m.deepak@intel.com>
Cc: Madhav Chauhan <madhav.chauhan@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/display/vlv_dsi_pll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/vlv_dsi_pll.c b/drivers/gpu/drm/i915/display/vlv_dsi_pll.c
index 99cc3e2e9c2c..f016a776a39e 100644
--- a/drivers/gpu/drm/i915/display/vlv_dsi_pll.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi_pll.c
@@ -396,8 +396,8 @@ static void glk_dsi_program_esc_clock(struct drm_device *dev,
 	else
 		txesc2_div = 10;
 
-	I915_WRITE(MIPIO_TXESC_CLK_DIV1, txesc1_div & GLK_TX_ESC_CLK_DIV1_MASK);
-	I915_WRITE(MIPIO_TXESC_CLK_DIV2, txesc2_div & GLK_TX_ESC_CLK_DIV2_MASK);
+	I915_WRITE(MIPIO_TXESC_CLK_DIV1, (1 << (txesc1_div - 1)) & GLK_TX_ESC_CLK_DIV1_MASK);
+	I915_WRITE(MIPIO_TXESC_CLK_DIV2, (1 << (txesc2_div - 1)) & GLK_TX_ESC_CLK_DIV2_MASK);
 }
 
 /* Program BXT Mipi clocks and dividers */
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8332E1C33E8
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 09:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgEDH7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 03:59:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:43137 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgEDH7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 03:59:02 -0400
IronPort-SDR: xsTOJ+CMBQGELtTtfEqdplJ0djGHN++QgS0Bxp8V0GmECKzQi4hcQud6zJx6yyqDxA1e2ZycQ6
 0+eDwaN9wzuA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 00:59:01 -0700
IronPort-SDR: pAlqvdFkQs9K6iURMIjLXPwu3k15qMbYCSY2ytFkejkWfMMrsZWZgjs7Odr3T+Mu1pU7H/At4I
 w8zE1UJG5yPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,351,1583222400"; 
   d="scan'208";a="259255944"
Received: from ideak-desk.fi.intel.com ([10.237.72.183])
  by orsmga003.jf.intel.com with ESMTP; 04 May 2020 00:59:00 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/i915/tgl+: Fix interrupt handling for DP AUX transactions
Date:   Mon,  4 May 2020 10:58:28 +0300
Message-Id: <20200504075828.20348-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unmask/enable AUX interrupts on all ports on TGL+. So far the interrupts
worked only on port A, which meant each transaction on other ports took
10ms.

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/i915_irq.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index bd722d0650c8..0b8b0c069ce3 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3361,7 +3361,7 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
 	u32 de_pipe_masked = gen8_de_pipe_fault_mask(dev_priv) |
 		GEN8_PIPE_CDCLK_CRC_DONE;
 	u32 de_pipe_enables;
-	u32 de_port_masked = GEN8_AUX_CHANNEL_A;
+	u32 de_port_masked = gen8_de_port_aux_mask(dev_priv);
 	u32 de_port_enables;
 	u32 de_misc_masked = GEN8_DE_EDP_PSR;
 	enum pipe pipe;
@@ -3369,18 +3369,8 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
 	if (INTEL_GEN(dev_priv) <= 10)
 		de_misc_masked |= GEN8_DE_MISC_GSE;
 
-	if (INTEL_GEN(dev_priv) >= 9) {
-		de_port_masked |= GEN9_AUX_CHANNEL_B | GEN9_AUX_CHANNEL_C |
-				  GEN9_AUX_CHANNEL_D;
-		if (IS_GEN9_LP(dev_priv))
-			de_port_masked |= BXT_DE_PORT_GMBUS;
-	}
-
-	if (INTEL_GEN(dev_priv) >= 11)
-		de_port_masked |= ICL_AUX_CHANNEL_E;
-
-	if (IS_CNL_WITH_PORT_F(dev_priv) || INTEL_GEN(dev_priv) >= 11)
-		de_port_masked |= CNL_AUX_CHANNEL_F;
+	if (IS_GEN9_LP(dev_priv))
+		de_port_masked |= BXT_DE_PORT_GMBUS;
 
 	de_pipe_enables = de_pipe_masked | GEN8_PIPE_VBLANK |
 					   GEN8_PIPE_FIFO_UNDERRUN;
-- 
2.23.1


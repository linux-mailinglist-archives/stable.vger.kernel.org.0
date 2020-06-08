Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71541F2E4B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgFIAkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729192AbgFHXMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F06214D8;
        Mon,  8 Jun 2020 23:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657975;
        bh=5zNyKomWQO4uiYiSJCDxXIRcWas232csxiLAZe0gTvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1BZ5AvU+NQt3S0IhtiJV9jA4xRmAa413jfZZrxhke9QcZ1jz+mh9+vmC1h+7FgQ4
         a2jHiPjz3iDHCOhGz23tG/DiPw7n9ViIO3Sfuwxoaq8hRs+C2dZ/2TXZ+ZyIHxOZVT
         3/q2CoDstSoY9dg/GtsuStRPpTsKWNL8I/GJN+OY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 037/606] drm/i915/tgl+: Fix interrupt handling for DP AUX transactions
Date:   Mon,  8 Jun 2020 19:02:42 -0400
Message-Id: <20200608231211.3363633-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 4457a9db2bdec2360ddb15242341696108167886 upstream.

Unmask/enable AUX interrupts on all ports on TGL+. So far the interrupts
worked only on port A, which meant each transaction on other ports took
10ms.

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200504075828.20348-1-imre.deak@intel.com
(cherry picked from commit 054318c7e35f1d7d06b216143fff5f32405047ee)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_irq.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index c6f02b0b6c7a..52825ae8301b 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3324,7 +3324,7 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
 	u32 de_pipe_masked = gen8_de_pipe_fault_mask(dev_priv) |
 		GEN8_PIPE_CDCLK_CRC_DONE;
 	u32 de_pipe_enables;
-	u32 de_port_masked = GEN8_AUX_CHANNEL_A;
+	u32 de_port_masked = gen8_de_port_aux_mask(dev_priv);
 	u32 de_port_enables;
 	u32 de_misc_masked = GEN8_DE_EDP_PSR;
 	enum pipe pipe;
@@ -3332,18 +3332,8 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
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
2.25.1


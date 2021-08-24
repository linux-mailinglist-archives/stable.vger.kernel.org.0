Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A50F3F6407
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhHXRAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235862AbhHXQ6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7BD361440;
        Tue, 24 Aug 2021 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824238;
        bh=PvCNSCfZaqTaas9a9ikNledVoTOpKjgHbdCJFDdgDbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoZQv4XI3bJtFVFlrpV+/GcL4d9DJ9FNXwNRBu/MVtxG9Tt16Fu332/ls/OjA/mKp
         cPgJOdV9E6uWTmZ2g7ud2EBUf+J5qwWxXiA/Eihi80WZPFmfixSxvW/776VfRpthL9
         wHnpq/KjMSuCl7fAiYkf92alJ/BUBtOpd9NMMwjxth21bx+7ZKAWg7KHnBTnFHeGE5
         kwcAZnsTGWGRUwwrg+VJAhhr14pZKaacoyHG8XSf26qjjlD5vSSMK4P4WPtfPHLxFj
         FDQvcXk+p5zvAi779qeIdPxy+EOYArAFvGaKIKjZQUx5p/W5M0/2x7e0wNd/HGihX/
         KUUFJJxt6SsXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/127] drm/i915: Skip display interruption setup when display is not available
Date:   Tue, 24 Aug 2021 12:55:11 -0400
Message-Id: <20210824165607.709387-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit a844cfbe648d15d9f1031c45508c194f2d61c917 ]

Return ealier in the functions doing interruption setup for GEN8+ also
adding a warning in gen8_de_irq_handler() to let us know that
something else is still missing.

Reviewed-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210408203150.237947-1-jose.souza@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_irq.c | 39 +++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 7eefbdec25a2..e0d0b300c4aa 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2421,6 +2421,8 @@ gen8_de_irq_handler(struct drm_i915_private *dev_priv, u32 master_ctl)
 	u32 iir;
 	enum pipe pipe;
 
+	drm_WARN_ON_ONCE(&dev_priv->drm, !HAS_DISPLAY(dev_priv));
+
 	if (master_ctl & GEN8_DE_MISC_IRQ) {
 		iir = intel_uncore_read(&dev_priv->uncore, GEN8_DE_MISC_IIR);
 		if (iir) {
@@ -3058,14 +3060,13 @@ static void cnp_display_clock_wa(struct drm_i915_private *dev_priv)
 	}
 }
 
-static void gen8_irq_reset(struct drm_i915_private *dev_priv)
+static void gen8_display_irq_reset(struct drm_i915_private *dev_priv)
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
 	enum pipe pipe;
 
-	gen8_master_intr_disable(dev_priv->uncore.regs);
-
-	gen8_gt_irq_reset(&dev_priv->gt);
+	if (!HAS_DISPLAY(dev_priv))
+		return;
 
 	intel_uncore_write(uncore, EDP_PSR_IMR, 0xffffffff);
 	intel_uncore_write(uncore, EDP_PSR_IIR, 0xffffffff);
@@ -3077,6 +3078,16 @@ static void gen8_irq_reset(struct drm_i915_private *dev_priv)
 
 	GEN3_IRQ_RESET(uncore, GEN8_DE_PORT_);
 	GEN3_IRQ_RESET(uncore, GEN8_DE_MISC_);
+}
+
+static void gen8_irq_reset(struct drm_i915_private *dev_priv)
+{
+	struct intel_uncore *uncore = &dev_priv->uncore;
+
+	gen8_master_intr_disable(dev_priv->uncore.regs);
+
+	gen8_gt_irq_reset(&dev_priv->gt);
+	gen8_display_irq_reset(dev_priv);
 	GEN3_IRQ_RESET(uncore, GEN8_PCU_);
 
 	if (HAS_PCH_SPLIT(dev_priv))
@@ -3092,6 +3103,9 @@ static void gen11_display_irq_reset(struct drm_i915_private *dev_priv)
 	u32 trans_mask = BIT(TRANSCODER_A) | BIT(TRANSCODER_B) |
 		BIT(TRANSCODER_C) | BIT(TRANSCODER_D);
 
+	if (!HAS_DISPLAY(dev_priv))
+		return;
+
 	intel_uncore_write(uncore, GEN11_DISPLAY_INT_CTL, 0);
 
 	if (DISPLAY_VER(dev_priv) >= 12) {
@@ -3714,6 +3728,9 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
 		BIT(TRANSCODER_C) | BIT(TRANSCODER_D);
 	enum pipe pipe;
 
+	if (!HAS_DISPLAY(dev_priv))
+		return;
+
 	if (DISPLAY_VER(dev_priv) <= 10)
 		de_misc_masked |= GEN8_DE_MISC_GSE;
 
@@ -3797,6 +3814,16 @@ static void gen8_irq_postinstall(struct drm_i915_private *dev_priv)
 	gen8_master_intr_enable(dev_priv->uncore.regs);
 }
 
+static void gen11_de_irq_postinstall(struct drm_i915_private *dev_priv)
+{
+	if (!HAS_DISPLAY(dev_priv))
+		return;
+
+	gen8_de_irq_postinstall(dev_priv);
+
+	intel_uncore_write(&dev_priv->uncore, GEN11_DISPLAY_INT_CTL,
+			   GEN11_DISPLAY_IRQ_ENABLE);
+}
 
 static void gen11_irq_postinstall(struct drm_i915_private *dev_priv)
 {
@@ -3807,12 +3834,10 @@ static void gen11_irq_postinstall(struct drm_i915_private *dev_priv)
 		icp_irq_postinstall(dev_priv);
 
 	gen11_gt_irq_postinstall(&dev_priv->gt);
-	gen8_de_irq_postinstall(dev_priv);
+	gen11_de_irq_postinstall(dev_priv);
 
 	GEN3_IRQ_INIT(uncore, GEN11_GU_MISC_, ~gu_misc_masked, gu_misc_masked);
 
-	intel_uncore_write(&dev_priv->uncore, GEN11_DISPLAY_INT_CTL, GEN11_DISPLAY_IRQ_ENABLE);
-
 	if (HAS_MASTER_UNIT_IRQ(dev_priv)) {
 		dg1_master_intr_enable(uncore->regs);
 		intel_uncore_posting_read(&dev_priv->uncore, DG1_MSTR_UNIT_INTR);
-- 
2.30.2


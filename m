Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E39C1F1CD
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfEOLzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbfEOLSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337D9206BF;
        Wed, 15 May 2019 11:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919111;
        bh=fya0K4A2B5AA1H7SCysVvWjdhaVu9BpWOOUQwW7H79U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZhzwe7Mg3YxfLdhIn5ZoqqxwXKGbiXc1VBdrGnWGYXSgS/KdKZ9ihSs4C5ptQibd
         gfIbAKoZqMUWar3HgF1BKOc+OiQ63qE8PxEPwSz03OoRyYK7YyL+xP0l9Pz+heAHsT
         kwpGlIRvUjULPti81nesp14/6XKR+rThMmXfjKc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 054/115] drm/i915: Disable LP3 watermarks on all SNB machines
Date:   Wed, 15 May 2019 12:55:34 +0200
Message-Id: <20190515090703.534551972@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 03981c6ebec4fc7056b9b45f847393aeac90d060 ]

I have a Thinkpad X220 Tablet in my hands that is losing vblank
interrupts whenever LP3 watermarks are used.

If I nudge the latency value written to the WM3 register just
by one in either direction the problem disappears. That to me
suggests that the punit will not enter the corrsponding
powersave mode (MPLL shutdown IIRC) unless the latency value
in the register matches exactly what we read from SSKPD. Ie.
it's not really a latency value but rather just a cookie
by which the punit can identify the desired power saving state.
On HSW/BDW this was changed such that we actually just write
the WM level number into those bits, which makes much more
sense given the observed behaviour.

We could try to handle this by disallowing LP3 watermarks
only when vblank interrupts are enabled but we'd first have
to prove that only vblank interrupts are affected, which
seems unlikely. Also we can't grab the wm mutex from the
vblank enable/disable hooks because those are called with
various spinlocks held. Thus we'd have to redesigne the
watermark locking. So to play it safe and keep the code
simple we simply disable LP3 watermarks on all SNB machines.

To do that we simply zero out the latency values for
watermark level 3, and we adjust the watermark computation
to check for that. The behaviour now matches that of the
g4x/vlv/skl wm code in the presence of a zeroed latency
value.

v2: s/USHRT_MAX/U32_MAX/ for consistency with the types (Chris)

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=101269
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=103713
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181114173440.6730-1-ville.syrjala@linux.intel.com
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 41 ++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 87cccb5f8c5da..96a5237741e0c 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2471,6 +2471,9 @@ static uint32_t ilk_compute_pri_wm(const struct intel_crtc_state *cstate,
 	uint32_t method1, method2;
 	int cpp;
 
+	if (mem_value == 0)
+		return U32_MAX;
+
 	if (!intel_wm_plane_visible(cstate, pstate))
 		return 0;
 
@@ -2500,6 +2503,9 @@ static uint32_t ilk_compute_spr_wm(const struct intel_crtc_state *cstate,
 	uint32_t method1, method2;
 	int cpp;
 
+	if (mem_value == 0)
+		return U32_MAX;
+
 	if (!intel_wm_plane_visible(cstate, pstate))
 		return 0;
 
@@ -2523,6 +2529,9 @@ static uint32_t ilk_compute_cur_wm(const struct intel_crtc_state *cstate,
 {
 	int cpp;
 
+	if (mem_value == 0)
+		return U32_MAX;
+
 	if (!intel_wm_plane_visible(cstate, pstate))
 		return 0;
 
@@ -2981,6 +2990,34 @@ static void snb_wm_latency_quirk(struct drm_i915_private *dev_priv)
 	intel_print_wm_latency(dev_priv, "Cursor", dev_priv->wm.cur_latency);
 }
 
+static void snb_wm_lp3_irq_quirk(struct drm_i915_private *dev_priv)
+{
+	/*
+	 * On some SNB machines (Thinkpad X220 Tablet at least)
+	 * LP3 usage can cause vblank interrupts to be lost.
+	 * The DEIIR bit will go high but it looks like the CPU
+	 * never gets interrupted.
+	 *
+	 * It's not clear whether other interrupt source could
+	 * be affected or if this is somehow limited to vblank
+	 * interrupts only. To play it safe we disable LP3
+	 * watermarks entirely.
+	 */
+	if (dev_priv->wm.pri_latency[3] == 0 &&
+	    dev_priv->wm.spr_latency[3] == 0 &&
+	    dev_priv->wm.cur_latency[3] == 0)
+		return;
+
+	dev_priv->wm.pri_latency[3] = 0;
+	dev_priv->wm.spr_latency[3] = 0;
+	dev_priv->wm.cur_latency[3] = 0;
+
+	DRM_DEBUG_KMS("LP3 watermarks disabled due to potential for lost interrupts\n");
+	intel_print_wm_latency(dev_priv, "Primary", dev_priv->wm.pri_latency);
+	intel_print_wm_latency(dev_priv, "Sprite", dev_priv->wm.spr_latency);
+	intel_print_wm_latency(dev_priv, "Cursor", dev_priv->wm.cur_latency);
+}
+
 static void ilk_setup_wm_latency(struct drm_i915_private *dev_priv)
 {
 	intel_read_wm_latency(dev_priv, dev_priv->wm.pri_latency);
@@ -2997,8 +3034,10 @@ static void ilk_setup_wm_latency(struct drm_i915_private *dev_priv)
 	intel_print_wm_latency(dev_priv, "Sprite", dev_priv->wm.spr_latency);
 	intel_print_wm_latency(dev_priv, "Cursor", dev_priv->wm.cur_latency);
 
-	if (IS_GEN6(dev_priv))
+	if (IS_GEN6(dev_priv)) {
 		snb_wm_latency_quirk(dev_priv);
+		snb_wm_lp3_irq_quirk(dev_priv);
+	}
 }
 
 static void skl_setup_wm_latency(struct drm_i915_private *dev_priv)
-- 
2.20.1




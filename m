Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C882D5CBED
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGBICi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfGBICh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:02:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5946121479;
        Tue,  2 Jul 2019 08:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054556;
        bh=YLybbvL9M6RRhW5r/YxqFi+T2dcoLjxgCxub5e70VsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i40232cyCHBjH/2uqV3+DCjDcvOz/XCGptAEWUer5htCq2LvfdO+Nv/FbyWztUPgY
         JiQvdrIZkab8a8rhrnASCegvI8sXDnnIWaIFZgXrtjg+kLd6fT+avn8xQKjqFOIPWe
         AD52lKo792eCaJOw1TEsgZPCRMNbiL65iCwM7sV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH 5.1 10/55] drm/i915: Save the old CDCLK atomic state
Date:   Tue,  2 Jul 2019 10:01:18 +0200
Message-Id: <20190702080124.558446997@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 48d9f87ddd2108663fd866b254e05d422243cc56 upstream.

The old state will be needed by an upcoming patch to determine if the
commit increases or decreases CDCLK, so move the old state to the atomic
state (while keeping the new one in dev_priv). cdclk.logical and
cdclk.actual in the atomic state isn't used atm anywhere after the
atomic check phase, so this should be safe.

v2:
- Use swap() instead of opencoding it. (Ville)

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190320135439.12201-2-imre.deak@intel.com
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_cdclk.c   |   20 ++++++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 drivers/gpu/drm/i915/intel_drv.h     |    1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -2100,6 +2100,26 @@ bool intel_cdclk_changed(const struct in
 		a->voltage_level != b->voltage_level;
 }
 
+/**
+ * intel_cdclk_swap_state - make atomic CDCLK configuration effective
+ * @state: atomic state
+ *
+ * This is the CDCLK version of drm_atomic_helper_swap_state() since the
+ * helper does not handle driver-specific global state.
+ *
+ * Similarly to the atomic helpers this function does a complete swap,
+ * i.e. it also puts the old state into @state. This is used by the commit
+ * code to determine how CDCLK has changed (for instance did it increase or
+ * decrease).
+ */
+void intel_cdclk_swap_state(struct intel_atomic_state *state)
+{
+	struct drm_i915_private *dev_priv = to_i915(state->base.dev);
+
+	swap(state->cdclk.logical, dev_priv->cdclk.logical);
+	swap(state->cdclk.actual, dev_priv->cdclk.actual);
+}
+
 void intel_dump_cdclk_state(const struct intel_cdclk_state *cdclk_state,
 			    const char *context)
 {
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -13483,10 +13483,10 @@ static int intel_atomic_commit(struct dr
 		       intel_state->min_voltage_level,
 		       sizeof(intel_state->min_voltage_level));
 		dev_priv->active_crtcs = intel_state->active_crtcs;
-		dev_priv->cdclk.logical = intel_state->cdclk.logical;
-		dev_priv->cdclk.actual = intel_state->cdclk.actual;
 		dev_priv->cdclk.force_min_cdclk =
 			intel_state->cdclk.force_min_cdclk;
+
+		intel_cdclk_swap_state(intel_state);
 	}
 
 	drm_atomic_state_get(state);
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -1597,6 +1597,7 @@ bool intel_cdclk_needs_modeset(const str
 			       const struct intel_cdclk_state *b);
 bool intel_cdclk_changed(const struct intel_cdclk_state *a,
 			 const struct intel_cdclk_state *b);
+void intel_cdclk_swap_state(struct intel_atomic_state *state);
 void intel_set_cdclk(struct drm_i915_private *dev_priv,
 		     const struct intel_cdclk_state *cdclk_state);
 void intel_dump_cdclk_state(const struct intel_cdclk_state *cdclk_state,



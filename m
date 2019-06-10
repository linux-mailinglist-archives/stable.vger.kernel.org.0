Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E743AEDC
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 08:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbfFJGDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 02:03:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44665 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387614AbfFJGDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 02:03:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so4617664pfe.11
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 23:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RluknKncRwyoAwkY/RPFqx+kwEkFuwov93vQEe4X2RQ=;
        b=gPbJwk5OoJolHV0ncW9C225DsBV/mxQp5+T1SzgTTtboThz7AQ7eQTvAwPDn3V9taJ
         4MjezeKRSi0N3qQQ5LsLQeuJlwvPyTOQ2QAb0HfX6hDw+tydDtAFRVTAbAnFIKyrTQ7R
         LLUiwQRB21ZvI3ofe6NEo8Q62PQq4548O6y7ujg26ngFDZXeU7WNDyKELDn3YAczcrOA
         cvmyRl2CBjxbR9Asc1Ti3McVB5iQhngr54L8snTyKzN7/ZIC8y9HmCRmAw//y4Xf4rG1
         nYOs2I5O+ewGtIsFF1xbCvcTxVINw7ssO4QKp7FJfvKt5mGVFtx4npZomaUp0hLvxb8o
         gWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RluknKncRwyoAwkY/RPFqx+kwEkFuwov93vQEe4X2RQ=;
        b=mqbxvkby6E/gOiIwgg7VZPWm3PhyMXRD1EFK25GWRJ0hJSlR0lNd3PlcrBGcdo+N06
         h5oU5GqTXwA+6QStDwy3xp65JSCXPDs5381/cGnlwJ/vvQZJ/aaf3Maqyly0CPc66KCW
         4uIzNYce7MCFe79QRIczPILweYv08mK27Ddxec13d44BxvVjhY4o0gKzkSKzPanQPzOo
         J42A/FutbLiB8TKrTW69xuOJaWIfIAa3dDfKHODH1WLqzyR4/dfGiSU9V9tpnd1QFW3+
         gJ3P+oqa7yN8ipc5v4qUgUwQDQFzS9+Zh+04p+qiWDVgrtVIG9xWOZubh4/PLAkYSquw
         E2XA==
X-Gm-Message-State: APjAAAVcVl9UK0xWx8yDfi6pR+8GluIwLHTt6Z/RcfqdoGAdabdoXvlU
        hNGYZWlTrZg3/33Irr1Xv2lXnaXaKm7axbkJz1odUjEyq1vktc/5juBmL2NqmlR78y9ISD1NdjO
        Hmgg4jPi68danHi7SLsurbWmFA6i4tV57ZcF6SO5R8DNP6l+fDcENYe3ndj6BzazALEmhuJqMQw
        ==
X-Google-Smtp-Source: APXvYqyGp7/M5uvKcY11Zev36HrWFI83zg4LFjOM8q7dDyZbZuQtUEaW6H459byrO3TMnJ8UNNYY+w==
X-Received: by 2002:aa7:9825:: with SMTP id q5mr34955122pfl.140.1560146628986;
        Sun, 09 Jun 2019 23:03:48 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id x17sm8914263pgk.72.2019.06.09.23.03.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 23:03:48 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     stable@vger.kernel.org
Cc:     linux@endlessm.com, hui.wang@canonical.com,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 1/3] drm/i915: Save the old CDCLK atomic state
Date:   Mon, 10 Jun 2019 14:01:41 +0800
Message-Id: <20190610060141.5377-2-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190603100938.5414-1-jian-hong@endlessm.com>
References: <20190603100938.5414-1-jian-hong@endlessm.com>
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
Cc: <stable@vger.kernel.org> # 5.1.x
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 drivers/gpu/drm/i915/intel_cdclk.c   | 20 ++++++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |  4 ++--
 drivers/gpu/drm/i915/intel_drv.h     |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_cdclk.c b/drivers/gpu/drm/i915/intel_cdclk.c
index 553f57ff60f4..9814a6f2b3c4 100644
--- a/drivers/gpu/drm/i915/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/intel_cdclk.c
@@ -2100,6 +2100,26 @@ bool intel_cdclk_changed(const struct intel_cdclk_state *a,
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
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index ebbac873b8f4..dd1a059cf850 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -13459,10 +13459,10 @@ static int intel_atomic_commit(struct drm_device *dev,
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
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 539caca05da4..a9183579700d 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -1597,6 +1597,7 @@ bool intel_cdclk_needs_modeset(const struct intel_cdclk_state *a,
 			       const struct intel_cdclk_state *b);
 bool intel_cdclk_changed(const struct intel_cdclk_state *a,
 			 const struct intel_cdclk_state *b);
+void intel_cdclk_swap_state(struct intel_atomic_state *state);
 void intel_set_cdclk(struct drm_i915_private *dev_priv,
 		     const struct intel_cdclk_state *cdclk_state);
 void intel_dump_cdclk_state(const struct intel_cdclk_state *cdclk_state,
-- 
2.22.0


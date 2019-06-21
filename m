Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2474E56E
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfFUKIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 06:08:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34448 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfFUKIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 06:08:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so3155983pgn.1
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 03:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y8qi6cRMTaV2ydTC37GcB52WR88M7sSZMs4v+MBKaG0=;
        b=wehBTx4UZZY9oDxQm4anEBEVrQGgV0ZW1SrymmABii2/KUi484IPf9WirZ9l9C9h8l
         7pfctWOO0Z0H7Pt/8e15VO4XHnbDbN7E7+HlMI4leGtg4Dip+1zA2Vwg976HMxLN5KHL
         8f7iw9lyP7IcEmXjttlNUuuw7x2Ra+9fDvsoOpWQo0J8ELlFzIapZ+l0zHsV1rrGdhjl
         CxhC8tPXfINU3mwiQMZV14eGAXO4GVQ+Q72zEFf7rm05x2yFbpqr3SRkyAeWWkEOrxGD
         n4ecmSO510pSUwXDJei7gQDpKOo+428YyTVjXMYYl7Z3olJiW4sS9n7f32nQcgf2rOmT
         h5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y8qi6cRMTaV2ydTC37GcB52WR88M7sSZMs4v+MBKaG0=;
        b=H7oChmsbq/w9KbOTecvdiRch5O/4u+oh/OxLUjWeQmGCMbTn5QCIUlpPxdtuT7nQHU
         DUu2P712qltAWpg/7f6YPWVB/2eDAjtJMxzh3q2TVKbxmvqX7BUokkagr/+wukXp05fB
         gsLB/E9DVIXb9YzX/MRCWMLunr9854Yc7AggIkDiWTAKovArh+NQlPjtPHCHp3dUF3Pt
         V6EvbSNVrDPb4bLX1eoQqfGbSp0K4TAQgZ6e8lsiZHF9eC5OU0WkbTdXHa2acc8+A/H+
         d5km5bX1XI+emIS55gQrLMZ2x39b2z5Sxy+1A38k+wgE7DSa3qZackVOa653gqlHrIQK
         RsAw==
X-Gm-Message-State: APjAAAW4EkEf4PcWmoK6hIPauA1qD6XH3LlfY//7MuZ9dKKy2OGolKfk
        a1y5ALQO+RPhKHpl/2jJgkPA8Q==
X-Google-Smtp-Source: APXvYqymcbxCOfAZfgXm/UUnTSM4dKyOTpsTelVZZd/xSeqDH2hgAo5c7lrY5dOvdJazoE8dHpZevg==
X-Received: by 2002:a63:c006:: with SMTP id h6mr17213826pgg.285.1561111700352;
        Fri, 21 Jun 2019 03:08:20 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id c18sm2246892pfc.180.2019.06.21.03.08.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 03:08:19 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>, tiwai@suse.de,
        hui.wang@canonical.com, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH stable-5.1 v2 2/4] drm/i915: Save the old CDCLK atomic state
Date:   Fri, 21 Jun 2019 18:07:15 +0800
Message-Id: <20190621100716.8032-3-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190621100716.8032-1-jian-hong@endlessm.com>
References: <20190620141949.GD9832@kroah.com>
 <20190621100716.8032-1-jian-hong@endlessm.com>
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
index 1d7f750ad809..fb2a23830325 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -13463,10 +13463,10 @@ static int intel_atomic_commit(struct drm_device *dev,
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
index 824935b87a12..2a11dfc28a2a 100644
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


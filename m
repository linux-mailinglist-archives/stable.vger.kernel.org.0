Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CA7508B9
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbfFXKWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731112AbfFXKWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:22:23 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C2620645;
        Mon, 24 Jun 2019 10:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371742;
        bh=RX7MLUApaT4+8PU8oDqfpy7H8E4VhA3vs1vfH6SmPaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V70GXWzaKfKfhoyxL9IhJeiJY0TaG/JXNPrexqThHyaudZ64dNiI/s0F2TMUjX80W
         u9bvidH6Tz2Ii7Ep3fKihrhMK4EbGahPp1rYEKtxn6kJV99/OwfKIDMAkYBjnSfHGK
         StvKRR8FCNh+2/v6SOI9cLMp2hsjyLHaWOUGJ9rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Blubberbub@protonmail.com,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.1 107/121] drm/i915: Dont clobber M/N values during fastset check
Date:   Mon, 24 Jun 2019 17:57:19 +0800
Message-Id: <20190624092326.157730257@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 475df5d0f3eb2d031e4505f84d8fba75baaf2e80 upstream.

We're now calling intel_pipe_config_compare(..., true) uncoditionally
which means we're always going clobber the calculated M/N values with
the old values if the fuzzy M/N check passes. That causes problems
because the fuzzy check allows for a huge difference in the values.

I'm actually tempted to just make the M/N checks exact, but that might
prevent fastboot from kicking in when people want it. So for now let's
overwrite the computed values with the old values only if decide to skip
the modeset.

v2: Copy has_drrs along with M/N M2/N2 values

Cc: stable@vger.kernel.org
Cc: Blubberbub@protonmail.com
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Tested-by: Blubberbub@protonmail.com
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110782
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110675
Fixes: d19f958db23c ("drm/i915: Enable fastset for non-boot modesets.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190612172423.25231-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f0521558a2a89d58a08745e225025d338572e60a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190619120929.4057-1-ville.syrjala@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   38 ++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11820,9 +11820,6 @@ intel_compare_link_m_n(const struct inte
 			      m2_n2->gmch_m, m2_n2->gmch_n, !adjust) &&
 	    intel_compare_m_n(m_n->link_m, m_n->link_n,
 			      m2_n2->link_m, m2_n2->link_n, !adjust)) {
-		if (adjust)
-			*m2_n2 = *m_n;
-
 		return true;
 	}
 
@@ -12855,6 +12852,33 @@ static int calc_watermark_data(struct in
 	return 0;
 }
 
+static void intel_crtc_check_fastset(struct intel_crtc_state *old_crtc_state,
+				     struct intel_crtc_state *new_crtc_state)
+{
+	struct drm_i915_private *dev_priv =
+		to_i915(new_crtc_state->base.crtc->dev);
+
+	if (!intel_pipe_config_compare(dev_priv, old_crtc_state,
+				       new_crtc_state, true))
+		return;
+
+	new_crtc_state->base.mode_changed = false;
+	new_crtc_state->update_pipe = true;
+
+	/*
+	 * If we're not doing the full modeset we want to
+	 * keep the current M/N values as they may be
+	 * sufficiently different to the computed values
+	 * to cause problems.
+	 *
+	 * FIXME: should really copy more fuzzy state here
+	 */
+	new_crtc_state->fdi_m_n = old_crtc_state->fdi_m_n;
+	new_crtc_state->dp_m_n = old_crtc_state->dp_m_n;
+	new_crtc_state->dp_m2_n2 = old_crtc_state->dp_m2_n2;
+	new_crtc_state->has_drrs = old_crtc_state->has_drrs;
+}
+
 /**
  * intel_atomic_check - validate state object
  * @dev: drm device
@@ -12903,12 +12927,8 @@ static int intel_atomic_check(struct drm
 			return ret;
 		}
 
-		if (intel_pipe_config_compare(dev_priv,
-					to_intel_crtc_state(old_crtc_state),
-					pipe_config, true)) {
-			crtc_state->mode_changed = false;
-			pipe_config->update_pipe = true;
-		}
+		intel_crtc_check_fastset(to_intel_crtc_state(old_crtc_state),
+					 pipe_config);
 
 		if (needs_modeset(crtc_state))
 			any_ms = true;



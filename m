Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865B3492C6
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfFQVXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbfFQVXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B2DE206B7;
        Mon, 17 Jun 2019 21:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806615;
        bh=B1zwTSDONWABOLKYkfAxJ8lPwHHjtB7Eafy5TrOALlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPc4UpA7kZRGR2uGiG0BlWe6Bl+2DXv8rKLaLFA9njoZyXOQtNwBS5HyyaqurYOIY
         tiOSFmyMZYjstfvzmmsZEFMGCxMv6EbV1Ofw5WDQbD4OtPDJmWEQ04Dv9Dc8Nra7Yt
         sOe6eh2gojsj6zUuP0PKgjstfw2J9hTZD8B+bkj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Wise <pabs3@bonedaddy.net>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Harish Chegondi <harish.chegondi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.1 113/115] drm: add fallback override/firmware EDID modes workaround
Date:   Mon, 17 Jun 2019 23:10:13 +0200
Message-Id: <20190617210805.622907792@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 48eaeb7664c76139438724d520a1ea4a84a3ed92 upstream.

We've moved the override and firmware EDID (simply "override EDID" from
now on) handling to the low level drm_do_get_edid() function in order to
transparently use the override throughout the stack. The idea is that
you get the override EDID via the ->get_modes() hook.

Unfortunately, there are scenarios where the DDC probe in drm_get_edid()
called via ->get_modes() fails, although the preceding ->detect()
succeeds.

In the case reported by Paul Wise, the ->detect() hook,
intel_crt_detect(), relies on hotplug detect, bypassing the DDC. In the
case reported by Ilpo Järvinen, there is no ->detect() hook, which is
interpreted as connected. The subsequent DDC probe reached via
->get_modes() fails, and we don't even look at the override EDID,
resulting in no modes being added.

Because drm_get_edid() is used via ->detect() all over the place, we
can't trivially remove the DDC probe, as it leads to override EDID
effectively meaning connector forcing. The goal is that connector
forcing and override EDID remain orthogonal.

Generally, the underlying problem here is the conflation of ->detect()
and ->get_modes() via drm_get_edid(). The former should just detect, and
the latter should just get the modes, typically via reading the EDID. As
long as drm_get_edid() is used in ->detect(), it needs to retain the DDC
probe. Or such users need to have a separate DDC probe step first.

The EDID caching between ->detect() and ->get_modes() done by some
drivers is a further complication that prevents us from making
drm_do_get_edid() adapt to the two cases.

Work around the regression by falling back to a separate attempt at
getting the override EDID at drm_helper_probe_single_connector_modes()
level. With a working DDC and override EDID, it'll never be called; the
override EDID will come via ->get_modes(). There will still be a failing
DDC probe attempt in the cases that require the fallback.

v2:
- Call drm_connector_update_edid_property (Paul)
- Update commit message about EDID caching (Daniel)

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=107583
Reported-by: Paul Wise <pabs3@bonedaddy.net>
Cc: Paul Wise <pabs3@bonedaddy.net>
Reported-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
Cc: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: 53fd40a90f3c ("drm: handle override and firmware EDID at drm_do_get_edid() level")
Cc: <stable@vger.kernel.org> # v4.15+ 56a2b7f2a39a drm/edid: abstract override/firmware EDID retrieval
Cc: <stable@vger.kernel.org> # v4.15+
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Harish Chegondi <harish.chegondi@intel.com>
Tested-by: Paul Wise <pabs3@bonedaddy.net>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610093054.28445-1-jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c         |   30 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_probe_helper.c |    7 +++++++
 include/drm/drm_edid.h             |    1 +
 3 files changed, 38 insertions(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1595,6 +1595,36 @@ static struct edid *drm_get_override_edi
 }
 
 /**
+ * drm_add_override_edid_modes - add modes from override/firmware EDID
+ * @connector: connector we're probing
+ *
+ * Add modes from the override/firmware EDID, if available. Only to be used from
+ * drm_helper_probe_single_connector_modes() as a fallback for when DDC probe
+ * failed during drm_get_edid() and caused the override/firmware EDID to be
+ * skipped.
+ *
+ * Return: The number of modes added or 0 if we couldn't find any.
+ */
+int drm_add_override_edid_modes(struct drm_connector *connector)
+{
+	struct edid *override;
+	int num_modes = 0;
+
+	override = drm_get_override_edid(connector);
+	if (override) {
+		drm_connector_update_edid_property(connector, override);
+		num_modes = drm_add_edid_modes(connector, override);
+		kfree(override);
+
+		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] adding %d modes via fallback override/firmware EDID\n",
+			      connector->base.id, connector->name, num_modes);
+	}
+
+	return num_modes;
+}
+EXPORT_SYMBOL(drm_add_override_edid_modes);
+
+/**
  * drm_do_get_edid - get EDID data using a custom EDID block read function
  * @connector: connector we're probing
  * @get_edid_block: EDID block read function
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -479,6 +479,13 @@ retry:
 
 	count = (*connector_funcs->get_modes)(connector);
 
+	/*
+	 * Fallback for when DDC probe failed in drm_get_edid() and thus skipped
+	 * override/firmware EDID.
+	 */
+	if (count == 0 && connector->status == connector_status_connected)
+		count = drm_add_override_edid_modes(connector);
+
 	if (count == 0 && connector->status == connector_status_connected)
 		count = drm_add_modes_noedid(connector, 1024, 768);
 	count += drm_helper_probe_add_cmdline_mode(connector);
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -465,6 +465,7 @@ struct edid *drm_get_edid_switcheroo(str
 				     struct i2c_adapter *adapter);
 struct edid *drm_edid_duplicate(const struct edid *edid);
 int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid);
+int drm_add_override_edid_modes(struct drm_connector *connector);
 
 u8 drm_match_cea_mode(const struct drm_display_mode *to_match);
 enum hdmi_picture_aspect drm_get_cea_aspect_ratio(const u8 video_code);



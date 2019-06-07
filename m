Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3673638861
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 13:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfFGLCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 07:02:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:43682 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbfFGLCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 07:02:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 04:02:17 -0700
X-ExtLoop1: 1
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.150])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jun 2019 04:02:15 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     jani.nikula@intel.com, Paul Wise <pabs3@bonedaddy.net>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Harish Chegondi <harish.chegondi@intel.com>
Subject: [PATCH 2/2] drm: add fallback override/firmware EDID modes workaround
Date:   Fri,  7 Jun 2019 14:05:13 +0300
Message-Id: <20190607110513.12072-2-jani.nikula@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607110513.12072-1-jani.nikula@intel.com>
References: <20190607110513.12072-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Work around the regression by falling back to a separate attempt at
getting the override EDID at drm_helper_probe_single_connector_modes()
level. With a working DDC and override EDID, it'll never be called; the
override EDID will come via ->get_modes(). There will still be a failing
DDC probe attempt in the cases that require the fallback.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=107583
Reported-by: Paul Wise <pabs3@bonedaddy.net>
Cc: Paul Wise <pabs3@bonedaddy.net>
References: http://mid.mail-archive.com/alpine.DEB.2.20.1905262211270.24390@whs-18.cs.helsinki.fi
Reported-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
Cc: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
References: 15f080f08d48 ("drm/edid: respect connector force for drm_get_edid ddc probe")
Fixes: 53fd40a90f3c ("drm: handle override and firmware EDID at drm_do_get_edid() level")
Cc: <stable@vger.kernel.org> # v4.15+
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Harish Chegondi <harish.chegondi@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/drm_edid.c         | 29 +++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_probe_helper.c |  7 +++++++
 include/drm/drm_edid.h             |  1 +
 3 files changed, 37 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index c59a1e8c5ada..780146bfc225 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1587,6 +1587,35 @@ static struct edid *drm_get_override_edid(struct drm_connector *connector)
 	return IS_ERR(override) ? NULL : override;
 }
 
+/**
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
 /**
  * drm_do_get_edid - get EDID data using a custom EDID block read function
  * @connector: connector we're probing
diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index 01e243f1ea94..ef2c468205a2 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -480,6 +480,13 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
 
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
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 88b63801f9db..b9719418c3d2 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -478,6 +478,7 @@ struct edid *drm_get_edid_switcheroo(struct drm_connector *connector,
 				     struct i2c_adapter *adapter);
 struct edid *drm_edid_duplicate(const struct edid *edid);
 int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid);
+int drm_add_override_edid_modes(struct drm_connector *connector);
 
 u8 drm_match_cea_mode(const struct drm_display_mode *to_match);
 enum hdmi_picture_aspect drm_get_cea_aspect_ratio(const u8 video_code);
-- 
2.20.1


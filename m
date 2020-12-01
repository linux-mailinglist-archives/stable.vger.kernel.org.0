Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA2F2C9CC0
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388312AbgLAJA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388292AbgLAJAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:00:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B721321D46;
        Tue,  1 Dec 2020 08:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813183;
        bh=YI6A7sftMWw/if5lhDOT60C0VudP2xl6cBIz11hy188=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=weBhWq8PQU492RXY5sxIdnlICfjAqdTh7bftylK4pQgMHdWJncu7TG47lnNtVgPzT
         u27eSy9NO63mIDt4DZF2FNCE1obzvOG7lfbyiksc5TuP3TUooIXaLrRQd8v2MLosc6
         WSgJqrkBgnNs1yKMUfNZC5YT21vP1i/PmmDI6+gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>, Lyude Paul <lyude@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>
Subject: [PATCH 4.19 11/57] drm/atomic_helper: Stop modesets on unregistered connectors harder
Date:   Tue,  1 Dec 2020 09:53:16 +0100
Message-Id: <20201201084648.982712007@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit de9f8eea5a44b0b756d3d6345af7f8e630a3c8c0 upstream.

Unfortunately, it appears our fix in:
commit b5d29843d8ef ("drm/atomic_helper: Allow DPMS On<->Off changes
for unregistered connectors")

Which attempted to work around the problems introduced by:
commit 4d80273976bf ("drm/atomic_helper: Disallow new modesets on
unregistered connectors")

Is still not the right solution, as modesets can still be triggered
outside of drm_atomic_set_crtc_for_connector().

So in order to fix this, while still being careful that we don't break
modesets that a driver may perform before being registered with
userspace, we replace connector->registered with a tristate member,
connector->registration_state. This allows us to keep track of whether
or not a connector is still initializing and hasn't been exposed to
userspace, is currently registered and exposed to userspace, or has been
legitimately removed from the system after having once been present.

Using this info, we can prevent userspace from performing new modesets
on unregistered connectors while still allowing the driver to perform
modesets on unregistered connectors before the driver has finished being
registered.

Changes since v1:
- Fix WARN_ON() in drm_connector_cleanup() that CI caught with this
  patchset in igt@drv_module_reload@basic-reload-inject and
  igt@drv_module_reload@basic-reload by checking if the connector is
  registered instead of unregistered, as calling drm_connector_cleanup()
  on a connector that hasn't been registered with userspace yet should
  stay valid.
- Remove unregistered_connector_check(), and just go back to what we
  were doing before in commit 4d80273976bf ("drm/atomic_helper: Disallow
  new modesets on unregistered connectors") except replacing
  READ_ONCE(connector->registered) with drm_connector_is_unregistered().
  This gets rid of the behavior of allowing DPMS On<->Off, but that should
  be fine as it's more consistent with the UAPI we had before - danvet
- s/drm_connector_unregistered/drm_connector_is_unregistered/ - danvet
- Update documentation, fix some typos.

Fixes: b5d29843d8ef ("drm/atomic_helper: Allow DPMS On<->Off changes for unregistered connectors")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: stable@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20181016203946.9601-1-lyude@redhat.com
(cherry picked from commit 39b50c603878f4f8ae541ac4088a805d588abc79)
Fixes: e96550956fbc ("drm/atomic_helper: Disallow new modesets on unregistered connectors")
Fixes: 34ca26a98ad6 ("drm/atomic_helper: Allow DPMS On<->Off changes for unregistered connectors")
Cc: stable@vger.kernel.org
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/drm_atomic.c        |   21 ----------
 drivers/gpu/drm/drm_atomic_helper.c |   21 ++++++++++
 drivers/gpu/drm/drm_connector.c     |   11 +++--
 drivers/gpu/drm/i915/intel_dp_mst.c |    8 ++--
 include/drm/drm_connector.h         |   71 ++++++++++++++++++++++++++++++++++--
 5 files changed, 99 insertions(+), 33 deletions(-)

--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1702,27 +1702,6 @@ drm_atomic_set_crtc_for_connector(struct
 	struct drm_connector *connector = conn_state->connector;
 	struct drm_crtc_state *crtc_state;
 
-	/*
-	 * For compatibility with legacy users, we want to make sure that
-	 * we allow DPMS On<->Off modesets on unregistered connectors, since
-	 * legacy modesetting users will not be expecting these to fail. We do
-	 * not however, want to allow legacy users to assign a connector
-	 * that's been unregistered from sysfs to another CRTC, since doing
-	 * this with a now non-existent connector could potentially leave us
-	 * in an invalid state.
-	 *
-	 * Since the connector can be unregistered at any point during an
-	 * atomic check or commit, this is racy. But that's OK: all we care
-	 * about is ensuring that userspace can't use this connector for new
-	 * configurations after it's been notified that the connector is no
-	 * longer present.
-	 */
-	if (!READ_ONCE(connector->registered) && crtc) {
-		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] is not registered\n",
-				 connector->base.id, connector->name);
-		return -EINVAL;
-	}
-
 	if (conn_state->crtc == crtc)
 		return 0;
 
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -307,6 +307,26 @@ update_connector_routing(struct drm_atom
 		return 0;
 	}
 
+	crtc_state = drm_atomic_get_new_crtc_state(state,
+						   new_connector_state->crtc);
+	/*
+	 * For compatibility with legacy users, we want to make sure that
+	 * we allow DPMS On->Off modesets on unregistered connectors. Modesets
+	 * which would result in anything else must be considered invalid, to
+	 * avoid turning on new displays on dead connectors.
+	 *
+	 * Since the connector can be unregistered at any point during an
+	 * atomic check or commit, this is racy. But that's OK: all we care
+	 * about is ensuring that userspace can't do anything but shut off the
+	 * display on a connector that was destroyed after its been notified,
+	 * not before.
+	 */
+	if (drm_connector_is_unregistered(connector) && crtc_state->active) {
+		DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] is not registered\n",
+				 connector->base.id, connector->name);
+		return -EINVAL;
+	}
+
 	funcs = connector->helper_private;
 
 	if (funcs->atomic_best_encoder)
@@ -351,7 +371,6 @@ update_connector_routing(struct drm_atom
 
 	set_best_encoder(state, new_connector_state, new_encoder);
 
-	crtc_state = drm_atomic_get_new_crtc_state(state, new_connector_state->crtc);
 	crtc_state->connectors_changed = true;
 
 	DRM_DEBUG_ATOMIC("[CONNECTOR:%d:%s] using [ENCODER:%d:%s] on [CRTC:%d:%s]\n",
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -375,7 +375,8 @@ void drm_connector_cleanup(struct drm_co
 	/* The connector should have been removed from userspace long before
 	 * it is finally destroyed.
 	 */
-	if (WARN_ON(connector->registered))
+	if (WARN_ON(connector->registration_state ==
+		    DRM_CONNECTOR_REGISTERED))
 		drm_connector_unregister(connector);
 
 	if (connector->tile_group) {
@@ -432,7 +433,7 @@ int drm_connector_register(struct drm_co
 		return 0;
 
 	mutex_lock(&connector->mutex);
-	if (connector->registered)
+	if (connector->registration_state != DRM_CONNECTOR_INITIALIZING)
 		goto unlock;
 
 	ret = drm_sysfs_connector_add(connector);
@@ -452,7 +453,7 @@ int drm_connector_register(struct drm_co
 
 	drm_mode_object_register(connector->dev, &connector->base);
 
-	connector->registered = true;
+	connector->registration_state = DRM_CONNECTOR_REGISTERED;
 	goto unlock;
 
 err_debugfs:
@@ -474,7 +475,7 @@ EXPORT_SYMBOL(drm_connector_register);
 void drm_connector_unregister(struct drm_connector *connector)
 {
 	mutex_lock(&connector->mutex);
-	if (!connector->registered) {
+	if (connector->registration_state != DRM_CONNECTOR_REGISTERED) {
 		mutex_unlock(&connector->mutex);
 		return;
 	}
@@ -485,7 +486,7 @@ void drm_connector_unregister(struct drm
 	drm_sysfs_connector_remove(connector);
 	drm_debugfs_connector_remove(connector);
 
-	connector->registered = false;
+	connector->registration_state = DRM_CONNECTOR_UNREGISTERED;
 	mutex_unlock(&connector->mutex);
 }
 EXPORT_SYMBOL(drm_connector_unregister);
--- a/drivers/gpu/drm/i915/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/intel_dp_mst.c
@@ -77,7 +77,7 @@ static bool intel_dp_mst_compute_config(
 	pipe_config->pbn = mst_pbn;
 
 	/* Zombie connectors can't have VCPI slots */
-	if (READ_ONCE(connector->registered)) {
+	if (!drm_connector_is_unregistered(connector)) {
 		slots = drm_dp_atomic_find_vcpi_slots(state,
 						      &intel_dp->mst_mgr,
 						      port,
@@ -317,7 +317,7 @@ static int intel_dp_mst_get_ddc_modes(st
 	struct edid *edid;
 	int ret;
 
-	if (!READ_ONCE(connector->registered))
+	if (drm_connector_is_unregistered(connector))
 		return intel_connector_update_modes(connector, NULL);
 
 	edid = drm_dp_mst_get_edid(connector, &intel_dp->mst_mgr, intel_connector->port);
@@ -333,7 +333,7 @@ intel_dp_mst_detect(struct drm_connector
 	struct intel_connector *intel_connector = to_intel_connector(connector);
 	struct intel_dp *intel_dp = intel_connector->mst_port;
 
-	if (!READ_ONCE(connector->registered))
+	if (drm_connector_is_unregistered(connector))
 		return connector_status_disconnected;
 	return drm_dp_mst_detect_port(connector, &intel_dp->mst_mgr,
 				      intel_connector->port);
@@ -376,7 +376,7 @@ intel_dp_mst_mode_valid(struct drm_conne
 	int bpp = 24; /* MST uses fixed bpp */
 	int max_rate, mode_rate, max_lanes, max_link_clock;
 
-	if (!READ_ONCE(connector->registered))
+	if (drm_connector_is_unregistered(connector))
 		return MODE_ERROR;
 
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -81,6 +81,53 @@ enum drm_connector_status {
 	connector_status_unknown = 3,
 };
 
+/**
+ * enum drm_connector_registration_status - userspace registration status for
+ * a &drm_connector
+ *
+ * This enum is used to track the status of initializing a connector and
+ * registering it with userspace, so that DRM can prevent bogus modesets on
+ * connectors that no longer exist.
+ */
+enum drm_connector_registration_state {
+	/**
+	 * @DRM_CONNECTOR_INITIALIZING: The connector has just been created,
+	 * but has yet to be exposed to userspace. There should be no
+	 * additional restrictions to how the state of this connector may be
+	 * modified.
+	 */
+	DRM_CONNECTOR_INITIALIZING = 0,
+
+	/**
+	 * @DRM_CONNECTOR_REGISTERED: The connector has been fully initialized
+	 * and registered with sysfs, as such it has been exposed to
+	 * userspace. There should be no additional restrictions to how the
+	 * state of this connector may be modified.
+	 */
+	DRM_CONNECTOR_REGISTERED = 1,
+
+	/**
+	 * @DRM_CONNECTOR_UNREGISTERED: The connector has either been exposed
+	 * to userspace and has since been unregistered and removed from
+	 * userspace, or the connector was unregistered before it had a chance
+	 * to be exposed to userspace (e.g. still in the
+	 * @DRM_CONNECTOR_INITIALIZING state). When a connector is
+	 * unregistered, there are additional restrictions to how its state
+	 * may be modified:
+	 *
+	 * - An unregistered connector may only have its DPMS changed from
+	 *   On->Off. Once DPMS is changed to Off, it may not be switched back
+	 *   to On.
+	 * - Modesets are not allowed on unregistered connectors, unless they
+	 *   would result in disabling its assigned CRTCs. This means
+	 *   disabling a CRTC on an unregistered connector is OK, but enabling
+	 *   one is not.
+	 * - Removing a CRTC from an unregistered connector is OK, but new
+	 *   CRTCs may never be assigned to an unregistered connector.
+	 */
+	DRM_CONNECTOR_UNREGISTERED = 2,
+};
+
 enum subpixel_order {
 	SubPixelUnknown = 0,
 	SubPixelHorizontalRGB,
@@ -852,10 +899,12 @@ struct drm_connector {
 	bool ycbcr_420_allowed;
 
 	/**
-	 * @registered: Is this connector exposed (registered) with userspace?
+	 * @registration_state: Is this connector initializing, exposed
+	 * (registered) with userspace, or unregistered?
+	 *
 	 * Protected by @mutex.
 	 */
-	bool registered;
+	enum drm_connector_registration_state registration_state;
 
 	/**
 	 * @modes:
@@ -1165,6 +1214,24 @@ static inline void drm_connector_unrefer
 	drm_connector_put(connector);
 }
 
+/**
+ * drm_connector_is_unregistered - has the connector been unregistered from
+ * userspace?
+ * @connector: DRM connector
+ *
+ * Checks whether or not @connector has been unregistered from userspace.
+ *
+ * Returns:
+ * True if the connector was unregistered, false if the connector is
+ * registered or has not yet been registered with userspace.
+ */
+static inline bool
+drm_connector_is_unregistered(struct drm_connector *connector)
+{
+	return READ_ONCE(connector->registration_state) ==
+		DRM_CONNECTOR_UNREGISTERED;
+}
+
 const char *drm_get_connector_status_name(enum drm_connector_status status);
 const char *drm_get_subpixel_order_name(enum subpixel_order order);
 const char *drm_get_dpms_name(int val);



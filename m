Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AE86B4284
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjCJOEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjCJOED (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:04:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FC7580D4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:03:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66DE6B822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89F5C433EF;
        Fri, 10 Mar 2023 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457025;
        bh=HVBEpbmFeWEwfdNOHrtrFMFHxXtdlzwZ/HMrlECOqdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCbawo5CQDUBF5p1kQbOjvyfDYAskrwylGqP/Y1JB4OHXDpedN3fvdXYeZtI793se
         WaNAlP+o7uj6MfwErogM8D7q5gW2F3BHVDkw4OHVd77oN5WPBZWTQuzQv4DL+BmcvC
         O1THaeGEgS9DMYRcOoMAs5o6utINtZ34D4BuRA2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Daniel Vetter <daniel@ffwll.ch>,
        Wayne Lin <wayne.lin@amd.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.2 205/211] drm/i915/dp_mst: Add the MST topology state for modesetted CRTCs
Date:   Fri, 10 Mar 2023 14:39:45 +0100
Message-Id: <20230310133725.155073247@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 326b1e792ff08b4d8ecb9605aec98e4e5feef56e upstream.

Add the MST topology for a CRTC to the atomic state if the driver
needs to force a modeset on the CRTC after the encoder compute config
functions are called.

Later the MST encoder's disable hook also adds the state, but that isn't
guaranteed to work (since in that hook getting the state may fail, which
can't be handled there). This should fix that, while a later patch fixes
the use of the MST state in the disable hook.

v2: Add missing forward struct declartions, caught by hdrtest.
v3: Factor out intel_dp_mst_add_topology_state_for_connector() used
    later in the patchset.

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # 6.1
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com> # v2
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Lyude Paul <lyude@redhat.com>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230206114856.2665066-1-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    4 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c  |   61 +++++++++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dp_mst.h  |    4 +
 3 files changed, 69 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5950,6 +5950,10 @@ int intel_modeset_all_pipes(struct intel
 		if (ret)
 			return ret;
 
+		ret = intel_dp_mst_add_topology_state_for_crtc(state, crtc);
+		if (ret)
+			return ret;
+
 		ret = intel_atomic_add_affected_planes(state, crtc);
 		if (ret)
 			return ret;
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -1018,3 +1018,64 @@ bool intel_dp_mst_is_slave_trans(const s
 	return crtc_state->mst_master_transcoder != INVALID_TRANSCODER &&
 	       crtc_state->mst_master_transcoder != crtc_state->cpu_transcoder;
 }
+
+/**
+ * intel_dp_mst_add_topology_state_for_connector - add MST topology state for a connector
+ * @state: atomic state
+ * @connector: connector to add the state for
+ * @crtc: the CRTC @connector is attached to
+ *
+ * Add the MST topology state for @connector to @state.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int
+intel_dp_mst_add_topology_state_for_connector(struct intel_atomic_state *state,
+					      struct intel_connector *connector,
+					      struct intel_crtc *crtc)
+{
+	struct drm_dp_mst_topology_state *mst_state;
+
+	if (!connector->mst_port)
+		return 0;
+
+	mst_state = drm_atomic_get_mst_topology_state(&state->base,
+						      &connector->mst_port->mst_mgr);
+	if (IS_ERR(mst_state))
+		return PTR_ERR(mst_state);
+
+	mst_state->pending_crtc_mask |= drm_crtc_mask(&crtc->base);
+
+	return 0;
+}
+
+/**
+ * intel_dp_mst_add_topology_state_for_crtc - add MST topology state for a CRTC
+ * @state: atomic state
+ * @crtc: CRTC to add the state for
+ *
+ * Add the MST topology state for @crtc to @state.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *state,
+					     struct intel_crtc *crtc)
+{
+	struct drm_connector *_connector;
+	struct drm_connector_state *conn_state;
+	int i;
+
+	for_each_new_connector_in_state(&state->base, _connector, conn_state, i) {
+		struct intel_connector *connector = to_intel_connector(_connector);
+		int ret;
+
+		if (conn_state->crtc != &crtc->base)
+			continue;
+
+		ret = intel_dp_mst_add_topology_state_for_connector(state, connector, crtc);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
@@ -8,6 +8,8 @@
 
 #include <linux/types.h>
 
+struct intel_atomic_state;
+struct intel_crtc;
 struct intel_crtc_state;
 struct intel_digital_port;
 struct intel_dp;
@@ -18,5 +20,7 @@ int intel_dp_mst_encoder_active_links(st
 bool intel_dp_mst_is_master_trans(const struct intel_crtc_state *crtc_state);
 bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_state);
 bool intel_dp_mst_source_support(struct intel_dp *intel_dp);
+int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *state,
+					     struct intel_crtc *crtc);
 
 #endif /* __INTEL_DP_MST_H__ */



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0336830EB
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjAaPJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjAaPJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:09:18 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09852552B9
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 07:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675177620; x=1706713620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fs3r3CMd3EsjJLav2ylySIdmlp7P1TFyxKDBPYrnZDU=;
  b=Yp4xXWbTblGEqgZuzTYg+RDTrqa3JqTB5MU/dzbITo8yNWUnPhEXmkmM
   nROk4C7dgR9sIln8nosIYsR5OCOGZbcqyDwMRqHJxj/PgL0sVJc6+SsLT
   8k8pS0cfXSmMqaaAAqmH7g1XME0KuhXQ+mf0yzsKsRo3ZWW4kS85ECtUj
   +38C1SLoXvhsWPeKwTacp8n1wz6cQ0yo3KuljdfbURN7lld3Cuh8d/+Kt
   BeCpVeloMG4JyHHvb39cTHA/Pu1Se8B1nF17AgTWWoEkN2d3XCGd1w/H7
   easd7HFR5FESCzSL1FK4wUhrxi66KZdG9fntfaeCdsgbvg7gbpS8ECoSq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="308205493"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="308205493"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 07:05:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="807155288"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="807155288"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 07:05:51 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH v2 01/17] drm/i915/dp_mst: Add the MST topology state for modesetted CRTCs
Date:   Tue, 31 Jan 2023 17:05:32 +0200
Message-Id: <20230131150548.1614458-2-imre.deak@intel.com>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230131150548.1614458-1-imre.deak@intel.com>
References: <20230131150548.1614458-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_display.c |  4 ++
 drivers/gpu/drm/i915/display/intel_dp_mst.c  | 61 ++++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dp_mst.h  |  4 ++
 3 files changed, 69 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 166662ade593c..38106cf63b3b9 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5936,6 +5936,10 @@ int intel_modeset_all_pipes(struct intel_atomic_state *state,
 		if (ret)
 			return ret;
 
+		ret = intel_dp_mst_add_topology_state_for_crtc(state, crtc);
+		if (ret)
+			return ret;
+
 		ret = intel_atomic_add_affected_planes(state, crtc);
 		if (ret)
 			return ret;
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 8b0e4defa3f10..f3cb12dcfe0a7 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -1223,3 +1223,64 @@ bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_state)
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
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.h b/drivers/gpu/drm/i915/display/intel_dp_mst.h
index f7301de6cdfb3..f1815bb722672 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
@@ -8,6 +8,8 @@
 
 #include <linux/types.h>
 
+struct intel_atomic_state;
+struct intel_crtc;
 struct intel_crtc_state;
 struct intel_digital_port;
 struct intel_dp;
@@ -18,5 +20,7 @@ int intel_dp_mst_encoder_active_links(struct intel_digital_port *dig_port);
 bool intel_dp_mst_is_master_trans(const struct intel_crtc_state *crtc_state);
 bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_state);
 bool intel_dp_mst_source_support(struct intel_dp *intel_dp);
+int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *state,
+					     struct intel_crtc *crtc);
 
 #endif /* __INTEL_DP_MST_H__ */
-- 
2.37.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0418568BC0B
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 12:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjBFLtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 06:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjBFLtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 06:49:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E206F76B
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 03:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675684148; x=1707220148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rIOuk2wr0dRPgQKUm+ykRYb6/cm+SEUHKXBrHy+h2Iw=;
  b=Wyyn2mTU2lm2igfRE6rCLOu7Ap6HeSNkUIF4RhuFXgkteVlF9kE2vzsN
   zphmYOeCJlNDyPCOfn290nsx7z67TVfEgUvgNTPfO+yyN5vuOI3VmFra2
   z97HiD/Vxe6nTHMab736yIYCr8VDucSVqtd8rAxTN4G8GoBiDNuqC602M
   zMnD1G9jJXgFYvqBNChUaD9eHt/xbPpOUHZt5Y5MPEHdmBW8zA+AqYbKI
   SO0/CkfYi4eQYw4J2JUVEAB+1CqDyuJDlKlP1SZygSnYL8Tjk/C6BB29q
   lF4XZ4SHvkwxGYwZ8SW2+O+ewX91FoHDvG0froeMaLFtTL5RTyhHl82H3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="308829069"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="308829069"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 03:49:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="696850358"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="696850358"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 03:49:06 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [CI 4/4] drm/i915/dp_mst: Fix payload removal during output disabling
Date:   Mon,  6 Feb 2023 13:48:56 +0200
Message-Id: <20230206114856.2665066-4-imre.deak@intel.com>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230206114856.2665066-1-imre.deak@intel.com>
References: <20230206114856.2665066-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the correct old/new topology and payload states in
intel_mst_disable_dp(). So far drm_atomic_get_mst_topology_state() it
used returned either the old state, in case the state was added already
earlier during the atomic check phase or otherwise the new state (but
the latter could fail, which can't be handled in the enable/disable
hooks). After the first patch in the patchset, the state should always
get added already during the check phase, so here we can get the
old/new states without a failure.

drm_dp_remove_payload() should use time_slots from the old payload state
and vc_start_slot in the new one. It should update the new payload
states to reflect the sink's current payload table after the payload is
removed. Pass the new topology state and the old and new payload states
accordingly.

This also fixes a problem where the payload allocations for multiple MST
streams on the same link got inconsistent after a few commits, as
during payload removal the old instead of the new payload state got
updated, so the subsequent enabling sequence and commits used a stale
payload state.

v2: Constify the old payload state pointer. (Ville)

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # 6.1
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index dc4e5ff1dbb31..054a009e800d7 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -524,10 +524,14 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 	struct intel_dp *intel_dp = &dig_port->dp;
 	struct intel_connector *connector =
 		to_intel_connector(old_conn_state->connector);
-	struct drm_dp_mst_topology_state *mst_state =
-		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
-	struct drm_dp_mst_atomic_payload *payload =
-		drm_atomic_get_mst_payload_state(mst_state, connector->port);
+	struct drm_dp_mst_topology_state *old_mst_state =
+		drm_atomic_get_old_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	struct drm_dp_mst_topology_state *new_mst_state =
+		drm_atomic_get_new_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	const struct drm_dp_mst_atomic_payload *old_payload =
+		drm_atomic_get_mst_payload_state(old_mst_state, connector->port);
+	struct drm_dp_mst_atomic_payload *new_payload =
+		drm_atomic_get_mst_payload_state(new_mst_state, connector->port);
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 
 	drm_dbg_kms(&i915->drm, "active links %d\n",
@@ -535,8 +539,8 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 
 	intel_hdcp_disable(intel_mst->connector);
 
-	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
-			      payload, payload);
+	drm_dp_remove_payload(&intel_dp->mst_mgr, new_mst_state,
+			      old_payload, new_payload);
 
 	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
 }
-- 
2.37.1


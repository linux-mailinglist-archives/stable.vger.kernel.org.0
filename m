Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F169267B1E9
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 12:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbjAYLtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 06:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbjAYLtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 06:49:04 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165BC2F7B1
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 03:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674647344; x=1706183344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LjKht4btWvybU4Oox3ZEiD3HFls0QM8PcgwKUx7mlvM=;
  b=ju46xrHQqMHhkrswYaiwr13ll4kDE/fkE0aJFnK0/xeISa/ZuTIMry7e
   0SB1nxVLyhgWqAQNe3yXB4JRDolgybdTxCeqX7tJBawN8sf+J4a7tNy1g
   HGUPHFljzSGpq0MT3qUcNckrQGP2z6QR6/oQf9j2DJr5tqvaKPLTVhaMt
   4G7rdeYO/Po8Jy2Q9UKdGLhge0RF5LtKUYDeSFZbmES02ZGqCrroSRZkB
   gPo6XFw0D+s2VtcKoJeGVVi9wdZRxm/R66Y5xGsULg+e6o2vqV5WRijxc
   LDg8aPLXHGw4Bc0oj7ZeIR4PNzjksL8sUJVCp1yCSLiTT+Zq0p8ghPH4/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="412769919"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="412769919"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 03:49:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="786399707"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="786399707"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 03:49:02 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 4/9] drm/i915/dp_mst: Fix payload removal during output disabling
Date:   Wed, 25 Jan 2023 13:48:47 +0200
Message-Id: <20230125114852.748337-5-imre.deak@intel.com>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20230125114852.748337-1-imre.deak@intel.com>
References: <20230125114852.748337-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Cc: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 5f7bcb5c14847..800fa12a61d93 100644
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
+	struct drm_dp_mst_atomic_payload *old_payload =
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


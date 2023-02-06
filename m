Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044BE68BC0A
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 12:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjBFLtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 06:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjBFLtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 06:49:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13144222C3
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 03:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675684147; x=1707220147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WjpMaXLFh1RPQqCpfsf+7xTazQ4XyK3s5mfDv/APk9Q=;
  b=XI3hYrBx35K6ffHbCLVitQg+VGTDf7NqKiehq5NPJfTbxbswdgMvZvw4
   bl1Xmuc7S5+mHxnaGaCpnV6LbZRdRF+DmbNHZAGdacVKP403T89tp0Du7
   MOyyuYGXR49dDse7tDlSnsPv/pVZE/d+fpdYEJXPc65NZsYa952UpoIAP
   eUvxB03yeVR3l6c30Tm5uA59NLZXOomgFyQgkaXHpOZAbqHo9jYvdEToY
   0lcGuAcLl/zrBFUw5k46JGNZQBmizBbzHCBPYeNtVyQqZ4OqIxPzEeXqu
   B6AHzaXXKiFGx36Nq7PPMgxBfFRqBjWJb3TaUXyq0EPddblCe8hSKxfvz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="308829061"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="308829061"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 03:49:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="696850351"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="696850351"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 03:49:04 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [CI 3/4] drm/display/dp_mst: Add drm_atomic_get_old_mst_topology_state()
Date:   Mon,  6 Feb 2023 13:48:55 +0200
Message-Id: <20230206114856.2665066-3-imre.deak@intel.com>
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

Add a function to get the old MST topology state, required by a
follow-up i915 patch.

While at it clarify the code comment of
drm_atomic_get_new_mst_topology_state() and add _new prefix
to the new state pointer to remind about its difference from the old
state.

v2: Use old_/new_ prefixes for the state pointers. (Ville)

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # 6.1
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 33 ++++++++++++++++---
 include/drm/display/drm_dp_mst_helper.h       |  3 ++
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 1990ff5dc7ddd..38dab76ae69ea 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -5364,28 +5364,53 @@ struct drm_dp_mst_topology_state *drm_atomic_get_mst_topology_state(struct drm_a
 }
 EXPORT_SYMBOL(drm_atomic_get_mst_topology_state);
 
+/**
+ * drm_atomic_get_old_mst_topology_state: get old MST topology state in atomic state, if any
+ * @state: global atomic state
+ * @mgr: MST topology manager, also the private object in this case
+ *
+ * This function wraps drm_atomic_get_old_private_obj_state() passing in the MST atomic
+ * state vtable so that the private object state returned is that of a MST
+ * topology object.
+ *
+ * Returns:
+ *
+ * The old MST topology state, or NULL if there's no topology state for this MST mgr
+ * in the global atomic state
+ */
+struct drm_dp_mst_topology_state *
+drm_atomic_get_old_mst_topology_state(struct drm_atomic_state *state,
+				      struct drm_dp_mst_topology_mgr *mgr)
+{
+	struct drm_private_state *old_priv_state =
+		drm_atomic_get_old_private_obj_state(state, &mgr->base);
+
+	return old_priv_state ? to_dp_mst_topology_state(old_priv_state) : NULL;
+}
+EXPORT_SYMBOL(drm_atomic_get_old_mst_topology_state);
+
 /**
  * drm_atomic_get_new_mst_topology_state: get new MST topology state in atomic state, if any
  * @state: global atomic state
  * @mgr: MST topology manager, also the private object in this case
  *
- * This function wraps drm_atomic_get_priv_obj_state() passing in the MST atomic
+ * This function wraps drm_atomic_get_new_private_obj_state() passing in the MST atomic
  * state vtable so that the private object state returned is that of a MST
  * topology object.
  *
  * Returns:
  *
- * The MST topology state, or NULL if there's no topology state for this MST mgr
+ * The new MST topology state, or NULL if there's no topology state for this MST mgr
  * in the global atomic state
  */
 struct drm_dp_mst_topology_state *
 drm_atomic_get_new_mst_topology_state(struct drm_atomic_state *state,
 				      struct drm_dp_mst_topology_mgr *mgr)
 {
-	struct drm_private_state *priv_state =
+	struct drm_private_state *new_priv_state =
 		drm_atomic_get_new_private_obj_state(state, &mgr->base);
 
-	return priv_state ? to_dp_mst_topology_state(priv_state) : NULL;
+	return new_priv_state ? to_dp_mst_topology_state(new_priv_state) : NULL;
 }
 EXPORT_SYMBOL(drm_atomic_get_new_mst_topology_state);
 
diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
index f5eb9aa152b14..32c764fb9cb56 100644
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -868,6 +868,9 @@ struct drm_dp_mst_topology_state *
 drm_atomic_get_mst_topology_state(struct drm_atomic_state *state,
 				  struct drm_dp_mst_topology_mgr *mgr);
 struct drm_dp_mst_topology_state *
+drm_atomic_get_old_mst_topology_state(struct drm_atomic_state *state,
+				      struct drm_dp_mst_topology_mgr *mgr);
+struct drm_dp_mst_topology_state *
 drm_atomic_get_new_mst_topology_state(struct drm_atomic_state *state,
 				      struct drm_dp_mst_topology_mgr *mgr);
 struct drm_dp_mst_atomic_payload *
-- 
2.37.1


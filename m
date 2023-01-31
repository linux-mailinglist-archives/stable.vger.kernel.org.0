Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEAB6830EE
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjAaPKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjAaPJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:09:38 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695AE56191
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 07:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675177639; x=1706713639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j8Y2LV0W5VcgqRvSCj3NHM2NvF5FUThc1MCS7fVqAcM=;
  b=IRaJQbvcJsBgCx8ICXa83Grq9UK8Qs6//EL88RXw80iichqEISX4B8v+
   6mJbOMksitTYz1J+sOlNa/TGWmPVd0NFzmRMtMdlEjEvOhV6JRzeDgBig
   FhavV1e5nu3vFGA4LhbIFKq4whn2aoTk1xbJhOikXpj0WlkzJeEqDUL7M
   +ExWZSPhqPLgJTMHP+lfdB/av9qELoURhubzm+OWaIpULUTb//tpkB+po
   yyft5bhZnMX5vYiLHcDRckhP62sXgE67FTBwk8ODvhbYmHyeykxz31ivG
   j3LaOy+FEiEr7ImRv3S8ks8s65Av2jCBFixItU7p9IqVnpVZ8uYLByS6s
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="308205515"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="308205515"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 07:05:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="807155293"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="807155293"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 07:05:55 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH v2 03/17] drm/display/dp_mst: Add drm_atomic_get_old_mst_topology_state()
Date:   Tue, 31 Jan 2023 17:05:34 +0200
Message-Id: <20230131150548.1614458-4-imre.deak@intel.com>
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


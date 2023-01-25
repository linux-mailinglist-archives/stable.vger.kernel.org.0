Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC56967B1E8
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 12:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbjAYLtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 06:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbjAYLtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 06:49:03 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881292F7B1
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 03:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674647342; x=1706183342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FcDIXn+b1xfGwF5/0dgANgrSJc2u2QBQi/C9Qo6OVUg=;
  b=Diy3GM45CKEIeWQaSaAM48eFFrxADaDlEortZYt3ehzzTe+my0wRwwjW
   pGIn3xbhQ2jy9xKce2wpcDFNLjuucN+rhsAsABOVnCWflqQEfzrHnrX8j
   8mr30T8MHkbb3X7crGTS35IHJ1uSfi+3WvMpKZSPQxxWzEYB0WFRtRWqv
   ykY9tdQDk05fcNZZzirhBCzv9UaIQBE1k1m8ZJMu9ZoImUbxOjQvvDUn/
   d3kWxKn4760FvMxgujb6RDhA+CTyXImpIKBWP0c82Z8n9XlIJ3A3Bh9T1
   +08Z1MQabmyTJZE6/aJO2WQKEDkbJ/9+/M7Q94enp3FvlouhlnZDs3bZd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="412769910"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="412769910"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 03:49:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="786399699"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="786399699"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 03:49:00 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 3/9] drm/display/dp_mst: Add drm_atomic_get_old_mst_topology_state()
Date:   Wed, 25 Jan 2023 13:48:46 +0200
Message-Id: <20230125114852.748337-4-imre.deak@intel.com>
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

Add a function to get the old MST topology state, required by a
follow-up i915 patch.

While at it clarify the code comment of
drm_atomic_get_new_mst_topology_state().

Cc: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org # 6.1
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 29 +++++++++++++++++--
 include/drm/display/drm_dp_mst_helper.h       |  3 ++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index ebf6e31e156e0..81cc0c3b1e000 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -5362,18 +5362,43 @@ struct drm_dp_mst_topology_state *drm_atomic_get_mst_topology_state(struct drm_a
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
+	struct drm_private_state *priv_state =
+		drm_atomic_get_old_private_obj_state(state, &mgr->base);
+
+	return priv_state ? to_dp_mst_topology_state(priv_state) : NULL;
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF7B302934
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 18:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbhAYRnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 12:43:39 -0500
Received: from mga18.intel.com ([134.134.136.126]:23215 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbhAYRh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 12:37:28 -0500
IronPort-SDR: lstio9Gt/6X6fIhKJWolCJRthbPgtmNgjFPD/Q7uZvhiRFyk7Ar4UUmYJwrF2BLl9R9MhPHSU6
 Nsq8/BseUaog==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="167443702"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="167443702"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 09:36:40 -0800
IronPort-SDR: vgcu1GNmi57TdNrpab78XpsZHoQXiP78L00DoQXG1C45CXV+L2z6cbKQAiOjkujaGF5IKLZDP+
 X88HhnAZcleg==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="368762489"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 09:36:38 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Lyude Paul <lyude@redhat.com>,
        Ville Syrjala <ville.syrjala@intel.com>,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/2] drm/dp/mst: Export drm_dp_get_vc_payload_bw()
Date:   Mon, 25 Jan 2021 19:36:35 +0200
Message-Id: <20210125173636.1733812-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This function will be needed by the next patch where the driver
calculates the BW based on driver specific parameters, so export it.

At the same time sanitize the function params, passing the more natural
link rate instead of the encoding of the same rate.

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjala <ville.syrjala@intel.com>
Cc: <stable@vger.kernel.org>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 24 ++++++++++++++++++------
 include/drm/drm_dp_mst_helper.h       |  1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 475939138b21..dc96cbf78cc6 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3629,14 +3629,26 @@ static int drm_dp_send_up_ack_reply(struct drm_dp_mst_topology_mgr *mgr,
 	return 0;
 }
 
-static int drm_dp_get_vc_payload_bw(u8 dp_link_bw, u8  dp_link_count)
+/**
+ * drm_dp_get_vc_payload_bw - get the VC payload BW for an MST link
+ * @rate: link rate in 10kbits/s units
+ * @lane_count: lane count
+ *
+ * Calculate the toal bandwidth of a MultiStream Transport link. The returned
+ * value is in units of PBNs/(timeslots/1 MTP). This value can be used to
+ * convert the number of PBNs required for a given stream to the number of
+ * timeslots this stream requires in each MTP.
+ */
+int drm_dp_get_vc_payload_bw(int link_rate, int link_lane_count)
 {
-	if (dp_link_bw == 0 || dp_link_count == 0)
-		DRM_DEBUG_KMS("invalid link bandwidth in DPCD: %x (link count: %d)\n",
-			      dp_link_bw, dp_link_count);
+	if (link_rate == 0 || link_lane_count == 0)
+		DRM_DEBUG_KMS("invalid link rate/lane count: (%d / %d)\n",
+			      link_rate, link_lane_count);
 
-	return dp_link_bw * dp_link_count / 2;
+	/* See DP v2.0 2.6.4.2, VCPayload_Bandwidth_for_OneTimeSlotPer_MTP_Allocation */
+	return link_rate * link_lane_count / 54000;
 }
+EXPORT_SYMBOL(drm_dp_get_vc_payload_bw);
 
 /**
  * drm_dp_read_mst_cap() - check whether or not a sink supports MST
@@ -3692,7 +3704,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 			goto out_unlock;
 		}
 
-		mgr->pbn_div = drm_dp_get_vc_payload_bw(mgr->dpcd[1],
+		mgr->pbn_div = drm_dp_get_vc_payload_bw(drm_dp_bw_code_to_link_rate(mgr->dpcd[1]),
 							mgr->dpcd[2] & DP_MAX_LANE_COUNT_MASK);
 		if (mgr->pbn_div == 0) {
 			ret = -EINVAL;
diff --git a/include/drm/drm_dp_mst_helper.h b/include/drm/drm_dp_mst_helper.h
index f5e92fe9151c..bd1c39907b92 100644
--- a/include/drm/drm_dp_mst_helper.h
+++ b/include/drm/drm_dp_mst_helper.h
@@ -783,6 +783,7 @@ drm_dp_mst_detect_port(struct drm_connector *connector,
 
 struct edid *drm_dp_mst_get_edid(struct drm_connector *connector, struct drm_dp_mst_topology_mgr *mgr, struct drm_dp_mst_port *port);
 
+int drm_dp_get_vc_payload_bw(int link_rate, int link_lane_count);
 
 int drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc);
 
-- 
2.25.1


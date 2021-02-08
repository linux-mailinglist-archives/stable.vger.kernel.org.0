Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6903137C9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhBHPbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:31:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhBHP0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:26:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2FA864F20;
        Mon,  8 Feb 2021 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797346;
        bh=2ktO6u/bOQJqlEHKKcuoK+7PPWci1WCWMSoeppvCyiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmeHZ0T+Z0eosxr9d7jdPqLOX/J7lIuBfAGL4Ud3q/BwTmXnOQipr22I+RMvEzjU1
         U+XQft5Rz7Ip4RDVgMDN/hUAUTINq6Og3AnzBYNJmvUIOe9kCJTcxpC3i/XWpC1QL/
         Y7JUuUwJQk1Nb7Qr6QwdFNmHFtXZaPmCuQYSbP6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ville Syrjala <ville.syrjala@intel.com>,
        dri-devel@lists.freedesktop.org, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 078/120] drm/dp/mst: Export drm_dp_get_vc_payload_bw()
Date:   Mon,  8 Feb 2021 16:01:05 +0100
Message-Id: <20210208145821.517331268@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 83404d581471775f37f85e5261ec0d09407d8bed upstream.

This function will be needed by the next patch where the driver
calculates the BW based on driver specific parameters, so export it.

At the same time sanitize the function params, passing the more natural
link rate instead of the encoding of the same rate.

v2:
- Fix function documentation. (Lyude)

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjala <ville.syrjala@intel.com>
Cc: <stable@vger.kernel.org>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210125173636.1733812-1-imre.deak@intel.com
(cherry picked from commit a321fc2b4e60fc1b39517d26c8104351636a6062)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |   24 ++++++++++++++++++------
 include/drm/drm_dp_mst_helper.h       |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3629,14 +3629,26 @@ static int drm_dp_send_up_ack_reply(stru
 	return 0;
 }
 
-static int drm_dp_get_vc_payload_bw(u8 dp_link_bw, u8  dp_link_count)
+/**
+ * drm_dp_get_vc_payload_bw - get the VC payload BW for an MST link
+ * @link_rate: link rate in 10kbits/s units
+ * @link_lane_count: lane count
+ *
+ * Calculate the total bandwidth of a MultiStream Transport link. The returned
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
@@ -3692,7 +3704,7 @@ int drm_dp_mst_topology_mgr_set_mst(stru
 			goto out_unlock;
 		}
 
-		mgr->pbn_div = drm_dp_get_vc_payload_bw(mgr->dpcd[1],
+		mgr->pbn_div = drm_dp_get_vc_payload_bw(drm_dp_bw_code_to_link_rate(mgr->dpcd[1]),
 							mgr->dpcd[2] & DP_MAX_LANE_COUNT_MASK);
 		if (mgr->pbn_div == 0) {
 			ret = -EINVAL;
--- a/include/drm/drm_dp_mst_helper.h
+++ b/include/drm/drm_dp_mst_helper.h
@@ -783,6 +783,7 @@ drm_dp_mst_detect_port(struct drm_connec
 
 struct edid *drm_dp_mst_get_edid(struct drm_connector *connector, struct drm_dp_mst_topology_mgr *mgr, struct drm_dp_mst_port *port);
 
+int drm_dp_get_vc_payload_bw(int link_rate, int link_lane_count);
 
 int drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc);
 



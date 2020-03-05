Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918B217AFDA
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgCEUjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 15:39:46 -0500
Received: from mga12.intel.com ([192.55.52.136]:62773 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgCEUjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 15:39:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 12:39:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="413649952"
Received: from josouza-mobl2.jf.intel.com (HELO josouza-MOBL2.intel.com) ([10.24.14.241])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 12:39:44 -0800
From:   =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     Lyude Paul <lyude@redhat.com>, Sean Paul <sean@poorly.run>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Subject: [PATCH 1/2] drm/mst: Fix possible NULL pointer dereference in drm_dp_mst_process_up_req()
Date:   Thu,  5 Mar 2020 12:40:40 -0800
Message-Id: <20200305204041.37564-2-jose.souza@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200305204041.37564-1-jose.souza@intel.com>
References: <20200305204041.37564-1-jose.souza@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to DP specification, DP_SINK_EVENT_NOTIFY is also a
broadcast message but as this function only handles
DP_CONNECTION_STATUS_NOTIFY I will only make the static
analyzer that caught this issue happy by not calling
drm_dp_get_mst_branch_device_by_guid() with a NULL guid, causing
drm_dp_mst_process_up_req() to return in the "if (!mstb)" right
bellow.

Fixes: 9408cc94eb04 ("drm/dp_mst: Handle UP requests asynchronously")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Sean Paul <sean@poorly.run>
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
[added cc to stable]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200129232448.84704-1-jose.souza@intel.com
(cherry picked from commit 8ccb5bf7619c6523e7a4384a84b72e7be804298c)
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index cf6cf186e3c6..c9c43371c33c 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3810,7 +3810,8 @@ drm_dp_mst_process_up_req(struct drm_dp_mst_topology_mgr *mgr,
 		else if (msg->req_type == DP_RESOURCE_STATUS_NOTIFY)
 			guid = msg->u.resource_stat.guid;
 
-		mstb = drm_dp_get_mst_branch_device_by_guid(mgr, guid);
+		if (guid)
+			mstb = drm_dp_get_mst_branch_device_by_guid(mgr, guid);
 	} else {
 		mstb = drm_dp_get_mst_branch_device(mgr, hdr->lct, hdr->rad);
 	}

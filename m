Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590B7328D50
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbhCATIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236020AbhCATEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF4F64EED;
        Mon,  1 Mar 2021 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618837;
        bh=i3RbDcvo+TkZhXnIEYtch0b3jwEYLF2P1yujlXr0BKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiAuzY2SD92W5xIg1sUv1Ea1IEWOmxWSCRMYdTmxW9Qj3LMcw43uLRDFlNlb7oupl
         7pYH+d3RkxLiUKOWwVZ108fRkhCv6Vz62zYJjwttnopqYkkJd3vJs2/eWBpp9N9EgD
         Lk8sdWeXnmUOXH+jmw2T89gVUTpuo88Fgj+kUOI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Lyude Paul <lyude@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/663] drm/dp_mst: Dont cache EDIDs for physical ports
Date:   Mon,  1 Mar 2021 17:08:04 +0100
Message-Id: <20210301161153.493215125@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 4b8878eefa0a3b65e2e016db49014ea66fb9fd45 ]

Caching EDIDs for physical ports prevents updating the EDID if a port
gets reconnected via a Connection Status Notification message, fix this.

Fixes: db1a07956968 ("drm/dp_mst: Handle SST-only branch device case")
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210201120145.350258-2-imre.deak@intel.com
(cherry picked from commit 468091531c2e5c49f55d8c6f1d036ce997d24e13)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 17bdad95978a1..9cf35dab25273 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2302,7 +2302,8 @@ drm_dp_mst_port_add_connector(struct drm_dp_mst_branch *mstb,
 	}
 
 	if (port->pdt != DP_PEER_DEVICE_NONE &&
-	    drm_dp_mst_is_end_device(port->pdt, port->mcs)) {
+	    drm_dp_mst_is_end_device(port->pdt, port->mcs) &&
+	    port->port_num >= DP_MST_LOGICAL_PORT_0) {
 		port->cached_edid = drm_get_edid(port->connector,
 						 &port->aux.ddc);
 		drm_connector_set_tile_property(port->connector);
-- 
2.27.0




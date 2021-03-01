Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA95328C96
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbhCASyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240639AbhCASsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:48:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2264F6023B;
        Mon,  1 Mar 2021 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620789;
        bh=COfQtmskVanvlMHQLp4Xvo01CLDTaAfFlWPbsTYwp0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqxEmZUJ3fWQQAGhGc3Rb/Ax4FZf7BSPtHY0UEvT6jIL4oDTReMWrxOJWdkfFWmrS
         jZ6W0I/Dx0FCw6mb3MoQ6c2EqE4DsNKFfPT8ojBLafbDtd6YBWZlXloGzQOGCOllHg
         Hm1MOAKrlle7d0ePbOFo4/b18OSJMRXQjyyxc6Kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        Lyude Paul <lyude@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 281/775] drm/dp_mst: Dont cache EDIDs for physical ports
Date:   Mon,  1 Mar 2021 17:07:29 +0100
Message-Id: <20210301161215.516904085@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index b11c0522a4410..405501c74e400 100644
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




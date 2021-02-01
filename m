Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1ED30A714
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhBAMCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:02:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:41521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhBAMCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 07:02:40 -0500
IronPort-SDR: i4ZVn1BhIAuzYvLAGWG1JIcNDs0tQ6TX0w5oUG3eyHq4uv6lcD1DqFOSTaf2mzOOpPnNSmu7cu
 vUsIKYwlHM3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="167777622"
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="167777622"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 04:01:57 -0800
IronPort-SDR: 5te+dSWzpMjVjVAiMVuT0uYTTW+X4Fm9d9PDwHyO2uO0y6kdDAkJIbTf+KhPwe3nBlIcjMOLQt
 +pchkhiYUWMw==
X-IronPort-AV: E=Sophos;i="5.79,392,1602572400"; 
   d="scan'208";a="390880803"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 04:01:52 -0800
From:   Imre Deak <imre.deak@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>, Lyude Paul <lyude@redhat.com>,
        stable@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: [PATCH 1/4] drm/dp_mst: Don't report ports connected if nothing is attached to them
Date:   Mon,  1 Feb 2021 14:01:42 +0200
Message-Id: <20210201120145.350258-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reporting a port as connected if nothing is attached to them leads to
any i2c transactions on this port trying to use an uninitialized i2c
adapter, fix this.

Let's account for this case even if branch devices have no good reason
to report a port as unplugged with their peer device type set to 'none'.

Fixes: db1a07956968 ("drm/dp_mst: Handle SST-only branch device case")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/2987
References: https://gitlab.freedesktop.org/drm/intel/-/issues/1963
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v5.5+
Cc: intel-gfx@lists.freedesktop.org
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index e82b596d646c..deb7995f42fa 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4224,6 +4224,7 @@ drm_dp_mst_detect_port(struct drm_connector *connector,
 
 	switch (port->pdt) {
 	case DP_PEER_DEVICE_NONE:
+		break;
 	case DP_PEER_DEVICE_MST_BRANCHING:
 		if (!port->mcs)
 			ret = connector_status_connected;
-- 
2.25.1


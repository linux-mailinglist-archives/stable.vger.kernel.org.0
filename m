Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A4B3C5382
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbhGLHy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350413AbhGLHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 324AE6162D;
        Mon, 12 Jul 2021 07:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075901;
        bh=eEbmBHAcTpIUbvWMVOY/9WHwfbOWhuE7YFwe9aiRuek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dflCa2M6aGbOAE52/U+hzh+ZApNwzyVNwTHtcKQjMa3bmITTikhHHeKJkOHsTZ0ij
         aEDWYsg6SqzT5CnbgGyTO+JkR2arB2epz1+Vd9AejXjnOw4R0zv+K175NYcIS8kyXF
         N4WqT+O+GH+2qUUUGf64gx0OsSqD/PXy5tJ7xWwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 412/800] drm/amd/display: take dc_lock in short pulse handler only
Date:   Mon, 12 Jul 2021 08:07:15 +0200
Message-Id: <20210712061011.010398873@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit d2aa1356834d845ffdac0d8c01b58aa60d1bdc65 ]

[Why]
Conditions that end up modifying the global dc state must be locked.
However, during mst allocate payload sequence, lock is already taken.
With StarTech 1.2 DP hub, we get an HPD RX interrupt for a reason other
than to indicate down reply availability right after sending payload
allocation. The handler again takes dc lock before calling the
dc's HPD RX handler. Due to this contention, the DRM thread which waits
for MST down reply never gets a chance to finish its waiting
successfully and ends up timing out. Once the lock is released, the hpd
rx handler fires and goes ahead to read from the MST HUB, but now its
too late and the HUB doesnt lightup all displays since DRM lacks error
handling when payload allocation fails.

[How]
Take lock only if there is a change in link status or if automated test
pattern bit is set. The latter fixes the null pointer dereference when
running certain DP Link Layer Compliance test.

Fixes: c8ea79a8a276 ("drm/amd/display: NULL pointer error during compliance test")

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 19 +++++++++++++++++--
 .../gpu/drm/amd/display/dc/core/dc_link_dp.c  |  2 +-
 .../gpu/drm/amd/display/dc/inc/dc_link_dp.h   |  4 ++++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index dcb4e585c270..2b2d7b9f26f1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -28,6 +28,7 @@
 
 #include "dm_services_types.h"
 #include "dc.h"
+#include "dc_link_dp.h"
 #include "dc/inc/core_types.h"
 #include "dal_asic_id.h"
 #include "dmub/dmub_srv.h"
@@ -2696,6 +2697,7 @@ static void handle_hpd_rx_irq(void *param)
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	union hpd_irq_data hpd_irq_data;
+	bool lock_flag = 0;
 
 	memset(&hpd_irq_data, 0, sizeof(hpd_irq_data));
 
@@ -2726,15 +2728,28 @@ static void handle_hpd_rx_irq(void *param)
 		}
 	}
 
-	if (!amdgpu_in_reset(adev)) {
+	/*
+	 * TODO: We need the lock to avoid touching DC state while it's being
+	 * modified during automated compliance testing, or when link loss
+	 * happens. While this should be split into subhandlers and proper
+	 * interfaces to avoid having to conditionally lock like this in the
+	 * outer layer, we need this workaround temporarily to allow MST
+	 * lightup in some scenarios to avoid timeout.
+	 */
+	if (!amdgpu_in_reset(adev) &&
+	    (hpd_rx_irq_check_link_loss_status(dc_link, &hpd_irq_data) ||
+	     hpd_irq_data.bytes.device_service_irq.bits.AUTOMATED_TEST)) {
 		mutex_lock(&adev->dm.dc_lock);
+		lock_flag = 1;
+	}
+
 #ifdef CONFIG_DRM_AMD_DC_HDCP
 	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data, NULL);
 #else
 	result = dc_link_handle_hpd_rx_irq(dc_link, NULL, NULL);
 #endif
+	if (!amdgpu_in_reset(adev) && lock_flag)
 		mutex_unlock(&adev->dm.dc_lock);
-	}
 
 out:
 	if (result && !is_mst_root_connector) {
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 3ff3d9e90983..72bd7bc681a8 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1976,7 +1976,7 @@ enum dc_status read_hpd_rx_irq_data(
 	return retval;
 }
 
-static bool hpd_rx_irq_check_link_loss_status(
+bool hpd_rx_irq_check_link_loss_status(
 	struct dc_link *link,
 	union hpd_irq_data *hpd_irq_dpcd_data)
 {
diff --git a/drivers/gpu/drm/amd/display/dc/inc/dc_link_dp.h b/drivers/gpu/drm/amd/display/dc/inc/dc_link_dp.h
index 3ae05c96d557..a9c0c7f7a55d 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/dc_link_dp.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/dc_link_dp.h
@@ -67,6 +67,10 @@ bool perform_link_training_with_retries(
 	struct pipe_ctx *pipe_ctx,
 	enum signal_type signal);
 
+bool hpd_rx_irq_check_link_loss_status(
+	struct dc_link *link,
+	union hpd_irq_data *hpd_irq_dpcd_data);
+
 bool is_mst_supported(struct dc_link *link);
 
 bool detect_dp_sink_caps(struct dc_link *link);
-- 
2.30.2




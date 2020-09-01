Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755D7259909
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbgIAQfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbgIAPaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD01E2100A;
        Tue,  1 Sep 2020 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974207;
        bh=n+NKooXWrnmWSdjBy9zyPt1qKPuk9N41ZK2fyF+GGaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebhAfLQZ3p+dP00RJEBbrzU6TVRxFTieaLg8nUUzSsSYy5P5cRL9slqAggtyGVhdI
         vzZ3Duikl7zBZfOxp3OEpFvY10EgtWUgVTXvgSt0gs+72pr/nQygB0O+6FKMlpPh1o
         GNP9mbOt0fllUZ06TUMEe7XRQe1Bf7GD+0ISA4vE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        David Francis <David.Francis@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/214] drm/amd/display: Trigger modesets on MST DSC connectors
Date:   Tue,  1 Sep 2020 17:09:26 +0200
Message-Id: <20200901150957.110923732@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikita Lipski <mikita.lipski@amd.com>

[ Upstream commit 44be939ff7ac5858f0dbd8a2a4af1fe198e14db1 ]

Whenever a connector on an MST network is attached, detached, or
undergoes a modeset, the DSC configs for each stream on that
topology will be recalculated. This can change their required
bandwidth, requiring a full reprogramming, as though a modeset
was performed, even if that stream did not change timing.

Therefore, whenever a crtc has drm_atomic_crtc_needs_modeset,
for each crtc that shares a MST topology with that stream and
supports DSC, add that crtc (and all affected connectors and
planes) to the atomic state and set mode_changed on its state

v2: Do this check only on Navi and before adding connectors
and planes on modesetting crtcs

v3: Call the drm_dp_mst_add_affected_dsc_crtcs() to update
all affected CRTCs

Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2c0eb7140ca0e..5bde49a13f8c7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7230,6 +7230,29 @@ dm_determine_update_type_for_commit(struct amdgpu_display_manager *dm,
 	return ret;
 }
 
+static int add_affected_mst_dsc_crtcs(struct drm_atomic_state *state, struct drm_crtc *crtc)
+{
+	struct drm_connector *connector;
+	struct drm_connector_state *conn_state;
+	struct amdgpu_dm_connector *aconnector = NULL;
+	int i;
+	for_each_new_connector_in_state(state, connector, conn_state, i) {
+		if (conn_state->crtc != crtc)
+			continue;
+
+		aconnector = to_amdgpu_dm_connector(connector);
+		if (!aconnector->port || !aconnector->mst_port)
+			aconnector = NULL;
+		else
+			break;
+	}
+
+	if (!aconnector)
+		return 0;
+
+	return drm_dp_mst_add_affected_dsc_crtcs(state, &aconnector->mst_port->mst_mgr);
+}
+
 /**
  * amdgpu_dm_atomic_check() - Atomic check implementation for AMDgpu DM.
  * @dev: The DRM device
@@ -7282,6 +7305,16 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	if (ret)
 		goto fail;
 
+	if (adev->asic_type >= CHIP_NAVI10) {
+		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+			if (drm_atomic_crtc_needs_modeset(new_crtc_state)) {
+				ret = add_affected_mst_dsc_crtcs(state, crtc);
+				if (ret)
+					goto fail;
+			}
+		}
+	}
+
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 		if (!drm_atomic_crtc_needs_modeset(new_crtc_state) &&
 		    !new_crtc_state->color_mgmt_changed &&
-- 
2.25.1




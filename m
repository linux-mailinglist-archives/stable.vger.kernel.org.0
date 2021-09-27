Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCEA419C95
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhI0RaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237719AbhI0R2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9355961439;
        Mon, 27 Sep 2021 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763036;
        bh=Ewp67lUL2fZgbkiZj2DoZ6VUPqdyXRi+d88JaEbB0+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0UC0lhS8pZgtX/eHVu3fuU6qMQ+IJikAjaqKqhZvjtYfDoNmdZq/Sm0KVccvDp5i
         Am4u2EQYaJOBKfZy+swOiDAbvMVr45c3/gwi8dFc4JPrigF1pEUPodiskNcC09Ui1I
         Yn1dUk9AghwlHDFXKwtqyzYSdLFezTNSbYmGVvPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 143/162] amd/display: enable panel orientation quirks
Date:   Mon, 27 Sep 2021 19:03:09 +0200
Message-Id: <20210927170238.386907418@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit cd51a57eb59fd56f3fe7ce9cadef444451bcf804 ]

This patch allows panel orientation quirks from DRM core to be
used. They attach a DRM connector property "panel orientation"
which indicates in which direction the panel has been mounted.
Some machines have the internal screen mounted with a rotation.

Since the panel orientation quirks need the native mode from the
EDID, check for it in amdgpu_dm_connector_ddc_get_modes.

Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e7cf79b386da..3bb567ea2cef 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7514,6 +7514,32 @@ static void amdgpu_dm_connector_add_common_modes(struct drm_encoder *encoder,
 	}
 }
 
+static void amdgpu_set_panel_orientation(struct drm_connector *connector)
+{
+	struct drm_encoder *encoder;
+	struct amdgpu_encoder *amdgpu_encoder;
+	const struct drm_display_mode *native_mode;
+
+	if (connector->connector_type != DRM_MODE_CONNECTOR_eDP &&
+	    connector->connector_type != DRM_MODE_CONNECTOR_LVDS)
+		return;
+
+	encoder = amdgpu_dm_connector_to_encoder(connector);
+	if (!encoder)
+		return;
+
+	amdgpu_encoder = to_amdgpu_encoder(encoder);
+
+	native_mode = &amdgpu_encoder->native_mode;
+	if (native_mode->hdisplay == 0 || native_mode->vdisplay == 0)
+		return;
+
+	drm_connector_set_panel_orientation_with_quirk(connector,
+						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
+						       native_mode->hdisplay,
+						       native_mode->vdisplay);
+}
+
 static void amdgpu_dm_connector_ddc_get_modes(struct drm_connector *connector,
 					      struct edid *edid)
 {
@@ -7542,6 +7568,8 @@ static void amdgpu_dm_connector_ddc_get_modes(struct drm_connector *connector,
 		 * restored here.
 		 */
 		amdgpu_dm_update_freesync_caps(connector, edid);
+
+		amdgpu_set_panel_orientation(connector);
 	} else {
 		amdgpu_dm_connector->num_modes = 0;
 	}
-- 
2.33.0




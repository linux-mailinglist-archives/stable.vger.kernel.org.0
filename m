Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4366A1A5B90
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgDKXuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgDKXEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F2D3214D8;
        Sat, 11 Apr 2020 23:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646241;
        bh=Q99g52Fta1ZERSHsYKSqKAe6lrAJVypTbK5kyGjfU20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2TWd87KqSaWTitxTQn12h6DfN2PavhYEvKc9ZW/3SDVaGAqCQAX1Kfoc5w4CjeUm
         W+r3z2CRH9no5qBfdEIO2jcwjBGDORYNQLZrtt1r9jY/AlIxPayPJYxB35pgM3UbxH
         7w84O2rP2+KZUfJMBcPxZoVraLw5P824rmPbQTJQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Tsai <martin.tsai@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 010/149] drm/amd/display: differentiate vsc sdp colorimetry use criteria between MST and SST
Date:   Sat, 11 Apr 2020 19:01:27 -0400
Message-Id: <20200411230347.22371-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Tsai <martin.tsai@amd.com>

[ Upstream commit c38cc6770fd5f78a0918ed0b01af14de31aba5cb ]

[Why]
We should check MST BU support capability on output port before building
vsc info packet.

[How]
Add a new definition for port and sink capability check.

Signed-off-by: Martin Tsai <martin.tsai@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 19 +++++++++++++++---
 drivers/gpu/drm/amd/display/dc/dc.h           |  2 ++
 .../amd/display/modules/inc/mod_info_packet.h |  3 +--
 .../display/modules/info_packet/info_packet.c | 20 +++----------------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6240259b3a937..b9853fd724d60 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4200,9 +4200,22 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 			struct dmcu *dmcu = core_dc->res_pool->dmcu;
 
 			stream->psr_version = dmcu->dmcu_version.psr_version;
-			mod_build_vsc_infopacket(stream,
-					&stream->vsc_infopacket,
-					&stream->use_vsc_sdp_for_colorimetry);
+
+			//
+			// should decide stream support vsc sdp colorimetry capability
+			// before building vsc info packet
+			//
+			stream->use_vsc_sdp_for_colorimetry = false;
+			if (aconnector->dc_sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT_MST) {
+				stream->use_vsc_sdp_for_colorimetry =
+					aconnector->dc_sink->is_vsc_sdp_colorimetry_supported;
+			} else {
+				if (stream->link->dpcd_caps.dpcd_rev.raw >= 0x14 &&
+					stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED) {
+					stream->use_vsc_sdp_for_colorimetry = true;
+				}
+			}
+			mod_build_vsc_infopacket(stream, &stream->vsc_infopacket);
 		}
 	}
 finish:
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 8ff25b5dd2f6d..4afe33c6aeb5b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1019,6 +1019,8 @@ struct dc_sink {
 
 	struct dc_sink_dsc_caps sink_dsc_caps;
 
+	bool is_vsc_sdp_colorimetry_supported;
+
 	/* private to DC core */
 	struct dc_link *link;
 	struct dc_context *ctx;
diff --git a/drivers/gpu/drm/amd/display/modules/inc/mod_info_packet.h b/drivers/gpu/drm/amd/display/modules/inc/mod_info_packet.h
index 42cbeffac6402..13c57ff2abdce 100644
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_info_packet.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_info_packet.h
@@ -34,8 +34,7 @@ struct dc_info_packet;
 struct mod_vrr_params;
 
 void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
-		struct dc_info_packet *info_packet,
-		bool *use_vsc_sdp_for_colorimetry);
+		struct dc_info_packet *info_packet);
 
 void mod_build_hf_vsif_infopacket(const struct dc_stream_state *stream,
 		struct dc_info_packet *info_packet, int ALLMEnabled, int ALLMValue);
diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index 6a8a056424b85..cff3ab15fc0cc 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -130,8 +130,7 @@ enum ColorimetryYCCDP {
 };
 
 void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
-		struct dc_info_packet *info_packet,
-		bool *use_vsc_sdp_for_colorimetry)
+		struct dc_info_packet *info_packet)
 {
 	unsigned int vsc_packet_revision = vsc_packet_undefined;
 	unsigned int i;
@@ -139,11 +138,6 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
 	unsigned int colorimetryFormat = 0;
 	bool stereo3dSupport = false;
 
-	/* Initialize first, later if infopacket is valid determine if VSC SDP
-	 * should be used to signal colorimetry format and pixel encoding.
-	 */
-	*use_vsc_sdp_for_colorimetry = false;
-
 	if (stream->timing.timing_3d_format != TIMING_3D_FORMAT_NONE && stream->view_format != VIEW_3D_FORMAT_NONE) {
 		vsc_packet_revision = vsc_packet_rev1;
 		stereo3dSupport = true;
@@ -153,9 +147,8 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
 	if (stream->psr_version != 0)
 		vsc_packet_revision = vsc_packet_rev2;
 
-	/* Update to revision 5 for extended colorimetry support for DPCD 1.4+ */
-	if (stream->link->dpcd_caps.dpcd_rev.raw >= 0x14 &&
-			stream->link->dpcd_caps.dprx_feature.bits.VSC_SDP_COLORIMETRY_SUPPORTED)
+	/* Update to revision 5 for extended colorimetry support */
+	if (stream->use_vsc_sdp_for_colorimetry)
 		vsc_packet_revision = vsc_packet_rev5;
 
 	/* VSC packet not needed based on the features
@@ -269,13 +262,6 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
 
 		info_packet->valid = true;
 
-		/* If we are using VSC SDP revision 05h, use this to signal for
-		 * colorimetry format and pixel encoding. HW should later be
-		 * programmed to set MSA MISC1 bit 6 to indicate ignore
-		 * colorimetry format and pixel encoding in the MSA.
-		 */
-		*use_vsc_sdp_for_colorimetry = true;
-
 		/* Set VSC SDP fields for pixel encoding and colorimetry format from DP 1.3 specs
 		 * Data Bytes DB 18~16
 		 * Bits 3:0 (Colorimetry Format)        |  Bits 7:4 (Pixel Encoding)
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533FA34426A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhCVMl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231828AbhCVMjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 219C3619A1;
        Mon, 22 Mar 2021 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416711;
        bh=WvjUmu+aAy/JhFye8DfedIOigCgNSyngpN5isKOoFeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/xBCwwUU0FTOpJmawtVr+JeVbgZLOTZfYChxpnlHPPe+VfN/s82y3QT6UkLogiUA
         YznHw+al4TU0gF9dWdNmW1QkOfyzkeidsqBFEhGhH+l0JrG27JBXnMxsHMB9giv12U
         XQk65i8Rbg0Sy/CuTUmBMHrhfGYTK1DAcyVJ56vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/157] drm/amd/display: turn DPMS off on connector unplug
Date:   Mon, 22 Mar 2021 13:27:28 +0100
Message-Id: <20210322121936.671469945@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 3c4d55c9b9becedd8d31a7c96783a364533713ab ]

[Why&How]

Set dpms off on the connector that was unplugged, for the side effect of
releasing some references held through deallocation of MST payload. This is
the expected behaviour for non MST devices as well.

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Eryk Brol <eryk.brol@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 32 ++++++++++++++++++-
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 13 ++++++++
 drivers/gpu/drm/amd/display/dc/dc_stream.h    |  1 +
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ea1ea147f607..c07737c45677 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1902,6 +1902,33 @@ static void dm_gpureset_commit_state(struct dc_state *dc_state,
 	return;
 }
 
+static void dm_set_dpms_off(struct dc_link *link)
+{
+	struct dc_stream_state *stream_state;
+	struct amdgpu_dm_connector *aconnector = link->priv;
+	struct amdgpu_device *adev = drm_to_adev(aconnector->base.dev);
+	struct dc_stream_update stream_update;
+	bool dpms_off = true;
+
+	memset(&stream_update, 0, sizeof(stream_update));
+	stream_update.dpms_off = &dpms_off;
+
+	mutex_lock(&adev->dm.dc_lock);
+	stream_state = dc_stream_find_from_link(link);
+
+	if (stream_state == NULL) {
+		DRM_DEBUG_DRIVER("Error finding stream state associated with link!\n");
+		mutex_unlock(&adev->dm.dc_lock);
+		return;
+	}
+
+	stream_update.stream = stream_state;
+	dc_commit_updates_for_stream(stream_state->ctx->dc, NULL, 0,
+				     stream_state, &stream_update,
+				     stream_state->ctx->dc->current_state);
+	mutex_unlock(&adev->dm.dc_lock);
+}
+
 static int dm_resume(void *handle)
 {
 	struct amdgpu_device *adev = handle;
@@ -2353,8 +2380,11 @@ static void handle_hpd_irq(void *param)
 			drm_kms_helper_hotplug_event(dev);
 
 	} else if (dc_link_detect(aconnector->dc_link, DETECT_REASON_HPD)) {
-		amdgpu_dm_update_connector_after_detect(aconnector);
+		if (new_connection_type == dc_connection_none &&
+		    aconnector->dc_link->type == dc_connection_none)
+			dm_set_dpms_off(aconnector->dc_link);
 
+		amdgpu_dm_update_connector_after_detect(aconnector);
 
 		drm_modeset_lock_all(dev);
 		dm_restore_drm_connector_state(dev, connector);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 45ad05f6e03b..ffb21196bf59 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2767,6 +2767,19 @@ struct dc_stream_state *dc_get_stream_at_index(struct dc *dc, uint8_t i)
 	return NULL;
 }
 
+struct dc_stream_state *dc_stream_find_from_link(const struct dc_link *link)
+{
+	uint8_t i;
+	struct dc_context *ctx = link->ctx;
+
+	for (i = 0; i < ctx->dc->current_state->stream_count; i++) {
+		if (ctx->dc->current_state->streams[i]->link == link)
+			return ctx->dc->current_state->streams[i];
+	}
+
+	return NULL;
+}
+
 enum dc_irq_source dc_interrupt_to_irq_source(
 		struct dc *dc,
 		uint32_t src_id,
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index c246af7c584b..205bedd1b196 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -297,6 +297,7 @@ void dc_stream_log(const struct dc *dc, const struct dc_stream_state *stream);
 
 uint8_t dc_get_current_stream_count(struct dc *dc);
 struct dc_stream_state *dc_get_stream_at_index(struct dc *dc, uint8_t i);
+struct dc_stream_state *dc_stream_find_from_link(const struct dc_link *link);
 
 /*
  * Return the current frame counter.
-- 
2.30.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53CBBCEF8
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410670AbfIXQuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410666AbfIXQuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:50:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E5C21906;
        Tue, 24 Sep 2019 16:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343800;
        bh=K4T6lRYMyRRepGM0P+BdfI9+GRjzZhv/1SdRP6HK8Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PrSknN5lmJGIKYoZJlthmNIR2s/vsTVYERrU3GC0N3jZbcZa5IpVpmZoyHjhFqEZ
         nE4P0zlV5OuM0jXyOx57C6HunIdsBWDGju9re8SXDuhCIcYdb8qqCR5pFzDrHgd482
         6AjfTEj+C3kG8ZPz5vkoKlp7blkC6a4uP+kx99N0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charlene Liu <charlene.liu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 35/50] drm/amd/display: support spdif
Date:   Tue, 24 Sep 2019 12:48:32 -0400
Message-Id: <20190924164847.27780-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charlene Liu <charlene.liu@amd.com>

[ Upstream commit b5a41620bb88efb9fb31a4fa5e652e3d5bead7d4 ]

[Description]
port spdif fix to staging:
 spdif hardwired to afmt inst 1.
 spdif func pointer
 spdif resource allocation (reserve last audio endpoint for spdif only)

Signed-off-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_resource.c   | 17 ++++++++---------
 drivers/gpu/drm/amd/display/dc/dce/dce_audio.c  |  4 ++--
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index f0d68aa7c8fcc..d440b28ee43fb 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -229,12 +229,10 @@ bool resource_construct(
 				DC_ERR("DC: failed to create audio!\n");
 				return false;
 			}
-
 			if (!aud->funcs->endpoint_valid(aud)) {
 				aud->funcs->destroy(&aud);
 				break;
 			}
-
 			pool->audios[i] = aud;
 			pool->audio_count++;
 		}
@@ -1703,24 +1701,25 @@ static struct audio *find_first_free_audio(
 		const struct resource_pool *pool,
 		enum engine_id id)
 {
-	int i;
-	for (i = 0; i < pool->audio_count; i++) {
+	int i, available_audio_count;
+
+	available_audio_count = pool->audio_count;
+
+	for (i = 0; i < available_audio_count; i++) {
 		if ((res_ctx->is_audio_acquired[i] == false) && (res_ctx->is_stream_enc_acquired[i] == true)) {
 			/*we have enough audio endpoint, find the matching inst*/
 			if (id != i)
 				continue;
-
 			return pool->audios[i];
 		}
 	}
 
-    /* use engine id to find free audio */
-	if ((id < pool->audio_count) && (res_ctx->is_audio_acquired[id] == false)) {
+	/* use engine id to find free audio */
+	if ((id < available_audio_count) && (res_ctx->is_audio_acquired[id] == false)) {
 		return pool->audios[id];
 	}
-
 	/*not found the matching one, first come first serve*/
-	for (i = 0; i < pool->audio_count; i++) {
+	for (i = 0; i < available_audio_count; i++) {
 		if (res_ctx->is_audio_acquired[i] == false) {
 			return pool->audios[i];
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c b/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
index 7f6d724686f1a..abb559ce64085 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
@@ -611,6 +611,8 @@ void dce_aud_az_configure(
 
 	AZ_REG_WRITE(AZALIA_F0_CODEC_PIN_CONTROL_SINK_INFO1,
 		value);
+	DC_LOG_HW_AUDIO("\n\tAUDIO:az_configure: index: %u data, 0x%x, displayName %s: \n",
+		audio->inst, value, audio_info->display_name);
 
 	/*
 	*write the port ID:
@@ -922,7 +924,6 @@ static const struct audio_funcs funcs = {
 	.az_configure = dce_aud_az_configure,
 	.destroy = dce_aud_destroy,
 };
-
 void dce_aud_destroy(struct audio **audio)
 {
 	struct dce_audio *aud = DCE_AUD(*audio);
@@ -953,7 +954,6 @@ struct audio *dce_audio_create(
 	audio->regs = reg;
 	audio->shifts = shifts;
 	audio->masks = masks;
-
 	return &audio->base;
 }
 
-- 
2.20.1


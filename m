Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A5FCD6B7
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbfJFRlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbfJFRlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D73D2053B;
        Sun,  6 Oct 2019 17:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383676;
        bh=rvdn6CM18sRU3iihANkuQJrrZFTaDeCo9vZzLOAkUgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIgbLhHXy6U6qhgK/6gpz7pH86r/lY+l+8+DRpUN6NRQkDKGbQZOk4qgsLoFC0LD+
         kYFlupCQryKF8Nwmnm+mASr5TYgnnbYqaI/4xQGh1LJ0jBrCdhdrdT2PlStFFz7uCX
         W9pOKoEofqH1Z7vKfRGBvFB7JEYw4t+3O6SlbM4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <charlene.liu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 055/166] drm/amd/display: support spdif
Date:   Sun,  6 Oct 2019 19:20:21 +0200
Message-Id: <20191006171217.713757795@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2ceaab4fb5deb..68db60e4caf32 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -265,12 +265,10 @@ bool resource_construct(
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
@@ -1659,24 +1657,25 @@ static struct audio *find_first_free_audio(
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
index 4a10a5d22c90b..5de9623bdf66b 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
@@ -613,6 +613,8 @@ void dce_aud_az_configure(
 
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




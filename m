Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99B07FB02
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393338AbfHBNUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393329AbfHBNUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB03D2173E;
        Fri,  2 Aug 2019 13:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752018;
        bh=wR+477MA7YqEAkVVTxtZJpAaDsvuJGS+RBbhAOuOmHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+cQ4j0KxBSq09VdYSv0/HlemOO/XuoK7Dtdp93BFlE4y0m+StlPxMozpYbdf9OHZ
         QL7z6jWnHplj+lNN3G/Mtf+MK9GgHaRu7xrxXx5XaOxQlZe+hEx+GFi3BSybRnkAyq
         dJgF4bZtXsMJk01r6EPZMi72pcC1oQRkq0vf81S8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tai Man <taiman.wong@amd.com>, Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 20/76] drm/amd/display: use encoder's engine id to find matched free audio device
Date:   Fri,  2 Aug 2019 09:18:54 -0400
Message-Id: <20190802131951.11600-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tai Man <taiman.wong@amd.com>

[ Upstream commit 74eda776d7a4e69ec7aa1ce30a87636f14220fbb ]

[Why]
On some platforms, the encoder id 3 is not populated. So the encoders
are not stored in right order as index (id: 0, 1, 2, 4, 5) at pool. This
would cause encoders id 4 & id 5 to fail when finding corresponding
audio device, defaulting to the first available audio device. As result,
we cannot stream audio into two DP ports with encoders id 4 & id 5.

[How]
It need to create enough audio device objects (0 - 5) to perform matching.
Then use encoder engine id to find matched audio device.

Signed-off-by: Tai Man <taiman.wong@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index eac7186e4f084..ad82906b99db9 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -254,7 +254,7 @@ bool resource_construct(
 		 * PORT_CONNECTIVITY == 1 (as instructed by HW team).
 		 */
 		update_num_audio(&straps, &num_audio, &pool->audio_support);
-		for (i = 0; i < pool->pipe_count && i < num_audio; i++) {
+		for (i = 0; i < caps->num_audio; i++) {
 			struct audio *aud = create_funcs->create_audio(ctx, i);
 
 			if (aud == NULL) {
@@ -1702,6 +1702,12 @@ static struct audio *find_first_free_audio(
 			return pool->audios[i];
 		}
 	}
+
+    /* use engine id to find free audio */
+	if ((id < pool->audio_count) && (res_ctx->is_audio_acquired[id] == false)) {
+		return pool->audios[id];
+	}
+
 	/*not found the matching one, first come first serve*/
 	for (i = 0; i < pool->audio_count; i++) {
 		if (res_ctx->is_audio_acquired[i] == false) {
-- 
2.20.1


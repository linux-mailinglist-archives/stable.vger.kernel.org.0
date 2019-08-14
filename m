Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1026C8DABD
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfHNRUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730538AbfHNRKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:10:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B52BC2084D;
        Wed, 14 Aug 2019 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802654;
        bh=Lqu+Gb6MJgsXC8tH+vHrPCLUN56KFzybm5bfgYB8sV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZynM/+IqnAo28LohK3c2pnk0okH/zoGBfILl/Ktyu2M1JbcJVoiD8RQOkJmAKzFi
         8vLHL8iwQ0AS71FbWSAEoVy5LFTBEb7qNLlfS6v18YE9CW9R6viz0lolvhXb/qwDiU
         3w427o3S23jgftWSBMa6UreBSyhKuR7CnKdjXTLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tai Man <taiman.wong@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/91] drm/amd/display: use encoders engine id to find matched free audio device
Date:   Wed, 14 Aug 2019 19:01:03 +0200
Message-Id: <20190814165751.345796527@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index e0a96abb3c46c..06d5988dff723 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -222,7 +222,7 @@ bool resource_construct(
 		 * PORT_CONNECTIVITY == 1 (as instructed by HW team).
 		 */
 		update_num_audio(&straps, &num_audio, &pool->audio_support);
-		for (i = 0; i < pool->pipe_count && i < num_audio; i++) {
+		for (i = 0; i < caps->num_audio; i++) {
 			struct audio *aud = create_funcs->create_audio(ctx, i);
 
 			if (aud == NULL) {
@@ -1713,6 +1713,12 @@ static struct audio *find_first_free_audio(
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




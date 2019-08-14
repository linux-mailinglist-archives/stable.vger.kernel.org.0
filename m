Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9568DB8C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfHNRFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbfHNRFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17AB82084D;
        Wed, 14 Aug 2019 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802299;
        bh=gMyYvyHi4bzkfcwcBzPJRr8p4xBjXOE9TAdzrk2+zuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tosbT3N1NXDB7d+irX0pMkkLn+mjjqhXLdmDTid2tuEx7zd2+ZRdNvoz6+5BNS9W2
         WaANpKosQSQeG7vGn/bY8XZcE48tUkUO9r2ZrW/ewy8RnlufBXpJYhpqHq2SZxIidM
         WuvAbBEbuvr8CGXdsJXe5dXzNHs1sBz0Ts6XUyMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alvin Lee <alvin.lee2@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 072/144] drm/amd/display: Only enable audio if speaker allocation exists
Date:   Wed, 14 Aug 2019 19:00:28 +0200
Message-Id: <20190814165802.868097698@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6ac25e6d5b2fbf251e9fa2f4131d42c815b43867 ]

[Why]

In dm_helpers_parse_edid_caps, there is a corner case where no speakers
can be allocated even though the audio mode count is greater than 0.
Enabling audio when no speaker allocations exists can cause issues in
the video stream.

[How]

Add a check to not enable audio unless one or more speaker allocations
exist (since doing this can cause issues in the video stream).

Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index b2525ab8a95f6..b459ce056b609 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2019,7 +2019,7 @@ enum dc_status resource_map_pool_resources(
 	/* TODO: Add check if ASIC support and EDID audio */
 	if (!stream->converter_disable_audio &&
 	    dc_is_audio_capable_signal(pipe_ctx->stream->signal) &&
-	    stream->audio_info.mode_count) {
+	    stream->audio_info.mode_count && stream->audio_info.flags.all) {
 		pipe_ctx->stream_res.audio = find_first_free_audio(
 		&context->res_ctx, pool, pipe_ctx->stream_res.stream_enc->id);
 
-- 
2.20.1




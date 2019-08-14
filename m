Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031EF8DAB2
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfHNRLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729956AbfHNRLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:11:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEC24208C2;
        Wed, 14 Aug 2019 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802659;
        bh=BLwjPdtqgfNhqbOrTefGQ/E12D/Jkr6BQ+YzX/qBtxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUu+zpGEM1/0oPFBhblEoUsJdOevC0ZZ+hp1JyU4FyuMtsrJ/Sy8d102u+OmsKtx3
         ve7AeAXq1WoMi83g+QQ8VTmXkXEc0DhuvE4E5slTlZPWgAPWwGMbFqdbafYiK4XF+T
         CcUpK2F2IFWYEJJflev3gM/jv3jxmAgxpeJp6Pg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alvin Lee <alvin.lee2@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/91] drm/amd/display: Only enable audio if speaker allocation exists
Date:   Wed, 14 Aug 2019 19:01:05 +0200
Message-Id: <20190814165751.409847047@linuxfoundation.org>
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
index 19a951e5818ac..f0d68aa7c8fcc 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1956,7 +1956,7 @@ enum dc_status resource_map_pool_resources(
 	/* TODO: Add check if ASIC support and EDID audio */
 	if (!stream->sink->converter_disable_audio &&
 	    dc_is_audio_capable_signal(pipe_ctx->stream->signal) &&
-	    stream->audio_info.mode_count) {
+	    stream->audio_info.mode_count && stream->audio_info.flags.all) {
 		pipe_ctx->stream_res.audio = find_first_free_audio(
 		&context->res_ctx, pool, pipe_ctx->stream_res.stream_enc->id);
 
-- 
2.20.1




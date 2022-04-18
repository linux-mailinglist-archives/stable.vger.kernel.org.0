Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20075053AC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbiDRNA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242468AbiDRM76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:59:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73573121E;
        Mon, 18 Apr 2022 05:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFAA4B80EC3;
        Mon, 18 Apr 2022 12:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0A2C385A7;
        Mon, 18 Apr 2022 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285678;
        bh=xVm6RRwV0iebQzfEjV2PEmWJc2EKFy1OV3lmNHvO7uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBnOh1VAq+D8KX7JMaZLUMU5A5jXPxE0gHIRnqjt2P2ZXG9H4xyBGJedhLDScxY9Q
         3tgJGRTCo/y+okmhStDaMwOXcSi83icOybMawoyVE3NnsGBVxxjYyJOHPa/YkjjLzx
         5plDFz+grcf40bT+ylV7CZAM4rlTMtTnHCg95o+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alvin Lee <Alvin.Lee2@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Alex Hung <alex.hung@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/105] drm/amd/display: fix audio format not updated after edid updated
Date:   Mon, 18 Apr 2022 14:12:47 +0200
Message-Id: <20220418121147.759894866@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 5e8a71cf13bc9184fee915b2220be71b4c6cac74 ]

[why]
for the case edid change only changed audio format.
driver still need to update stream.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 5c5ccbad9658..1e47afc4ccc1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1701,8 +1701,8 @@ bool dc_is_stream_unchanged(
 	if (old_stream->ignore_msa_timing_param != stream->ignore_msa_timing_param)
 		return false;
 
-	// Only Have Audio left to check whether it is same or not. This is a corner case for Tiled sinks
-	if (old_stream->audio_info.mode_count != stream->audio_info.mode_count)
+	/*compare audio info*/
+	if (memcmp(&old_stream->audio_info, &stream->audio_info, sizeof(stream->audio_info)) != 0)
 		return false;
 
 	return true;
-- 
2.35.1




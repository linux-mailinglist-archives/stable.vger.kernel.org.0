Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B0A4EEF67
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346901AbiDAO15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346890AbiDAO1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:27:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A382A1E1105;
        Fri,  1 Apr 2022 07:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5950BB824FD;
        Fri,  1 Apr 2022 14:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D10C2BBE4;
        Fri,  1 Apr 2022 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823154;
        bh=G849KKjTIoPjmi1Mg986OziEyFIWyoiWM20WA5zBffo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raIYTcwJsOglg1Jio/Xx5r54IirgunGzrihUKXIFMxEZJYgGbPZ4BG6ZjLLn8XvKu
         IH621V9UU5Ww2vqujeAWdcNNcTmMeo869tL1reYKbKYVSQzcpPQEjvpR+D2cRmeV5f
         /jfLVw+yh5XqxXIfD2xBCgPeDQaKfvWDnA71YYtbhGgoAgr+cuVQ66zXEsY55QkVhN
         NgnLa/yTeUb+AO2Npzk4u1zU5Sm/nY6Z6sbJPmJ1jDOzZY7VpZsCtr6sECOU6JOpK5
         /S76ni2wKGwtpe7leqG3bAOkcl8dzk7RFpBH0XATjyCiRSItRVP8r86bpMYHqNu30U
         l3dbk0SXhzG1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dale Zhao <dale.zhao@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Jun.Lei@amd.com, aric.cyr@amd.com,
        Jimmy.Kizito@amd.com, wenjing.liu@amd.com,
        nicholas.kazlauskas@amd.com, mario.kleiner.de@gmail.com,
        Dmytro.Laktyushkin@amd.com, Jerry.Zuo@amd.com,
        meenakshikumar.somasundaram@amd.com, eric.bernstein@amd.com,
        Martin.Leung@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 005/149] drm/amd/display: Add signal type check when verify stream backends same
Date:   Fri,  1 Apr 2022 10:23:12 -0400
Message-Id: <20220401142536.1948161-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dale Zhao <dale.zhao@amd.com>

[ Upstream commit 047db281c026de5971cedb5bb486aa29bd16a39d ]

[Why]
For allow eDP hot-plug feature, the stream signal may change to VIRTUAL
when plug-out and back to eDP when plug-in. OS will still setPathMode
with same timing for each plugging, but eDP gets no stream update as we
don't check signal type changing back as keeping it VIRTUAL. It's also
unsafe for future cases that stream signal is switched with same timing.

[How]
Check stream signal type change include previous HDMI signal case.

Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Dale Zhao <dale.zhao@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 18757c158523..ac3071e38e4a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1640,6 +1640,9 @@ static bool are_stream_backends_same(
 	if (is_timing_changed(stream_a, stream_b))
 		return false;
 
+	if (stream_a->signal != stream_b->signal)
+		return false;
+
 	if (stream_a->dpms_off != stream_b->dpms_off)
 		return false;
 
-- 
2.34.1


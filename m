Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9688A46255B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhK2WiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbhK2Whi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:37:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA74C0613F4;
        Mon, 29 Nov 2021 10:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64A5BB815A9;
        Mon, 29 Nov 2021 18:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94207C53FAD;
        Mon, 29 Nov 2021 18:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210689;
        bh=0l0Hecp7loOQJiK9HvOlZaQePbUyh/4l3X1RoZUkBW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0GEBV9R8N6zBlQrUklq890m/TPlMx8oXZ8QymxcSOVjw7fbvQfHYPiVdfo75F2xr
         6tgYcc/+dkRpYmoMpcm4FLxLgiPuk3Ox/QCoxDxHKbLJcx9fppQuJjI/Px2blHzAKy
         fVZ6gRrumKylRpKClcBrIED1DOVkWgFyEnf6/QuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <Harry.Wentland@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/121] drm/amd/display: Set plane update flags for all planes in reset
Date:   Mon, 29 Nov 2021 19:18:33 +0100
Message-Id: <20211129181714.416731522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 21431f70f6014f81b0d118ff4fcee12b00b9dd70 ]

[Why]
We're only setting the flags on stream[0]'s planes so this logic fails
if we have more than one stream in the state.

This can cause a page flip timeout with multiple displays in the
configuration.

[How]
Index into the stream_status array using the stream index - it's a 1:1
mapping.

Fixes: cdaae8371aa9 ("drm/amd/display: Handle GPU reset for DC block")

Reviewed-by: Harry Wentland <Harry.Wentland@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d9525fbedad2d..a5b6f36fe1d72 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1963,8 +1963,8 @@ static int dm_resume(void *handle)
 
 		for (i = 0; i < dc_state->stream_count; i++) {
 			dc_state->streams[i]->mode_changed = true;
-			for (j = 0; j < dc_state->stream_status->plane_count; j++) {
-				dc_state->stream_status->plane_states[j]->update_flags.raw
+			for (j = 0; j < dc_state->stream_status[i].plane_count; j++) {
+				dc_state->stream_status[i].plane_states[j]->update_flags.raw
 					= 0xffffffff;
 			}
 		}
-- 
2.33.0




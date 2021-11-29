Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB8461F38
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378976AbhK2SpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:45:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43154 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379960AbhK2Sm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:42:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9483B815B1;
        Mon, 29 Nov 2021 18:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039A3C53FC7;
        Mon, 29 Nov 2021 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211179;
        bh=W8wTxhq6I/fqJIgFs1r5f7Z4sn+TJI5wU0U6qbQZ4U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06nOt8LGeWpzZwtP31PJLdDPyKjNhe4UDP4aNldBVZEocWVS4deUw9N0xHkts0RqB
         NwHgOhWXci35KCtEJkruZCiGu8GcUW3i4e/j18fsDq0jrPmhN3DOrRFxpZdjG6ocTa
         KMxKNy0QXPVy81oht2Y+NBTi6MF6R/FL7RFLpTWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <Harry.Wentland@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/179] drm/amd/display: Set plane update flags for all planes in reset
Date:   Mon, 29 Nov 2021 19:18:46 +0100
Message-Id: <20211129181723.297302973@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index 56f4569da2f7d..dc995ce52eff2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2226,8 +2226,8 @@ static int dm_resume(void *handle)
 
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



